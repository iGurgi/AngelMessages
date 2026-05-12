import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:angel_messages/core/database/database.dart';
import 'package:angel_messages/features/messages/data/message_repository.dart';

part 'message_detail_provider.g.dart';

@riverpod
class MessageDetail extends _$MessageDetail {
  @override
  Future<Message?> build(String messageId) async {
    final repository = ref.watch(messageRepositoryProvider);
    return repository.getMessageById(messageId);
  }

  Future<void> markAsViewed() async {
    final repository = ref.read(messageRepositoryProvider);
    await repository.markMessageAsViewed(messageId);

    // Refresh the state
    ref.invalidateSelf();
  }
}
