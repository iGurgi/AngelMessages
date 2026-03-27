import 'package:freezed_annotation/freezed_annotation.dart';

/// Defines the different notification schedule options available to users
enum NotificationSchedule {
  /// Angel times: 3:33, 4:44, 5:55 (AM/PM)
  @JsonValue('angel_times')
  angelTimes,
  
  /// Every hour from 6 AM to 10 PM
  @JsonValue('hourly')
  hourly,
  
  /// No notifications
  @JsonValue('off')
  off,
}

/// Extension to provide user-friendly display labels for notification schedules
extension NotificationScheduleX on NotificationSchedule {
  /// Human-readable label for the schedule option
  String get displayLabel {
    switch (this) {
      case NotificationSchedule.angelTimes:
        return 'Angel Times (3:33, 4:44, 5:55)';
      case NotificationSchedule.hourly:
        return 'Every Hour (6 AM - 10 PM)';
      case NotificationSchedule.off:
        return 'Off';
    }
  }
  
  /// Brief description of what this schedule does
  String get description {
    switch (this) {
      case NotificationSchedule.angelTimes:
        return 'Receive messages at special angel number times';
      case NotificationSchedule.hourly:
        return 'Get a new message every hour during daytime';
      case NotificationSchedule.off:
        return 'No automatic notifications';
    }
  }
  
  /// Whether this schedule option sends notifications
  bool get isEnabled {
    return this != NotificationSchedule.off;
  }
}
