// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatDTO _$ChatDTOFromJson(Map<String, dynamic> json) => ChatDTO(
      id: json['chat_id'] as String,
      title: json['title'] as String,
      imagePath: json['image_path'] as String?,
      participants: (json['participants'] as List<dynamic>)
          .map((e) => UserDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastMessage: ShortMessageDTO.fromJson(
          json['last_message'] as Map<String, dynamic>),
      hasUnreadMessages: json['has_unread_messages'] as bool,
    );

Map<String, dynamic> _$ChatDTOToJson(ChatDTO instance) => <String, dynamic>{
      'chat_id': instance.id,
      'title': instance.title,
      'image_path': instance.imagePath,
      'participants': instance.participants.map((e) => e.toJson()).toList(),
      'last_message': instance.lastMessage.toJson(),
      'has_unread_messages': instance.hasUnreadMessages,
    };

ChatMessagesDTO _$ChatMessagesDTOFromJson(Map<String, dynamic> json) =>
    ChatMessagesDTO(
      messages: (json['messages'] as List<dynamic>)
          .map((e) => ShortMessageDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPages: json['total_pages'] as int,
      hasNextPage: json['has_next_page'] as bool,
    );

Map<String, dynamic> _$ChatMessagesDTOToJson(ChatMessagesDTO instance) =>
    <String, dynamic>{
      'messages': instance.messages.map((e) => e.toJson()).toList(),
      'total_pages': instance.totalPages,
      'has_next_page': instance.hasNextPage,
    };
