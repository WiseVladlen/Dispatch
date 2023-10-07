// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageContentDTO _$MessageContentDTOFromJson(Map<String, dynamic> json) =>
    MessageContentDTO(
      text: json['text'] as String,
    );

Map<String, dynamic> _$MessageContentDTOToJson(MessageContentDTO instance) =>
    <String, dynamic>{
      'text': instance.text,
    };

ShortMessageDTO _$ShortMessageDTOFromJson(Map<String, dynamic> json) =>
    ShortMessageDTO(
      id: json['message_id'] as String,
      content: MessageContentDTO.fromJson(
          json['message_content'] as Map<String, dynamic>),
      dispatchTime: json['dispatch_time'] as int,
      status: $enumDecode(_$MessageStatusDTOEnumMap, json['status']),
      sender: UserDTO.fromJson(json['sender'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShortMessageDTOToJson(ShortMessageDTO instance) =>
    <String, dynamic>{
      'message_id': instance.id,
      'message_content': instance.content.toJson(),
      'dispatch_time': instance.dispatchTime,
      'status': _$MessageStatusDTOEnumMap[instance.status]!,
      'sender': instance.sender.toJson(),
    };

const _$MessageStatusDTOEnumMap = {
  MessageStatusDTO.delivered: 'DELIVERED',
  MessageStatusDTO.read: 'READ',
};

StandardMessageDTO _$StandardMessageDTOFromJson(Map<String, dynamic> json) =>
    StandardMessageDTO(
      id: json['message_id'] as String,
      content: MessageContentDTO.fromJson(
          json['message_content'] as Map<String, dynamic>),
      dispatchTime: json['dispatch_time'] as int,
      status: $enumDecode(_$MessageStatusDTOEnumMap, json['status']),
      sender: UserDTO.fromJson(json['sender'] as Map<String, dynamic>),
      chatId: json['chat_id'] as String,
    );

Map<String, dynamic> _$StandardMessageDTOToJson(StandardMessageDTO instance) =>
    <String, dynamic>{
      'message_id': instance.id,
      'message_content': instance.content.toJson(),
      'dispatch_time': instance.dispatchTime,
      'status': _$MessageStatusDTOEnumMap[instance.status]!,
      'sender': instance.sender.toJson(),
      'chat_id': instance.chatId,
    };

SendMessageRequestDTO _$SendMessageRequestDTOFromJson(
        Map<String, dynamic> json) =>
    SendMessageRequestDTO(
      chatId: json['chat_id'] as String,
      content: MessageContentDTO.fromJson(
          json['message_content'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SendMessageRequestDTOToJson(
        SendMessageRequestDTO instance) =>
    <String, dynamic>{
      'chat_id': instance.chatId,
      'message_content': instance.content.toJson(),
    };
