import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  Message({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.createdAt,
    this.viewed = false,
  });

  final String id;
  final String title;
  final String body;
  final String category;
  final DateTime createdAt;
  final bool viewed;

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

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      category: json['category'] as String,
      createdAt: json['created_at'] is String 
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.fromMillisecondsSinceEpoch(json['created_at'] as int),
      viewed: json['viewed'] as bool? ?? false,
    );
  }

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
