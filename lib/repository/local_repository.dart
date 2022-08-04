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
    final String _loadedRooms = await rootBundle.loadString('assets/rooms.txt');
    listRooms = _loadedRooms.split('\n');
    return listRooms;
  }

  Future<List<Event>> getEventsList() async {
    eventsFromDB = await _dbProvider.getEvents();
    return eventsFromDB;
  }

  List<String> deleteMemberEvent(int index) {
    loginsList.removeAt(index);
    return loginsList;
  }

  Future<void> saveForm(Event seveEvent) async {
    _dbProvider.addEvent(seveEvent);
  }

  Future<void> updateForm(Event seveEvent, String name) async {
    _dbProvider.updateForm(seveEvent, name);
  }

  Future<void> deleteEvent(String _title) async {
    await _dbProvider.deleteEvent(_title);
  }
}
