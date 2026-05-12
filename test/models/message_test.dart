import 'package:flutter_test/flutter_test.dart';
import 'package:angel_messages/models/message.dart';

void main() {
  group('Message', () {
    test('creates a message with required fields', () {
      final message = Message(
        id: 'test-id',
        title: 'Test Title',
        body: 'Test Body',
        category: 'test',
        createdAt: DateTime(2024, 1, 1),
      );

      expect(message.id, 'test-id');
      expect(message.title, 'Test Title');
      expect(message.body, 'Test Body');
      expect(message.category, 'test');
      expect(message.createdAt, DateTime(2024, 1, 1));
      expect(message.viewed, false);
    });

    test('creates a message with viewed flag', () {
      final message = Message(
        id: 'test-id',
        title: 'Test Title',
        body: 'Test Body',
        category: 'test',
        createdAt: DateTime(2024, 1, 1),
        viewed: true,
      );

      expect(message.viewed, true);
    });

    test('copyWith updates fields correctly', () {
      final message = Message(
        id: 'test-id',
        title: 'Test Title',
        body: 'Test Body',
        category: 'test',
        createdAt: DateTime(2024, 1, 1),
        viewed: false,
      );

      final updated = message.copyWith(viewed: true);

      expect(updated.id, message.id);
      expect(updated.title, message.title);
      expect(updated.body, message.body);
      expect(updated.category, message.category);
      expect(updated.createdAt, message.createdAt);
      expect(updated.viewed, true);
    });

    test('equality works correctly', () {
      final message1 = Message(
        id: 'test-id',
        title: 'Test Title',
        body: 'Test Body',
        category: 'test',
        createdAt: DateTime(2024, 1, 1),
      );

      final message2 = Message(
        id: 'test-id',
        title: 'Test Title',
        body: 'Test Body',
        category: 'test',
        createdAt: DateTime(2024, 1, 1),
      );

      expect(message1, equals(message2));
    });

    test('fastHash generates consistent IDs', () {
      const id = 'test-id';
      final hash1 = fastHash(id);
      final hash2 = fastHash(id);

      expect(hash1, equals(hash2));
      expect(hash1, isNot(equals(0)));
    });

    test('fastHash generates different IDs for different strings', () {
      final hash1 = fastHash('test-id-1');
      final hash2 = fastHash('test-id-2');

      expect(hash1, isNot(equals(hash2)));
    });
  });
}
