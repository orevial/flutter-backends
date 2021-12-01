import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_flutter/amplify_hub.dart';
import 'package:amplify_flutter/categories/amplify_categories.dart';
import 'package:backend_repository/backend_repository.dart';

class AwsAmplifyAuthenticationRepository
    extends AuthenticationRepository<AuthUser> {
  final AuthCategory auth;
  final AmplifyHub hub;

  AwsAmplifyAuthenticationRepository(this.auth, this.hub) : super() {
    this.auth.getCurrentUser().then((_) {
      updateAuthStatus(AuthenticationStatus.authenticated);
    }).catchError((_) {
      updateAuthStatus(AuthenticationStatus.unauthenticated);
    });
    hub.availableStreams[HubChannel.Auth]!.listen((dynamic event) {
      if (event.eventName == 'SIGNED_IN') {
        updateAuthStatus(AuthenticationStatus.authenticated);
      } else {
        updateAuthStatus(AuthenticationStatus.unauthenticated);
      }
    });
  }

  @override
  void checkAuthStatus() async {
    // Do nothing
  }

  @override
  Future<void> login({required String email, required String password}) {
    return auth
        .signIn(
      username: email,
      password: password,
    )
        .then((value) {
      print('Login OK : $value');
    }).catchError((Object e) {
      print(e);
    });
  }

  @override
  Future<void> createAccount({
    required String email,
    required String password,
  }) {
    return auth.signUp(
      username: email,
      password: password,
      options: CognitoSignUpOptions(
        userAttributes: {
          'email': email,
        },
      ),
    );
  }

  @override
  Future<void> logout() {
    return auth.signOut();
  }

  @override
  Future<bool> get isAuthenticated {
    print('Is authenticated ?');
    return auth.getCurrentUser().then((_) => true).catchError((_) => false);
  }

  @override
  bool get needsConfirmation => true;

  @override
  Future<void> confirmAccount({
    required String email,
    required String confirmationCode,
  }) =>
      auth.confirmSignUp(
        username: email,
        confirmationCode: confirmationCode,
      );
}
