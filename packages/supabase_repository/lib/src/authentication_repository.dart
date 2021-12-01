import 'package:backend_repository/backend_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthenticationRepository
    extends AuthenticationRepository<Session> {
  final GoTrueClient auth;
  Session? _session;

  SupabaseAuthenticationRepository(this.auth) : super() {
    _session = auth.session();
    if (_session != null && !_session!.isExpired) {
      updateAuthStatus(AuthenticationStatus.authenticated);
    } else {
      updateAuthStatus(AuthenticationStatus.unauthenticated);
    }
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
    return auth
        .signIn(
      email: email,
      password: password,
    )
        .then((session) {
      _session = session.data;
      updateAuthStatus(AuthenticationStatus.authenticated);
    });
  }

  @override
  Future<void> createAccount({
    required String email,
    required String password,
  }) {
    return auth
        .signUp(
          email,
          password,
      options: AuthOptions()
        )
        .then((_) => print('User just signed up !'))
        .catchError((e) {
      print('Error while signing up');
      throw e;
    });
  }

  @override
  Future<void> logout() {
    return auth.signOut().then((_) {
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
  bool get isExpired => DateTime.fromMillisecondsSinceEpoch(expiresAt! * 1000)
      .isBefore(DateTime.now().toUtc());
}
