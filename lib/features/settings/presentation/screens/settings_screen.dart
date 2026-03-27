import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  TimeOfDay _notificationTime = const TimeOfDay(hour: 9, minute: 0);
  bool _weekendsEnabled = true;
  ThemeMode _themeMode = ThemeMode.system;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        elevation: 0,
        scrolledUnderElevation: 3,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notifications Section
            _buildSectionHeader('Notifications', Icons.notifications_outlined),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              color: colorScheme.surfaceContainer,
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Enable Notifications'),
                    subtitle: const Text('Receive daily angel messages'),
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                    secondary: Icon(
                      _notificationsEnabled
                          ? Icons.notifications_active
                          : Icons.notifications_off,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (_notificationsEnabled) ..[
                    const Divider(height: 1),
                    ListTile(
                      title: const Text('Notification Time'),
                      subtitle: Text(_notificationTime.format(context)),
                      leading: Icon(
                        Icons.schedule,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: _notificationTime,
                          helpText: 'Select notification time',
                        );
                        if (time != null) {
                          setState(() {
                            _notificationTime = time;
                          });
                        }
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const Text('Weekend Notifications'),
                      subtitle: const Text('Receive messages on weekends'),
                      value: _weekendsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _weekendsEnabled = value;
                        });
                      },
                      secondary: Icon(
                        Icons.weekend,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const Text('Sound'),
                      subtitle: const Text('Play sound with notifications'),
                      value: _soundEnabled,
                      onChanged: (value) {
                        setState(() {
                          _soundEnabled = value;
                        });
                      },
                      secondary: Icon(
                        _soundEnabled ? Icons.volume_up : Icons.volume_off,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const Text('Vibration'),
                      subtitle: const Text('Vibrate with notifications'),
                      value: _vibrationEnabled,
                      onChanged: (value) {
                        setState(() {
                          _vibrationEnabled = value;
                        });
                      },
                      secondary: Icon(
                        _vibrationEnabled ? Icons.vibration : Icons.phone_android,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Appearance Section
            _buildSectionHeader('Appearance', Icons.palette_outlined),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              color: colorScheme.surfaceContainer,
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Theme'),
                    subtitle: Text(_getThemeModeDescription(_themeMode)),
                    leading: Icon(
                      _getThemeModeIcon(_themeMode),
                      color: colorScheme.onSurfaceVariant,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showThemeDialog(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // About Section
            _buildSectionHeader('About', Icons.info_outline),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              color: colorScheme.surfaceContainer,
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Version'),
                    subtitle: const Text('1.0.0'),
                    leading: Icon(
                      Icons.info,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('Privacy Policy'),
                    leading: Icon(
                      Icons.privacy_tip_outlined,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Open privacy policy
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('Terms of Service'),
                    leading: Icon(
                      Icons.description_outlined,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Open terms of service
                    },
                  ),
                ],
              ),
            ),

            // Add some bottom padding for better scroll experience
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog() {
    showDialog<ThemeMode>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('System'),
              subtitle: const Text('Follow system setting'),
              value: ThemeMode.system,
              groupValue: _themeMode,
              onChanged: (value) {
                Navigator.pop(context, value);
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              subtitle: const Text('Light theme'),
              value: ThemeMode.light,
              groupValue: _themeMode,
              onChanged: (value) {
                Navigator.pop(context, value);
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              subtitle: const Text('Dark theme'),
              value: ThemeMode.dark,
              groupValue: _themeMode,
              onChanged: (value) {
                Navigator.pop(context, value);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    ).then((value) {
      if (value != null) {
        setState(() {
          _themeMode = value;
        });
      }
    });
  }

  String _getThemeModeDescription(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'Follow system setting';
      case ThemeMode.light:
        return 'Light theme';
      case ThemeMode.dark:
        return 'Dark theme';
    }
  }

  IconData _getThemeModeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return Icons.brightness_auto;
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
    }
  }
}