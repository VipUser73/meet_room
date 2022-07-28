import 'package:meet_room/models/event_model.dart';

abstract class CalendarState {
  List<Event> events;
  final DateTime? selectedDate;
  final DateTime? startEvent;
  final DateTime? finishEvent;
  CalendarState(
      {this.events = const [],
      this.startEvent,
      this.finishEvent,
      this.selectedDate});
}

class LoadingCalendarState extends CalendarState {
  LoadingCalendarState(
      {required DateTime? startEvent, required DateTime? finishEvent})
      : super(startEvent: startEvent, finishEvent: finishEvent);
}

class LoadedCalendarState extends CalendarState {
  LoadedCalendarState({required List<Event> events}) : super(events: events);
}

class PickLoadedState extends CalendarState {
  PickLoadedState({DateTime? startEvent, DateTime? finishEvent})
      : super(startEvent: startEvent, finishEvent: finishEvent);
}

class ShowTasksState extends CalendarState {
  ShowTasksState({required List<Event> events, required DateTime? selectedDate})
      : super(events: events, selectedDate: selectedDate);
}