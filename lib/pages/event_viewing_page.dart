import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_room/blocs/room_bloc/calendar_bloc.dart';
import 'package:meet_room/blocs/room_bloc/calendar_event.dart';
import 'package:meet_room/blocs/room_bloc/calendar_state.dart';
import 'package:meet_room/models/event_model.dart';
import 'package:meet_room/models/utils.dart';
import 'package:meet_room/pages/event_editing_page.dart';
import 'package:meet_room/pages/home_page.dart';

class EventViewingPage extends StatelessWidget {
  const EventViewingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CalendarBloc, CalendarState>(
        listener: (context, state) {
      if (state is LoadedEditingPageState) {
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => EventEditingPage()));
      }
    }, builder: (context, state) {
      if (state is LoadedViewingPageState) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green.shade700,
            leading: CloseButton(
              onPressed: () {
                context.read<CalendarBloc>().add(LoadingCalendarEvent());
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
            ),
            actions: _buildViewingActions(context, state.selectedEvent!),
          ),
          body: ListView(
            padding: const EdgeInsets.all(30),
            children: [
              _titleOrMembers(state.selectedEvent?.title ?? ''),
              const SizedBox(height: 30),
              _startOrFinish(state.selectedEvent!.start),
              const SizedBox(height: 20),
              _startOrFinish(state.selectedEvent!.finish),
              const SizedBox(height: 30),
              const Center(
                  child: Text('Members',
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold))),
              const SizedBox(height: 10),
              _titleOrMembers(state.selectedEvent!.members),
            ],
          ),
        );
      } else {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
    });
  }

  Widget _titleOrMembers(String titleOrMembers) {
    return Center(
      child: Text(
        titleOrMembers,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _startOrFinish(DateTime startOrFinish) {
    return Center(
      child: Text(
        Utils.toDateTime(startOrFinish),
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  List<Widget> _buildViewingActions(BuildContext context, Event event) => [
        IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context
                  .read<CalendarBloc>()
                  .add(GoToEditingPageEvent(event.title));
            }),
        IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              context.read<CalendarBloc>().add(DeleteEventEvent(
                    event.title,
                  ));
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomePage()));
            }),
      ];
}
