import 'dart:async';

import 'package:backend_repository/backend_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  late AuthenticationRepository _authRepository;
  late StreamSubscription<AuthenticationStatus> _authStatusSubscription;

  AuthenticationCubit({required AuthenticationRepository authRepository})
      : super(
          const AuthenticationState.unknown(),
        ) {
    _authRepository = authRepository;
    _authStatusSubscription =
        _authRepository.status.listen(_onAuthStatusChanged);
  }

  void _onAuthStatusChanged(AuthenticationStatus newStatus) async {
    switch (newStatus) {
      case AuthenticationStatus.unauthenticated:
        return emit(const AuthenticationState.unauthenticated());
      case AuthenticationStatus.authenticated:
        return emit(_authRepository.isAuthenticated
            ? const AuthenticationState.authenticated()
            : const AuthenticationState.unauthenticated());
      default:
        return emit(const AuthenticationState.unknown());
    }
  }

  Future<void> logout() {
    return _authRepository.logout();
  }

  @override
  Future<void> close() {
    _authStatusSubscription.cancel();
    return super.close();
  }
}
