import 'package:formz/formz.dart';

enum NameValidationError { invalid }

class Name extends FormzInput<String, NameValidationError> {
  const Name.pure() : super.pure('');
  const Name.dirty([super.value = '']) : super.dirty();

  @override
  NameValidationError? validator(String? value) {
    return (value == null || (value.trim().isNotEmpty && value.trim().length > 1))
        ? null
        : NameValidationError.invalid;
  }
}
