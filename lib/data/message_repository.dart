import 'package:angel_messages/data/database.dart';
import 'package:angel_messages/models/message.dart';
import 'package:angel_messages/services/supabase_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart' as drift;

class MessageRepository {
  MessageRepository({
    required this.database,
    required this.supabaseService,
  });

  final AppDatabase database;
  final SupabaseService supabaseService;

  /// Fetch all messages from local database ordered by creation date
  Future<List<Message>> getAllMessages() async {
    final query = database.select(database.messages)
      ..orderBy([
        (t) => drift.OrderingTerm(
              expression: t.createdAt,
              mode: drift.OrderingMode.desc,
            ),
      ]);

    final results = await query.get();
    return results
        .map(
          (row) => Message(
            id: row.id,
            title: row.title,
            body: row.body,
            category: row.category,
            createdAt: row.createdAt,
            viewed: row.viewed,
          ),
        )
        .toList();
  }

  /// Get next unviewed message
  Future<Message?> getNextUnviewedMessage() async {
    final query = database.select(database.messages)
      ..where((t) => t.viewed.equals(false))
      ..orderBy([
        (t) => drift.OrderingTerm(
              expression: t.createdAt,
              mode: drift.OrderingMode.asc,
            ),
      ])
      ..limit(1);

    final results = await query.get();
    if (results.isEmpty) {
      // No unviewed messages, reset all viewed flags
      await resetAllViewed();
      // Try again
      final retryResults = await query.get();
      if (retryResults.isEmpty) {
        return null;
      }
      final row = retryResults.first;
      return Message(
        id: row.id,
        title: row.title,
        body: row.body,
        category: row.category,
        createdAt: row.createdAt,
        viewed: row.viewed,
      );
    }

    final row = results.first;
    return Message(
      id: row.id,
      title: row.title,
      body: row.body,
      category: row.category,
      createdAt: row.createdAt,
      viewed: row.viewed,
    );
  }

  /// Get a specific message by ID
  Future<Message?> getMessageById(String messageId) async {
    final query = database.select(database.messages)
      ..where((t) => t.id.equals(messageId));

    final results = await query.get();
    if (results.isEmpty) {
      return null;
    }

    final row = results.first;
    return Message(
      id: row.id,
      title: row.title,
      body: row.body,
      category: row.category,
      createdAt: row.createdAt,
      viewed: row.viewed,
    );
  }

  /// Mark a message as viewed
  Future<void> markAsViewed(String messageId) async {
    await (database.update(database.messages)
          ..where((t) => t.id.equals(messageId)))
        .write(MessagesCompanion(viewed: const drift.Value(true)));
  }

  /// Reset all viewed flags
  Future<void> resetAllViewed() async {
    await database.update(database.messages).write(
          const MessagesCompanion(viewed: drift.Value(false)),
        );
  }

  /// Sync messages from remote Supabase API
  Future<void> syncFromRemote() async {
    // Check connectivity
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      // No network, skip sync
      return;
    }

    try {
      final remoteMessages = await supabaseService.fetchMessages();

      // Upsert messages into local database
      for (final message in remoteMessages) {
        await database.into(database.messages).insertOnConflictUpdate(
              MessagesCompanion(
                id: drift.Value(message.id),
                title: drift.Value(message.title),
                body: drift.Value(message.body),
                category: drift.Value(message.category),
                createdAt: drift.Value(message.createdAt),
                // Don't overwrite viewed status on sync
                viewed: drift.Value(message.viewed),
              ),
            );
      }
    } catch (e) {
      // Log error but don't throw - offline-first architecture
      // In production, use proper logging
      print('Failed to sync messages: $e');
    }
  }
}
