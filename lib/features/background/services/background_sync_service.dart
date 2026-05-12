import 'package:workmanager/workmanager.dart';
import 'package:angel_messages/core/config/environment.dart';
import 'package:angel_messages/core/database/database.dart';
import 'package:angel_messages/features/messages/data/message_repository.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      // Initialize database
      final database = AppDatabase();

      // Create repository
      final repository = MessageRepository(database: database);

      // Sync messages
      await repository.syncMessages();

      // Clean up
      await database.close();

      return true;
    } catch (e) {
      print('Background sync failed: $e');
      return false;
    }
  });
}

class BackgroundSyncService {
  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
  }

  static Future<void> registerDailySync() async {
    await Workmanager().registerPeriodicTask(
      Environment.dailySyncTaskName,
      Environment.dailySyncTaskName,
      frequency: const Duration(hours: 24),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      backoffPolicy: BackoffPolicy.exponential,
      backoffPolicyDelay: const Duration(minutes: 15),
    );
  }

  static Future<void> cancelSync() async {
    await Workmanager().cancelByUniqueName(Environment.dailySyncTaskName);
  }
}
