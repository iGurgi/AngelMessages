import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/message_data_source.dart';
import '../data/message_repository_impl.dart';
import '../domain/message_repository.dart';

part 'message_providers.g.dart';

/// Provider for the message repository implementation
/// 
/// This provider creates and manages the MessageRepository instance,
/// injecting the required MessageDataSource dependency through Riverpod's
/// dependency injection system.
@riverpod
MessageRepository messageRepository(MessageRepositoryRef ref) {
  return MessageRepositoryImpl(ref.watch(messageDataSourceProvider));
}

/// Provider for the message data source
/// 
/// This provider creates and manages the MessageDataSource instance
/// which handles direct database operations with Isar.
@riverpod
MessageDataSource messageDataSource(MessageDataSourceRef ref) {
  return MessageDataSourceImpl();
}