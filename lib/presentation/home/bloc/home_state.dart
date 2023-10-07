import 'package:dispatch/domain/model/chat_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';

class HomeState extends Equatable {
  final List<ChatModel>? chats;
  final ScrollDirection direction;

  const HomeState({
    this.chats,
    this.direction = ScrollDirection.idle,
  });

  HomeState copyWith({
    List<ChatModel>? chats,
    ScrollDirection? direction,
  }) {
    return HomeState(
      chats: chats ?? this.chats,
      direction: direction ?? this.direction,
    );
  }

  @override
  List<Object?> get props => [chats, direction];
}
