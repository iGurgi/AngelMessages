import 'package:flutter_test/flutter_test.dart';
import 'package:angel_messages/models/schedule_category.dart';

void main() {
  group('ScheduleCategory', () {
    test('creates AngelTimes variant', () {
      const category = ScheduleCategory.angelTimes();
      expect(category, isA<AngelTimes>());
    });

    test('creates EveryHour variant', () {
      const category = ScheduleCategory.everyHour();
      expect(category, isA<EveryHour>());
    });

    test('AngelTimes has correct label', () {
      const category = ScheduleCategory.angelTimes();
      expect(category.label, '✨ Angel Times');
    });

    test('EveryHour has correct label', () {
      const category = ScheduleCategory.everyHour();
      expect(category.label, '🕐 Every Hour');
    });

    test('AngelTimes has correct description', () {
      const category = ScheduleCategory.angelTimes();
      expect(
        category.description,
        contains('1:11'),
      );
      expect(category.description, contains('11:11'));
    });

    test('EveryHour has correct description', () {
      const category = ScheduleCategory.everyHour();
      expect(category.description, contains('top of every hour'));
    });

    test('AngelTimes has correct key', () {
      const category = ScheduleCategory.angelTimes();
      expect(category.key, 'angel_times');
    });

    test('EveryHour has correct key', () {
      const category = ScheduleCategory.everyHour();
      expect(category.key, 'every_hour');
    });

    test('scheduleCategoryFromKey returns correct variant', () {
      final angelTimes = scheduleCategoryFromKey('angel_times');
      expect(angelTimes, isA<AngelTimes>());

      final everyHour = scheduleCategoryFromKey('every_hour');
      expect(everyHour, isA<EveryHour>());
    });

    test('scheduleCategoryFromKey defaults to AngelTimes for unknown key', () {
      final category = scheduleCategoryFromKey('unknown');
      expect(category, isA<AngelTimes>());
    });

    test('equality works correctly', () {
      const category1 = ScheduleCategory.angelTimes();
      const category2 = ScheduleCategory.angelTimes();
      const category3 = ScheduleCategory.everyHour();

      expect(category1, equals(category2));
      expect(category1, isNot(equals(category3)));
    });
  });
}
