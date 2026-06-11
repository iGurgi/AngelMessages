import 'package:angel_messages/models/message.dart';
import 'package:dio/dio.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'message_repository.g.dart';

@riverpod
MessageRepository messageRepository(MessageRepositoryRef ref) {
  throw UnimplementedError('Must be overridden in main.dart');
}

class MessageRepository {
  MessageRepository({
    required Isar isar,
    required Dio dio,
    required String supabaseUrl,
    required String supabaseAnonKey,
  })  : _isar = isar,
        _dio = dio,
        _supabaseUrl = supabaseUrl,
        _supabaseAnonKey = supabaseAnonKey;

  final Isar _isar;
  final Dio _dio;
  final String _supabaseUrl;
  final String _supabaseAnonKey;

  /// Fetch all messages from local database
  Future<List<Message>> getAllMessages() async {
    return _isar.messages.where().sortByCreatedAtDesc().findAll();
  }

  /// Get a specific message by ID
  Future<Message?> getMessageById(String id) async {
    return _isar.messages.filter().idEqualTo(id).findFirst();
  }

  /// Get next unviewed message, or null if all viewed
  Future<Message?> getNextUnviewedMessage() async {
    final unviewed = await _isar.messages
        .filter()
        .viewedEqualTo(false)
        .sortByCreatedAt()
        .findFirst();

    if (unviewed == null) {
      // All messages have been viewed, reset all viewed flags
      await _resetAllViewed();
      // Return the oldest message
      return _isar.messages.where().sortByCreatedAt().findFirst();
    }

    return unviewed;
  }

  /// Mark a message as viewed
  Future<void> markAsViewed(String id) async {
    await _isar.writeTxn(() async {
      final message = await _isar.messages.filter().idEqualTo(id).findFirst();
      if (message != null) {
        message.viewed = true;
        await _isar.messages.put(message);
      }
    });
  }

  /// Reset all viewed flags
  Future<void> _resetAllViewed() async {
    await _isar.writeTxn(() async {
      final allMessages = await _isar.messages.where().findAll();
      for (final message in allMessages) {
        message.viewed = false;
      }
      await _isar.messages.putAll(allMessages);
    });
  }

  /// Sync messages from Supabase API
  Future<void> syncFromApi() async {
    try {
      final response = await _dio.get<List<dynamic>>(
        '$_supabaseUrl/rest/v1/messages',
        queryParameters: {'order': 'created_at.desc'},
        options: Options(
          headers: {
            'apikey': _supabaseAnonKey,
            'Authorization': 'Bearer $_supabaseAnonKey',
          },
        ),
      );

      if (response.data != null) {
        final messages = response.data!
            .map((json) => Message.fromJson(json as Map<String, dynamic>))
            .toList();

        await _upsertMessages(messages);
      }
    } catch (e) {
      // Silently fail if network is unavailable
      // App will continue to work with cached messages
      rethrow;
    }
  }

  /// Upsert messages into local database
  Future<void> _upsertMessages(List<Message> messages) async {
    await _isar.writeTxn(() async {
      for (final message in messages) {
        final existing = await _isar.messages.filter().idEqualTo(message.id).findFirst();
        if (existing != null) {
          // Preserve viewed status for existing messages
          final updated = message.copyWith(viewed: existing.viewed);
          await _isar.messages.put(updated);
        } else {
          // New message, insert with viewed = false
          await _isar.messages.put(message);
        }
      }
    });
  }

  /// Get count of unviewed messages
  Future<int> getUnviewedCount() async {
    return _isar.messages.filter().viewedEqualTo(false).count();
  }

  /// Seed initial messages (for testing/development)
  Future<void> seedInitialMessages() async {
    final count = await _isar.messages.count();
    if (count > 0) return; // Already seeded

    final initialMessages = [
      Message(
        id: '00000000-0000-0000-0000-000000000001',
        title: 'Divine Guidance',
        body: 'The angels remind you that you are exactly where you need to be. Trust in the divine timing of your journey and know that every step brings you closer to your highest self.',
        category: 'guidance',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      Message(
        id: '00000000-0000-0000-0000-000000000002',
        title: 'Inner Peace',
        body: 'Find stillness within the chaos. Your inner sanctuary is always accessible, a place of infinite peace and wisdom. Breathe deeply and return to your center.',
        category: 'peace',
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
      ),
      Message(
        id: '00000000-0000-0000-0000-000000000003',
        title: 'Abundance Flows',
        body: 'You are a magnet for miracles and abundance. Open your heart to receive the blessings that the universe is sending your way. You are worthy of all good things.',
        category: 'abundance',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Message(
        id: '00000000-0000-0000-0000-000000000004',
        title: 'Intuitive Wisdom',
        body: 'Your intuition is a direct line to divine wisdom. Trust the whispers of your soul and the signs that appear on your path. You already know the answer.',
        category: 'intuition',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
      Message(
        id: '00000000-0000-0000-0000-000000000005',
        title: 'Love and Light',
        body: 'You are surrounded by angels who love you unconditionally. Feel their presence, their warmth, their unwavering support. You are never alone.',
        category: 'love',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];

    await _isar.writeTxn(() async {
      await _isar.messages.putAll(initialMessages);
    });
  }
}
