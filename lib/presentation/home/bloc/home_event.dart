import 'package:dispatch/domain/model/message_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

final class LoadChatListEvent extends HomeEvent {}

final class ScrollDirectionChangedEvent extends HomeEvent {
  const ScrollDirectionChangedEvent(this.direction);

  final ScrollDirection direction;

  @override
  List<Object> get props => [direction];
}

final class GetMessageChatEvent extends HomeEvent {
  const GetMessageChatEvent({required this.message});

  final StandardMessageModel message;

  @override
  List<Object> get props => [message];
}
