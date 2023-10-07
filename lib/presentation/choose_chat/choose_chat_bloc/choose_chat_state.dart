import 'package:dispatch/domain/model/user_model.dart';
import 'package:equatable/equatable.dart';

class ChooseChatState extends Equatable {
  final String? searchQuery;
  final Future<List<UserModel>>? users;

  const ChooseChatState({this.searchQuery, this.users});

  ChooseChatState copyWith({
    String? searchQuery,
    Future<List<UserModel>>? users,
  }) {
    return ChooseChatState(
      searchQuery: searchQuery ?? this.searchQuery,
      users: users,
    );
  }

  @override
  List<Object?> get props => [searchQuery, users];
}
