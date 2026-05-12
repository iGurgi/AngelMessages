import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:angel_messages/models/schedule_category.dart';
import 'package:angel_messages/providers/schedule_providers.dart';
import 'package:angel_messages/providers/permission_providers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gap/gap.dart';

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
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Notification Schedule Section
          Text(
            'Notification Schedule',
            style: theme.textTheme.titleLarge,
          ),
          const Gap(8),
          Text(
            'Choose when you want to receive angel messages',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const Gap(16),

          scheduleAsync.when(
            data: (currentSchedule) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SegmentedButton<ScheduleCategory>(
                    segments: const [
                      ButtonSegment<ScheduleCategory>(
                        value: ScheduleCategory.angelTimes(),
                        label: Text('✨ Angel Times'),
                      ),
                      ButtonSegment<ScheduleCategory>(
                        value: ScheduleCategory.everyHour(),
                        label: Text('🕐 Every Hour'),
                      ),
                    ],
                    selected: {currentSchedule},
                    onSelectionChanged: (Set<ScheduleCategory> selected) {
                      ref
                          .read(scheduleNotifierProvider.notifier)
                          .setSchedule(selected.first);
                    },
                  ),
                  const Gap(16),
                  _ScheduleDescriptionCard(schedule: currentSchedule),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Text(
              'Error loading schedule: $error',
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),

          const Gap(32),

          // Permissions Section
          Text(
            'Permissions',
            style: theme.textTheme.titleLarge,
          ),
          const Gap(8),

          permissionAsync.when(
            data: (status) {
              final isGranted = status.isGranted;
              final isDenied = status.isDenied || status.isPermanentlyDenied;

              return Card(
                child: ListTile(
                  leading: Icon(
                    Icons.notifications,
                    color: isGranted
                        ? Colors.green
                        : (isDenied ? Colors.red : Colors.orange),
                  ),
                  title: const Text('Notification Permission'),
                  subtitle: Text(_getPermissionStatusText(status)),
                  trailing: isDenied
                      ? TextButton(
                          onPressed: () {
                            ref
                                .read(notificationPermissionProvider.notifier)
                                .openSettings();
                          },
                          child: const Text('Open Settings'),
                        )
                      : (!isGranted
                          ? TextButton(
                              onPressed: () {
                                ref
                                    .read(
                                      notificationPermissionProvider.notifier,
                                    )
                                    .request();
                              },
                              child: const Text('Enable'),
                            )
                          : Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            )),
                ),
              );
            },
            loading: () => const Card(
              child: ListTile(
                leading: CircularProgressIndicator(),
                title: Text('Checking permissions...'),
              ),
            ),
            error: (error, stack) => Card(
              child: ListTile(
                leading: Icon(Icons.error, color: theme.colorScheme.error),
                title: const Text('Error checking permissions'),
                subtitle: Text(error.toString()),
              ),
            ),
          ),

          const Gap(32),

          // About Section
          Text(
            'About',
            style: theme.textTheme.titleLarge,
          ),
          const Gap(8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Angel Messages',
                    style: theme.textTheme.titleMedium,
                  ),
                  const Gap(8),
                  Text(
                    'Receive inspirational messages from your angels throughout the day. '
                    'Each message is carefully crafted to bring you guidance, comfort, and spiritual insight.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const Gap(16),
                  Text(
                    'Version 1.0.0',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getPermissionStatusText(PermissionStatus status) {
    if (status.isGranted) {
      return 'Granted - You will receive notifications';
    } else if (status.isDenied) {
      return 'Denied - Tap to enable in settings';
    } else if (status.isPermanentlyDenied) {
      return 'Permanently denied - Enable in system settings';
    } else if (status.isRestricted) {
      return 'Restricted';
    } else {
      return 'Not determined';
    }
  }
}

class _ScheduleDescriptionCard extends StatelessWidget {
  const _ScheduleDescriptionCard({
    required this.schedule,
  });

  final ScheduleCategory schedule;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              schedule.label,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const Gap(8),
            Text(
              schedule.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
