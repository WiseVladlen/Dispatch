import 'package:dispatch/domain/model/message_model.dart';

abstract interface class IMessageRepository {
  abstract final Stream<StandardMessageModel> messageStream;

  void sendMessage(SendMessageRequestModel messageRequestModel);

  Future<List<ShortMessageModel>> getMessages(String chatId, {int page = 0, int pageSize = 0});
  Future<void> readMessages(List<String> messageIds);
}
