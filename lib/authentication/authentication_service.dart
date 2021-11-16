import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:appwrite_app/authentication/authentication_cubit.dart';
import 'package:appwrite_app/home_page.dart';

class AuthenticationService {
  final Account account;

  late final StreamController<AuthenticationStatus> _controller =
      StreamController<AuthenticationStatus>(
    onListen: _startTimer,
    onCancel: _stopTimer,
  );
  Timer? _timer;
  Session? _session;

  AuthenticationService(this.account) {
    _controller.add(AuthenticationStatus.unknown);
    account.getSession(sessionId: 'current').then((session) {
      print('Got existing session');
      print(session.toString2());
      print('Authenticated');
      _session = session;
      _controller.add(AuthenticationStatus.authenticated);
    }).catchError((Object e) {
      print('Unauthenticated');
      _controller.add(AuthenticationStatus.unauthenticated);
    });
  }

  Session? get session => _session;

  void _checkAuthStatus(_) {
    if (_session != null &&
        DateTime.fromMillisecondsSinceEpoch(_session!.expire * 1000)
            .isBefore(DateTime.now().toUtc())) {
      _session = null;
      _controller.add(AuthenticationStatus.unauthenticated);
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 5),
      _checkAuthStatus,
    );
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Stream<AuthenticationStatus> get status {
    return _controller.stream;
  }

  Future<Session> login({
    required String email,
    required String password,
  }) {
    return account
        .createSession(
      // email: email,
      // password: password,
      // TODO Remove this, but a useful fix cause it's so boring...
      email: 'john.doe@stack-labs.com',
      password: 'awesomepass',
    )
        .then((session) {
      _session = session;
      _controller.add(AuthenticationStatus.authenticated);
      return session;
    }).catchError((Object e) {
      print('Error on login: $e');
      throw e;
    });
  }

  Future<void> logout() {
    return account.deleteSessions().then((_) {
      _session = null;
      _controller.add(AuthenticationStatus.unauthenticated);
    });
  }
}
