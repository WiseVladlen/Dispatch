import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:dispatch/utils/http_utils.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';

class StompService {
  static const scheme = 'http';
  static const host = '172.30.54.112';
  static const port = 8080;
  static const path = 'web-socket';

  StompService({
    required this.onConnect,
    required this.onDisconnect,
  });

  final VoidCallback onConnect;
  final VoidCallback onDisconnect;

  StompClient? _client;

  StompClient get client => _client ??= _buildClient();

  StompClient _buildClient() {
    return StompClient(
      config: StompConfig.sockJS(
        url: Uri(scheme: scheme, host: host, port: port, path: path).toString(),
        stompConnectHeaders: HttpHeaders.build(contentType: Headers.jsonContentType),
        //onConnect: (_) => onConnect(),
        //onDisconnect: (_) => onDisconnect(),
        onConnect: (frame) {
          print('A stomp on connect :: ${frame.toString()}');
          onConnect();
        },
        onDisconnect: (frame) {
          print('A stomp on disconnect :: ${frame.toString()}');
          onDisconnect();
        },
        onStompError: (frame) {
          print('A stomp error occurred in web socket connection :: ${frame.toString()}');
        },
        onWebSocketError: (dynamic frame) {
          print('A Web socket error occurred in web socket connection :: ${frame.toString()}');
        },
        onWebSocketDone: () {
          print('WebSocket - onWebSocketDone executed!');
        },
        onUnhandledFrame: (frame) {
          print('WebSocket - onUnhandledFrame executed! ${frame.toString()}');
        },
        onUnhandledMessage: (frame) {
          print('WebSocket - onUnhandledMessage executed! ${frame.toString()}');
        },
        onUnhandledReceipt: (frame) {
          print('WebSocket - onUnhandledReceipt executed! ${frame.toString()}');
        },
      ),
    );
  }

  void activate() => client.activate();

  void deactivate() => client.deactivate();
}
