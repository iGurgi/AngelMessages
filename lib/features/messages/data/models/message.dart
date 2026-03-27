import 'package:isar/isar.dart';

part 'message.g.dart';

/// Core message model representing an angel message in the local database
/// 
/// This model uses Isar for local persistence and offline-first data access.
/// Messages are automatically assigned IDs and track viewing status.
@collection
class Message {
  /// Auto-increment primary key for the message
  Id id = Isar.autoIncrement;

  /// The title/subject of the angel message
  late String title;

  /// The full content/body of the angel message
  late String content;

  /// Whether this message has been viewed by the user
  /// Defaults to false for new messages
  @Default(false)
  late bool isViewed;

  /// When this message was received/created
  /// Used for chronological ordering and filtering
  late DateTime dateReceived;

  /// Default constructor for Isar object creation
  Message();

  /// Named constructor for creating new messages
  Message.create({
    required this.title,
    required this.content,
    required this.dateReceived,
    this.isViewed = false,
  });

  /// Helper method to mark message as viewed
  void markAsViewed() {
    isViewed = true;
  }

  /// Helper method to check if message is from today
  bool get isFromToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(
      dateReceived.year,
      dateReceived.month,
      dateReceived.day,
    );
    return messageDate.isAtSameMomentAs(today);
  }

  @override
  String toString() {
    return 'Message{id: $id, title: $title, isViewed: $isViewed, dateReceived: $dateReceived}';
  }
}
