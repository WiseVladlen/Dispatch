import 'package:dispatch/utils/form/email.dart';
import 'package:dispatch/utils/form/name.dart';
import 'package:dispatch/utils/form/password.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

class SettingsState extends Equatable {
  final Name name;
  final Email email;
  final Password password;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? imagePath;
  final String? errorMessage;

  const SettingsState({
    this.name = const Name.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = true,
    this.imagePath,
    this.errorMessage,
  });

  SettingsState copyWith({
    Name? name,
    Email? email,
    Password? password,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? imagePath,
    String? errorMessage,
    bool changeImagePath = false,
  }) {
    return SettingsState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      imagePath: changeImagePath ? imagePath : this.imagePath,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [name, email, password, status, isValid, imagePath, errorMessage];
}
