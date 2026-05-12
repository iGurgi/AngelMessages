import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
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
}
