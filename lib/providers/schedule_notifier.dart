import 'package:angel_messages/models/schedule_category.dart';
import 'package:angel_messages/services/notification_scheduler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'schedule_notifier.g.dart';

const String _schedulePreferenceKey = 'schedule_category';

@riverpod
class ScheduleNotifier extends _$ScheduleNotifier {
  late final SharedPreferences _prefs;
  late final NotificationScheduler _scheduler;

  @override
  Future<ScheduleCategory> build() async {
    _prefs = await SharedPreferences.getInstance();
    _scheduler = ref.watch(notificationSchedulerProvider);
    
    final savedKey = _prefs.getString(_schedulePreferenceKey);
    final category = savedKey != null
        ? ScheduleCategory.fromKey(savedKey)
        : ScheduleCategory.angelTimes;

    // Schedule notifications on startup
    await _scheduler.scheduleNotifications(category);

    return category;
  }

  Future<void> setScheduleCategory(ScheduleCategory category) async {
    await _prefs.setString(_schedulePreferenceKey, category.key);
    state = AsyncValue.data(category);
    
    // Immediately reschedule notifications
    await _scheduler.scheduleNotifications(category);
  }
}

@riverpod
NotificationScheduler notificationScheduler(NotificationSchedulerRef ref) {
  throw UnimplementedError('Must be overridden in main.dart');
}
