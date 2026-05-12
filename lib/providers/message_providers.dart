import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'message_providers.g.dart';

@riverpod
class Messages extends _$Messages {
  @override
  Future<List<String>> build() async {
    // TODO: Implement message fetching
    return [];
  }
}
