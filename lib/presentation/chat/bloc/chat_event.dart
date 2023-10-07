import 'package:dispatch/domain/model/message_model.dart';
import 'package:equatable/equatable.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

final class LoadMessageListEvent extends ChatEvent {
  const LoadMessageListEvent(this.chatId);

  final String chatId;

  @override
  List<Object> get props => [chatId];
}

final class EditTypedMessage extends ChatEvent {
  const EditTypedMessage(this.text);

  final String text;

  @override
  List<Object> get props => [text];
}

final class SendTypedMessageEvent extends ChatEvent {}

final class ReadMessages extends ChatEvent {}

final class QueueMessageForReading extends ChatEvent {
  const QueueMessageForReading(this.id);

  final String id;

  @override
  List<Object> get props => [id];
}

final class GetMessageEvent extends ChatEvent {
  const GetMessageEvent(this.message);

  final ShortMessageModel message;

  @override
  List<Object> get props => [message];
}
