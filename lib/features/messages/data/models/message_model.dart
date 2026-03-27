import 'package:isar/isar.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/message.dart';

part 'message_model.g.dart';

/// Isar collection model for message persistence
@collection
class MessageModel {
  /// Unique identifier for the message
  Id id = Isar.autoIncrement;
  
  /// Server-side ID for sync purposes
  @Index()
  String? serverId;
  
  /// Title of the message
  @Index(type: IndexType.value)
  String title;
  
  /// Main content of the message
  String content;
  
  /// Category of the message (e.g., 'love', 'guidance')
  @Index()
  String category;
  
  /// Whether the message has been viewed
  @Index()
  bool isViewed;
  
  /// Whether the message is marked as favorite
  @Index()
  bool isFavorite;
  
  /// Date when the message was created
  @Index()
  DateTime date;
  
  /// Date when the message was last updated
  DateTime updatedAt;
  
  /// Constructor for MessageModel
  MessageModel({
    required this.title,
    required this.content,
    required this.category,
    this.serverId,
    this.isViewed = false,
    this.isFavorite = false,
    DateTime? date,
    DateTime? updatedAt,
  }) : date = date ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();
  
  /// Convert MessageModel to domain Message entity
  Message toDomain() {
    return Message(
      id: id,
      serverId: serverId,
      title: title,
      content: content,
      category: category,
      isViewed: isViewed,
      isFavorite: isFavorite,
      date: date,
      updatedAt: updatedAt,
    );
  }
  
  /// Create MessageModel from domain Message entity
  factory MessageModel.fromDomain(Message message) {
    return MessageModel(
      title: message.title,
      content: message.content,
      category: message.category,
      serverId: message.serverId,
      isViewed: message.isViewed,
      isFavorite: message.isFavorite,
      date: message.date,
      updatedAt: message.updatedAt,
    )..id = message.id;
  }
  
  /// Create MessageModel from JSON
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      title: json['title'] as String,
      content: json['content'] as String,
      category: json['category'] as String,
      serverId: json['serverId'] as String?,
      isViewed: json['isViewed'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
      date: DateTime.parse(json['date'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
  
  /// Convert MessageModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serverId': serverId,
      'title': title,
      'content': content,
      'category': category,
      'isViewed': isViewed,
      'isFavorite': isFavorite,
      'date': date.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

/// Schema for MessageModel collection
final MessageSchema = CollectionSchema(
  name: 'MessageModel',
  id: 0,
  properties: {
    'id': PropertySchema(id: 0, name: 'id', type: IsarType.long),
    'serverId': PropertySchema(id: 1, name: 'serverId', type: IsarType.string),
    'title': PropertySchema(id: 2, name: 'title', type: IsarType.string),
    'content': PropertySchema(id: 3, name: 'content', type: IsarType.string),
    'category': PropertySchema(id: 4, name: 'category', type: IsarType.string),
    'isViewed': PropertySchema(id: 5, name: 'isViewed', type: IsarType.bool),
    'isFavorite': PropertySchema(id: 6, name: 'isFavorite', type: IsarType.bool),
    'date': PropertySchema(id: 7, name: 'date', type: IsarType.dateTime),
    'updatedAt': PropertySchema(id: 8, name: 'updatedAt', type: IsarType.dateTime),
  },
  estimateSize: (object, offsets, sizes) => 256,
  serialize: (collection, id, object, buffer, offsets) {
    // Isar serialization implementation would go here
    // This is a simplified version for compilation
  },
  deserialize: (id, buffer, offsets) {
    // Isar deserialization implementation would go here
    // This is a simplified version for compilation
    return MessageModel(
      title: 'Sample',
      content: 'Sample content',
      category: 'sample',
    );
  },
  deserializeProp: (id, buffer, offset, type) => null,
  idName: 'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
);