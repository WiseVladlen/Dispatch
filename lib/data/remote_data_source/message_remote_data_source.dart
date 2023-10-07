import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dispatch/data/dto/message_dto.dart';
import 'package:dispatch/data/http_service/dio_service.dart';
import 'package:dispatch/data/http_service/stomp_service.dart';
import 'package:dispatch/data/mapper/message_mapper.dart';
import 'package:dispatch/domain/model/message_model.dart';
import 'package:dispatch/utils/object_utils.dart';

class MessageRemoteDataSource {
  final _messageStreamController = StreamController<StandardMessageModel>.broadcast();

  MessageRemoteDataSource({required this.stompService});

  final StompService stompService;

  /// Updates the status of messages
  /// whose ID is in the [messageIds] list to the value [MessageStatus.read].
  Future<void> readMessages({required List<String> messageIds}) async {
    final uri = DioService.buildUri(path: 'chats/read-messages');
    await DioService.cookieJar.loadForRequest(uri);
    await DioService.dio.setHeaders().postUri(uri, data: messageIds);
  }

  /// Returns chat messages according to [chatId] parameter.
  ///
  /// The [page] parameter defines the current data page,
  /// and [pageSize] determines the size of the requested page.
  Future<List<ShortMessageModel>> getMessages(
    String chatId, {
    int page = 0,
    int pageSize = 0,
  }) async {
    final queryParameters = <String, int>{
      'page': page,
      'page-size': pageSize,
    };
    final uri = DioService.buildUri(
      path: 'chats/$chatId/messages',
      queryParameters: queryParameters,
    );

    await DioService.cookieJar.loadForRequest(uri);
    final response = await DioService.dio.setHeaders().getUri(uri);
    return (response.data as List<dynamic>)
        .map((e) => ShortMessageDTO.fromJson(e).toShortMessageModel())
        .toList();
  }

  /// Sends the [content] message to the user's current chat according to the [chatId] parameter.
  void sendMessage({required SendMessageRequestModel messageRequestModel}) {
    stompService.client.send(
      headers: {Headers.contentTypeHeader: Headers.jsonContentType},
      destination: '/chats/send',
      body: jsonEncode(messageRequestModel.toSendMessageRequestDTO().toJson()),
    );
  }

  /// Creates a subscription to the user's message stream according to the [email] parameter.
  void subscribeMessageStream(String email) {
    stompService.client.subscribe(
      headers: {Headers.contentTypeHeader: Headers.jsonContentType},
      destination: '/users/$email/messages',
      callback: (frame) {
        frame.body.safeLet((body) {
          _messageStreamController.sink.add(
            StandardMessageDTO.fromJson(jsonDecode(body)).toStandardMessageModel(),
          );
        });
      },
    );
  }

  /// Returns the user's message stream.
  Stream<StandardMessageModel> get messageStream => _messageStreamController.stream;
}
