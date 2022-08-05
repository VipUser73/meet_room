import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_room/blocs/room_bloc/calendar_bloc.dart';
import 'package:meet_room/blocs/room_bloc/calendar_event.dart';
import 'package:meet_room/blocs/room_bloc/calendar_state.dart';
import 'package:meet_room/models/event_model.dart';
import 'package:meet_room/models/utils.dart';
import 'package:time_range/time_range.dart';

class AddRoomPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  AddRoomPage({Key? key}) : super(key: key);

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
              title: const Text('Add room'),
              leading: CloseButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<CalendarBloc>().add(LoadingCalendarEvent());
                },
              ),
              actions: [
                IconButton(
                  onPressed: () => _saveForm(context, _titleController.text),
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
                ],
              ),
            ),
          ),
        ),
      );
    });
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

  Future<void> _saveForm(BuildContext context, String nameRoom) async {
    final bool isValid = _formKey.currentState!.validate();
    if (isValid) {
      context.read<CalendarBloc>().add(SaveRoomEvent(nameRoom));
      Navigator.of(context).pop();
    }
  }
}
