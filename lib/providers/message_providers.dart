import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:angel_messages/data/message_repository.dart';
import 'package:angel_messages/models/message.dart';
import 'package:angel_messages/providers/repository_providers.dart';

part 'message_providers.g.dart';

@riverpod
class AllMessages extends _$AllMessages {
  @override
  Future<List<Message>> build() async {
    final repository = ref.watch(messageRepositoryProvider);
    return repository.getAllMessages();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(messageRepositoryProvider);
      await repository.syncFromRemote();
      return repository.getAllMessages();
    });
  }
}

@riverpod
class MessageDetail extends _$MessageDetail {
  @override
  Future<Message?> build(String messageId) async {
    final repository = ref.watch(messageRepositoryProvider);
    return repository.getMessageById(messageId);
  }

  Future<void> markAsViewed() async {
    final repository = ref.read(messageRepositoryProvider);
    await repository.markAsViewed(messageId);
    ref.invalidate(allMessagesProvider);
    ref.invalidate(unviewedCountProvider);
  }
}

@riverpod
Future<int> unviewedCount(UnviewedCountRef ref) async {
  final repository = ref.watch(messageRepositoryProvider);
  return repository.getUnviewedCount();
}

@riverpod
Future<Message?> nextUnviewedMessage(NextUnviewedMessageRef ref) async {
  final repository = ref.watch(messageRepositoryProvider);
  return repository.getNextUnviewedMessage();
}
