import 'package:dispatch/data/dto/message_dto.dart';
import 'package:dispatch/data/mapper/user_mapper.dart';
import 'package:dispatch/domain/model/message_model.dart';
import 'package:dispatch/domain/model/user_model.dart';

extension MessageStatusToMessageStatusDTOMapper on MessageStatus {
  MessageStatusDTO toMessageStatusDTO() {
    return isRead ? MessageStatusDTO.read : MessageStatusDTO.delivered;
  }
}

extension MessageStatusDTOToMessageStatusMapper on MessageStatusDTO {
  MessageStatus toMessageStatus() {
    return isRead ? MessageStatus.read : MessageStatus.delivered;
  }
}

extension MessageContentToMessageContentDTOMapper on MessageContent {
  MessageContentDTO toMessageContentDTO() => MessageContentDTO(text: text);
}

extension MessageContentDTOToMessageContentMapper on MessageContentDTO {
  MessageContent toMessageContent() => MessageContent(text: text);
}

extension MessageDTOToShortMessageModelMapper on ShortMessageDTO {
  ShortMessageModel toShortMessageModel() {
    return ShortMessageModel(
      id: id,
      content: content.toMessageContent(),
      dispatchTime: DateTime.fromMillisecondsSinceEpoch(dispatchTime, isUtc: true),
      status: status.toMessageStatus(),
      sender: sender.toShortUserModel(),
    );
  }
}

extension MessageDTOToStandardMessageModelMapper on StandardMessageDTO {
  StandardMessageModel toStandardMessageModel() {
    return StandardMessageModel(
      id: id,
      content: content.toMessageContent(),
      dispatchTime: DateTime.fromMillisecondsSinceEpoch(dispatchTime, isUtc: true),
      status: status.toMessageStatus(),
      sender: sender.toShortUserModel(),
      chatId: chatId,
    );
  }
}

extension MessageModelToStandardMessageDTOMapper on StandardMessageModel {
  ShortMessageDTO toStandardMessageDTO() {
    return StandardMessageDTO(
      id: id,
      content: content.toMessageContentDTO(),
      dispatchTime: dispatchTime.millisecondsSinceEpoch,
      status: status.toMessageStatusDTO(),
      sender: (sender as UserModel).toUserDTO(),
      chatId: chatId,
    );
  }
}

extension SendMessageRequestModelToSendMessageRequestDTO on SendMessageRequestModel {
  SendMessageRequestDTO toSendMessageRequestDTO() {
    return SendMessageRequestDTO(
      chatId: chatId,
      messageContent: messageContent,
    );
  }
}

extension SendMessageRequestDTOToJson on SendMessageRequestDTO {
  Map<String, dynamic> toJson() => {
        'chat_id': chatId,
        'message_content': messageContent,
      };
}
