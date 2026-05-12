import 'package:angel_messages/features/messages/data/data_sources/local/message_local_data_source.dart';
import 'package:angel_messages/features/messages/data/data_sources/remote/message_remote_data_source.dart';
import 'package:angel_messages/features/messages/data/models/message.dart';

/// Repository for managing messages with offline-first architecture
class MessageRepository {
  MessageRepository({
    required MessageLocalDataSource localDataSource,
    required MessageRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  final MessageLocalDataSource _localDataSource;
  final MessageRemoteDataSource _remoteDataSource;

  /// Get all messages from local database
  Future<List<Message>> getMessages() async {
    return _localDataSource.getAllMessages();
  }

  /// Get a specific message by ID
  Future<Message?> getMessageById(String id) async {
    return _localDataSource.getMessageById(id);
  }

  /// Get next unviewed message
  Future<Message?> getNextUnviewedMessage() async {
    final unviewed = await _localDataSource.getUnviewedMessages();
    return unviewed.isEmpty ? null : unviewed.first;
  }

  /// Mark a message as viewed
  Future<void> markMessageAsViewed(String id) async {
    await _localDataSource.markAsViewed(id);

    // Check if all messages have been viewed
    if (await _localDataSource.allMessagesViewed()) {
      // Reset all messages to unviewed for next cycle
      await _localDataSource.resetAllViewed();
    }
  }

  /// Sync messages from remote API
  /// Returns true if sync was successful, false otherwise
  Future<bool> syncMessages() async {
    try {
      // Fetch messages from Supabase
      final remoteMessages = await _remoteDataSource.fetchMessages();

      if (remoteMessages.isEmpty) {
        return true; // No messages to sync, but not an error
      }

      // Get existing messages to preserve viewed state
      final existingMessages = await _localDataSource.getAllMessages();
      final existingMap = {
        for (final msg in existingMessages) msg.id: msg.viewed,
      };

      // Merge remote messages with existing viewed state
      final messagesToUpsert = remoteMessages.map((remoteMsg) {
        final existingViewed = existingMap[remoteMsg.id] ?? false;
        return remoteMsg.copyWith(viewed: existingViewed);
      }).toList();

      // Upsert all messages
      await _localDataSource.upsertMessages(messagesToUpsert);

      return true;
    } catch (e) {
      // Log error but don't throw - allow offline functionality
      return false;
    }
  }

  /// Check if local database has any messages
  Future<bool> hasMessages() async {
    final count = await _localDataSource.getMessageCount();
    return count > 0;
  }

  /// Get count of unviewed messages
  Future<int> getUnviewedCount() async {
    final unviewed = await _localDataSource.getUnviewedMessages();
    return unviewed.length;
  }
}
