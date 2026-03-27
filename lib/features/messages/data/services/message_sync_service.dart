import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/message_model.dart';
import '../repositories/message_repository.dart';

/// Service responsible for syncing daily messages from the API
/// and managing sync timestamps to avoid unnecessary requests
class MessageSyncService {
  static const String _lastSyncKey = 'last_message_sync';
  static const String _apiBaseUrl = 'https://api.angelmessages.com'; // TODO: Replace with actual API endpoint
  
  final Dio _dio;
  final SharedPreferences _prefs;
  final MessageRepository _messageRepository;
  
  MessageSyncService({
    required Dio dio,
    required SharedPreferences prefs,
    required MessageRepository messageRepository,
  }) : _dio = dio,
       _prefs = prefs,
       _messageRepository = messageRepository;

  /// Syncs daily messages from the API if needed
  /// Returns true if sync was performed, false if skipped
  Future<bool> syncDailyMessages() async {
    try {
      final lastSync = await _getLastSyncTimestamp();
      final now = DateTime.now();
      
      // Check if we need to sync (once per day)
      if (_shouldSync(lastSync, now)) {
        await _performSync();
        await _updateLastSyncTimestamp(now);
        return true;
      }
      
      return false;
    } catch (e) {
      // Log error but don't throw - app should work offline
      print('Message sync failed: $e');
      return false;
    }
  }
  
  /// Performs the actual API sync operation
  Future<void> _performSync() async {
    try {
      final response = await _dio.get(
        '$_apiBaseUrl/messages/daily',
        options: Options(
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 10),
        ),
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> messageData = response.data['messages'] ?? [];
        
        // Convert API response to MessageModel objects
        final messages = messageData
            .map((data) => MessageModel.fromJson(data as Map<String, dynamic>))
            .toList();
        
        // Store messages locally (repository handles duplicates)
        for (final message in messages) {
          await _messageRepository.saveMessage(message);
        }
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Network timeout during message sync');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Network connection error during message sync');
      } else {
        throw Exception('API error during message sync: ${e.message}');
      }
    }
  }
  
  /// Determines if a sync is needed based on last sync time
  bool _shouldSync(DateTime? lastSync, DateTime now) {
    if (lastSync == null) {
      return true; // Never synced before
    }
    
    // Sync once per day
    final daysSinceLastSync = now.difference(lastSync).inDays;
    return daysSinceLastSync >= 1;
  }
  
  /// Gets the last sync timestamp from SharedPreferences
  Future<DateTime?> _getLastSyncTimestamp() async {
    final timestamp = _prefs.getInt(_lastSyncKey);
    if (timestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }
  
  /// Updates the last sync timestamp in SharedPreferences
  Future<void> _updateLastSyncTimestamp(DateTime timestamp) async {
    await _prefs.setInt(_lastSyncKey, timestamp.millisecondsSinceEpoch);
  }
  
  /// Forces a sync regardless of last sync time (for manual refresh)
  Future<void> forceSyncDailyMessages() async {
    try {
      await _performSync();
      await _updateLastSyncTimestamp(DateTime.now());
    } catch (e) {
      rethrow; // Let caller handle forced sync errors
    }
  }
  
  /// Gets the last sync timestamp for UI display
  Future<DateTime?> getLastSyncTime() async {
    return _getLastSyncTimestamp();
  }
  
  /// Clears sync history (useful for testing or reset)
  Future<void> clearSyncHistory() async {
    await _prefs.remove(_lastSyncKey);
  }
}
