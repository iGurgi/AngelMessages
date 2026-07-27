import 'package:angel_messages/models/schedule_category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScheduleCategory', () {
    test('has correct values', () {
      expect(ScheduleCategory.angelTimes.key, 'angel_times');
      expect(ScheduleCategory.everyHour.key, 'every_hour');
    });

    test('has correct display names', () {
      expect(ScheduleCategory.angelTimes.displayName, '✨ Angel Times');
      expect(ScheduleCategory.everyHour.displayName, '🕐 Every Hour');
    });

    test('fromKey returns correct category', () {
      expect(
        ScheduleCategory.fromKey('angel_times'),
        ScheduleCategory.angelTimes,
      );
      expect(
        ScheduleCategory.fromKey('every_hour'),
        ScheduleCategory.everyHour,
      );
    });

    test('fromKey returns default for invalid key', () {
      expect(
        ScheduleCategory.fromKey('invalid'),
        ScheduleCategory.angelTimes,
      );
    });
  });
}
