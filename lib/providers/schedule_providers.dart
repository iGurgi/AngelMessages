import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:angel_messages/models/schedule_category.dart';
import 'package:angel_messages/services/notification_scheduler.dart';
import 'package:angel_messages/providers/repository_providers.dart';

part 'schedule_providers.g.dart';

const String _schedulePreferenceKey = 'notification_schedule';

@riverpod
class ScheduleNotifier extends _$ScheduleNotifier {
  @override
  Future<ScheduleCategory> build() async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(_schedulePreferenceKey) ?? 'angel_times';
    return scheduleCategoryFromKey(key);
  }

  Future<void> setSchedule(ScheduleCategory category) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_schedulePreferenceKey, category.key);

    // Update state
    state = AsyncValue.data(category);

    // Reschedule notifications
    final scheduler = ref.read(notificationSchedulerProvider);
    await scheduler.scheduleNotifications(category);
  }
}
