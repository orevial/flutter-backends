part of 'login_cubit.dart';

@immutable
abstract class LoginState extends Equatable {}

class LoginFormInProgress extends LoginState {
  final String email;
  final String password;

  LoginFormInProgress({this.email = '', this.password = ''});

  bool get isValid => email.length >= 3 && password.length >= 3;

  @override
  List<Object?> get props => [email, password];
}

class LoginInProgress extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginFailure extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginSuccess extends LoginState {
  @override
  List<Object?> get props => [];
}
