import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_room/blocs/login_bloc/form_status.dart';
import 'package:meet_room/blocs/login_bloc/login_event.dart';
import 'package:meet_room/blocs/login_bloc/login_state.dart';
import 'package:meet_room/repository/user_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._userRepository) : super(LoginState()) {
    on<LoginUsernameChanged>(_loginUsernameChanged);
    on<LoginPasswordChanged>(_loginPasswordChanged);
    on<LoginSubmited>(_loginSubmited);
  }
  final UserRepository _userRepository;

  _loginUsernameChanged(
      LoginUsernameChanged event, Emitter<LoginState> emit) async {
    emit(state.copyWith(username: event.username));
  }

  _loginPasswordChanged(
      LoginPasswordChanged event, Emitter<LoginState> emit) async {
    emit(state.copyWith(password: event.password));
  }

  _loginSubmited(LoginSubmited event, Emitter<LoginState> emit) async {
    emit(state.copyWith(formStatus: FormSubmitting()));

    bool check =
        await _userRepository.checkLogin(event.username, event.password);
    if (check) {
      emit(state.copyWith(formStatus: SubmissionSuccess()));
    } else {
      emit(state.copyWith(formStatus: SubmissionFailed()));
      emit(state.copyWith(formStatus: const InitialFormStatus()));
    }
  }
}
