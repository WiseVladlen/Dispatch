import 'package:dispatch/data/remote_data_source/chat_remote_data_source.dart';
import 'package:dispatch/domain/model/chat_model.dart';
import 'package:dispatch/domain/repository/chat_repository.dart';

class ChatRepository implements IChatRepository {
  const ChatRepository({required this.remoteDataSource});

  final ChatRemoteDataSource remoteDataSource;

  @override
  Future<String> createChat({required List<String> participants}) async {
    return await remoteDataSource.createChat(participants: participants);
  }

  @override
  Future<ChatModel> getChat({required String id}) async {
    return await remoteDataSource.getChat(id: id);
  }

  @override
  Future<List<ChatModel>> get chats => remoteDataSource.getChats();
}
