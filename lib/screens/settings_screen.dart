import 'package:angel_messages/models/schedule_category.dart';
import 'package:angel_messages/providers/schedule_notifier.dart';
import 'package:angel_messages/services/permission_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleAsync = ref.watch(scheduleNotifierProvider);
    final permissionAsync = ref.watch(notificationPermissionProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Notification permission status
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: permissionAsync.when(
                data: (status) {
                  final isGranted = status == PermissionStatus.granted;
                  return ListTile(
                    leading: Icon(
                      isGranted ? Icons.notifications_active : Icons.notifications_off,
                      color: isGranted ? Colors.green : Colors.red,
                    ),
                    title: const Text('Notification Permission'),
                    subtitle: Text(
                      isGranted ? 'Enabled' : 'Disabled',
                      style: TextStyle(
                        color: isGranted ? Colors.green : Colors.red,
                      ),
                    ),
                    trailing: isGranted
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : TextButton(
                            onPressed: () async {
                              await ref
                                  .read(permissionServiceProvider)
                                  .requestNotificationPermission();
                              ref.invalidate(notificationPermissionProvider);
                            },
                            child: const Text('Enable'),
                          ),
                  );
                },
                loading: () => const ListTile(
                  leading: CircularProgressIndicator(),
                  title: Text('Checking permission...'),
                ),
                error: (_, __) => const ListTile(
                  leading: Icon(Icons.error, color: Colors.red),
                  title: Text('Error checking permission'),
                ),
              ),
            ),
          ),
          const Gap(24),
          // Schedule category section
          Text(
            'Notification Schedule',
            style: theme.textTheme.titleLarge,
          ),
          const Gap(8),
          Text(
            'Choose when you want to receive angel messages',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onBackground.withOpacity(0.7),
            ),
          ),
          const Gap(16),
          scheduleAsync.when(
            data: (selectedCategory) {
              return Column(
                children: [
                  SegmentedButton<ScheduleCategory>(
                    segments: ScheduleCategory.values
                        .map(
                          (category) => ButtonSegment(
                            value: category,
                            label: Text(category.displayName),
                          ),
                        )
                        .toList(),
                    selected: {selectedCategory},
                    onSelectionChanged: (Set<ScheduleCategory> selection) {
                      ref
                          .read(scheduleNotifierProvider.notifier)
                          .setScheduleCategory(selection.first);
                    },
                  ),
                  const Gap(16),
                  // Description cards for each option
                  ...ScheduleCategory.values.map((category) {
                    final isSelected = category == selectedCategory;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      color: isSelected
                          ? theme.colorScheme.secondary.withOpacity(0.1)
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isSelected)
                              Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Icon(
                                  Icons.check_circle,
                                  color: theme.colorScheme.secondary,
                                ),
                              ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    category.displayName,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      color: isSelected
                                          ? theme.colorScheme.secondary
                                          : null,
                                    ),
                                  ),
                                  const Gap(4),
                                  Text(
                                    category.description,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const Gap(8),
                    Text(
                      'Failed to load schedule settings',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
