import 'package:dio/dio.dart';
import 'package:angel_messages/models/message.dart';

class SupabaseService {
  SupabaseService({
    required this.supabaseUrl,
    required this.supabaseAnonKey,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: supabaseUrl,
        headers: {
          'apikey': supabaseAnonKey,
          'Authorization': 'Bearer $supabaseAnonKey',
        },
      ),
    );
  }

  final String supabaseUrl;
  final String supabaseAnonKey;
  late final Dio _dio;

  /// Fetch messages from Supabase REST API
  Future<List<Message>> fetchMessages() async {
    try {
      final response = await _dio.get<List<dynamic>>(
        '/rest/v1/messages',
        queryParameters: {
          'order': 'created_at.desc',
        },
      );

      if (response.data == null) {
        return [];
      }

      return response.data!
          .map((json) => Message.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw NetworkException('Network connection failed');
      }
      rethrow;
    }
  }
}

class NetworkException implements Exception {
  NetworkException(this.message);
  final String message;

  @override
  String toString() => message;
}
