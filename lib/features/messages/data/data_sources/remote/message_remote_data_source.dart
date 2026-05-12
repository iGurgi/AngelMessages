import 'package:angel_messages/core/constants/app_constants.dart';
import 'package:angel_messages/features/messages/data/models/message.dart';
import 'package:dio/dio.dart';

/// Remote data source for messages using Supabase REST API
class MessageRemoteDataSource {
  MessageRemoteDataSource(this._dio);

  final Dio _dio;

  /// Fetch all messages from Supabase
  Future<List<Message>> fetchMessages() async {
    try {
      final response = await _dio.get<List<dynamic>>(
        '${AppConstants.supabaseUrl}/rest/v1/messages',
        queryParameters: {
          'order': 'created_at.desc',
        },
        options: Options(
          headers: {
            'apikey': AppConstants.supabaseAnonKey,
            'Authorization': 'Bearer ${AppConstants.supabaseAnonKey}',
          },
        ),
      );

      if (response.data == null) {
        return [];
      }

      return response.data!
          .map((json) => Message.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw RemoteDataSourceException(
        'Failed to fetch messages: ${e.message}',
      );
    }
  }
}

/// Exception thrown when remote data source operations fail
class RemoteDataSourceException implements Exception {
  RemoteDataSourceException(this.message);

  final String message;

  @override
  String toString() => message;
}
