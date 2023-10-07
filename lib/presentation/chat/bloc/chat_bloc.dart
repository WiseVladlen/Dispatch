import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dispatch/domain/model/message_model.dart';
import 'package:dispatch/domain/model/user_model.dart';
import 'package:dispatch/domain/repository/chat_repository.dart';
import 'package:dispatch/domain/repository/message_repository.dart';
import 'package:dispatch/presentation/chat/bloc/chat_event.dart';
import 'package:dispatch/presentation/chat/bloc/chat_state.dart';
import 'package:dispatch/utils/form/message.dart';
import 'package:dispatch/utils/list_utils.dart';
import 'package:dispatch/utils/message_list_utils.dart';
import 'package:dispatch/utils/object_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:uuid/uuid.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final _queueMessageIdToRead = <String>{};

  late final StreamSubscription<StandardMessageModel> _messageStreamSubscription;

  ChatBloc({
    required this.chatId,
    required this.email,
    required this.sender,
    required this.chatRepository,
    required this.messageRepository,
  }) : super(ChatState(messages: email != null ? [] : null)) {
    on<LoadMessageListEvent>(_loadMessageList);
    on<EditTypedMessage>(_editTypedMessage);
    on<SendTypedMessageEvent>(_sendTypedMessage);
    on<QueueMessageForReading>(_queueMessageForReading);
    on<ReadMessages>(_readMessages, transformer: droppable());
    on<GetMessageEvent>(_getMessage);

    chatId.safeLet((it) => add(LoadMessageListEvent(it)));

    _messageStreamSubscription = messageRepository.messageStream.listen((message) {
      add(GetMessageEvent(message));
    });
  }

  String? chatId;
  String? email;

  final UserModel sender;

  final IChatRepository chatRepository;
  final IMessageRepository messageRepository;

  void _loadMessageList(LoadMessageListEvent event, Emitter<ChatState> emit) async {
    chatId.safeLet((it) async {
      emit(state.copyWith(
        messages: await messageRepository.getMessages(
          it,
          page: 0,
          pageSize: 100,
        ),
      ));
    });
  }

  void _sendTypedMessage(SendTypedMessageEvent event, Emitter<ChatState> emit) {
    final message = ShortMessageModel(
      id: const Uuid().v1(),
      content: MessageContent(text: state.typedMessage.value.trim()),
      dispatchTime: DateTime.now(),
      status: MessageStatus.sent,
      sender: sender,
    );

    Future.microtask(() {
      email.safeLet((it) async {
        messageRepository.sendMessage(
          SendMessageRequestModel(
            chatId: chatId ??= await chatRepository.createChat(participants: [it]),
            content: message.content,
          ),
        );
      });
    });

    emit(state.copyWith(
      isValid: false,
      changeMessage: true,
      messages: (state.messages ?? [])..add(message),
      //messages: List.of(state.messages ?? [])..add(message),
    ));
  }

  void _editTypedMessage(EditTypedMessage event, Emitter<ChatState> emit) {
    Message.dirty(event.text).let((it) {
      emit(state.copyWith(
        typedMessage: it,
        changeMessage: true,
        isValid: Formz.validate([it]),
      ));
    });
  }

  void _queueMessageForReading(QueueMessageForReading event, Emitter<ChatState> emit) {
    _queueMessageIdToRead.add(event.id);
  }

  void _readMessages(ReadMessages event, Emitter<ChatState> emit) async {
    await messageRepository.readMessages(_queueMessageIdToRead.toList());

    emit(state.copyWith(
      messages: state.messages?.mapWhere(
        (message) => _queueMessageIdToRead.contains(message.id),
        toElement: (e) => e.copyWith(status: MessageStatus.read),
      ),
    ));

    _queueMessageIdToRead.clear();
  }

  void _getMessage(GetMessageEvent event, Emitter<ChatState> emit) {
    emit(state.copyWith(
      messages: state.messages?.mapFirstSentMessage(
        email: sender.email,
        content: event.message.content,
        toElement: (e) => e.copyWith(status: event.message.status),
        orElse: (list) => list..add(event.message),
      ),
    ));
  }

  @override
  Future<void> close() {
    _messageStreamSubscription.cancel();
    return super.close();
  }
}
