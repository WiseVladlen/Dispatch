import 'package:dispatch/data/dto/user_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message_dto.g.dart';

enum MessageStatusDTO {
  @JsonValue('DELIVERED')
  delivered,
  @JsonValue('READ')
  read;

  bool get isRead => this == read;
}

@JsonSerializable()
class MessageContentDTO {
  @JsonKey(name: 'text')
  final String text;

  const MessageContentDTO({required this.text});

  factory MessageContentDTO.fromJson(Map<String, dynamic> json) =>
      _$MessageContentDTOFromJson(json);

  Map<String, dynamic> toJson() => _$MessageContentDTOToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ShortMessageDTO {
  @JsonKey(name: 'message_id')
  final String id;

  @JsonKey(name: 'message_content')
  final MessageContentDTO content;

  @JsonKey(name: 'dispatch_time')
  final int dispatchTime;

  @JsonKey(name: 'status')
  final MessageStatusDTO status;

  @JsonKey(name: 'sender')
  final ShortUserDTO sender;

  const ShortMessageDTO({
    required this.id,
    required this.content,
    required this.dispatchTime,
    required this.status,
    required this.sender,
  });

  factory ShortMessageDTO.fromJson(Map<String, dynamic> json) => _$ShortMessageDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ShortMessageDTOToJson(this);
}

@JsonSerializable(explicitToJson: true)
class StandardMessageDTO extends ShortMessageDTO {
  @JsonKey(name: 'chat_id')
  final String chatId;

  const StandardMessageDTO({
    required super.id,
    required super.content,
    required super.dispatchTime,
    required super.status,
    required super.sender,
    required this.chatId,
  });

  factory StandardMessageDTO.fromJson(Map<String, dynamic> json) =>
      _$StandardMessageDTOFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StandardMessageDTOToJson(this);
}

final class SendMessageRequestDTO {
  final String chatId;
  final String messageContent;

  const SendMessageRequestDTO({
    required this.chatId,
    required this.messageContent,
  });
}
