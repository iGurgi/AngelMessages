import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository_providers.g.dart';

@riverpod
String appVersion(AppVersionRef ref) {
  return '1.0.0';
}
