import 'dart:io';
import 'package:meet_room/models/event_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DBProvider {
  Database? _database;
  List<Event> eventsFromDB = [];

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationSupportDirectory();
    String path = join(documentsDirectory.path, "Events.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE EVENTS ("
          "id INTEGER PRIMARY KEY,"
          "title TEXT,"
          "room TEXT,"
          "start TEXT,"
          "finish TEXT,"
          "members TEXT"
          ")");
    });
  }

  addEvent(Event event) async {
    final db = await database;
    var raw = await db.rawInsert(
        "INSERT INTO EVENTS(title, room, start, finish, members)"
        "VALUES(?, ?, ?, ?, ?)",
        [
          event.title,
          event.room,
          event.start.toString(),
          event.finish.toString(),
          event.members
        ]);
    return raw;
  }

  Future<List<Event>> getEvents() async {
    final db = await database;
    var res = await db.query("EVENTS");
    eventsFromDB = res.map((e) => Event.fromDB(e)).toList();
    return eventsFromDB;
  }

  updateForm(Event event, String name) async {
    final db = await database;
    var raw = await db.rawUpdate(
        "UPDATE EVENTS SET title = ?, room = ?, start = ?, finish = ?, members = ?, WHERE title = ?",
        [
          event.title,
          event.room,
          event.start.toString(),
          event.finish.toString(),
          event.members,
          name
        ]);
    return raw;
  }

  deleteEvent(String _title) async {
    final db = await database;
    return db.delete("EVENTS", where: "title = ?", whereArgs: [_title]);
  }
}
