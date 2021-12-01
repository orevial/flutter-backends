part of 'create_account_cubit.dart';

@immutable
abstract class CreateAccountState extends Equatable {}

class CreateAccountFormInProgress extends CreateAccountState {
  final String email;
  final String password;

  CreateAccountFormInProgress({
    this.email = '',
    this.password = '',
  });

  bool get isValid => email.length >= 3 && password.length >= 3;

  @override
  List<Object?> get props => [email, password];
}

class CreateAccountInProgress extends CreateAccountState {
  @override
  List<Object?> get props => [];
}

class ConfirmAccountInProgress extends CreateAccountState {
  @override
  List<Object?> get props => [];
}

class CreateAccountFailure extends CreateAccountState {
  @override
  List<Object?> get props => [];
}

class CreateAccountSuccess extends CreateAccountState {
  @override
  List<Object?> get props => [];
}

class CreateAccountNeedsConfirmation extends CreateAccountState {
  final String email;
  final String confirmationCode;

  CreateAccountNeedsConfirmation({
    this.email = '',
    this.confirmationCode = '',
  });

  bool get isValid => email.length >= 3 && confirmationCode.length >= 3;

  @override
  List<Object?> get props => [email, confirmationCode];
}
