import 'package:isar/isar.dart';

import '../../domain/entities/message.dart';
import '../models/message_model.dart';
import 'message_data_source.dart';

/// Local data source implementation using Isar database for message persistence.
/// Handles CRUD operations for messages with offline-first approach.
class LocalMessageDataSource implements MessageDataSource {
  /// Isar database instance for message operations
  final Isar _isar;

  /// Creates a local message data source with the provided Isar instance
  const LocalMessageDataSource(this._isar);

  /// Retrieves all messages from local storage ordered by date descending
  /// Returns empty list if no messages exist or on error
  @override
  Future<List<Message>> getAll() async {
    try {
      final messageModels = await _isar.messageModels
          .where()
          .sortByDateDesc()
          .findAll();
      
      return messageModels.map((model) => model.toDomain()).toList();
    } catch (e) {
      // Log error in production app
      return [];
    }
  }

  /// Finds the first unviewed message from local storage
  /// Returns null if no unviewed messages exist or on error
  @override
  Future<Message?> getUnviewed() async {
    try {
      final messageModel = await _isar.messageModels
          .where()
          .isViewedEqualTo(false)
          .sortByDateDesc()
          .findFirst();
      
      return messageModel?.toDomain();
    } catch (e) {
      // Log error in production app
      return null;
    }
  }

  /// Updates multiple messages in local storage using a transaction
  /// Ensures data consistency by wrapping all operations in a single transaction
  @override
  Future<void> updateAll(List<Message> messages) async {
    try {
      final messageModels = messages
          .map((message) => MessageModel.fromDomain(message))
          .toList();
      
      await _isar.writeTxn(() async {
        await _isar.messageModels.putAll(messageModels);
      });
    } catch (e) {
      // Log error in production app
      rethrow;
    }
  }

  /// Stores a single message in local storage
  /// Uses putAll internally for consistency with bulk operations
  @override
  Future<void> store(Message message) async {
    await updateAll([message]);
  }

  /// Clears all messages from local storage
  /// Used for data reset or cleanup operations
  @override
  Future<void> clear() async {
    try {
      await _isar.writeTxn(() async {
        await _isar.messageModels.clear();
      });
    } catch (e) {
      // Log error in production app
      rethrow;
    }
  }

  /// Gets the total count of messages in local storage
  /// Useful for pagination or statistics
  @override
  Future<int> getCount() async {
    try {
      return await _isar.messageModels.count();
    } catch (e) {
      // Log error in production app
      return 0;
    }
  }

  /// Gets the count of unviewed messages in local storage
  /// Used for badge counts and notification management
  @override
  Future<int> getUnviewedCount() async {
    try {
      return await _isar.messageModels
          .where()
          .isViewedEqualTo(false)
          .count();
    } catch (e) {
      // Log error in production app
      return 0;
    }
  }
}