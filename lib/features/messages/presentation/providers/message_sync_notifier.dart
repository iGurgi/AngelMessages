import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/message_repository.dart';
import '../../domain/models/sync_state.dart';

/// Notifier for managing daily message synchronization with the API
/// 
/// This notifier handles the sync state and provides methods to trigger
/// message syncing from the remote service. It extends AsyncNotifier to
/// handle async operations with loading states and error handling.
class MessageSyncNotifier extends AsyncNotifier<SyncState> {
  late final MessageRepository _messageRepository;

  @override
  Future<SyncState> build() async {
    // Get the message repository from the provider container
    _messageRepository = ref.read(messageRepositoryProvider);
    
    // Return initial sync state
    return const SyncState(
      lastSyncTime: null,
      issyncing: false,
      messageCount: 0,
      lastError: null,
    );
  }

  /// Triggers a manual sync of daily messages from the API
  /// 
  /// Returns true if sync was successful, false otherwise.
  /// Updates the sync state throughout the process.
  Future<bool> syncMessages() async {
    try {
      // Set syncing state
      state = AsyncData(
        state.value?.copyWith(
          issyncing: true,
          lastError: null,
        ) ?? const SyncState(
          lastSyncTime: null,
          issyncing: true,
          messageCount: 0,
          lastError: null,
        ),
      );

      // Perform the sync operation
      final result = await _messageRepository.syncDailyMessages();
      
      if (result.isSuccess) {
        // Update state with successful sync
        final now = DateTime.now();
        final messageCount = await _messageRepository.getMessageCount();
        
        state = AsyncData(
          SyncState(
            lastSyncTime: now,
            issyncing: false,
            messageCount: messageCount,
            lastError: null,
          ),
        );
        
        return true;
      } else {
        // Handle sync failure
        final currentState = state.value ?? const SyncState(
          lastSyncTime: null,
          issyncing: false,
          messageCount: 0,
          lastError: null,
        );
        
        state = AsyncData(
          currentState.copyWith(
            issyncing: false,
            lastError: result.error,
          ),
        );
        
        return false;
      }
    } catch (error, stackTrace) {
      // Handle unexpected errors
      final currentState = state.value ?? const SyncState(
        lastSyncTime: null,
        issyncing: false,
        messageCount: 0,
        lastError: null,
      );
      
      state = AsyncData(
        currentState.copyWith(
          issyncing: false,
          lastError: error.toString(),
        ),
      );
      
      // Log error for debugging
      // TODO: Add proper logging when logger is set up
      // log('Message sync failed: $error', error, stackTrace);
      
      return false;
    }
  }

  /// Checks if auto-sync should be performed based on last sync time
  /// 
  /// Returns true if it's been more than 24 hours since last sync
  /// or if no sync has been performed yet.
  bool shouldAutoSync() {
    final currentState = state.value;
    if (currentState?.lastSyncTime == null) {
      return true;
    }
    
    final hoursSinceLastSync = DateTime.now()
        .difference(currentState!.lastSyncTime!)
        .inHours;
    
    return hoursSinceLastSync >= 24;
  }

  /// Performs auto-sync if conditions are met
  /// 
  /// This method checks if auto-sync should be performed and triggers
  /// it if necessary. Designed to be called on app startup or resume.
  Future<void> autoSyncIfNeeded() async {
    if (shouldAutoSync() && !(state.value?.issyncing ?? false)) {
      await syncMessages();
    }
  }

  /// Resets the sync state (useful for testing or manual reset)
  void resetSyncState() {
    state = const AsyncData(
      SyncState(
        lastSyncTime: null,
        issyncing: false,
        messageCount: 0,
        lastError: null,
      ),
    );
  }
}

/// Provider for the MessageSyncNotifier
/// 
/// This provider manages the daily message synchronization state
/// and exposes methods to trigger sync operations.
final messageSyncNotifierProvider = 
    AsyncNotifierProvider<MessageSyncNotifier, SyncState>(
  MessageSyncNotifier.new,
);
