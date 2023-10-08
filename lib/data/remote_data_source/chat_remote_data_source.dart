import 'package:dispatch/data/dto/chat_dto.dart';
import 'package:dispatch/data/http_service/dio_service.dart';
import 'package:dispatch/data/mapper/chat_mapper.dart';
import 'package:dispatch/domain/model/chat_model.dart';

class ChatRemoteDataSource {
  /// Creates a chat according to the [participants] - email of participants.
  ///
  /// Returns the id of the created chat.
  Future<String> createChat({required List<String> participants}) async {
    final uri = DioService.buildUri(path: 'chats/create');
    await DioService.cookieJar.loadForRequest(uri);
    final response = await DioService.dio.setHeaders().postUri(
      uri,
      data: {'participants': participants},
    );
    return response.data.toString();
  }

  /// Returns char according to the [id] parameter.
  Future<ChatModel> getChat({required String id}) async {
    final uri = DioService.buildUri(path: 'chats/$id');
    await DioService.cookieJar.loadForRequest(uri);
    final response = await DioService.dio.setHeaders().getUri(uri);
    return ChatDTO.fromJson(response.data as Map<String, dynamic>).toChatModel();
  }

  /// Returns the list of chats of the current user.
  Future<List<ChatModel>> getChats() async {
    final uri = DioService.buildUri(path: 'chats');
    await DioService.cookieJar.loadForRequest(uri);
    final response = await DioService.dio.setHeaders().getUri(uri);
    return (response.data as List<dynamic>)
        .map((e) => ChatDTO.fromJson(e as Map<String, dynamic>).toChatModel())
        .toList();
  }
}
