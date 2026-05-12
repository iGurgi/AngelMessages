import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart' as drift;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:angel_messages/core/config/environment.dart';
import 'package:angel_messages/core/database/database.dart';
import 'package:angel_messages/core/providers/database_provider.dart';

part 'message_repository.g.dart';

@riverpod
MessageRepository messageRepository(MessageRepositoryRef ref) {
  final database = ref.watch(appDatabaseProvider);
  return MessageRepository(database: database);
}

class MessageRepository {
  final AppDatabase database;
  final Dio _dio;
  final Connectivity _connectivity;

  MessageRepository({
    required this.database,
    Dio? dio,
    Connectivity? connectivity,
  })  : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: Environment.supabaseUrl,
                headers: {
                  'apikey': Environment.supabaseAnonKey,
                  'Authorization': 'Bearer ${Environment.supabaseAnonKey}',
                },
              ),
            ),
        _connectivity = connectivity ?? Connectivity();

  /// Fetch messages from Supabase and sync to local database
  Future<void> syncMessages() async {
    // Check connectivity first
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return; // No network, skip sync
    }

    try {
      final response = await _dio.get(
        '/rest/v1/messages',
        queryParameters: {
          'order': 'created_at.desc',
        },
      );

      if (response.statusCode == 200 && response.data is List) {
        final messages = (response.data as List)
            .map((json) => _messageFromSupabase(json))
            .toList();

        // Upsert messages into local database
        for (final message in messages) {
          await database.insertMessage(message);
        }
      }
    } on DioException catch (e) {
      // Log error but don't throw - offline-first architecture
      print('Failed to sync messages: ${e.message}');
    }
  }

  /// Get next unviewed message
  Future<Message?> getNextUnviewedMessage() async {
    final unviewed = await database.getUnviewedMessages();

    if (unviewed.isEmpty) {
      // All messages viewed, reset and try again
      await database.resetAllViewed();
      final messages = await database.getUnviewedMessages();
      return messages.isNotEmpty ? messages.first : null;
    }

    return unviewed.first;
  }

  /// Get message by ID
  Future<Message?> getMessageById(String id) async {
    return database.getMessageById(id);
  }

  /// Mark message as viewed
  Future<void> markMessageAsViewed(String id) async {
    await database.markAsViewed(id);
  }

  /// Get all messages
  Future<List<Message>> getAllMessages() async {
    return database.getAllMessages();
  }

  /// Helper to convert Supabase JSON to Drift companion
  MessagesCompanion _messageFromSupabase(Map<String, dynamic> json) {
    return MessagesCompanion(
      id: drift.Value(json['id'] as String),
      title: drift.Value(json['title'] as String),
      body: drift.Value(json['body'] as String),
      category: drift.Value(json['category'] as String),
      createdAt: drift.Value(DateTime.parse(json['created_at'] as String)),
      viewed: const drift.Value(false),
    );
  }
}
