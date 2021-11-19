import 'dart:async';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

abstract class AuthSession {}

abstract class AuthenticationRepository<T> {
  late final StreamController<AuthenticationStatus> _controller =
      StreamController<AuthenticationStatus>(
    onListen: _startTimer,
    onCancel: _stopTimer,
  );
  Timer? _timer;

  AuthenticationRepository() {
    _controller.add(AuthenticationStatus.unknown);
  }

  T? get session;

  void checkAuthStatus();

  Stream<AuthenticationStatus> get status {
    return _controller.stream;
  }

  Future<T> login({
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
