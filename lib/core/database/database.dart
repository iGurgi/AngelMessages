import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DataClassName('MessageData')
class Messages extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get category => text()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get viewed => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Messages])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Query methods
  Future<List<MessageData>> getAllMessages() => select(messages).get();

  Future<List<MessageData>> getUnviewedMessages() =>
      (select(messages)..where((tbl) => tbl.viewed.equals(false))).get();

  Future<MessageData?> getMessageById(String id) =>
      (select(messages)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<int> insertMessage(MessagesCompanion message) =>
      into(messages).insert(message, mode: InsertMode.insertOrReplace);

  Future<void> markAsViewed(String id) =>
      (update(messages)..where((tbl) => tbl.id.equals(id)))
          .write(const MessagesCompanion(viewed: Value(true)));

  Future<void> resetAllViewed() =>
      update(messages).write(const MessagesCompanion(viewed: Value(false)));

  Future<int> countUnviewedMessages() async {
    final count = messages.viewed.count();
    final query = selectOnly(messages)
      ..addColumns([count])
      ..where(messages.viewed.equals(false));
    return await query.map((row) => row.read(count) ?? 0).getSingle();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'angel_messages.sqlite'));
    return NativeDatabase(file);
  });
}
