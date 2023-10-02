import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ksica/Layout/main_layout.dart';
import 'package:ksica/config/const.dart';
import 'package:ksica/provider/chatroom_ws.dart';
import 'package:ksica/query/chatroom.dart';
import 'package:provider/provider.dart';

import '../component/chat/message_preview.dart';
import '../config.dart';
import '../provider/auth.dart';
import '../query/user_info.dart';

class ChatroomList extends StatefulWidget {
  const ChatroomList({super.key});

  @override
  State<ChatroomList> createState() => _ChatroomListState();
}

class _ChatroomListState extends State<ChatroomList> {
  late ChatroomWebSocketManager webSocketManager;
  List<dynamic> unreadMessageCounts = [];
  List<dynamic> lastMessages = [];
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    webSocketManager.closeWebSocket();
    _controller.dispose();
    super.dispose();
  }

  // void refreshCallback(double prevPosition) async {
  //   // print(_controller.position.pixels);
  //   setState(() {});
  //   // unreadMessageCounts = await getAllUnreadMessageCount();
  //   print(prevPosition);
  //   Timer(
  //     const Duration(milliseconds: 100),
  //     () => _controller.jumpTo(prevPosition),
  //   );
  // }

  void refreshAndScrollJumpToPreviousPosition(double prevPosition) async {
    setState(() {});
    // unreadMessageCounts = await getAllUnreadMessageCount();
    print(prevPosition);
    Timer(
      const Duration(milliseconds: 100),
      () => _controller.jumpTo(prevPosition),
    );
  }

  @override
  Widget build(BuildContext context) {
    webSocketManager = Provider.of<ChatroomWebSocketManager>(context);
    return MainLayout(
      currentScreen: CHATROOM_LIST_SCREEN,
      child: SingleChildScrollView(
        controller: _controller,
        child: FutureBuilder(
          future: Future.wait([getClients(), fetchAllChatrooms()]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Failed to load client'),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {});
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No client yet.'));
            }
            List<dynamic> clients = snapshot.data![0];
            List<dynamic> chatrooms = snapshot.data![1];
            print(chatrooms);
            return Consumer<Auth>(
              builder: (context, auth, child) {
                return Consumer<ChatroomWebSocketManager>(
                  builder: (context, chatroomWebSocketManager, child) {
                    webSocketManager = chatroomWebSocketManager;
                    webSocketManager.connectWebSocket(
                        "$WEBSOCKET_SERVER_URL/admin/message/unread/count/all/ws/?token=${auth.token}");
                    return StreamBuilder(
                      stream: webSocketManager.channel.stream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Failed to load user'),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {});
                                  },
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          );
                        } else if (!snapshot.hasData) {
                          return const Center(child: Text('No user yet.'));
                        }
                        dynamic data = json.decode(snapshot.data);

                        unreadMessageCounts = data[0];
                        lastMessages = data[1];

                        Map<int, Map<String, dynamic>> unreadMessageCountsMap =
                            {};
                        for (var item in unreadMessageCounts) {
                          unreadMessageCountsMap[item["chatroom_id"]] = item;
                        }
                        Map<int, Map<String, dynamic>> clientsMap = {};
                        for (var item in clients) {
                          clientsMap[item["id"]] = item;
                        }
                        Map<int, Map<String, dynamic>> chatroomsMap = {};
                        for (var item in chatrooms) {
                          chatroomsMap[item["chatroom_id"]] = item;
                        }
                        Map<int, Map<String, dynamic>> lastMessagesMap = {};
                        for (var item in lastMessages) {
                          lastMessagesMap[item["chatroom_id"]] = item;
                        }

                        List<dynamic> chatroomInfo = chatrooms.map((chatroom) {
                          int chatroomId = chatroom["chatroom_id"];
                          int opponentId = chatroom["user_id"];
                          // chatroomsMap[chatroomId]!["user_id"];
                          dynamic client = clientsMap[opponentId];
                          dynamic message =
                              lastMessagesMap.containsKey(chatroomId)
                                  ? lastMessagesMap[chatroomId]
                                  : null;
                          int unreadMessageCount =
                              unreadMessageCountsMap.containsKey(chatroomId)
                                  ? unreadMessageCountsMap[chatroomId]![
                                      "unread_message_count"]
                                  : 0;

                          return {
                            "chatroom_id": chatroomId,
                            "client": client,
                            "unread_message_count": unreadMessageCount,
                            "message": message,
                          };
                        }).toList();

                        chatroomInfo.sort((a, b) {
                          DateTime? timeA = a["message"] != null
                              ? DateTime.parse(a["message"]["timestamp"])
                              : null;
                          DateTime? timeB = b["message"] != null
                              ? DateTime.parse(b["message"]["timestamp"])
                              : null;

                          if (timeA == null && timeB == null) {
                            return a["chatroom_id"] > b["chatroom_id"] ? 1 : -1;
                          }

                          if (timeA != null && timeB != null) {
                            return timeA.isAfter(timeB) ? -1 : 1;
                          }

                          return timeA != null ? -1 : 1;
                        });

                        print(chatroomInfo);

                        return Container(
                          child: Column(
                            children: chatroomInfo.map((e) {
                              return MessagePreviewBox(
                                chatroomId: e["chatroom_id"],
                                client: e["client"],
                                unreadMessageCount: e["unread_message_count"],
                                message: e["message"],
                                scrollController: _controller,
                                refreshCallback:
                                    refreshAndScrollJumpToPreviousPosition,
                              );
                            }).toList(),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
