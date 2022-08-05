import 'package:meet_room/models/event_model.dart';

abstract class CalendarState {
  List<Event> events;
  List<String> listRooms;
  int? indexRoom;
  String name;
  List<String> loginsList;
  Event? selectedEvent;
  final DateTime? dateNow;
  CalendarState({
    this.events = const [],
    this.listRooms = const [],
    this.indexRoom,
    this.name = '',
    this.loginsList = const [],
    this.selectedEvent,
    this.dateNow,
  });
}

class LoadingCalendarState extends CalendarState {}

class LoadedRoomsState extends CalendarState {
  LoadedRoomsState({required List<String> listRooms})
      : super(listRooms: listRooms);
}

class LoadedCalendarState extends CalendarState {
  LoadedCalendarState(
      {required List<Event> events,
      required List<String> listRooms,
      required int? indexRoom})
      : super(events: events, listRooms: listRooms, indexRoom: indexRoom);
}

class PickLoadedState extends CalendarState {
  PickLoadedState(
      {DateTime? dateNow,
      required List<String> loginsList,
      required List<String> listRooms,
      required int? indexRoom})
      : super(
            dateNow: dateNow,
            loginsList: loginsList,
            listRooms: listRooms,
            indexRoom: indexRoom);
}

class PickLoadedEditState extends CalendarState {
  PickLoadedEditState({final Event? selectedEvent, required int? indexRoom})
      : super(selectedEvent: selectedEvent, indexRoom: indexRoom);
}

class AddEventState extends CalendarState {
  AddEventState(
      {required List<String> loginsList,
      required List<String> listRooms,
      required int? indexRoom})
      : super(
            loginsList: loginsList, listRooms: listRooms, indexRoom: indexRoom);
}

class GoToBackState extends CalendarState {
  GoToBackState({required Event selectedEvent})
      : super(selectedEvent: selectedEvent);
}

class LoadedEditingPageState extends CalendarState {
  LoadedEditingPageState({required Event selectedEvent, required String name})
      : super(selectedEvent: selectedEvent, name: name);
}

class LoadedViewingPageState extends CalendarState {
  LoadedViewingPageState({required Event selectedEvent})
      : super(selectedEvent: selectedEvent);
}
