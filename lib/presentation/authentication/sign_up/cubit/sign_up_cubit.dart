import 'package:dispatch/domain/model/authentication_data_model.dart';
import 'package:dispatch/domain/repository/authentication_repository.dart';
import 'package:dispatch/presentation/authentication/sign_up/cubit/sign_up_state.dart';
import 'package:dispatch/utils/form/email.dart';
import 'package:dispatch/utils/form/name.dart';
import 'package:dispatch/utils/form/password.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final IAuthenticationRepository authenticationRepository;

  SignUpCubit({required this.authenticationRepository}) : super(const SignUpState());

  void nameChanged(String value) {
    final name = Name.dirty(value);
    emit(state.copyWith(name: name, isValid: Formz.validate([name, state.email, state.password])));
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      isValid: Formz.validate([state.name, email, state.password]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      isValid: Formz.validate([state.name, state.email, password]),
    ));
  }

  Future<void> signUp() async {
    if (!state.isValid) return;

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      await authenticationRepository.signUp(
        model: RegistrationDataModel(
          name: state.name.value,
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
