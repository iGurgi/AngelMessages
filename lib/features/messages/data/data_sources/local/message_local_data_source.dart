import 'package:angel_messages/features/messages/data/models/message.dart';
import 'package:isar/isar.dart';

/// Local data source for messages using Isar database
class MessageLocalDataSource {
  MessageLocalDataSource(this._isar);

  final Isar _isar;

  /// Get all messages ordered by creation date (newest first)
  Future<List<Message>> getAllMessages() async {
    return _isar.messages.where().sortByCreatedAtDesc().findAll();
  }

  /// Get all unviewed messages ordered by creation date (oldest first)
  Future<List<Message>> getUnviewedMessages() async {
    return _isar.messages
        .filter()
        .viewedEqualTo(false)
        .sortByCreatedAt()
        .findAll();
  }

  /// Get a specific message by ID
  Future<Message?> getMessageById(String id) async {
    return _isar.messages.filter().idEqualTo(id).findFirst();
  }

  /// Insert or update a message
  Future<void> upsertMessage(Message message) async {
    await _isar.writeTxn(() async {
      await _isar.messages.put(message);
    });
  }

  /// Insert or update multiple messages
  Future<void> upsertMessages(List<Message> messages) async {
    await _isar.writeTxn(() async {
      await _isar.messages.putAll(messages);
    });
  }

  /// Mark a message as viewed
  Future<void> markAsViewed(String id) async {
    await _isar.writeTxn(() async {
      final message = await _isar.messages.filter().idEqualTo(id).findFirst();
      if (message != null) {
        message.viewed = true;
        await _isar.messages.put(message);
      }
    });
  }

  /// Reset all messages to unviewed
  Future<void> resetAllViewed() async {
    await _isar.writeTxn(() async {
      final messages = await _isar.messages.where().findAll();
      for (final message in messages) {
        message.viewed = false;
      }
      await _isar.messages.putAll(messages);
    });
  }

  /// Check if all messages have been viewed
  Future<bool> allMessagesViewed() async {
    final unviewedCount =
        await _isar.messages.filter().viewedEqualTo(false).count();
    return unviewedCount == 0;
  }

  /// Get total message count
  Future<int> getMessageCount() async {
    return _isar.messages.count();
  }

  /// Delete all messages (for testing)
  Future<void> deleteAll() async {
    await _isar.writeTxn(() async {
      await _isar.messages.clear();
    });
  }
}
