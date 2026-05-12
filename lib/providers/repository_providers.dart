import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository_providers.g.dart';

@riverpod
Future<String> appVersion(AppVersionRef ref) async {
  // TODO: Get version from package info
  return '1.0.0';
}
