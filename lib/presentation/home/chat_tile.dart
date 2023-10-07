import 'package:dispatch/app/user_cubit/user_cubit.dart';
import 'package:dispatch/app/widget/circle_image.dart';
import 'package:dispatch/domain/model/chat_model.dart';
import 'package:dispatch/domain/model/message_model.dart';
import 'package:dispatch/presentation/chat/chat_page.dart';
import 'package:dispatch/presentation/chat/view_model/chat_view_model.dart';
import 'package:dispatch/utils/date_utils.dart';
import 'package:dispatch/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({super.key, required this.chat});

  final ChatModel chat;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleNetworkImage(
        imagePath: chat.imagePath ?? '',
        radius: 28,
        errorWidget: () => Text(
          chat.lastMessage.sender.name[0].toUpperCase(),
          style: TextStyles.displayLargeLight,
        ),
        placeholderColor: Colors.green,
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              chat.lastMessage.sender.name,
              style: Theme.of(context).textTheme.titleLarge,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 72,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 20),
                if (chat.lastMessage.sender.email == context.read<UserCubit>().state.user.email)
                  switch (chat.lastMessage.status) {
                    MessageStatus.sent => const Icon(Icons.access_time, size: 14),
                    MessageStatus.delivered => const Icon(
                        Icons.done,
                        size: 14,
                        color: Colors.blue,
                      ),
                    MessageStatus.read => const Icon(
                        Icons.done_all,
                        size: 14,
                        color: Colors.blue,
                      ),
                  },
                Text(
                  chat.lastMessage.dispatchTime.toLastOnlineTime(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
      isThreeLine: true,
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                chat.lastMessage.content.text,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            if (chat.hasUnreadMessages)
              Container(
                height: 24,
                constraints: const BoxConstraints(minWidth: 24),
                margin: const EdgeInsets.only(left: 4),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(24),
                  ),
                ),
                alignment: Alignment.center,
                child: const Text('!', style: TextStyles.unreadMessageCountIndicator),
              ),
          ],
        ),
      ),
      onTap: () => Navigator.of(context).pushNamed(
        ChatPage.path,
        arguments: ChatArguments(ChatViewModel.fromChatModel(chat)),
      ),
    );
  }
}
