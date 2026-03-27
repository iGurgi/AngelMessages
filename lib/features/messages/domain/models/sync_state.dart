import 'package:freezed_annotation/freezed_annotation.dart';
import 'message.dart';

part 'sync_state.freezed.dart';

/// Represents the different states of message synchronization
@freezed
class SyncState with _$SyncState {
  /// Sync is in progress
  const factory SyncState.loading() = _Loading;
  
  /// Sync completed successfully with messages
  const factory SyncState.success(List<Message> messages) = _Success;
  
  /// Sync failed with an error message
  const factory SyncState.error(String message) = _Error;
}
