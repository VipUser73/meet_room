import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_room/blocs/login_bloc/form_status.dart';
import 'package:meet_room/blocs/login_bloc/login_bloc.dart';
import 'package:meet_room/blocs/login_bloc/login_event.dart';
import 'package:meet_room/blocs/login_bloc/login_state.dart';
import 'package:meet_room/pages/home_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.green.shade700,
          title: const Text('MeetRoom'),
        ),
        body: SafeArea(
          child: _loginForm(),
        ),
      ),
    );
  }

  Widget _loginForm() {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        final formStatus = state.formStatus;
        if (formStatus is SubmissionSuccess) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const HomePage()));
        }
        if (formStatus is SubmissionFailed) {
          _showSnackBar(context, 'Invalid Login or Password');
        }
      },
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 60),
          children: [
            _usernameField(),
            const SizedBox(height: 16),
            _passwordField(),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80),
              child: _loginButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _usernameField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return TextFormField(
        textInputAction: TextInputAction.next,
        cursorColor: Colors.green,
        decoration: const InputDecoration(
          labelText: 'Login',
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
        validator: (value) => state.isValidUsername
            ? null
            : 'Username should contain minimum 3 characters',
        onChanged: (value) => context
            .read<LoginBloc>()
            .add(LoginUsernameChanged(username: value)),
        controller: _loginController,
      );
    });
  }

  Widget _passwordField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return TextFormField(
        obscureText: true,
        maxLength: 8,
        textInputAction: TextInputAction.done,
        cursorColor: Colors.green,
        decoration: const InputDecoration(
          labelText: 'Password',
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
        validator: (value) => state.isValidPassword
            ? null
            : 'Password should contain minimum 5 characters',
        onChanged: (value) => context
            .read<LoginBloc>()
            .add(LoginPasswordChanged(password: value)),
        controller: _passwordController,
        onFieldSubmitted: (_) => submit(context),
      );
    });
  }

  Widget _loginButton() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return state.formStatus is FormSubmitting
          ? const Center(child: CircularProgressIndicator())
          : ElevatedButton(
              onPressed: () => submit(context),
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            );
    });
  }

  void submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(LoginSubmited(
          username: _loginController.text, password: _passwordController.text));
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
