import 'package:dispatch/data/dto/chat_dto.dart';
import 'package:dispatch/data/mapper/message_mapper.dart';
import 'package:dispatch/data/mapper/user_mapper.dart';
import 'package:dispatch/domain/model/chat_model.dart';

extension ChatDTOToChatModelMapper on ChatDTO {
  ChatModel toChatModel() {
    return ChatModel(
      id: id,
      name: name,
      imagePath: imagePath,
      type: ChatType.oneOnOne,
      participants: participants.map((e) => e.toUserModel()).toList(),
      lastMessage: lastMessage.toShortMessageModel(),
      hasUnreadMessages: hasUnreadMessages,
    );
  }
}

extension ChatMessagesDTOToChatMessagesModel on ChatMessagesDTO {
  ChatMessagesModel toChatMessagesModel() {
    return ChatMessagesModel(
      messages: messages.map((e) => e.toShortMessageModel()).toList(),
      totalPages: totalPages,
      hasNextPage: hasNextPage,
    );
  }
}
