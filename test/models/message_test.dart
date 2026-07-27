import 'package:angel_messages/models/message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Message', () {
    test('creates message from JSON', () {
      final json = {
        'id': 'test-id',
        'title': 'Test Title',
        'body': 'Test Body',
        'category': 'test',
        'created_at': '2024-01-01T00:00:00.000Z',
      };

      final message = Message.fromJson(json);

      expect(message.id, 'test-id');
      expect(message.title, 'Test Title');
      expect(message.body, 'Test Body');
      expect(message.category, 'test');
      expect(message.viewed, false);
    });

    test('converts message to JSON', () {
      final message = Message(
        id: 'test-id',
        title: 'Test Title',
        body: 'Test Body',
        category: 'test',
        createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
      );

      final json = message.toJson();

      expect(json['id'], 'test-id');
      expect(json['title'], 'Test Title');
      expect(json['body'], 'Test Body');
      expect(json['category'], 'test');
      expect(json['created_at'], '2024-01-01T00:00:00.000Z');
    });

    test('copyWith creates new instance with updated fields', () {
      final original = Message(
        id: 'test-id',
        title: 'Test Title',
        body: 'Test Body',
        category: 'test',
        createdAt: DateTime.now(),
      );

      final updated = original.copyWith(viewed: true);

      expect(updated.id, original.id);
      expect(updated.title, original.title);
      expect(updated.viewed, true);
      expect(original.viewed, false);
    });

    test('fastHash generates consistent hash for same string', () {
      const testString = 'test-id';
      final hash1 = fastHash(testString);
      final hash2 = fastHash(testString);

      expect(hash1, hash2);
    });
  });
}
