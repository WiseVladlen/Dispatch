import 'package:dispatch/data/remote_data_source/message_remote_data_source.dart';
import 'package:dispatch/domain/model/chat_model.dart';
import 'package:dispatch/domain/model/message_model.dart';
import 'package:dispatch/domain/repository/message_repository.dart';

class MessageRepository implements IMessageRepository {
  const MessageRepository({required this.remoteDataSource});

  final MessageRemoteDataSource remoteDataSource;

  @override
  Stream<StandardMessageModel> get messageStream => remoteDataSource.messageStream;

  @override
  void sendMessage(SendMessageRequestModel messageRequestModel) {
    remoteDataSource.sendMessage(messageRequestModel: messageRequestModel);
  }

  @override
  Future<ChatMessagesModel> getChatMessages(
    String chatId, {
    int page = 0,
    int pageSize = 0,
  }) async {
    return remoteDataSource.getChatMessages(chatId, page: page, pageSize: pageSize);
  }

  @override
  Future<void> readMessages(List<String> messageIds) async {
    return remoteDataSource.readMessages(messageIds: messageIds);
  }
}
