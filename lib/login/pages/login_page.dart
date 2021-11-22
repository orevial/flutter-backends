import 'package:flutter_backends/login/bloc/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _dialogKey = GlobalKey(debugLabel: 'loading-waiting-dialog');

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final login = context.read<LoginCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              onChanged: (email) => login.updateEmail(email),
              decoration: const InputDecoration(
                label: Text('Email'),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              onChanged: (pwd) => login.updatePassword(pwd),
              decoration: const InputDecoration(
                label: Text('Password'),
              ),
            ),
          ),
          const SizedBox(height: 20),
          BlocConsumer<LoginCubit, LoginState>(
            listenWhen: (_, state) => state is! LoginFormInProgress,
            listener: (context, state) {
              switch (state.runtimeType) {
                case LoginInProgress:
                  showLoadingDialog(context, _dialogKey);
                  break;
                case LoginSuccess:
                  Navigator.of(_dialogKey.currentContext!).pop();
                  Navigator.of(context).pushReplacementNamed('/');
                  break;
                case LoginFailure:
                  Navigator.of(_dialogKey.currentContext!).pop();
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(content: Text('Authentication Failure')),
                    );
                  break;
              }
            },
            builder: (_, state) {
              return ElevatedButton(
                onPressed: state is! LoginFormInProgress || state.isValid
                    ? () => login.login()
                    : null,
                child: const Text('Login'),
              );
            },
          ),
        ],
      ),
    );
  }

  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(key: key, children: <Widget>[
                Center(
                  child: Column(children: const [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Please Wait....")
                  ]),
                )
              ]));
        });
  }
}
