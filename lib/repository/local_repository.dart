import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:meet_room/models/event_model.dart';
import 'package:meet_room/services/db_provider.dart';

class LocalRepository {
  LocalRepository(this._dbProvider);
  final DBProvider _dbProvider;
  List<Event> eventsFromDB = [];
  List<String> loginsList = [];
  List<String> listRooms = [];

  Future<List<String>> readLogins() async {
    final _loadedLogins = await rootBundle.loadString('assets/login.json');
    Map<String, dynamic> _loginAndPassword = json.decode(_loadedLogins);
    loginsList.clear();
    _loginAndPassword.forEach((key, value) {
      loginsList.add(key);
    });
    return loginsList;
  }

  Future<List<String>> readRooms() async {
    listRooms = await _dbProvider.getRooms();
    return listRooms;
  }

  Future<void> addRoom(String nameRoom) async {
    await _dbProvider.addRoom(nameRoom);
    await readRooms();
  }

  Future<void> saveForm(Event seveEvent) async {
    await _dbProvider.addEvent(seveEvent);
  }

  Future<List<Event>> getEventsList() async {
    eventsFromDB = await _dbProvider.getEvents();
    return eventsFromDB;
  }

  List<String> deleteMemberEvent(int index) {
    loginsList.removeAt(index);
    return loginsList;
  }

  Future<void> updateForm(Event seveEvent, String name) async {
    _dbProvider.updateForm(seveEvent, name);
  }

  Future<void> deleteEvent(String _title) async {
    await _dbProvider.deleteEvent(_title);
  }

  Future<void> deleteRoom(String _room) async {
    await _dbProvider.deleteRoom(_room);
    await readRooms();
  }
}
