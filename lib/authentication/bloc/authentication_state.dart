part of 'authentication_cubit.dart';

class AuthenticationState extends Equatable {
  final AuthenticationStatus status;
  final Session? session;

  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.session ,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(Session session)
      : this._(status: AuthenticationStatus.authenticated, session: session);

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  @override
  List<Object?> get props => [status, session];
}

enum AuthenticationStatus { unknown, authenticated, unauthenticated }
