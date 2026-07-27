import 'dart:convert';
import 'dart:io';

import 'package:angel_messages/models/message.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'message_repository.g.dart';

@riverpod
MessageRepository messageRepository(MessageRepositoryRef ref) {
  throw UnimplementedError('Must be overridden in main.dart');
}

class MessageRepository {
  MessageRepository({
    required Dio dio,
    required String supabaseUrl,
    required String supabaseAnonKey,
  })  : _dio = dio,
        _supabaseUrl = supabaseUrl,
        _supabaseAnonKey = supabaseAnonKey;

  final Dio _dio;
  final String _supabaseUrl;
  final String _supabaseAnonKey;
  
  File? _messagesFile;
  List<Message>? _cachedMessages;

  Future<File> get _file async {
    if (_messagesFile != null) return _messagesFile!;
    final directory = await getApplicationDocumentsDirectory();
    _messagesFile = File('${directory.path}/messages.json');
    return _messagesFile!;
  }

  /// Fetch all messages from local storage
  Future<List<Message>> getAllMessages() async {
    if (_cachedMessages != null) return List.from(_cachedMessages!);
    
    final file = await _file;
    if (!await file.exists()) {
      return [];
    }

    final jsonString = await file.readAsString();
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    _cachedMessages = jsonList
        .map((json) => Message.fromJson(json as Map<String, dynamic>))
        .toList();
    
    // Sort by created date descending
    _cachedMessages!.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    return List.from(_cachedMessages!);
  }

  /// Get a specific message by ID
  Future<Message?> getMessageById(String id) async {
    final messages = await getAllMessages();
    try {
      return messages.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get next unviewed message, or null if all viewed
  Future<Message?> getNextUnviewedMessage() async {
    final messages = await getAllMessages();
    final unviewed = messages.where((m) => !m.viewed).toList();

    if (unviewed.isEmpty) {
      // All messages have been viewed, reset all viewed flags
      await _resetAllViewed();
      // Return the oldest message
      final sorted = List<Message>.from(messages)
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return sorted.isNotEmpty ? sorted.first : null;
    }

    // Return oldest unviewed
    unviewed.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return unviewed.first;
  }

  /// Mark a message as viewed
  Future<void> markAsViewed(String id) async {
    final messages = await getAllMessages();
    final index = messages.indexWhere((m) => m.id == id);
    
    if (index != -1) {
      messages[index] = messages[index].copyWith(viewed: true);
      await _saveMessages(messages);
    }
  }

  /// Reset all viewed flags
  Future<void> _resetAllViewed() async {
    final messages = await getAllMessages();
    final updated = messages.map((m) => m.copyWith(viewed: false)).toList();
    await _saveMessages(updated);
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
        final newMessages = response.data!
            .map((json) => Message.fromJson(json as Map<String, dynamic>))
            .toList();

        await _upsertMessages(newMessages);
      }
    } catch (e) {
      // Silently fail if network is unavailable
      // App will continue to work with cached messages
    }
  }

  /// Upsert messages into local storage
  Future<void> _upsertMessages(List<Message> newMessages) async {
    final existing = await getAllMessages();
    final Map<String, Message> messageMap = {
      for (var msg in existing) msg.id: msg,
    };

    // Update map with new messages, preserving viewed status
    for (final newMsg in newMessages) {
      if (messageMap.containsKey(newMsg.id)) {
        // Preserve viewed status
        messageMap[newMsg.id] = newMsg.copyWith(
          viewed: messageMap[newMsg.id]!.viewed,
        );
      } else {
        messageMap[newMsg.id] = newMsg;
      }
    }

    await _saveMessages(messageMap.values.toList());
  }

  /// Save messages to file
  Future<void> _saveMessages(List<Message> messages) async {
    final file = await _file;
    final jsonList = messages.map((m) => m.toJson()).toList();
    await file.writeAsString(json.encode(jsonList));
    _cachedMessages = List.from(messages);
  }

  /// Get count of unviewed messages
  Future<int> getUnviewedCount() async {
    final messages = await getAllMessages();
    return messages.where((m) => !m.viewed).length;
  }

  /// Seed initial messages (for testing/development)
  Future<void> seedInitialMessages() async {
    final existing = await getAllMessages();
    if (existing.isNotEmpty) return; // Already seeded

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

    await _saveMessages(initialMessages);
  }
}
