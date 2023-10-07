import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dispatch/domain/model/chat_model.dart';
import 'package:dispatch/domain/model/message_model.dart';
import 'package:dispatch/domain/repository/chat_repository.dart';
import 'package:dispatch/domain/repository/message_repository.dart';
import 'package:dispatch/presentation/home/bloc/home_event.dart';
import 'package:dispatch/presentation/home/bloc/home_state.dart';
import 'package:dispatch/utils/list_utils.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  late final StreamSubscription<StandardMessageModel> _messageStreamSubscription;

  HomeBloc({
    required this.chatRepository,
    required this.messageRepository,
  }) : super(const HomeState()) {
    on<LoadChatListEvent>(_loadChatList);
    on<ScrollDirectionChangedEvent>(_scrollDirectionChanged);
    on<GetMessageChatEvent>(_getMessageChatEvent);

    add(LoadChatListEvent());

    _messageStreamSubscription = messageRepository.messageStream.listen((message) {
      add(GetMessageChatEvent(message: message));
    });
  }

  final IChatRepository chatRepository;
  final IMessageRepository messageRepository;

  void _loadChatList(LoadChatListEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(chats: await chatRepository.chats));
  }

  void _scrollDirectionChanged(ScrollDirectionChangedEvent event, Emitter<HomeState> emit) {
    if (event.direction != ScrollDirection.idle) {
      emit(state.copyWith(direction: event.direction));
    }
  }

  void _getMessageChatEvent(GetMessageChatEvent event, Emitter<HomeState> emit) async {
    final list = state.chats ?? [];
    final (index, chatOrNull) = list.firstIndexedWhere(
      (element) => element.id == event.message.chatId,
      orElse: () => (-1, null),
    );

    if (chatOrNull != null) {
      emit(state.copyWith(
        chats: list..[index].copyWith(lastMessage: event.message),
      ));
    } else {
      final chat = await chatRepository.getChat(id: event.message.chatId);
      emit(state.copyWith(chats: list..add(chat)));
    }
  }

  ChatModel? firstByEmailOrNull(String email) {
    return state.chats?.firstWhereOrNull(
      (chat) => chat.type.isOneOnOne && chat.participants.first.email == email,
    );
  }

  @override
  Future<void> close() {
    _messageStreamSubscription.cancel();
    return super.close();
  }
}
