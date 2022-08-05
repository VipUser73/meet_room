import 'dart:io';
import 'package:meet_room/models/event_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DBProvider {
  Database? _database;
  List<Event> eventsFromDB = [];
  List<String> roomsFromDB = [];

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
      await db.execute("CREATE TABLE ROOMS ("
          "id INTEGER PRIMARY KEY,"
          "room TEXT"
          ")");
      await db.rawInsert('INSERT INTO ROOMS(room) VALUES("Room1")');
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

  addRoom(String nameRoom) async {
    final db = await database;
    var raw = await db.rawInsert('INSERT INTO ROOMS(room) VALUES("$nameRoom")');
    return raw;
  }

  Future<List<Event>> getEvents() async {
    final db = await database;
    var res = await db.query("EVENTS");
    eventsFromDB = res.map((e) => Event.fromDB(e)).toList();
    return eventsFromDB;
  }

  Future<List<String>> getRooms() async {
    final db = await database;
    var res = await db.query("ROOMS");
    roomsFromDB =
        res.map((e) => e.values).map((e) => e.last.toString()).toList();
    print(roomsFromDB);
    return roomsFromDB;
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

  deleteRoom(String room) async {
    final db = await database;
    db.delete("EVENTS", where: "room = ?", whereArgs: [room]);
    db.delete("ROOMS", where: "room = ?", whereArgs: [room]);
    return db;
  }
}
