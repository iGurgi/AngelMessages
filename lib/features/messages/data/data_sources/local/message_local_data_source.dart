import 'package:angel_messages/features/messages/data/models/message.dart';
import 'package:isar/isar.dart';

/// Local data source for messages using Isar database
/// NOTE: Temporarily using in-memory storage until Isar schema is generated
class MessageLocalDataSource {
  MessageLocalDataSource(this._isar);

  final Isar _isar;
  
  // Temporary in-memory storage until schema is generated
  static final List<Message> _tempMessages = [];

  /// Get all messages ordered by creation date (newest first)
  Future<List<Message>> getAllMessages() async {
    // TODO: Replace with Isar query after build_runner
    // return _isar.messages.where().sortByCreatedAtDesc().findAll();
    final sorted = List<Message>.from(_tempMessages);
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted;
  }

  /// Get all unviewed messages ordered by creation date (oldest first)
  Future<List<Message>> getUnviewedMessages() async {
    // TODO: Replace with Isar query after build_runner
    // return _isar.messages
    //     .filter()
    //     .viewedEqualTo(false)
    //     .sortByCreatedAt()
    //     .findAll();
    final unviewed = _tempMessages.where((m) => !m.viewed).toList();
    unviewed.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return unviewed;
  }

  /// Get a specific message by ID
  Future<Message?> getMessageById(String id) async {
    // TODO: Replace with Isar query after build_runner
    // return _isar.messages.filter().idEqualTo(id).findFirst();
    try {
      return _tempMessages.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Insert or update a message
  Future<void> upsertMessage(Message message) async {
    // TODO: Replace with Isar transaction after build_runner
    // await _isar.writeTxn(() async {
    //   await _isar.messages.put(message);
    // });
    final index = _tempMessages.indexWhere((m) => m.id == message.id);
    if (index >= 0) {
      _tempMessages[index] = message;
    } else {
      _tempMessages.add(message);
    }
  }

  /// Insert or update multiple messages
  Future<void> upsertMessages(List<Message> messages) async {
    // TODO: Replace with Isar transaction after build_runner
    // await _isar.writeTxn(() async {
    //   await _isar.messages.putAll(messages);
    // });
    for (final message in messages) {
      await upsertMessage(message);
    }
  }

  /// Mark a message as viewed
  Future<void> markAsViewed(String id) async {
    // TODO: Replace with Isar transaction after build_runner
    // await _isar.writeTxn(() async {
    //   final message = await _isar.messages.filter().idEqualTo(id).findFirst();
    //   if (message != null) {
    //     message.viewed = true;
    //     await _isar.messages.put(message);
    //   }
    // });
    final message = await getMessageById(id);
    if (message != null) {
      message.viewed = true;
      await upsertMessage(message);
    }
  }

  /// Reset all messages to unviewed
  Future<void> resetAllViewed() async {
    // TODO: Replace with Isar transaction after build_runner
    // await _isar.writeTxn(() async {
    //   final messages = await _isar.messages.where().findAll();
    //   for (final message in messages) {
    //     message.viewed = false;
    //   }
    //   await _isar.messages.putAll(messages);
    // });
    for (final message in _tempMessages) {
      message.viewed = false;
    }
  }

  /// Check if all messages have been viewed
  Future<bool> allMessagesViewed() async {
    // TODO: Replace with Isar query after build_runner
    // final unviewedCount =
    //     await _isar.messages.filter().viewedEqualTo(false).count();
    // return unviewedCount == 0;
    return _tempMessages.every((m) => m.viewed);
  }

  /// Get total message count
  Future<int> getMessageCount() async {
    // TODO: Replace with Isar query after build_runner
    // return _isar.messages.count();
    return _tempMessages.length;
  }

  /// Delete all messages (for testing)
  Future<void> deleteAll() async {
    // TODO: Replace with Isar transaction after build_runner
    // await _isar.writeTxn(() async {
    //   await _isar.messages.clear();
    // });
    _tempMessages.clear();
  }
}
