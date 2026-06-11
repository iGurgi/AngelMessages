enum ScheduleCategory {
  angelTimes('angel_times', '✨ Angel Times', 'Notifications at 1:11, 2:22, 3:33, 4:44, 5:55, 11:11, 12:12, 22:22'),
  everyHour('every_hour', '🕐 Every Hour', 'Notifications at the top of each hour');

  const ScheduleCategory(this.key, this.displayName, this.description);

  final String key;
  final String displayName;
  final String description;

  static ScheduleCategory fromKey(String key) {
    return ScheduleCategory.values.firstWhere(
      (category) => category.key == key,
      orElse: () => ScheduleCategory.angelTimes,
    );
  }
}
