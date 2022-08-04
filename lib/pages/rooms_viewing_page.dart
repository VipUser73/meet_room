import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_room/blocs/room_bloc/calendar_bloc.dart';
import 'package:meet_room/blocs/room_bloc/calendar_event.dart';
import 'package:meet_room/blocs/room_bloc/calendar_state.dart';

class RoomsViewingPage extends StatelessWidget {
  const RoomsViewingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CalendarBloc, CalendarState>(
        listener: (context, state) {
      if (state is LoadedEditingPageState) {
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => EventEditingPage()));
      }
    }, builder: (context, state) {
      if (state is LoadedRoomsState) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green.shade700,
            leading: CloseButton(
              onPressed: () {
                context.read<CalendarBloc>().add(LoadingCalendarEvent());
                Navigator.of(context).pop();
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add, color: Colors.white),
              backgroundColor: Colors.green.shade800,
              onPressed: () {
                context.read<CalendarBloc>().add(AddRoomEvent());
              }),
          body: _listRooms(context, state.listRooms),
        );
      } else {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
    });
  }

  Widget _listRooms(BuildContext context, List<String> listRooms) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        itemCount: listRooms.length,
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 10),
        itemBuilder: (context, index) {
          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            onDismissed: (_) {},
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
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  context.read<CalendarBloc>().add(SelectedRoomEvent(index));
                },
                child: Card(
                  margin: EdgeInsets.zero,
                  color: Colors.green.shade700,
                  child: Center(
                    child: Text(
                      listRooms[index],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
