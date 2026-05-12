import 'package:isar/isar.dart';

part 'message.g.dart';

/// Message entity stored in local Isar database
@collection
class Message {
  Message({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.createdAt,
    this.viewed = false,
  });

  /// Unique identifier from Supabase (stored as String UUID)
  Id get isarId => fastHash(id);

  @Index(unique: true)
  final String id;

  final String title;

  final String body;

  final String category;

  final DateTime createdAt;

  bool viewed;

  /// Create a copy with modified fields
  Message copyWith({
    String? id,
    String? title,
    String? body,
    String? category,
    DateTime? createdAt,
    bool? viewed,
  }) {
    return Message(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      viewed: viewed ?? this.viewed,
    );
  }

  /// Create from JSON (Supabase response)
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      category: json['category'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      viewed: false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'category': category,
      'created_at': createdAt.toIso8601String(),
      'viewed': viewed,
    };
  }
}

/// Fast hash function for String to Id conversion
/// Required by Isar for string-based primary keys
int fastHash(String string) {
  var hash = 0xcbf29ce484222325;

  var i = 0;
  while (i < string.length) {
    final codeUnit = string.codeUnitAt(i++);
    hash ^= codeUnit >> 8;
    hash *= 0x100000001b3;
    hash ^= codeUnit & 0xFF;
    hash *= 0x100000001b3;
  }

  return hash;
}
