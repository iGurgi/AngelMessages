import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_api_model.freezed.dart';
part 'message_api_model.g.dart';

/// API model for daily angel messages received from the backend service.
/// Handles JSON serialization/deserialization with freezed code generation.
@freezed
class MessageApiModel with _$MessageApiModel {
  const factory MessageApiModel({
    /// Unique identifier for the message from the API
    required String id,
    
    /// The inspirational message content
    required String content,
    
    /// ISO 8601 formatted date string when the message was created
    @JsonKey(name: 'date_created')
    required String dateCreated,
    
    /// Category/theme of the message (e.g., 'hope', 'strength', 'love')
    required String category,
  }) = _MessageApiModel;

  /// Factory constructor for JSON deserialization
  factory MessageApiModel.fromJson(Map<String, dynamic> json) =>
      _$MessageApiModelFromJson(json);
}
