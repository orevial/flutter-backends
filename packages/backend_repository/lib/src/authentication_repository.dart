import 'dart:async';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

abstract class AuthenticationRepository<T> {
  // TODO Maybe move this to repository implementations as certain backends API such as Firebase do not need this
  late final StreamController<AuthenticationStatus> _controller =
      StreamController<AuthenticationStatus>(
    onListen: _startTimer,
    onCancel: _stopTimer,
  );
  Timer? _timer;

  AuthenticationRepository() {
    _controller.add(AuthenticationStatus.unknown);
  }

  bool get isAuthenticated;

  void checkAuthStatus();

  Stream<AuthenticationStatus> get status {
    return _controller.stream;
  }

  Future<void> createAccount({
    required String email,
    required String password,
  });

  Future<void> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  void updateAuthStatus(AuthenticationStatus status) {
    _controller.add(status);
  }

  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => checkAuthStatus(),
    );
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }
}
