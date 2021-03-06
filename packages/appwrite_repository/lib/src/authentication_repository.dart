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
    if (_session != null && _session!.isExpired) {
      _session = null;
      updateAuthStatus(AuthenticationStatus.unauthenticated);
    }
  }

  @override
  Future<void> login({required String email, required String password}) {
    return account
        .createSession(
      // email: email,
      // password: password,
      // TODO Remove this, but a useful fix cause it's so boring...
      email: 'john@company.com',
      password: 'testtest',
    )
        .then((session) {
      _session = session;
      updateAuthStatus(AuthenticationStatus.authenticated);
    });
  }

  @override
  Future<void> createAccount({
    required String email,
    required String password,
  }) {
    return account.create(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() {
    return account.deleteSessions().then((_) {
      _session = null;
      updateAuthStatus(AuthenticationStatus.unauthenticated);
    });
  }

  @override
  Future<bool> get isAuthenticated async => _session != null;

  @override
  bool get needsConfirmation => false;

  @override
  Future<void> confirmAccount({
    required String email,
    required String confirmationCode,
  }) =>
      throw UnimplementedError();
}

extension SessionUtils on Session {
  bool get isExpired => DateTime.fromMillisecondsSinceEpoch(expire * 1000)
      .isBefore(DateTime.now().toUtc());
}
