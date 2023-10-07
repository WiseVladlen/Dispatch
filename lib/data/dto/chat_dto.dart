import 'package:dispatch/data/dto/message_dto.dart';
import 'package:dispatch/data/dto/user_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class ChatDTO {
  @JsonKey(name: 'chat_id')
  final String id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'image_path')
  final String? imagePath;

  @JsonKey(name: 'participants')
  final List<UserDTO> participants;

  @JsonKey(name: 'last_message')
  final ShortMessageDTO lastMessage;

  @JsonKey(name: 'has_unread_messages')
  final bool hasUnreadMessages;

  const ChatDTO({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.participants,
    required this.lastMessage,
    required this.hasUnreadMessages,
  });

  factory ChatDTO.fromJson(Map<String, dynamic> json) => _$ChatDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ChatDTOToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ChatMessagesDTO {
  @JsonKey(name: 'messages')
  final List<ShortMessageDTO> messages;

  @JsonKey(name: 'total_pages')
  final int totalPages;

  @JsonKey(name: 'has_next_page')
  final bool hasNextPage;

  ChatMessagesDTO({
    required this.messages,
    required this.totalPages,
    required this.hasNextPage,
  });

  factory ChatMessagesDTO.fromJson(Map<String, dynamic> json) => _$ChatMessagesDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessagesDTOToJson(this);
}
