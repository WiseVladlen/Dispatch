import 'package:dispatch/domain/model/message_model.dart';
import 'package:dispatch/domain/model/user_model.dart';
import 'package:equatable/equatable.dart';

enum ChatType {
  oneOnOne,
  group;

  bool get isOneOnOne => this == oneOnOne;
}

class ChatModel extends Equatable {
  const ChatModel({
    required this.id,
    required this.title,
    this.imagePath,
    required this.type,
    required this.participants,
    required this.lastMessage,
    required this.hasUnreadMessages,
  });

  final String id;
  final String title;
  final String? imagePath;
  final ChatType type;
  final List<UserModel> participants;
  final ShortMessageModel lastMessage;
  final bool hasUnreadMessages;

  ChatModel copyWith({
    String? id,
    String? title,
    String? imagePath,
    ChatType? type,
    List<UserModel>? participants,
    ShortMessageModel? lastMessage,
    bool? hasUnreadMessages,
  }) {
    return ChatModel(
      id: id ?? this.id,
      title: title ?? this.title,
      imagePath: imagePath ?? this.imagePath,
      type: type ?? this.type,
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      hasUnreadMessages: hasUnreadMessages ?? this.hasUnreadMessages,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        imagePath,
        type,
        participants,
        lastMessage,
        hasUnreadMessages,
      ];
}

class ChatMessagesModel extends Equatable {
  const ChatMessagesModel({
    required this.messages,
    required this.totalPages,
    required this.hasNextPage,
  });

  final List<ShortMessageModel> messages;
  final int totalPages;
  final bool hasNextPage;

  @override
  List<Object> get props => [messages, totalPages, hasNextPage];
}
