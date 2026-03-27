import 'package:freezed_annotation/freezed_annotation.dart';

part 'freezed.freezed.dart';
part 'freezed.g.dart';

/// Generic API response wrapper with success/error states
@freezed
class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse.success({
    required T data,
    String? message,
  }) = ApiSuccess<T>;

  const factory ApiResponse.error({
    required String message,
    int? statusCode,
    String? errorCode,
  }) = ApiError<T>;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);
}

/// Message model from API responses
@freezed
class MessageApiModel with _$MessageApiModel {
  const factory MessageApiModel({
    required String id,
    required String content,
    required String category,
    required DateTime createdAt,
    required DateTime scheduledFor,
    String? author,
    Map<String, dynamic>? metadata,
    @Default(false) bool isRead,
    @Default(false) bool isFavorite,
  }) = _MessageApiModel;

  factory MessageApiModel.fromJson(Map<String, dynamic> json) =>
      _$MessageApiModelFromJson(json);
}

/// Sync state for tracking API synchronization status
@freezed
class SyncState with _$SyncState {
  const factory SyncState({
    @Default(SyncStatus.idle) SyncStatus status,
    DateTime? lastSyncAt,
    String? errorMessage,
    @Default(0) int totalMessages,
    @Default(0) int syncedMessages,
  }) = _SyncState;

  factory SyncState.fromJson(Map<String, dynamic> json) =>
      _$SyncStateFromJson(json);
}

/// Sync status enumeration
enum SyncStatus {
  @JsonValue('idle')
  idle,
  @JsonValue('syncing')
  syncing,
  @JsonValue('success')
  success,
  @JsonValue('error')
  error,
}
