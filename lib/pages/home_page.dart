import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_room/blocs/room_bloc/calendar_bloc.dart';
import 'package:meet_room/blocs/room_bloc/calendar_event.dart';
import 'package:meet_room/blocs/room_bloc/calendar_state.dart';
import 'package:meet_room/models/event_data_source.dart';
import 'package:meet_room/pages/add_event_page.dart';
import 'package:meet_room/pages/event_viewing_page.dart';
import 'package:meet_room/pages/rooms_viewing_page.dart';
import 'package:meet_room/widgets/tasks_widget.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CalendarBloc, CalendarState>(
        bloc: context.read<CalendarBloc>()..add(LoadingCalendarEvent()),
        listener: (context, state) {
          if (state is AddEventState) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AddEventPage()));
          }
          if (state is LoadedViewingPageState) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const EventViewingPage()));
          }
          if (state is LoadedRoomsState) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const RoomsViewingPage()));
          }
        },
        builder: (context, state) {
          if (state is LoadedCalendarState) {
            return Scaffold(
              appBar: AppBar(
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  backgroundColor: Colors.green.shade700,
                  title:
                      _appBarTitle(context, state.listRooms, state.indexRoom)),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 90),
                  child: SfCalendar(
                    headerHeight: 50,
                    view: CalendarView.month,
                    firstDayOfWeek: 1,
                    selectionDecoration:
                        BoxDecoration(border: Border.all(color: Colors.white)),
                    cellBorderColor: Colors.black,
                    todayHighlightColor: Colors.green,
                    dataSource: EventDataSource(state.events),
                    initialDisplayDate: DateTime.now(),
                    onLongPress: (CalendarLongPressDetails details) {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => TasksWidget(details.date!),
                      );
                    },
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                  child: const Icon(Icons.add, color: Colors.white),
                  backgroundColor: Colors.green.shade800,
                  onPressed: () {
                    context.read<CalendarBloc>().add(AddEventEvent());
                  }),
            );
          } else {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }
        });
  }

  Widget _appBarTitle(
      BuildContext context, List<String> listRooms, int? index) {
    String title = 'Rooms';
    if (index != null) {
      title = listRooms[index];
    }
    return GestureDetector(
      onTap: () {
        context.read<CalendarBloc>().add(GoToViewingRoomsEvent());
      },
      child: Container(
          width: 100,
          height: 34,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(width: 2, color: Colors.green.shade800)),
          child: Center(child: Text(title))),
    );
  }
}
