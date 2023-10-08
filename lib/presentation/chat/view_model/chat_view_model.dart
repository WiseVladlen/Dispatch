import 'package:dispatch/domain/model/chat_model.dart';
import 'package:dispatch/domain/model/user_model.dart';
import 'package:dispatch/utils/date_utils.dart';

class ChatViewModel {
  const ChatViewModel({
    this.id,
    this.email,
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  final String? id;
  final String? email;
  final String title;
  final String subtitle;
  final String? imagePath;

  static ChatViewModel fromUserModel(UserModel model) {
    return ChatViewModel(
      email: model.email,
      title: model.name,
      subtitle: model.lastTimeOnline.toLastOnlineTime(),
      imagePath: model.imagePath,
    );
  }

  static ChatViewModel fromChatModel(ChatModel model) {
    return ChatViewModel(
      id: model.id,
      title: model.title,
      subtitle: model.participants.first.lastTimeOnline.toLastOnlineTime(),
      imagePath: model.imagePath,
    );
  }

  static ChatViewModel fromModels(ChatModel? chat, UserModel user) {
    return chat != null ? fromChatModel(chat) : fromUserModel(user);
  }
}
