import 'package:dispatch/app/widget/circle_image.dart';
import 'package:dispatch/domain/model/chat_model.dart';
import 'package:dispatch/domain/model/user_model.dart';
import 'package:dispatch/presentation/chat/chat_page.dart';
import 'package:dispatch/presentation/chat/view_model/chat_view_model.dart';
import 'package:dispatch/utils/date_utils.dart';
import 'package:dispatch/utils/text_style.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  const UserTile({
    super.key,
    required this.user,
    required this.isFirstEntryByAlphabetLetter,
    required this.chatByEmailOrNull,
  });

  final UserModel user;
  final bool isFirstEntryByAlphabetLetter;
  final ChatModel? Function(String) chatByEmailOrNull;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        children: [
          if (isFirstEntryByAlphabetLetter)
            Positioned(
              left: 8,
              top: 16,
              child: Text(
                user.name[0].toUpperCase(),
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(left: 56),
            child: CircleNetworkImage(
              imagePath: user.imagePath ?? '',
              radius: 28,
              errorWidget: () => Text(
                user.name[0].toUpperCase(),
                style: TextStyles.displayLargeLight,
              ),
              placeholderColor: Colors.green,
            ),
          ),
        ],
      ),
      title: Text(
        user.name,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      subtitle: Text(user.lastTimeOnline.toLastOnlineTime()),
      onTap: () {
        Navigator.of(context).pushReplacementNamed(
          ChatPage.path,
          arguments: ChatArguments(
            ChatViewModel.fromModels(chatByEmailOrNull(user.email), user),
          ),
        );
      },
    );
  }
}
