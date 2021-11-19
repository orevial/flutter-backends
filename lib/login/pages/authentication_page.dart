import 'package:appwrite_app/login/bloc/create_account_cubit.dart';
import 'package:appwrite_app/login/bloc/login_cubit.dart';
import 'package:appwrite_app/login/pages/create_account_page.dart';
import 'package:appwrite_app/login/pages/login_page.dart';
import 'package:backend_repository/backend_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🍺 Login 🍺'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => BlocProvider(
                      create: (_) => LoginCubit(
                        context.read<AuthenticationRepository>(),
                      ),
                      child: const LoginPage(),
                    ),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => BlocProvider(
                      create: (_) => CreateAccountCubit(
                        context.read<AuthenticationRepository>(),
                      ),
                      child: const CreateAccountPage(),
                    ),
                  ),
                ),
                child: const Text(
                  'Create account',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
