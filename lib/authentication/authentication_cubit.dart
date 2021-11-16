import 'dart:async';

import 'package:appwrite/models.dart';
import 'package:appwrite_app/authentication/authentication_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  late AuthenticationService _authService;
  late StreamSubscription<AuthenticationStatus> _authStatusSubscription;

  AuthenticationCubit({required AuthenticationService authService})
      : super(
          const AuthenticationState.unknown(),
        ) {
    _authService = authService;
    _authStatusSubscription = _authService.status.listen(_onAuthStatusChanged);

  }

  void _onAuthStatusChanged(AuthenticationStatus newStatus) async {
    switch (newStatus) {
      case AuthenticationStatus.unauthenticated:
        return emit(const AuthenticationState.unauthenticated());
      case AuthenticationStatus.authenticated:
        final session = _authService.session;
        return emit(session != null
            ? AuthenticationState.authenticated(session)
            : const AuthenticationState.unauthenticated());
      default:
        return emit(const AuthenticationState.unknown());
    }
  }

  Future<void> logout() {
    return _authService.logout();
  }

  @override
  Future<void> close() {
    _authStatusSubscription.cancel();
    return super.close();
  }
}
