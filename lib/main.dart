import 'package:flutter_backends/authentication/bloc/authentication_cubit.dart';
import 'package:flutter_backends/home_page.dart';
import 'package:flutter_backends/login/pages/authentication_page.dart';
import 'package:flutter_backends/splash_page.dart';
import 'package:flutter_backends/utils/repository_utils.dart';
import 'package:backend_repository/backend_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'breweries/bloc/brewery_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repositories = await backendRepositories(Backend.awsAmplify);

  runApp(
    MyApp(repositories: repositories),
  );
}

class MyApp extends StatelessWidget {
  final List<RepositoryProvider> repositories;

  MyApp({
    required this.repositories,
    Key? key,
  }) : super(key: key);

  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: repositories,
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
                      builder: (_) => const AuthenticationPage(),
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
