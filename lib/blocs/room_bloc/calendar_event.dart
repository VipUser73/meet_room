import 'package:meet_room/models/event_model.dart';

abstract class CalendarEvent {}

class LoadingCalendarEvent extends CalendarEvent {}

class PickDateEvent extends CalendarEvent {
  DateTime dateNow;
  PickDateEvent(this.dateNow);
}

class GoToViewingRoomsEvent extends CalendarEvent {}

class AddRoomEvent extends CalendarEvent {}

class SelectedRoomEvent extends CalendarEvent {
  final int indexRoom;
  SelectedRoomEvent(this.indexRoom);
}

class PickTimeEditEvent extends CalendarEvent {
  final Event selectedEvent;
  PickTimeEditEvent(this.selectedEvent);
}

class SaveFormEvent extends CalendarEvent {
  final Event saveEvent;
  SaveFormEvent(this.saveEvent);
}

class ShowTasksEvent extends CalendarEvent {
  final DateTime selectedDate;
  ShowTasksEvent(this.selectedDate);
}

class AddEventEvent extends CalendarEvent {}

class DeleteMemberEvent extends CalendarEvent {
  final int index;
  DeleteMemberEvent(this.index);
}

class GoToViewingPageEvent extends CalendarEvent {
  final Event selectedEvent;
  GoToViewingPageEvent(this.selectedEvent);
}

class GoToEditingPageEvent extends CalendarEvent {
  final String name;
  GoToEditingPageEvent(this.name);
}

class GoToBackEvent extends CalendarEvent {}

class UpdateFormEvent extends CalendarEvent {
  final Event updateEvent;
  UpdateFormEvent(this.updateEvent);
}

class DeleteEventEvent extends CalendarEvent {
  final String title;
  DeleteEventEvent(this.title);
}
