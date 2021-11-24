import 'package:backend_repository/backend_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthenticationRepository extends AuthenticationRepository<User> {
  final FirebaseAuth auth;
  User? _user;

  FirebaseAuthenticationRepository(this.auth) : super();

  @override
  void checkAuthStatus() async {
    // Do nothing
  }

  @override
  Stream<AuthenticationStatus> get status =>
      auth.authStateChanges().map((user) {
        _user = user;
        return user == null
            ? AuthenticationStatus.unauthenticated
            : AuthenticationStatus.authenticated;
      });

  @override
  Future<void> login({required String email, required String password}) {
    return auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> createAccount({
    required String email,
    required String password,
  }) {
    return auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() {
    return auth.signOut();
  }

  @override
  bool get isAuthenticated => _user != null;
}
