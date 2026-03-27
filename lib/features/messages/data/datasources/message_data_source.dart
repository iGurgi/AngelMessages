import '../models/message.dart';

/// Abstract data source for message operations.
/// 
/// Defines the contract for message data access, including retrieval,
/// viewing status management, and bulk operations.
abstract class MessageDataSource {
  /// Retrieves all messages from the data source.
  /// 
  /// Returns a list of all messages, regardless of their viewed status.
  /// The order of messages is implementation-dependent.
  Future<List<Message>> getAllMessages();

  /// Gets the next unviewed message from the data source.
  /// 
  /// Returns the first unviewed message found, or null if all messages
  /// have been viewed. The selection criteria for "next" message is
  /// implementation-dependent (could be by date, ID, or random).
  Future<Message?> getUnviewedMessage();

  /// Marks a specific message as viewed.
  /// 
  /// Updates the message with the given [id] to set its viewed status to true.
  /// If no message exists with the provided [id], the operation should
  /// complete without error.
  /// 
  /// [id] The unique identifier of the message to mark as viewed.
  Future<void> markAsViewed(int id);

  /// Resets all messages to unviewed state.
  /// 
  /// Sets the viewed status to false for all messages in the data source.
  /// This allows users to revisit all messages again.
  Future<void> resetAllViewed();
}
