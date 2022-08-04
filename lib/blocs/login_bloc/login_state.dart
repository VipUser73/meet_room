import 'package:meet_room/blocs/login_bloc/form_status.dart';

class LoginState {
  final String username;
  bool get isValidUsername => username.length >= 3;

  final String password;
  bool get isValidPassword => password.length >= 5;

  final FormStatus formStatus;
  LoginState({
    this.username = '',
    this.password = '',
    this.formStatus = const InitialFormStatus(),
  });

  LoginState copyWith({
    String? username,
    String? password,
    FormStatus? formStatus,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
