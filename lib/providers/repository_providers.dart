import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository_providers.g.dart';

@riverpod
class AppVersion extends _$AppVersion {
  @override
  String build() {
    // TODO: Get version from package info
    return '1.0.0';
  }
}
