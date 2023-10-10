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
import 'package:dispatch/utils/object_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:uuid/uuid.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final _queueMessageIdToRead = <String>{};

  final uuid = const Uuid();

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

    messageRepository.subscribeMessageStream(sender.email);

    _messageStreamSubscription = messageRepository.messageStream.listen((message) {
      add(GetMessageEvent(message));
    });
  }

  String? chatId;
  String? email;

  final UserModel sender;

  final IChatRepository chatRepository;
  final IMessageRepository messageRepository;

  Future<void> _loadMessageList(LoadMessageListEvent event, Emitter<ChatState> emit) async {
    await chatId.safeLet((it) async {
      final chatMessages = await messageRepository.getChatMessages(it, page: 0, pageSize: 100);
      emit(state.copyWith(messages: chatMessages.messages));
    });
  }

  Future<void> _sendTypedMessage(SendTypedMessageEvent event, Emitter<ChatState> emit) async {
    final message = ShortMessageModel(
      id: uuid.v1(),
      content: MessageContent(text: state.typedMessage.value.trim()),
      dispatchTime: DateTime.now(),
      status: MessageStatus.sent,
      sender: sender,
    );

    emit(state.copyWith(
      typedMessage: const Message.pure(),
      isValid: false,
      textFieldIsCleared: true,
      messages: [message, ...?state.messages],
    ));

    Future.microtask(() async {
      switch ((chatId, email)) {
        case (String? chatId, String email):
          messageRepository.sendMessage(
            SendMessageRequestModel(
              chatId: chatId ??= await chatRepository.createChat(participants: [email]),
              messageContent: message.content.text,
            ),
          );
        case (String chatId, String? _):
          messageRepository.sendMessage(
            SendMessageRequestModel(chatId: chatId, messageContent: message.content.text),
          );
      }
    });
  }

  void _editTypedMessage(EditTypedMessage event, Emitter<ChatState> emit) {
    Message.dirty(event.text).let((it) {
      emit(state.copyWith(
        typedMessage: it,
        isValid: Formz.validate([it]),
      ));
    });
  }

  void _queueMessageForReading(QueueMessageForReading event, Emitter<ChatState> emit) {
    _queueMessageIdToRead.add(event.id);
  }

  void _readMessages(ReadMessages event, Emitter<ChatState> emit) async {
    await messageRepository.readMessages(_queueMessageIdToRead.toList());

    final messages = (state.messages ?? [])
        .mapWhere(
          (message) => _queueMessageIdToRead.contains(message.id),
          toElement: (e) => e.copyWith(status: MessageStatus.read),
        )
        .toList();

    _queueMessageIdToRead.clear();

    emit(state.copyWith(messages: messages));
  }

  void _getMessage(GetMessageEvent event, Emitter<ChatState> emit) {
    final messages = state.messages ?? [];

    final (index, message) = messages.firstIndexedWhere(
      (e) {
        return e.status.isSent &&
            (e.sender.email == sender.email) &&
            (e.content == event.message.content);
      },
      orElse: () => (-1, null),
    );

    if (message != null) {
      emit(state.copyWith(
        messages: List.of(messages)..[index] = message.copyWith(status: event.message.status),
      ));
    } else {
      emit(state.copyWith(
        messages: [event.message, ...messages],
      ));
    }
  }

  @override
  Future<void> close() {
    _messageStreamSubscription.cancel();
    return super.close();
  }
}
