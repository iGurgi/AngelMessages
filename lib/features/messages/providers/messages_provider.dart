import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:angel_messages/core/database/database.dart';
import 'package:angel_messages/features/messages/data/message_repository.dart';

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
    state = await AsyncValue.guard(() async {
      final repository = ref.read(messageRepositoryProvider);
      await repository.syncMessages();
      return repository.getAllMessages();
    });
  }
}
