import 'package:dispatch/app/user_cubit/user_cubit.dart';
import 'package:dispatch/app/widget/circle_image.dart';
import 'package:dispatch/domain/repository/chat_repository.dart';
import 'package:dispatch/domain/repository/message_repository.dart';
import 'package:dispatch/presentation/chat/bloc/chat_bloc.dart';
import 'package:dispatch/presentation/chat/bloc/chat_event.dart';
import 'package:dispatch/presentation/chat/bloc/chat_state.dart';
import 'package:dispatch/presentation/chat/message_tile.dart';
import 'package:dispatch/presentation/chat/view_model/chat_view_model.dart';
import 'package:dispatch/utils/date_utils.dart';
import 'package:dispatch/utils/delayed_action.dart';
import 'package:dispatch/utils/message_utils.dart';
import 'package:dispatch/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ChatArguments {
  const ChatArguments(this.chat);

  final ChatViewModel chat;
}

class ChatPage extends StatelessWidget {
  const ChatPage({super.key, required this.args});

  final ChatArguments args;

  static const path = '/chat';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatBloc(
        chatId: args.chat.id,
        email: args.chat.email,
        sender: context.read<UserCubit>().state.user,
        chatRepository: context.read<IChatRepository>(),
        messageRepository: context.read<IMessageRepository>(),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          titleSpacing: 0,
          title: ListTile(
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 12,
            leading: CircleNetworkImage(
              imagePath: args.chat.imagePath ?? '',
              radius: 20,
              errorWidget: () => Text(
                args.chat.title[0].toUpperCase(),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              placeholderColor: Theme.of(context).cardColor,
            ),
            title: Text(
              args.chat.title,
              style: TextStyles.titleLarge,
            ),
            subtitle: Text(
              args.chat.subtitle,
              style: TextStyles.titleMedium,
            ),
            splashColor: Colors.transparent,
          ),
        ),
        body: const SafeArea(
          child: _ChatPageBody(),
        ),
      ),
    );
  }
}

@immutable
class _ChatPageBody extends StatefulWidget {
  const _ChatPageBody();

  @override
  State<_ChatPageBody> createState() => _ChatPageBodyState();
}

class _ChatPageBodyState extends State<_ChatPageBody> with SingleTickerProviderStateMixin {
  late final _itemScrollController = ItemScrollController();

  late final AnimationController _animationController = AnimationController(
    duration: const Duration(milliseconds: 250),
    vsync: this,
  );

  late final Animation<double> _opacityAnimation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.linear,
  );

  @override
  Widget build(BuildContext context) {
    String? initialUnreadMessageId;

    return Column(
      children: [
        Expanded(
          child: BlocBuilder<ChatBloc, ChatState>(
            buildWhen: (oldState, newState) => (oldState.messages != newState.messages),
            builder: (context, state) {
              final messages = state.messages;
              final user = context.read<UserCubit>().state.user;

              if (messages == null) return const Center(child: CircularProgressIndicator());

              if (messages.isEmpty) return const Center(child: Text('No messages here yet'));

              _animationController.forward();

              SchedulerBinding.instance.addPostFrameCallback((_) {
                final (index, message) = messages.firstIndexedUnreadMessage(
                  email: user.email,
                  orElse: () => (-1, null),
                );

                if (message == null) {
                  initialUnreadMessageId = null;
                  scrollTo(0, alignment: 0);
                  return;
                }

                initialUnreadMessageId = message.id;

                scrollTo(index - 1);
              });

              return FadeTransition(
                opacity: _opacityAnimation,
                child: ScrollablePositionedList.separated(
                  itemCount: messages.length + 1,
                  itemBuilder: (context, index) {
                    if (index == messages.length) return const SizedBox.shrink();

                    final message = messages[index];

                    Widget buildMessageTile({Key? key, required bool isSentByMe}) {
                      return MessageTile(
                        key: key,
                        message: message,
                        isSentByMe: isSentByMe,
                      );
                    }

                    if (message.sender.email != user.email && message.status.isDelivered) {
                      return VisibilityDetector(
                        key: ValueKey(message.id),
                        child: buildMessageTile(isSentByMe: false),
                        onVisibilityChanged: (info) {
                          if (info.visibleFraction == 1) {
                            context.read<ChatBloc>().add(QueueMessageForReading(message.id));

                            DelayedAction.run(() {
                              context.read<ChatBloc>().add(ReadMessages());
                            });
                          }
                        },
                      );
                    }

                    return buildMessageTile(
                      key: ValueKey(message.id),
                      isSentByMe: message.sender.email == user.email,
                    );
                  },
                  separatorBuilder: (context, index) {
                    if (index == messages.length - 1) {
                      return UnconstrainedBox(
                        child: _DateOfYearSeparator(date: messages.last.dispatchTime),
                      );
                    }

                    if (messages[index].id == initialUnreadMessageId) {
                      return const _UnreadMessageSeparator();
                    }

                    late final isDaysEqual = messages[index + 1].dayEquals(messages[index]);

                    if (index != messages.length - 1 && !isDaysEqual) {
                      return UnconstrainedBox(
                        child: _DateOfYearSeparator(date: messages[index].dispatchTime),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                  reverse: true,
                  itemScrollController: _itemScrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
              );
            },
          ),
        ),
        PhysicalModel(
          color: Theme.of(context).colorScheme.surface,
          elevation: 8,
          child: const _MessageInput(),
        ),
      ],
    );
  }

  Future<void> scrollTo(int index, {double alignment = 0.5}) async {
    _itemScrollController.jumpTo(index: index, alignment: alignment);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class _UnreadMessageSeparator extends StatelessWidget {
  const _UnreadMessageSeparator();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.75),
      width: double.maxFinite,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 8),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: const Text(
        'Unread messages',
        style: TextStyles.unreadMessageTitle,
      ),
    );
  }
}

@immutable
class _DateOfYearSeparator extends StatelessWidget {
  const _DateOfYearSeparator({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue[300],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        date.toDateOfYear(),
        style: TextStyles.dateOfYearTitle,
      ),
    );
  }
}

class _MessageInput extends StatelessWidget {
  const _MessageInput();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const IconButton(icon: Icon(Icons.lock), onPressed: null),
        Expanded(
          child: BlocBuilder<ChatBloc, ChatState>(
            buildWhen: (oldState, newState) => newState.textFieldIsCleared,
            builder: (context, state) {
              return TextField(
                key: const Key('chatPage_messageInput_textFiled'),
                controller: TextEditingController()..text = state.typedMessage.value,
                onChanged: (value) => context.read<ChatBloc>().add(EditTypedMessage(value)),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Message',
                ),
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 7,
              );
            },
          ),
        ),
        BlocBuilder<ChatBloc, ChatState>(
          buildWhen: (oldState, newState) => (oldState.isValid != newState.isValid),
          builder: (context, state) {
            return IconButton(
              icon: const Icon(Icons.send),
              onPressed: state.isValid
                  ? () => context.read<ChatBloc>().add(SendTypedMessageEvent())
                  : null,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            );
          },
        ),
      ],
    );
  }
}
