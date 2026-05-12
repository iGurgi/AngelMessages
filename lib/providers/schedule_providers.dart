import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'schedule_providers.g.dart';

@riverpod
class NotificationsEnabled extends _$NotificationsEnabled {
  @override
  bool build() {
    // TODO: Check actual notification settings
    return false;
  }
}
