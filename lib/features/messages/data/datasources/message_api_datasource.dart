import 'package:dio/dio.dart';
import '../models/api_response.dart';
import '../models/message_api_model.dart';

/// Remote data source for message API operations
class MessageApiDataSource {
  final Dio _dio;

  MessageApiDataSource({
    Dio? dio,
  }) : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: const String.fromEnvironment(
                'API_BASE_URL',
                defaultValue: 'https://api.angelmessages.com',
              ),
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ));

  /// Fetches daily messages from the API
  /// 
  /// Returns an [ApiResponse] containing a list of [MessageApiModel] on success,
  /// or error information on failure.
  Future<ApiResponse<List<MessageApiModel>>> fetchDailyMessages() async {
    try {
      final response = await _dio.get('/messages/daily');
      
      // Check if response status is successful
      if (response.statusCode != null && 
          response.statusCode! >= 200 && 
          response.statusCode! < 300) {
        
        // Parse response data
        final data = response.data;
        if (data is Map<String, dynamic>) {
          // Handle wrapped response format
          if (data.containsKey('data') && data['data'] is List) {
            final messagesJson = data['data'] as List;
            final messages = messagesJson
                .cast<Map<String, dynamic>>()
                .map((json) => MessageApiModel.fromJson(json))
                .toList();
            
            return ApiResponse.success(
              data: messages,
              message: data['message'] as String? ?? 'Messages fetched successfully',
            );
          }
          // Handle direct array response wrapped in object
          else if (data.containsKey('messages') && data['messages'] is List) {
            final messagesJson = data['messages'] as List;
            final messages = messagesJson
                .cast<Map<String, dynamic>>()
                .map((json) => MessageApiModel.fromJson(json))
                .toList();
            
            return ApiResponse.success(
              data: messages,
              message: 'Messages fetched successfully',
            );
          }
        }
        // Handle direct array response
        else if (data is List) {
          final messages = data
              .cast<Map<String, dynamic>>()
              .map((json) => MessageApiModel.fromJson(json))
              .toList();
          
          return ApiResponse.success(
            data: messages,
            message: 'Messages fetched successfully',
          );
        }
        
        // Unexpected response format
        return ApiResponse.error(
          message: 'Unexpected response format from server',
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse.error(
          message: 'Server returned error status: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors
      return _handleDioError(e);
    } catch (e) {
      // Handle any other unexpected errors
      return ApiResponse.error(
        message: 'Unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Handles Dio errors and converts them to appropriate ApiResponse
  ApiResponse<List<MessageApiModel>> _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiResponse.error(
          message: 'Connection timeout. Please check your internet connection.',
          statusCode: error.response?.statusCode,
        );
      
      case DioExceptionType.connectionError:
        return ApiResponse.error(
          message: 'Network connection error. Please check your internet connection.',
          statusCode: error.response?.statusCode,
        );
      
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;
        
        String errorMessage = 'Server error occurred';
        if (responseData is Map<String, dynamic>) {
          errorMessage = responseData['message'] as String? ?? 
                        responseData['error'] as String? ?? 
                        errorMessage;
        }
        
        return ApiResponse.error(
          message: errorMessage,
          statusCode: statusCode,
        );
      
      case DioExceptionType.cancel:
        return ApiResponse.error(
          message: 'Request was cancelled',
          statusCode: error.response?.statusCode,
        );
      
      case DioExceptionType.unknown:
      default:
        return ApiResponse.error(
          message: error.message ?? 'An unknown error occurred',
          statusCode: error.response?.statusCode,
        );
    }
  }

  /// Disposes the Dio client resources
  void dispose() {
    _dio.close();
  }
}
