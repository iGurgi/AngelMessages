import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/repositories/messages_repository.dart';
import '../../domain/models/message.dart';

part 'message_sync_notifier.freezed.dart';

/// Sync state for message synchronization operations
@freezed
class SyncState with _$SyncState {
  const factory SyncState.idle() = _Idle;
  const factory SyncState.syncing() = _Syncing;
  const factory SyncState.success({
    required DateTime lastSyncTime,
    required int messageCount,
  }) = _Success;
  const factory SyncState.error(String message) = _Error;
}

/// AsyncNotifier for handling message sync operations
class MessageSyncNotifier extends AsyncNotifier<SyncState> {
  @override
  Future<SyncState> build() async {
    // Initialize with idle state
    return const SyncState.idle();
  }

  /// Triggers a sync operation to fetch daily messages from API
  Future<void> syncMessages() async {
    state = const AsyncValue.loading();
    
    try {
      // Set syncing state
      state = AsyncValue.data(const SyncState.syncing());
      
      final repository = ref.read(messagesRepositoryProvider);
      
      // Perform sync operation
      final messages = await repository.syncMessagesFromApi();
      
      // Update state with success
      state = AsyncValue.data(SyncState.success(
        lastSyncTime: DateTime.now(),
        messageCount: messages.length,
      ));
      
    } catch (error, stackTrace) {
      // Handle sync errors
      state = AsyncValue.error(
        SyncState.error('Failed to sync messages: ${error.toString()}'),
        stackTrace,
      );
    }
  }

  /// Checks if sync is needed based on last sync time
  bool shouldSync() {
    final currentState = state.value;
    if (currentState is _Success) {
      final timeSinceLastSync = DateTime.now().difference(currentState.lastSyncTime);
      // Sync if more than 24 hours since last sync
      return timeSinceLastSync.inHours >= 24;
    }
    // Sync if never synced before or in error state
    return true;
  }

  /// Auto-sync if needed (called on app startup/resume)
  Future<void> autoSyncIfNeeded() async {
    if (shouldSync()) {
      await syncMessages();
    }
  }

  /// Forces a manual sync regardless of last sync time
  Future<void> forcSync() async {
    await syncMessages();
  }

  /// Resets sync state to idle
  void resetState() {
    state = const AsyncValue.data(SyncState.idle());
  }
}

/// Provider for MessageSyncNotifier
final messageSyncProvider = AsyncNotifierProvider<MessageSyncNotifier, SyncState>(
  () => MessageSyncNotifier(),
);