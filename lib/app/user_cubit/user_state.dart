import 'package:dispatch/domain/model/user_model.dart';
import 'package:equatable/equatable.dart';

class UserState extends Equatable {
  const UserState({required this.user});

  final UserModel user;

  UserState copyWith({UserModel? user}) => UserState(user: user ?? this.user);

  @override
  List<Object> get props => [user];
}
