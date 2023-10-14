import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:ksica/config/style.dart';
import 'package:ksica/provider/chatroom.dart';
import 'package:ksica/query/message.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../Layout/sub_layout.dart';
import '../../config.dart';
import '../../provider/auth.dart';
import '../../query/chatroom.dart';
import '../chat/message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> messages0 = [];
  late WebSocketChannel channel;
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    channel.sink.close();
    scrollController.dispose();
    super.dispose();
  }

  void _addMessage(Map<String, dynamic> message) {
    messages0.add(message);
    Timer(
      const Duration(milliseconds: 200),
      () {
        _slideToBottom();
      },
    );
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  }

  void _slideToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<List<dynamic>> fetchData(chatroomId) async {
    dynamic messages = await fetchMessages(chatroomId);
    dynamic opponent = await fetchOpponent(chatroomId);
    return [messages, opponent];
  }

  @override
  Widget build(BuildContext context) {
    return SubLayout(
      title: "상담하기",
      child: Container(
        color: lightBlue,
        child: Consumer<Auth>(
          builder: (context, auth, child) {
            int chatroomId =
                Provider.of<Chatroom>(context, listen: true).chatroomId!;
            return FutureBuilder(
              future: fetchData(chatroomId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Map<String, dynamic>> messages =
                      snapshot.data?[0].toList() ?? [];
                  messages0.addAll(messages);
                }
                int? opponentId = snapshot.data?[1]?["opponent_id"];
                channel = IOWebSocketChannel.connect(
                  Uri.parse(
                      '$WEBSOCKET_SERVER_URL/message/ws/$chatroomId?token=${auth.token}'),
                );
                Map<String, dynamic> token = {};
                token = JwtDecoder.decode(auth.token);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 7,
                      child: StreamBuilder(
                        stream: channel.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            Map<String, dynamic> message =
                                json.decode(snapshot.data);
                            _addMessage(message);
                          }
                          if (messages0.isNotEmpty) {
                            updateLastReadMessage(chatroomId,
                                messages0[messages0.length - 1]["id"]);
                          }

                          return MessageBoxes(
                            scrollController: scrollController,
                            scrollToBottom: _scrollToBottom,
                            messages: messages0,
                            userId: token["id"],
                            opponentId: opponentId,
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: MessageInputBox(
                        channel: channel,
                        scrollToBottom: _scrollToBottom,
                        scrollcontroller: scrollController,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
