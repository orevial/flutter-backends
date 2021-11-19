import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:backend_repository/backend_repository.dart';

class AppwriteAuthenticationRepository
    extends AuthenticationRepository<Session> {
  final Account account;
  Session? _session;

  AppwriteAuthenticationRepository(this.account) : super() {
    account.getSession(sessionId: 'current').then((session) {
      if (session.isExpired) {
        throw 'Session expired';
      }
      _session = session;
      updateAuthStatus(AuthenticationStatus.authenticated);
    }).catchError((Object e) {
      updateAuthStatus(AuthenticationStatus.unauthenticated);
    });
  }

  @override
  void checkAuthStatus() async {
    if (_session != null &&
        DateTime.fromMillisecondsSinceEpoch(_session!.expire * 1000)
            .isBefore(DateTime.now().toUtc())) {
      _session = null;
      updateAuthStatus(AuthenticationStatus.unauthenticated);
    }
  }

  @override
  Future<Session> login({required String email, required String password}) {
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
      updateAuthStatus(AuthenticationStatus.authenticated);
      return session;
    });
  }

  @override
  Future<void> logout() {
    return account.deleteSessions().then((_) {
      _session = null;
      updateAuthStatus(AuthenticationStatus.unauthenticated);
    });
  }

  @override
  Session? get session => _session;
}

extension SessionUtils on Session {
  bool get isExpired => DateTime.fromMillisecondsSinceEpoch(expire * 1000)
      .isBefore(DateTime.now().toUtc());
}
