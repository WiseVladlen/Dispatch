import 'package:dispatch/domain/model/user_model.dart';
import 'package:equatable/equatable.dart';

final class MessageContent extends Equatable {
  const MessageContent({required this.text});

  final String text;

  @override
  List<Object> get props => [text];
}

enum MessageStatus {
  sent,
  delivered,
  read;

  bool get isSent => this == MessageStatus.sent;
  bool get isDelivered => this == MessageStatus.delivered;
  bool get isRead => this == MessageStatus.read;
}

final class ShortMessageModel extends Equatable {
  const ShortMessageModel({
    required this.id,
    required this.content,
    required this.dispatchTime,
    required this.status,
    required this.sender,
  });

  final String id;
  final MessageContent content;
  final DateTime dispatchTime;
  final MessageStatus status;
  final ShortUserModel sender;

  ShortMessageModel copyWith({
    String? id,
    MessageContent? content,
    DateTime? dispatchTime,
    MessageStatus? status,
    ShortUserModel? sender,
  }) {
    return ShortMessageModel(
      id: id ?? this.id,
      content: content ?? this.content,
      dispatchTime: dispatchTime ?? this.dispatchTime,
      status: status ?? this.status,
      sender: sender ?? this.sender,
    );
  }

  @override
  List<Object> get props => [id, content, dispatchTime, status, sender];
}

final class StandardMessageModel extends ShortMessageModel {
  const StandardMessageModel({
    required super.id,
    required super.content,
    required super.dispatchTime,
    required super.status,
    required super.sender,
    required this.chatId,
  });

  final String chatId;

  @override
  StandardMessageModel copyWith({
    String? id,
    MessageContent? content,
    DateTime? dispatchTime,
    MessageStatus? status,
    ShortUserModel? sender,
    String? chatId,
  }) {
    return StandardMessageModel(
      id: id ?? this.id,
      content: content ?? this.content,
      dispatchTime: dispatchTime ?? this.dispatchTime,
      status: status ?? this.status,
      sender: sender ?? this.sender,
      chatId: chatId ?? this.chatId,
    );
  }

  @override
  List<Object> get props => [super.props, chatId];
}

final class SendMessageRequestModel {
  const SendMessageRequestModel({
    required this.chatId,
    required this.messageContent,
  });

  final String chatId;
  final String messageContent;
}
