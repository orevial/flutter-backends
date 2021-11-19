import 'package:appwrite_app/authentication/bloc/authentication_cubit.dart';
import 'package:appwrite_app/home_page.dart';
import 'package:appwrite_app/login/pages/login_page.dart';
import 'package:appwrite_app/splash_page.dart';
import 'package:appwrite_app/utils/repository_utils.dart';
import 'package:backend_repository/backend_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'breweries/bloc/brewery_cubit.dart';
import 'login/bloc/login_cubit.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: backendRepositories(Backend.appwrite),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationCubit>(
            create: (context) => AuthenticationCubit(
              authRepository: context.read<AuthenticationRepository>(),
            ),
          ),
          BlocProvider<BreweryCubit>(
            create: (context) => BreweryCubit(
              context.read<BreweryRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          navigatorKey: _navigatorKey,
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          builder: (context, child) {
            return BlocListener<AuthenticationCubit, AuthenticationState>(
              listenWhen: (previous, current) => previous != current,
              listener: (_, state) {
                if (state.status == AuthenticationStatus.authenticated) {
                  _navigator.pushAndRemoveUntil(
                    MaterialPageRoute<void>(
                      builder: (_) => const HomePage(),
                    ),
                    (_) => false,
                  );
                } else {
                  _navigator.pushAndRemoveUntil(
                    MaterialPageRoute<void>(
                      builder: (_) => BlocProvider(
                        create: (_) => LoginCubit(
                          context.read<AuthenticationRepository>(),
                        ),
                        child: const LoginPage(),
                      ),
                    ),
                    (_) => false,
                  );
                }
              },
              child: child,
            );
          },
          onGenerateRoute: (_) =>
              MaterialPageRoute<void>(builder: (_) => const SplashPage()),
        ),
      ),
    );
  }
}
