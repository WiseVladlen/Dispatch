import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.email,
    required this.name,
    required this.isOnline,
    required this.lastTimeOnline,
    this.imagePath,
  });

  final String email;
  final String name;
  final bool isOnline;
  final DateTime lastTimeOnline;
  final String? imagePath;

  UserModel copyWith({
    String? email,
    String? password,
    String? name,
    bool? isOnline,
    DateTime? lastTimeOnline,
    String? imagePath,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      isOnline: isOnline ?? this.isOnline,
      lastTimeOnline: lastTimeOnline ?? this.lastTimeOnline,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  List<Object?> get props => [email, name, isOnline, lastTimeOnline, imagePath];
}

final class AuthenticatedUserModel {
  final UserModel user;
  final String? accessToken;

  const AuthenticatedUserModel({
    required this.user,
    this.accessToken,
  });
}

final proxyUser = UserModel(
  email: 'email',
  name: 'name',
  isOnline: true,
  lastTimeOnline: DateTime.now(),
);
