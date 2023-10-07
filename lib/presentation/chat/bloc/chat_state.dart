import 'package:dispatch/domain/model/message_model.dart';
import 'package:dispatch/utils/form/message.dart';
import 'package:equatable/equatable.dart';

class ChatState extends Equatable {
  final Message typedMessage;
  final bool isValid;
  final List<ShortMessageModel>? messages;

  const ChatState({
    this.typedMessage = const Message.pure(),
    this.isValid = false,
    this.messages,
  });

  ChatState copyWith({
    Message typedMessage = const Message.pure(),
    bool? isValid,
    bool changeMessage = false,
    List<ShortMessageModel>? messages,
  }) {
    return ChatState(
      typedMessage: changeMessage ? typedMessage : this.typedMessage,
      isValid: isValid ?? this.isValid,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object?> get props => [typedMessage, isValid, messages];
}
