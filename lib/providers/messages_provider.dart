import 'package:angel_messages/models/message.dart';
import 'package:angel_messages/repositories/message_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'messages_provider.g.dart';

@riverpod
class Messages extends _$Messages {
  @override
  Future<List<Message>> build() async {
    final repository = ref.watch(messageRepositoryProvider);
    return repository.getAllMessages();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final repository = ref.read(messageRepositoryProvider);
    
    try {
      await repository.syncFromApi();
      final messages = await repository.getAllMessages();
      state = AsyncValue.data(messages);
    } catch (e, st) {
      // If sync fails, still load from local DB
      final messages = await repository.getAllMessages();
      state = AsyncValue.data(messages);
    }
  }

  Future<void> markAsViewed(String id) async {
    final repository = ref.read(messageRepositoryProvider);
    await repository.markAsViewed(id);
    ref.invalidateSelf();
  }
}

@riverpod
Future<Message?> messageById(MessageByIdRef ref, String id) async {
  final repository = ref.watch(messageRepositoryProvider);
  return repository.getMessageById(id);
}
