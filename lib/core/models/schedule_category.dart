enum ScheduleCategory {
  angelTimes,
  everyHour,
}

extension ScheduleCategoryExtension on ScheduleCategory {
  String get displayName {
    switch (this) {
      case ScheduleCategory.angelTimes:
        return '✨ Angel Times';
      case ScheduleCategory.everyHour:
        return '🕐 Every Hour';
    }
  }

  String get description {
    switch (this) {
      case ScheduleCategory.angelTimes:
        return 'Receive messages at special times: 1:11, 2:22, 3:33, 4:44, 5:55, 11:11, 12:12, 22:22';
      case ScheduleCategory.everyHour:
        return 'Receive messages at the top of every hour';
    }
  }

  String get key {
    switch (this) {
      case ScheduleCategory.angelTimes:
        return 'angel_times';
      case ScheduleCategory.everyHour:
        return 'every_hour';
    }
  }

  static ScheduleCategory fromKey(String key) {
    switch (key) {
      case 'angel_times':
        return ScheduleCategory.angelTimes;
      case 'every_hour':
        return ScheduleCategory.everyHour;
      default:
        return ScheduleCategory.angelTimes;
    }
  }
}
