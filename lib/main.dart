import 'package:appwrite/appwrite.dart';
import 'package:appwrite_app/authentication/authentication_cubit.dart';
import 'package:appwrite_app/breweries/brewery_cubit.dart';
import 'package:appwrite_app/home_page.dart';
import 'package:appwrite_app/login/pages/login_page.dart';
import 'package:appwrite_app/splash_page.dart';
import 'package:appwrite_app/utils/app_write_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'authentication/authentication_service.dart';
import 'login/login_cubit.dart';

const breweryCollectionId = '61923aa141911';
const beersCollectionId = '61923abb90834';

final _state = AppWriteState(client: Client());
final _authenticationService = AuthenticationService(_state.account);
final _authCubit = AuthenticationCubit(
  authService: _authenticationService,
);

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
      providers: [
        RepositoryProvider<AppWriteState>(create: (_) => _state),
        RepositoryProvider<AuthenticationService>(
          create: (_) => _authenticationService,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationCubit>(
            create: (context) => _authCubit,
          ),
          BlocProvider<BreweryCubit>(
            create: (context) => BreweryCubit(
              _state.database,
              _state.realtime,
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
                  print('Here ? ');
                  _navigator.pushAndRemoveUntil(
                    MaterialPageRoute<void>(
                      builder: (_) => BlocProvider(
                        create: (_) => LoginCubit(_authenticationService),
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
