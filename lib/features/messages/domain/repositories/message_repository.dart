import '../entities/message.dart';
import '../../../shared/utils/result.dart';

/// Abstract repository interface for message data operations.
/// 
/// Defines the contract for retrieving, updating, and managing messages.
/// Uses Result pattern for proper error handling without throwing exceptions.
abstract class MessageRepository {
  /// Retrieves all messages from storage.
  /// 
  /// Returns [Result] containing:
  /// - Success: List of all messages (may be empty)
  /// - Failure: Error message describing what went wrong
  Future<Result<List<Message>, String>> getAllMessages();

  /// Gets the next unviewed message.
  /// 
  /// Returns [Result] containing:
  /// - Success: Next unviewed message, or null if all messages have been viewed
  /// - Failure: Error message describing what went wrong
  Future<Result<Message?, String>> getUnviewedMessage();

  /// Marks a specific message as viewed by its ID.
  /// 
  /// Parameters:
  /// - [id]: The unique identifier of the message to mark as viewed
  /// 
  /// Returns [Result] containing:
  /// - Success: void (operation completed successfully)
  /// - Failure: Error message if message not found or update failed
  Future<Result<void, String>> markAsViewed(int id);

  /// Resets all messages to unviewed state.
  /// 
  /// Useful for allowing users to re-read all messages or for testing.
  /// 
  /// Returns [Result] containing:
  /// - Success: void (operation completed successfully)
  /// - Failure: Error message describing what went wrong
  Future<Result<void, String>> resetAllViewed();
}
