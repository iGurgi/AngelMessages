import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'permission_providers.g.dart';

@riverpod
Future<bool> hasNotificationPermission(HasNotificationPermissionRef ref) async {
  return false;
}
