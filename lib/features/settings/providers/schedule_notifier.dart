import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:angel_messages/core/models/schedule_category.dart';
import 'package:angel_messages/features/messages/data/message_repository.dart';
import 'package:angel_messages/features/notifications/services/notification_scheduler.dart';

part 'schedule_notifier.g.dart';

const String _schedulePreferenceKey = 'schedule_category';

@riverpod
class ScheduleNotifier extends _$ScheduleNotifier {
  NotificationScheduler? _scheduler;

  @override
  Future<ScheduleCategory> build() async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(_schedulePreferenceKey);

    if (key != null) {
      return ScheduleCategoryExtension.fromKey(key);
    }

    return ScheduleCategory.angelTimes; // Default
  }

  /// Update the schedule category
  Future<void> updateSchedule(ScheduleCategory category) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_schedulePreferenceKey, category.key);

    // Update state
    state = AsyncValue.data(category);

    // Reschedule notifications
    await _rescheduleNotifications(category);
  }

  /// Initialize the notification scheduler
  void setScheduler(NotificationScheduler scheduler) {
    _scheduler = scheduler;
  }

  /// Reschedule notifications for the new category
  Future<void> _rescheduleNotifications(ScheduleCategory category) async {
    if (_scheduler != null) {
      await _scheduler!.scheduleNotifications(category);
    }
  }
}

@riverpod
NotificationScheduler notificationScheduler(NotificationSchedulerRef ref) {
  final messageRepository = ref.watch(messageRepositoryProvider);
  final scheduler = NotificationScheduler(messageRepository: messageRepository);
  
  // Set the scheduler in the ScheduleNotifier
  ref.listen<AsyncValue<ScheduleCategory>>(
    scheduleNotifierProvider,
    (previous, next) {
      next.whenData((category) {
        scheduler.scheduleNotifications(category);
      });
    },
  );

  return scheduler;
}
