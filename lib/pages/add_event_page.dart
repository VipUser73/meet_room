import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_room/blocs/room_bloc/calendar_bloc.dart';
import 'package:meet_room/blocs/room_bloc/calendar_event.dart';
import 'package:meet_room/blocs/room_bloc/calendar_state.dart';
import 'package:meet_room/models/event_model.dart';
import 'package:meet_room/models/utils.dart';
import 'package:meet_room/pages/home_page.dart';
import 'package:time_range/time_range.dart';

class AddEventPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  TimeRangeResult? _timeRange;

  AddEventPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(builder: (context, state) {
      DateTime now = DateTime.now();
      DateTime dateNow =
          state.dateNow ?? DateTime(now.year, now.month, now.day);
      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.green.shade700,
              title: _appBarTitle(context, state.listRooms[state.indexRoom!]),
              leading: CloseButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<CalendarBloc>().add(LoadingCalendarEvent());
                },
              ),
              actions: [
                IconButton(
                  onPressed: () => saveForm(
                      context,
                      dateNow,
                      _timeRange,
                      _titleController.text,
                      state.loginsList,
                      state.listRooms[state.indexRoom!]),
                  icon: const Icon(Icons.done),
                ),
              ]),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  titleField(context),
                  const SizedBox(height: 20),
                  const Text('Data'),
                  dateField(
                    text: Utils.toDate(dateNow),
                    onClicked: () => pickEventDate(context, dateNow),
                  ),
                  const SizedBox(height: 10),
                  _timeRangeWidget(context),
                  const SizedBox(height: 20),
                  const Text('Members'),
                  const SizedBox(height: 10),
                  _usernamesList(context, state.loginsList)
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _appBarTitle(BuildContext context, String room) {
    return Container(
        width: 170,
        height: 34,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(width: 2, color: Colors.green.shade800)),
        child: Center(child: Text(room)));
  }

  Widget titleField(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.green,
      decoration: const InputDecoration(
        labelText: 'Add title of the event',
        labelStyle: TextStyle(color: Colors.white),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
      onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
      validator: (title) =>
          title != null && title.isEmpty ? 'Title cannot be empty' : null,
      controller: _titleController,
    );
  }

  Widget dateField({
    required String text,
    required VoidCallback onClicked,
  }) =>
      GestureDetector(
        onTap: onClicked,
        child: SizedBox(
          width: 160,
          height: 50,
          child: Card(
              child: Center(
            child: Text(
              text,
              maxLines: 1,
              style: const TextStyle(fontSize: 18),
            ),
          )),
        ),
      );

  Widget _usernamesList(BuildContext context, List<String> usernamesList) {
    return SizedBox(
      width: 250,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        itemCount: usernamesList.length,
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 10),
        itemBuilder: (context, index) {
          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            onDismissed: (_) =>
                context.read<CalendarBloc>().add(DeleteMemberEvent(index)),
            background: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.centerRight,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: SizedBox(
              height: 50,
              child: Card(
                margin: EdgeInsets.zero,
                color: Colors.green.shade700,
                child: Center(
                  child: Text(usernamesList[index]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _timeRangeWidget(BuildContext context) {
    return TimeRange(
      fromTitle: const Text(
        'Start',
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
      toTitle: const Text(
        'Finish',
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
      titlePadding: 20,
      textStyle:
          const TextStyle(fontWeight: FontWeight.normal, color: Colors.white),
      activeTextStyle:
          const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      borderColor: Colors.black,
      backgroundColor: Colors.transparent,
      activeBackgroundColor: Colors.green,
      firstTime: const TimeOfDay(hour: 9, minute: 00),
      lastTime: const TimeOfDay(hour: 20, minute: 00),
      timeStep: 10,
      timeBlock: 30,
      onRangeCompleted: (range) => _timeRange = range,
    );
  }

  Future<void> pickEventDate(BuildContext context, DateTime dateNow) async {
    final date = await showDatePicker(
      context: context,
      initialDate: dateNow,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      final Duration time =
          Duration(hours: dateNow.hour, minutes: dateNow.minute);
      dateNow = date.add(time);
      context.read<CalendarBloc>().add(PickDateEvent(dateNow));
    }
  }

  Future<void> saveForm(
      BuildContext context,
      DateTime dateNow,
      TimeRangeResult? timeRange,
      String text,
      List<String> usernamesList,
      String room) async {
    final bool isValid = _formKey.currentState!.validate();
    if (isValid && timeRange != null) {
      final saveEvent = Event(
        title: text,
        room: room,
        start: dateNow.add(Duration(
            hours: timeRange.start.hour, minutes: timeRange.start.minute)),
        finish: dateNow.add(
            Duration(hours: timeRange.end.hour, minutes: timeRange.end.minute)),
        members: usernamesList.toString(),
      );
      context.read<CalendarBloc>().add(SaveFormEvent(saveEvent));
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const HomePage()));
    }
  }
}
