import 'package:flutter_backends/login/bloc/create_account_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'authentication_page.dart';

final _dialogKey = GlobalKey(debugLabel: 'loading-waiting-dialog');

class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final createAccount = context.read<CreateAccountCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('CreateAccount'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              onChanged: (email) => createAccount.updateEmail(email),
              decoration: const InputDecoration(
                label: Text('Email'),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              onChanged: (pwd) => createAccount.updatePassword(pwd),
              decoration: const InputDecoration(
                label: Text('Password'),
              ),
            ),
          ),
          const SizedBox(height: 20),
          BlocBuilder<CreateAccountCubit, CreateAccountState>(
            builder: (_, state) {
              return state is CreateAccountNeedsConfirmation
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        onChanged: (code) =>
                            createAccount.updateConfirmationCode(code),
                        decoration: const InputDecoration(
                          label: Text('Confirmation code'),
                        ),
                      ),
                    )
                  : Container();
            },
            buildWhen: (_, currentState) =>
                currentState is CreateAccountNeedsConfirmation,
          ),
          const SizedBox(height: 20),
          BlocConsumer<CreateAccountCubit, CreateAccountState>(
            listenWhen: (_, state) =>
                state is! CreateAccountFormInProgress &&
                state is! CreateAccountNeedsConfirmation,
            listener: (context, state) {
              switch (state.runtimeType) {
                case CreateAccountInProgress:
                case ConfirmAccountInProgress:
                  showLoadingDialog(context, _dialogKey);
                  break;
                case CreateAccountSuccess:
                  if (_dialogKey.currentContext != null) {
                    Navigator.of(_dialogKey.currentContext!).pop();
                  }
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (_) => const AuthenticationPage(),
                    ),
                  );
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                          content: Text('Account created, you can now login')),
                    );
                  break;
                case CreateAccountFailure:
                  Navigator.of(_dialogKey.currentContext!).pop();
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(content: Text('Account creation failure')),
                    );
                  break;
              }
            },
            builder: (_, state) {
              if (state is CreateAccountNeedsConfirmation) {
                return ElevatedButton(
                  onPressed: state.isValid
                      ? () => createAccount.confirmAccount()
                      : null,
                  child: const Text('Confirm account'),
                );
              }
              return ElevatedButton(
                onPressed:
                    state is! CreateAccountFormInProgress || state.isValid
                        ? () => createAccount.createAccount()
                        : null,
                child: const Text('Create account'),
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
