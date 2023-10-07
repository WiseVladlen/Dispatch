import 'package:formz/formz.dart';

enum MessageValidationError { invalid }

class Message extends FormzInput<String, MessageValidationError> {
  const Message.pure() : super.pure('');
  const Message.dirty([super.value = '']) : super.dirty();

  @override
  MessageValidationError? validator(String? value) {
    return (value == null || value.trim().isNotEmpty) ? null : MessageValidationError.invalid;
  }
}
