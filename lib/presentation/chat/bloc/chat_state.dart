import 'package:dispatch/domain/model/message_model.dart';
import 'package:dispatch/utils/form/message.dart';
import 'package:equatable/equatable.dart';

class ChatState extends Equatable {
  final Message typedMessage;
  final bool isValid;
  final bool textFieldIsCleared;
  final List<ShortMessageModel>? messages;

  const ChatState({
    this.typedMessage = const Message.pure(),
    this.isValid = false,
    this.textFieldIsCleared = false,
    this.messages,
  });

  ChatState copyWith({
    Message? typedMessage,
    bool? isValid,
    bool textFieldIsCleared = false,
    List<ShortMessageModel>? messages,
  }) {
    return ChatState(
      typedMessage: typedMessage ?? this.typedMessage,
      isValid: isValid ?? this.isValid,
      textFieldIsCleared: textFieldIsCleared,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object?> get props => [typedMessage, isValid, textFieldIsCleared, messages];
}
