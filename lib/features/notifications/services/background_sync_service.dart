import 'package:angel_messages/core/constants/app_constants.dart';
import 'package:angel_messages/features/messages/data/repositories/message_repository.dart';
import 'package:workmanager/workmanager.dart';

/// Background sync service using WorkManager for daily message synchronization
class BackgroundSyncService {
  BackgroundSyncService({
    required MessageRepository messageRepository,
  }) : _messageRepository = messageRepository;

  final MessageRepository _messageRepository;

  /// Initialize WorkManager
  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
  }

  /// Register the daily sync task
  Future<void> registerDailySync() async {
    await Workmanager().registerPeriodicTask(
      AppConstants.bgTaskUniqueName,
      AppConstants.bgTaskDailySync,
      frequency: const Duration(hours: 24),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      existingWorkPolicy: ExistingWorkPolicy.keep,
    );
  }

  /// Cancel the daily sync task
  Future<void> cancelDailySync() async {
    await Workmanager().cancelByUniqueName(AppConstants.bgTaskUniqueName);
  }

  /// Execute sync operation
  Future<bool> executeSync() async {
    return _messageRepository.syncMessages();
  }
}

/// Top-level callback dispatcher for WorkManager
/// Must be a top-level function or static method
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      switch (task) {
        case AppConstants.bgTaskDailySync:
          // Note: In production, you would need to initialize dependencies here
          // For now, we'll return success
          // In a real app, you'd use get_it or another DI solution
          // to provide the repository to the background task
          return Future.value(true);
        default:
          return Future.value(false);
      }
    } catch (e) {
      return Future.value(false);
    }
  });
}
