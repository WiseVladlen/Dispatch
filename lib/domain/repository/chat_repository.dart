import 'package:dispatch/domain/model/chat_model.dart';

abstract interface class IChatRepository {
  abstract final Future<List<ChatModel>> chats;

  Future<String> createChat({required List<String> participants});
  Future<ChatModel> getChat({required String id});
}
