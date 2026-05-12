import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'schedule_providers.g.dart';

@riverpod
bool notificationsEnabled(NotificationsEnabledRef ref) {
  return false;
}
