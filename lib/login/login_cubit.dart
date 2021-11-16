
import 'package:appwrite_app/authentication/authentication_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationService authService;

  LoginCubit(this.authService) : super(LoginFormInProgress());

  void updateEmail(String email) {
    emit(
      LoginFormInProgress(
        email: email,
        password: (state as LoginFormInProgress).password,
      ),
    );
  }

  void updatePassword(String password) {
    emit(
      LoginFormInProgress(
        email: (state as LoginFormInProgress).email,
        password: password,
      ),
    );
  }

  void login() async {
    final stateBefore = state as LoginFormInProgress;
    emit(LoginInProgress());
    await authService
        .login(
          email: stateBefore.email,
          password: stateBefore.password,
        )
        .then((_) => emit(LoginSuccess()))
        .catchError((Object e) {
      emit(LoginFailure());
      emit(LoginFormInProgress(
        email: stateBefore.email,
        password: stateBefore.password,
      ));
    });
  }
}
