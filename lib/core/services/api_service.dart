import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service for handling all HTTP API communication
/// Configured with proper timeouts, headers, and error handling
class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(_buildBaseOptions());
    _setupInterceptors();
  }

  /// Get the configured Dio instance
  Dio get dio => _dio;

  /// Build base configuration options for Dio
  BaseOptions _buildBaseOptions() {
    const baseUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'https://api.angelmessages.app',
    );

    return BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (status) {
        // Accept status codes 200-299 as successful
        return status != null && status >= 200 && status < 300;
      },
    );
  }

  /// Setup request/response interceptors for logging and error handling
  void _setupInterceptors() {
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (object) {
          // In production, you might want to use a proper logging service
          // ignore: avoid_print
          print('[API] $object');
        },
      ),
    );

    // Add error interceptor for consistent error handling
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          final apiError = _handleDioError(error);
          handler.reject(DioException(
            requestOptions: error.requestOptions,
            response: error.response,
            type: error.type,
            error: apiError,
            message: apiError.message,
          ));
        },
      ),
    );
  }

  /// Handle and standardize Dio errors
  ApiError _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiError(
          message: 'Connection timeout. Please check your internet connection.',
          type: ApiErrorType.timeout,
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        if (statusCode >= 500) {
          return ApiError(
            message: 'Server error. Please try again later.',
            type: ApiErrorType.server,
            statusCode: statusCode,
          );
        } else if (statusCode >= 400) {
          return ApiError(
            message: error.response?.data?['message'] ?? 'Request failed.',
            type: ApiErrorType.client,
            statusCode: statusCode,
          );
        }
        break;
      case DioExceptionType.connectionError:
        return ApiError(
          message: 'No internet connection. Please check your network.',
          type: ApiErrorType.network,
        );
      case DioExceptionType.cancel:
        return ApiError(
          message: 'Request was cancelled.',
          type: ApiErrorType.cancelled,
        );
      default:
        return ApiError(
          message: 'An unexpected error occurred.',
          type: ApiErrorType.unknown,
        );
    }

    return ApiError(
      message: error.message ?? 'An unexpected error occurred.',
      type: ApiErrorType.unknown,
    );
  }

  /// Fetch daily messages from the API
  Future<Response> fetchDailyMessages() async {
    try {
      return await _dio.get('/messages/daily');
    } on DioException {
      rethrow;
    }
  }

  /// Fetch a specific message by ID
  Future<Response> fetchMessage(String messageId) async {
    try {
      return await _dio.get('/messages/$messageId');
    } on DioException {
      rethrow;
    }
  }

  /// Sync messages for offline access
  Future<Response> syncMessages({DateTime? since}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (since != null) {
        queryParams['since'] = since.toIso8601String();
      }

      return await _dio.get(
        '/messages/sync',
        queryParameters: queryParams,
      );
    } on DioException {
      rethrow;
    }
  }

  /// Report message interaction for analytics
  Future<Response> reportMessageInteraction({
    required String messageId,
    required String interactionType,
  }) async {
    try {
      return await _dio.post(
        '/messages/$messageId/interactions',
        data: {
          'type': interactionType,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } on DioException {
      rethrow;
    }
  }

  /// Close the Dio client and clean up resources
  void close() {
    _dio.close();
  }
}

/// Standardized API error class
class ApiError {
  final String message;
  final ApiErrorType type;
  final int? statusCode;
  final Map<String, dynamic>? details;

  const ApiError({
    required this.message,
    required this.type,
    this.statusCode,
    this.details,
  });

  @override
  String toString() {
    return 'ApiError(message: $message, type: $type, statusCode: $statusCode)';
  }
}

/// Types of API errors for consistent handling
enum ApiErrorType {
  network,
  timeout,
  server,
  client,
  cancelled,
  unknown,
}

/// Riverpod provider for ApiService
final apiServiceProvider = Provider<ApiService>((ref) {
  final apiService = ApiService();
  
  // Clean up when provider is disposed
  ref.onDispose(() {
    apiService.close();
  });
  
  return apiService;
});
