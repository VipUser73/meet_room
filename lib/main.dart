import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_room/blocs/login_bloc/login_bloc.dart';
import 'package:meet_room/blocs/room_bloc/calendar_bloc.dart';
import 'package:meet_room/pages/login_page/login_page.dart';
import 'package:meet_room/repository/local_repository.dart';
import 'package:meet_room/repository/user_repository.dart';
import 'package:meet_room/services/db_provider.dart';

void main() => runApp(const CalendarApp());

class CalendarApp extends StatelessWidget {
  const CalendarApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<UserRepository>(
        create: (context) => UserRepository(),
        child: RepositoryProvider<LocalRepository>(
          create: (context) => LocalRepository(DBProvider()),
          child: BlocProvider<LoginBloc>(
            create: (BuildContext context) =>
                LoginBloc(context.read<UserRepository>()),
            child: BlocProvider<CalendarBloc>(
              create: (BuildContext context) =>
                  CalendarBloc(context.read<LocalRepository>()),
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData.dark(),
                home: LoginPage(),
              ),
            ),
          ),
        ));
  }
}
