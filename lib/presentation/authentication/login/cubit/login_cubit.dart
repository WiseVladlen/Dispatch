import 'package:dispatch/domain/model/authentication_data_model.dart';
import 'package:dispatch/domain/repository/authentication_repository.dart';
import 'package:dispatch/presentation/authentication/login/cubit/login_state.dart';
import 'package:dispatch/utils/form/email.dart';
import 'package:dispatch/utils/form/password.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class LoginCubit extends Cubit<LoginState> {
  final IAuthenticationRepository authenticationRepository;

  LoginCubit({required this.authenticationRepository}) : super(const LoginState());

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(email: email, isValid: Formz.validate([email, state.password])));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(password: password, isValid: Formz.validate([state.email, password])));
  }

  Future<void> logIn() async {
    if (!state.isValid) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      await authenticationRepository.logIn(
        model: LoginDataModel(
          email: state.email.value,
          password: state.password.value,
        ),
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
