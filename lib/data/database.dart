import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:angel_messages/models/message.dart';

class AppDatabase {
  static Isar? _instance;

  static Future<Isar> getInstance() async {
    if (_instance != null) {
      return _instance!;
    }

    final dir = await getApplicationDocumentsDirectory();
    _instance = await Isar.open(
      [MessageSchema],
      directory: dir.path,
      name: 'angel_messages',
    );

    return _instance!;
  }

  static Future<void> close() async {
    await _instance?.close();
    _instance = null;
  }
}
