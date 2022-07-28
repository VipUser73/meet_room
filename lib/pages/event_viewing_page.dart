import 'package:flutter/material.dart';
import 'package:meet_room/models/event_model.dart';
import 'package:meet_room/models/utils.dart';
import 'package:meet_room/pages/event_editing_page.dart';

class EventViewingPage extends StatelessWidget {
  final Event event;
  const EventViewingPage({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        actions: buildViewingActions(context, event),
      ),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          Center(
            child: Text(
              event.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 30),
          Text(
            Utils.toDateTime(event.start),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            Utils.toDateTime(event.finish),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ));

  List<Widget> buildViewingActions(BuildContext context, Event event) => [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => EventEditingPage())),
        ),
        IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ];
}
