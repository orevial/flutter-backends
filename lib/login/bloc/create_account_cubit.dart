import 'package:backend_repository/backend_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'create_account_state.dart';

class CreateAccountCubit extends Cubit<CreateAccountState> {
  final AuthenticationRepository authRepository;

  CreateAccountCubit(this.authRepository)
      : super(CreateAccountFormInProgress());

  void updateEmail(String email) {
    emit(
      CreateAccountFormInProgress(
        email: email,
        password: (state as CreateAccountFormInProgress).password,
      ),
    );
  }

  void updatePassword(String password) {
    emit(
      CreateAccountFormInProgress(
        email: (state as CreateAccountFormInProgress).email,
        password: password,
      ),
    );
  }

  void updateConfirmationCode(String confirmationCode) {
    emit(
      CreateAccountNeedsConfirmation(
        email: (state as CreateAccountNeedsConfirmation).email,
        confirmationCode: confirmationCode,
      ),
    );
  }

  void createAccount() async {
    final stateBefore = state as CreateAccountFormInProgress;
    emit(ConfirmAccountInProgress());
    await authRepository
        .createAccount(
          email: stateBefore.email,
          password: stateBefore.password,
        )
        .then((_) => emit(authRepository.needsConfirmation
            ? CreateAccountNeedsConfirmation(email: stateBefore.email)
            : CreateAccountSuccess()))
        .catchError((Object e) {
      emit(CreateAccountFailure());
      emit(CreateAccountFormInProgress(
        email: '',
        password: '',
      ));
    });
  }

  void confirmAccount() async {
    final stateBefore = state as CreateAccountNeedsConfirmation;
    emit(ConfirmAccountInProgress());
    await authRepository
        .confirmAccount(
          email: stateBefore.email,
          confirmationCode: stateBefore.confirmationCode,
        )
        .then((_) => emit(CreateAccountSuccess()))
        .catchError((Object e) {
      emit(CreateAccountFailure());
      emit(CreateAccountFormInProgress(
        email: '',
        password: '',
      ));
    });
  }
}
