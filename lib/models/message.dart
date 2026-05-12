import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
@Collection(ignore: {'copyWith'})
class Message with _$Message {
  const Message._();

  const factory Message({
    @JsonKey(name: 'id') required String id,
    required String title,
    required String body,
    required String category,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @Default(false) bool viewed,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  @override
  Id get isarId => fastHash(id);

  @Index()
  bool get isViewed => viewed;

  @Index()
  DateTime get isarCreatedAt => createdAt;
}

/// Fast string hash for Isar ID generation
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
