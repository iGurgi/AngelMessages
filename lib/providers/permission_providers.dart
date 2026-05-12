import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'permission_providers.g.dart';

@riverpod
class HasNotificationPermission extends _$HasNotificationPermission {
  @override
  Future<bool> build() async {
    // TODO: Check actual permission status
    return false;
  }
}
