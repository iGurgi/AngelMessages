import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:angel_messages/core/models/schedule_category.dart';
import 'package:angel_messages/features/settings/providers/schedule_notifier.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleAsync = ref.watch(scheduleNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Schedule selection
          Text(
            'Notification Schedule',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Gap(8),
          Text(
            'Choose when you\'d like to receive messages',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Gap(16),

          scheduleAsync.when(
            data: (currentSchedule) {
              return Column(
                children: [
                  for (final category in ScheduleCategory.values)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        child: InkWell(
                          onTap: () async {
                            await ref
                                .read(scheduleNotifierProvider.notifier)
                                .updateSchedule(category);
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Radio<ScheduleCategory>(
                                  value: category,
                                  groupValue: currentSchedule,
                                  onChanged: (value) async {
                                    if (value != null) {
                                      await ref
                                          .read(scheduleNotifierProvider.notifier)
                                          .updateSchedule(value);
                                    }
                                  },
                                ),
                                const Gap(12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        category.displayName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      const Gap(4),
                                      Text(
                                        category.description,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Text('Error: $error'),
          ),

          const Gap(32),

          // Notification permission status
          Text(
            'Permissions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Gap(16),

          FutureBuilder<PermissionStatus>(
            future: Permission.notification.status,
            builder: (context, snapshot) {
              final isGranted = snapshot.data?.isGranted ?? false;

              return ListTile(
                leading: Icon(
                  isGranted ? Icons.notifications_active : Icons.notifications_off,
                  color: isGranted ? Colors.green : Colors.red,
                ),
                title: const Text('Notifications'),
                subtitle: Text(
                  isGranted
                      ? 'Enabled'
                      : 'Disabled - Tap to enable in settings',
                ),
                trailing: isGranted
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const Icon(Icons.error, color: Colors.red),
                onTap: isGranted
                    ? null
                    : () async {
                        final status = await Permission.notification.request();
                        if (!status.isGranted) {
                          await openAppSettings();
                        }
                      },
              );
            },
          ),

          const Gap(16),

          // About section
          const Divider(),
          const Gap(16),

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            subtitle: const Text('Angel Messages v1.0.0'),
          ),
        ],
      ),
    );
  }
}
