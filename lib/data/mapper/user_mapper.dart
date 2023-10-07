import 'package:dispatch/data/database.dart' as database;
import 'package:dispatch/data/dto/user_dto.dart';
import 'package:dispatch/domain/model/user_model.dart';

extension UserTableToUserMapper on database.User {
  UserModel toUserModel() {
    return UserModel(
      email: email,
      name: name,
      isOnline: true,
      lastTimeOnline: DateTime.now(),
      imagePath: imagePath,
    );
  }
}

extension UserTableToAuthenticatedUserModelMapper on database.User {
  AuthenticatedUserModel toAuthenticatedUserModel() {
    return AuthenticatedUserModel(
      user: toUserModel(),
      accessToken: accessToken,
    );
  }
}

extension UserToUserTableMapper on UserModel {
  database.User toDatabaseUser() {
    return database.User(
      email: email,
      name: name,
      imagePath: imagePath,
    );
  }
}

extension AuthenticatedUserModelToUserTableMapper on AuthenticatedUserModel {
  database.User toDatabaseUser() {
    return database.User(
      email: user.email,
      name: user.name,
      imagePath: user.imagePath,
      accessToken: accessToken,
    );
  }
}

extension UserDTOToUserModelMapper on UserDTO {
  UserModel toUserModel() {
    return UserModel(
      email: email,
      name: name,
      isOnline: isOnline,
      lastTimeOnline: DateTime.fromMillisecondsSinceEpoch(lastTimeOnline, isUtc: true),
      imagePath: imagePath,
    );
  }
}

extension UserModelToUserDTOMapper on UserModel {
  UserDTO toUserDTO() {
    return UserDTO(
      email: email,
      name: name,
      isOnline: isOnline,
      lastTimeOnline: lastTimeOnline.millisecondsSinceEpoch,
    );
  }
}

extension AuthenticatedUserDTOToAuthenticatedUserModelMapper on AuthenticatedUserDTO {
  AuthenticatedUserModel toAuthenticatedUserModel() {
    return AuthenticatedUserModel(
      user: user.toUserModel(),
      accessToken: accessToken,
    );
  }
}
