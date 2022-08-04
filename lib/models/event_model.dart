class Event {
  String title;
  String room;
  DateTime start;
  DateTime finish;
  String members;

  Event({
    required this.title,
    required this.room,
    required this.start,
    required this.finish,
    required this.members,
  });
  factory Event.fromDB(Map<String, dynamic> dataDB) => Event(
        title: dataDB["title"] ?? '',
        room: dataDB["room"] ?? '',
        start: DateTime.parse(dataDB["start"]),
        finish: DateTime.parse(dataDB["finish"]),
        members: dataDB["members"] ?? '',
      );
}
