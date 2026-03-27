import '../../../core/utils/result.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/message_repository.dart';
import '../datasources/message_data_source.dart';

/// Implementation of [MessageRepository] using Isar database.
/// 
/// Handles message data operations with proper error handling and rotation logic.
/// When no unviewed messages are found, automatically resets all messages to
/// unviewed state and returns the first message.
class MessageRepositoryImpl implements MessageRepository {
  final MessageDataSource _dataSource;

  const MessageRepositoryImpl(this._dataSource);

  @override
  Future<Result<Message?>> getUnviewedMessage() async {
    try {
      // First, try to get an unviewed message
      final unviewedMessage = await _dataSource.getUnviewedMessage();
      
      if (unviewedMessage != null) {
        return Result.success(unviewedMessage);
      }
      
      // No unviewed messages found - reset all to unviewed
      await _dataSource.resetAllViewed();
      
      // Get the first message after reset
      final firstMessage = await _dataSource.getFirstMessage();
      
      return Result.success(firstMessage);
    } catch (e, stackTrace) {
      return Result.failure(
        Exception('Failed to get unviewed message: $e'),
        stackTrace,
      );
    }
  }

  @override
  Future<Result<void>> markMessageAsViewed(int messageId) async {
    try {
      await _dataSource.markMessageAsViewed(messageId);
      return Result.success(null);
    } catch (e, stackTrace) {
      return Result.failure(
        Exception('Failed to mark message as viewed: $e'),
        stackTrace,
      );
    }
  }

  @override
  Future<Result<List<Message>>> getAllMessages() async {
    try {
      final messages = await _dataSource.getAllMessages();
      return Result.success(messages);
    } catch (e, stackTrace) {
      return Result.failure(
        Exception('Failed to get all messages: $e'),
        stackTrace,
      );
    }
  }

  @override
  Future<Result<void>> saveMessages(List<Message> messages) async {
    try {
      await _dataSource.saveMessages(messages);
      return Result.success(null);
    } catch (e, stackTrace) {
      return Result.failure(
        Exception('Failed to save messages: $e'),
        stackTrace,
      );
    }
  }

  @override
  Future<Result<void>> clearAllMessages() async {
    try {
      await _dataSource.clearAllMessages();
      return Result.success(null);
    } catch (e, stackTrace) {
      return Result.failure(
        Exception('Failed to clear all messages: $e'),
        stackTrace,
      );
    }
  }

  @override
  Future<Result<int>> getUnviewedMessageCount() async {
    try {
      final count = await _dataSource.getUnviewedMessageCount();
      return Result.success(count);
    } catch (e, stackTrace) {
      return Result.failure(
        Exception('Failed to get unviewed message count: $e'),
        stackTrace,
      );
    }
  }

  @override
  Future<Result<Message?>> getMessageById(int id) async {
    try {
      final message = await _dataSource.getMessageById(id);
      return Result.success(message);
    } catch (e, stackTrace) {
      return Result.failure(
        Exception('Failed to get message by ID: $e'),
        stackTrace,
      );
    }
  }

  @override
  Future<Result<void>> resetAllViewed() async {
    try {
      await _dataSource.resetAllViewed();
      return Result.success(null);
    } catch (e, stackTrace) {
      return Result.failure(
        Exception('Failed to reset all viewed messages: $e'),
        stackTrace,
      );
    }
  }
}