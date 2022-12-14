import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_room/blocs/room_bloc/calendar_event.dart';
import 'package:meet_room/blocs/room_bloc/calendar_state.dart';
import 'package:meet_room/repository/local_repository.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc(this._storageRepository) : super(LoadingCalendarState()) {
    on<LoadingCalendarEvent>(_loadingCalendarEvent);
    on<GoToViewingRoomsEvent>(_goToViewingRoomsEvent);
    on<SelectedRoomEvent>(_selectedRoomEvent);
    on<PickDateEvent>(_pickDateEvent);
    on<PickTimeEditEvent>(_pickTimeEditEvent);
    on<AddEventEvent>(_addEventEvent);
    on<SaveRoomEvent>(_saveRoomEvent);
    on<GoToViewingPageEvent>(_goToViewingPageEvent);
    on<GoToBackEvent>(_goToBackEvent);
    on<GoToEditingPageEvent>(_goToEditingPageEvent);
    on<DeleteMemberEvent>(_deleteMemberEvent);
    on<SaveFormEvent>(_saveFormEvent);
    on<UpdateFormEvent>(_updateFormEvent);
    on<DeleteEventEvent>(_deleteEvent);
    on<DeleteRoomEvent>(_deleteRoom);
  }
  final LocalRepository _storageRepository;
  String name = '';
  int? indexRoom;

  void _loadingCalendarEvent(
      LoadingCalendarEvent event, Emitter<CalendarState> emit) async {
    await _storageRepository.getEventsList();
    await _storageRepository.readRooms();
    emit(LoadedCalendarState(
        events: _storageRepository.eventsFromDB,
        listRooms: _storageRepository.listRooms,
        indexRoom: state.indexRoom));
  }

  void _goToViewingRoomsEvent(
      GoToViewingRoomsEvent event, Emitter<CalendarState> emit) async {
    emit(LoadedRoomsState(listRooms: _storageRepository.listRooms));
  }

  void _selectedRoomEvent(
      SelectedRoomEvent event, Emitter<CalendarState> emit) async {
    indexRoom = event.indexRoom;
    emit(LoadedCalendarState(
        events: _storageRepository.eventsFromDB,
        listRooms: _storageRepository.listRooms,
        indexRoom: indexRoom));
  }

  void _saveRoomEvent(SaveRoomEvent event, Emitter<CalendarState> emit) async {
    await _storageRepository.addRoom(event.nameRoom);
    emit(LoadedRoomsState(listRooms: _storageRepository.listRooms));
  }

  void _addEventEvent(AddEventEvent event, Emitter<CalendarState> emit) async {
    await _storageRepository.readLogins();
    emit(AddEventState(
        loginsList: _storageRepository.loginsList,
        listRooms: _storageRepository.listRooms,
        indexRoom: indexRoom));
  }

  void _deleteMemberEvent(
      DeleteMemberEvent event, Emitter<CalendarState> emit) async {
    _storageRepository.deleteMemberEvent(event.index);
  }

  void _pickDateEvent(PickDateEvent event, Emitter<CalendarState> emit) async {
    emit(PickLoadedState(
        dateNow: event.dateNow,
        loginsList: _storageRepository.loginsList,
        listRooms: _storageRepository.listRooms,
        indexRoom: indexRoom));
  }

  void _pickTimeEditEvent(
      PickTimeEditEvent event, Emitter<CalendarState> emit) async {
    emit(PickLoadedEditState(
        selectedEvent: event.selectedEvent, indexRoom: indexRoom));
  }

  void _saveFormEvent(SaveFormEvent event, Emitter<CalendarState> emit) async {
    await _storageRepository.saveForm(event.saveEvent);
    add(LoadingCalendarEvent());
  }

  void _updateFormEvent(
      UpdateFormEvent event, Emitter<CalendarState> emit) async {
    await _storageRepository.updateForm(event.updateEvent, name);
  }

  void _deleteEvent(DeleteEventEvent event, Emitter<CalendarState> emit) async {
    await _storageRepository.deleteEvent(event.title);
    add(LoadingCalendarEvent());
  }

  void _deleteRoom(DeleteRoomEvent event, Emitter<CalendarState> emit) async {
    await _storageRepository.deleteRoom(event.room);
    emit(LoadedRoomsState(listRooms: _storageRepository.listRooms));
  }

  void _goToViewingPageEvent(
      GoToViewingPageEvent event, Emitter<CalendarState> emit) async {
    emit(LoadedViewingPageState(selectedEvent: event.selectedEvent));
  }

  void _goToBackEvent(GoToBackEvent event, Emitter<CalendarState> emit) async {
    //emit(LoadedViewingPageState(selectedEvent: selectedEvent));
  }

  void _goToEditingPageEvent(
      GoToEditingPageEvent event, Emitter<CalendarState> emit) async {
    name = event.name;
    //emit(LoadedEditingPageState(selectedEvent: selectedEvent, name: name));
  }
}
