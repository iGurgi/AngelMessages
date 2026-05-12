import 'package:angel_messages/core/constants/app_constants.dart';
import 'package:angel_messages/core/routing/app_router.dart';
import 'package:angel_messages/core/theme/app_theme.dart';
import 'package:angel_messages/shared/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:permission_handler/permission_handler.dart';

/// Settings screen for managing app preferences
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleCategoryAsync = ref.watch(scheduleCategoryProvider);
    final notificationPermissionAsync = ref.watch(notificationPermissionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => AppRouter.navigateBack(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Notification Schedule Section
          _SectionHeader(
            title: 'Notification Schedule',
            icon: Icons.notifications_active,
          ),
          const Gap(16),
          scheduleCategoryAsync.when(
            data: (category) => _ScheduleSelector(
              currentCategory: category,
              onCategoryChanged: (newCategory) async {
                await ref
                    .read(scheduleCategoryProvider.notifier)
                    .setCategory(newCategory);
              },
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => Text('Error: $error'),
          ),
          const Gap(32),
          
          // Permissions Section
          _SectionHeader(
            title: 'Permissions',
            icon: Icons.security,
          ),
          const Gap(16),
          notificationPermissionAsync.when(
            data: (granted) => _PermissionTile(
              title: 'Notifications',
              subtitle: granted
                  ? 'Enabled - You will receive daily messages'
                  : 'Disabled - Enable to receive messages',
              granted: granted,
              onTap: () async {
                final status = await Permission.notification.request();
                await ref
                    .read(notificationPermissionProvider.notifier)
                    .setGranted(status.isGranted);
                
                if (!status.isGranted && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Please enable notifications in Settings',
                      ),
                      action: SnackBarAction(
                        label: 'Open Settings',
                        onPressed: openAppSettings,
                      ),
                    ),
                  );
                }
              },
            ),
            loading: () => const LinearProgressIndicator(),
            error: (error, stack) => Text('Error: $error'),
          ),
          const Gap(32),
          
          // About Section
          _SectionHeader(
            title: 'About',
            icon: Icons.info_outline,
          ),
          const Gap(16),
          ListTile(
            title: const Text('Angel Messages'),
            subtitle: const Text('Version 1.0.0'),
            leading: Icon(
              Icons.auto_awesome,
              color: AppTheme.softGold,
            ),
          ),
          ListTile(
            title: const Text('Created with love for the spiritual community'),
            subtitle: const Text('✨ May your days be filled with light'),
            leading: Icon(
              Icons.favorite,
              color: AppTheme.mutedLavender,
            ),
          ),
        ],
      ),
    );
  }
}

/// Section header widget
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppTheme.softGold,
          size: 24,
        ),
        const Gap(12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.softGold,
              ),
        ),
      ],
    );
  }
}

/// Schedule selector widget using segmented button
class _ScheduleSelector extends StatelessWidget {
  const _ScheduleSelector({
    required this.currentCategory,
    required this.onCategoryChanged,
  });

  final String currentCategory;
  final ValueChanged<String> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SegmentedButton<String>(
          segments: const [
            ButtonSegment<String>(
              value: AppConstants.scheduleCategoryAngelTimes,
              label: Text('✨ Angel Times'),
            ),
            ButtonSegment<String>(
              value: AppConstants.scheduleCategoryEveryHour,
              label: Text('🕐 Every Hour'),
            ),
          ],
          selected: {currentCategory},
          onSelectionChanged: (Set<String> selection) {
            onCategoryChanged(selection.first);
          },
        ),
        const Gap(16),
        // Description
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.mutedLavender.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.mutedLavender.withOpacity(0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentCategory == AppConstants.scheduleCategoryAngelTimes
                    ? 'Angel Times'
                    : 'Every Hour',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.softGold,
                    ),
              ),
              const Gap(8),
              Text(
                currentCategory == AppConstants.scheduleCategoryAngelTimes
                    ? 'Receive messages at sacred times: 1:11, 2:22, 3:33, 4:44, 5:55, 11:11, 12:12, and 22:22'
                    : 'Receive a message at the top of every hour throughout the day',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Permission tile widget
class _PermissionTile extends StatelessWidget {
  const _PermissionTile({
    required this.title,
    required this.subtitle,
    required this.granted,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool granted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: granted ? Colors.green : Colors.red,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: (granted ? Colors.green : Colors.red).withOpacity(0.5),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: ElevatedButton(
          onPressed: onTap,
          child: Text(granted ? 'Enabled' : 'Enable'),
        ),
      ),
    );
  }
}
