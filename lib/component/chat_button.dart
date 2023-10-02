import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ksica/config/style.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../config.dart';
import '../provider/auth.dart';
import '../utils/navigator.dart';

class ChatButton extends StatefulWidget {
  final int chatroomId;
  final double iconSize;
  const ChatButton(
      {required this.chatroomId, required this.iconSize, super.key});

  @override
  State<ChatButton> createState() => ChatButtonState();
}

class ChatButtonState extends State<ChatButton> {
  late WebSocketChannel _channel;

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  Widget chatIcon(int chatroomId, double size, bool unreadMessageExist) {
    return IconButton(
      onPressed: () => goToChat(
        context,
        chatroomId,
        () {
          setState(() {});
        },
      ),
      icon: Icon(
        unreadMessageExist
            ? Icons.mark_chat_unread_outlined
            : Icons.chat_bubble_outline,
        size: size,
        color: mainBlack,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, auth, child) {
        _channel = IOWebSocketChannel.connect(
          Uri.parse(
              "$WEBSOCKET_SERVER_URL/message/unread/count/ws/${widget.chatroomId}?token=${auth.token}"),
        );

        return StreamBuilder(
          stream: _channel.stream,
          builder: (context, snapshot) {
            bool unreadMessageExist = false;
            int unreadMessageCount = 0;
            if (snapshot.hasData) {
              unreadMessageCount = json.decode(snapshot.data);
            }
            if (unreadMessageCount > 0) {
              unreadMessageExist = true;
            }
            return chatIcon(
                widget.chatroomId, widget.iconSize, unreadMessageExist);
          },
        );
      },
    );
  }
}
