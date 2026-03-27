import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

/// Domain entity representing an angel message
/// 
/// Contains all the core information about a message including its content,
/// metadata, and user interaction state.
@freezed
class Message with _$Message {
  /// Creates a new Message entity
  /// 
  /// [id] - Unique local identifier
  /// [serverId] - Server-side identifier for sync
  /// [title] - Display title of the message
  /// [content] - Main message content
  /// [category] - Category classification (e.g., 'love', 'guidance')
  /// [isViewed] - Whether user has viewed this message
  /// [isFavorite] - Whether user marked as favorite
  /// [date] - Creation date
  /// [updatedAt] - Last modification date
  const factory Message({
    required int id,
    String? serverId,
    required String title,
    required String content,
    required String category,
    @Default(false) bool isViewed,
    @Default(false) bool isFavorite,
    required DateTime date,
    required DateTime updatedAt,
  }) = _Message;

  /// JSON serialization support
  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
      
  /// Creates a sample message for testing and development
  factory Message.sample() => Message(
    id: 1,
    title: 'Divine Love Surrounds You',
    content: 'Your angels want you to know that you are deeply loved and supported. Trust in the divine plan unfolding in your life.',
    category: 'love',
    date: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}
