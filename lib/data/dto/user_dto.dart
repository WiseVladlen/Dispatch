import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class ShortUserDTO {
  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'image_path')
  final String? imagePath;

  const ShortUserDTO({
    required this.email,
    required this.name,
    this.imagePath,
  });

  factory ShortUserDTO.fromJson(Map<String, dynamic> json) => _$ShortUserDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ShortUserDTOToJson(this);
}

@JsonSerializable()
class UserDTO extends ShortUserDTO {
  @JsonKey(name: 'is_online')
  final bool isOnline;

  @JsonKey(name: 'last_time_online')
  final int lastTimeOnline;

  const UserDTO({
    required super.email,
    required super.name,
    required this.isOnline,
    required this.lastTimeOnline,
    super.imagePath,
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) => _$UserDTOFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserDTOToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AuthenticatedUserDTO {
  @JsonKey(name: 'user')
  final UserDTO user;

  @JsonKey(name: 'token')
  final String accessToken;

  const AuthenticatedUserDTO({
    required this.user,
    required this.accessToken,
  });

  factory AuthenticatedUserDTO.fromJson(Map<String, dynamic> json) =>
      _$AuthenticatedUserDTOFromJson(json);

  Map<String, dynamic> toJson() => _$AuthenticatedUserDTOToJson(this);
}
