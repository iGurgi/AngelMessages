import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response.freezed.dart';

/// Sealed class representing API response states
/// 
/// Used throughout the app to handle HTTP responses in a type-safe manner.
/// Provides clear success/error states with optional status code information.
@freezed
class ApiResponse<T> with _$ApiResponse<T> {
  /// Successful API response containing the expected data
  const factory ApiResponse.success(T data) = Success<T>;
  
  /// Failed API response with error message and optional HTTP status code
  /// 
  /// [message] - Human-readable error description
  /// [statusCode] - HTTP status code if available (null for network errors)
  const factory ApiResponse.error(
    String message, [
    int? statusCode,
  ]) = Error<T>;
}