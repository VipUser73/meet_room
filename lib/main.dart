import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_room/bloc/calendar_bloc.dart';
import 'package:meet_room/pages/home_page.dart';
import 'package:meet_room/repository/local_repository.dart';
import 'package:meet_room/services/db_provider.dart';

void main() => runApp(CalendarApp());

class CalendarApp extends StatelessWidget {
  CalendarApp({Key? key}) : super(key: key);
  final LocalRepository _storageRepository = LocalRepository(DBProvider());

  @override
  Widget build(BuildContext context) => RepositoryProvider.value(
        value: _storageRepository,
        child: BlocProvider<CalendarBloc>(
          create: (context) => CalendarBloc(context.read<LocalRepository>()),
          child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData.dark(),
              home: const HomePage()),
        ),
      );
}
