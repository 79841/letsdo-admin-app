import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

enum WebSocketConnectionStatus {
  connected,
  connecting,
  disconnected,
}

class ChatroomWebSocketManager extends ChangeNotifier {
  late IOWebSocketChannel _channel;
  IOWebSocketChannel get channel => _channel;
  WebSocketConnectionStatus _connectionStatus =
      WebSocketConnectionStatus.disconnected;

  WebSocketConnectionStatus get connectionStatus => _connectionStatus;

  Future<void> initializeWebSocket(String url) async {
    _connectionStatus = WebSocketConnectionStatus.connecting;
    _channel = IOWebSocketChannel.connect(Uri.parse(url));
    _connectionStatus = WebSocketConnectionStatus.connected;
    notifyListeners();
  }

  void closeWebSocket() {
    _channel.sink.close();
    _connectionStatus = WebSocketConnectionStatus.disconnected;
    print("WebSocket disconnected");
  }

  Future<void> connectWebSocket(String url) async {
    if (_connectionStatus == WebSocketConnectionStatus.connected) {
      _channel.sink.close();
      _connectionStatus = WebSocketConnectionStatus.disconnected;
      print("WebSocket disconnected");
      _connectionStatus = WebSocketConnectionStatus.connecting;
      _channel = IOWebSocketChannel.connect(Uri.parse(url));
      _connectionStatus = WebSocketConnectionStatus.connected;
    } else {
      _connectionStatus = WebSocketConnectionStatus.connecting;
      _channel = IOWebSocketChannel.connect(Uri.parse(url));
      _connectionStatus = WebSocketConnectionStatus.connected;
    }
    print("WebSocket connected");
  }
}
