import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/messages/data/datasources/local_message_data_source.dart';
import '../../features/messages/data/models/message_model.dart';

part 'database_providers.g.dart';

/// Provides the initialized Isar database instance
/// 
/// Opens Isar database with MessageSchema for message persistence.
/// This is a singleton that will be shared across the app.
@riverpod
Future<Isar> isar(IsarRef ref) async {
  return await Isar.open([
    MessageSchema,
  ]);
}

/// Provides the message data source implementation
/// 
/// Returns LocalMessageDataSource instance configured with the Isar database.
/// Depends on isarProvider and will wait for database initialization.
@riverpod
MessageDataSource messageDataSource(MessageDataSourceRef ref) {
  final isar = ref.watch(isarProvider).value!;
  return LocalMessageDataSource(isar);
}
