import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_room/bloc/calendar_event.dart';
import 'package:meet_room/bloc/calendar_state.dart';
import 'package:meet_room/models/event_model.dart';
import 'package:meet_room/repository/local_repository.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc(this._storageRepository)
      : super(LoadingCalendarState(
            startEvent: _storageRepository.startEvent,
            finishEvent: _storageRepository.finishEvent)) {
    on<LoadingCalendarEvent>(_loadingCalendarList);
    on<PickStartTimeEvent>(_pickStartTimeEvent);
    on<PickFinishTimeEvent>(_pickFinishTimeEvent);
    on<ShowTasksEvent>(_showTasksEvent);
    on<SaveFormEvent>(_saveFormEvent);
  }
  final LocalRepository _storageRepository;
  List<Event> eventsFromDB = [];

  void _loadingCalendarList(
      LoadingCalendarEvent event, Emitter<CalendarState> emit) async {
    eventsFromDB = await _storageRepository.getEventsList();
    emit(LoadedCalendarState(events: eventsFromDB));
  }

  void _pickStartTimeEvent(
      PickStartTimeEvent event, Emitter<CalendarState> emit) async {
    DateTime? startEvent = await _storageRepository
        .pickstartEventTime(event.context, pickDate: event.pickDate);
    emit(PickLoadedState(
        startEvent: startEvent, finishEvent: _storageRepository.finishEvent));
  }

  void _pickFinishTimeEvent(
      PickFinishTimeEvent event, Emitter<CalendarState> emit) async {
    DateTime? finishEvent = await _storageRepository
        .pickfinishEventTime(event.context, pickDate: event.pickDate);
    emit(PickLoadedState(
        startEvent: _storageRepository.startEvent, finishEvent: finishEvent));
  }

  void _saveFormEvent(SaveFormEvent event, Emitter<CalendarState> emit) async {
    await _storageRepository.saveForm(event.text);
    emit(PickLoadedState());
  }

  void _showTasksEvent(
      ShowTasksEvent event, Emitter<CalendarState> emit) async {
    emit(
        ShowTasksState(selectedDate: event.selectedDate, events: eventsFromDB));
  }

  // void _deleteEvent(DeleteCalendarEvent event, Emitter<CalendarState> emit) async {
  //   await _storageRepository.deleteEvent(event.cityName);
  //   _updateCalendar();
  // }

}