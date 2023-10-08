// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShortUserDTO _$ShortUserDTOFromJson(Map<String, dynamic> json) => ShortUserDTO(
      email: json['email'] as String,
      name: json['name'] as String,
      imagePath: json['image_path'] as String?,
    );

Map<String, dynamic> _$ShortUserDTOToJson(ShortUserDTO instance) =>
    <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'image_path': instance.imagePath,
    };

UserDTO _$UserDTOFromJson(Map<String, dynamic> json) => UserDTO(
      email: json['email'] as String,
      name: json['name'] as String,
      isOnline: json['is_online'] as bool,
      lastTimeOnline: json['last_time_online'] as int,
      imagePath: json['image_path'] as String?,
    );

Map<String, dynamic> _$UserDTOToJson(UserDTO instance) => <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'image_path': instance.imagePath,
      'is_online': instance.isOnline,
      'last_time_online': instance.lastTimeOnline,
    };

AuthenticatedUserDTO _$AuthenticatedUserDTOFromJson(
        Map<String, dynamic> json) =>
    AuthenticatedUserDTO(
      user: UserDTO.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['token'] as String,
    );

Map<String, dynamic> _$AuthenticatedUserDTOToJson(
        AuthenticatedUserDTO instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
      'token': instance.accessToken,
    };
