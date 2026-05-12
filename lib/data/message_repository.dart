import 'package:isar/isar.dart';
import 'package:angel_messages/data/database.dart';
import 'package:angel_messages/models/message.dart';
import 'package:angel_messages/services/supabase_service.dart';

class MessageRepository {
  MessageRepository({
    required this.supabaseService,
  });

  final SupabaseService supabaseService;

  Future<Isar> get _db async => AppDatabase.getInstance();

  /// Fetch all messages from local database ordered by creation date
  Future<List<Message>> getAllMessages() async {
    final db = await _db;
    final messages = await db.messages.where().sortByIsarCreatedAtDesc().findAll();
    return messages;
  }

  /// Get next unviewed message
  Future<Message?> getNextUnviewedMessage() async {
    final db = await _db;
    final message = await db.messages
        .filter()
        .isViewedEqualTo(false)
        .sortByIsarCreatedAt()
        .findFirst();

    // If no unviewed messages, reset all viewed flags
    if (message == null) {
      await resetAllViewedFlags();
      // Return the first message after reset
      return db.messages.where().sortByIsarCreatedAt().findFirst();
    }

    return message;
  }

  /// Get message by ID
  Future<Message?> getMessageById(String id) async {
    final db = await _db;
    final isarId = fastHash(id);
    return db.messages.get(isarId);
  }

  /// Mark message as viewed
  Future<void> markAsViewed(String id) async {
    final db = await _db;
    final message = await getMessageById(id);
    if (message != null) {
      await db.writeTxn(() async {
        await db.messages.put(message.copyWith(viewed: true));
      });
    }
  }

  /// Reset all viewed flags
  Future<void> resetAllViewedFlags() async {
    final db = await _db;
    final allMessages = await db.messages.where().findAll();

    await db.writeTxn(() async {
      for (final message in allMessages) {
        await db.messages.put(message.copyWith(viewed: false));
      }
    });
  }

  /// Sync messages from Supabase API
  Future<void> syncFromRemote() async {
    try {
      final remoteMessages = await supabaseService.fetchMessages();
      final db = await _db;

      await db.writeTxn(() async {
        for (final message in remoteMessages) {
          await db.messages.put(message);
        }
      });
    } catch (e) {
      // Silent fail for offline scenarios
      // In production, you'd want to log this
      rethrow;
    }
  }

  /// Upsert a message into local database
  Future<void> upsertMessage(Message message) async {
    final db = await _db;
    await db.writeTxn(() async {
      await db.messages.put(message);
    });
  }

  /// Get count of unviewed messages
  Future<int> getUnviewedCount() async {
    final db = await _db;
    return db.messages.filter().isViewedEqualTo(false).count();
  }
}
