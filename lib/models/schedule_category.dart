import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_category.freezed.dart';
part 'schedule_category.g.dart';

@freezed
class ScheduleCategory with _$ScheduleCategory {
  const factory ScheduleCategory.angelTimes() = AngelTimes;
  const factory ScheduleCategory.everyHour() = EveryHour;

  factory ScheduleCategory.fromJson(Map<String, dynamic> json) =>
      _$ScheduleCategoryFromJson(json);
}

extension ScheduleCategoryExtension on ScheduleCategory {
  String get label => when(
        angelTimes: () => '✨ Angel Times',
        everyHour: () => '🕐 Every Hour',
      );

  String get description => when(
        angelTimes: () =>
            'Receive messages at sacred times: 1:11, 2:22, 3:33, 4:44, 5:55, 11:11, 12:12, and 22:22',
        everyHour: () => 'Receive messages at the top of every hour',
      );

  String get key => when(
        angelTimes: () => 'angel_times',
        everyHour: () => 'every_hour',
      );
}

ScheduleCategory scheduleCategoryFromKey(String key) {
  switch (key) {
    case 'angel_times':
      return const ScheduleCategory.angelTimes();
    case 'every_hour':
      return const ScheduleCategory.everyHour();
    default:
      return const ScheduleCategory.angelTimes();
  }
}
