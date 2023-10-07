import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class UserDTO {
  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'is_online')
  final bool isOnline;

  @JsonKey(name: 'last_time_online')
  final int lastTimeOnline;

  @JsonKey(name: 'image_path')
  final String? imagePath;

  const UserDTO({
    required this.email,
    required this.name,
    required this.isOnline,
    required this.lastTimeOnline,
    this.imagePath,
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) => _$UserDTOFromJson(json);

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
