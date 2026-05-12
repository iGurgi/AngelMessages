import 'package:angel_messages/core/routing/app_router.dart';
import 'package:angel_messages/core/theme/app_theme.dart';
import 'package:angel_messages/features/messages/presentation/widgets/message_card.dart';
import 'package:angel_messages/shared/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

/// Home screen displaying list of messages
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger initial sync on first load
    _syncMessages();
  }

  Future<void> _syncMessages() async {
    final repository = await ref.read(messageRepositoryProvider.future);
    await repository.syncMessages();
    ref.invalidate(messagesProvider);
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(messagesProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar.large(
            floating: true,
            pinned: true,
            backgroundColor: AppTheme.deepPurple.withOpacity(0.9),
            flexibleSpace: FlexibleSpaceBar(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo placeholder (would use SVG in production)
                  Icon(
                    Icons.auto_awesome,
                    color: AppTheme.softGold,
                    size: 24,
                  ),
                  const Gap(8),
                  Text(
                    'Angel Messages',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.softGold,
                        ),
                  ),
                ],
              ),
              centerTitle: true,
            ),
            actions: [
              // Settings button
              IconButton(
                icon: const Icon(Icons.settings),
                color: AppTheme.softGold,
                onPressed: () => AppRouter.navigateToSettings(context),
              ),
            ],
          ),
          
          // Messages list
          messagesAsync.when(
            data: (messages) {
              if (messages.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.auto_awesome_outlined,
                          size: 64,
                          color: AppTheme.mutedLavender.withOpacity(0.5),
                        ),
                        const Gap(16),
                        Text(
                          'No messages yet',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Gap(8),
                        Text(
                          'Pull down to sync',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final message = messages[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: MessageCard(message: message),
                      );
                    },
                    childCount: messages.length,
                  ),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  color: AppTheme.softGold,
                ),
              ),
            ),
            error: (error, stack) => SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const Gap(16),
                    Text(
                      'Error loading messages',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Gap(8),
                    Text(
                      error.toString(),
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // Refresh FAB
      floatingActionButton: FloatingActionButton(
        onPressed: _syncMessages,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
