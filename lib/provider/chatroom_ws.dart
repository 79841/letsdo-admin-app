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

  // WebSocket 연결을 초기화하는 메서드
  Future<void> initializeWebSocket(String url) async {
    _connectionStatus = WebSocketConnectionStatus.connecting;
    _channel = IOWebSocketChannel.connect(Uri.parse(url));
    _connectionStatus = WebSocketConnectionStatus.connected;
    notifyListeners();
  }

  // WebSocket 연결을 닫는 메서드
  void closeWebSocket() {
    _channel.sink.close();
    _connectionStatus = WebSocketConnectionStatus.disconnected;
    print("WebSocket disconnected");
    notifyListeners();
  }

  Future<void> connectWebSocket(String url) async {
    // if (_connectionStatus == WebSocketConnectionStatus.disconnected) {
    //   try {
    //     _connectionStatus = WebSocketConnectionStatus.connecting;
    //     _channel = IOWebSocketChannel.connect(Uri.parse(url));
    //     _connectionStatus = WebSocketConnectionStatus.connected;
    //     print('WebSocket connected');
    //   } catch (e) {
    //     print('WebSocket connection failed: $e');
    //     _connectionStatus = WebSocketConnectionStatus.disconnected;
    //   }
    // } else if (_connectionStatus == WebSocketConnectionStatus.connecting) {
    //   print("WebSocket connecting");
    // } else {
    //   print("WebSocket already connected");
    // }
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
    notifyListeners();
  }
}
