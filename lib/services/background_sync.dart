import 'package:angel_messages/repositories/message_repository.dart';
import 'package:workmanager/workmanager.dart';

const String dailySyncTaskName = 'angelMessages.dailySync';
const String dailySyncUniqueKey = 'dailySyncTask';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == dailySyncTaskName) {
      try {
        // Note: In a real app, you would need to reinitialize Isar and Dio here
        // For now, this is a placeholder showing the structure
        // The actual sync would happen in main.dart where dependencies are available
        return Future.value(true);
      } catch (e) {
        // Return true to indicate task completed even if sync failed
        // This prevents WorkManager from retrying indefinitely
        return Future.value(true);
      }
    }
    return Future.value(true);
  });
}

class BackgroundSyncService {
  /// Initialize WorkManager and register periodic task
  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );

    await registerDailySync();
  }

  /// Register daily sync task
  static Future<void> registerDailySync() async {
    await Workmanager().registerPeriodicTask(
      dailySyncUniqueKey,
      dailySyncTaskName,
      frequency: const Duration(hours: 24),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      existingWorkPolicy: ExistingWorkPolicy.keep,
    );
  }

  /// Cancel all background tasks
  static Future<void> cancelAll() async {
    await Workmanager().cancelAll();
  }
}
