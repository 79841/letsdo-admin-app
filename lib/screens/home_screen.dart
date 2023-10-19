import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ksica/config/const.dart';
import 'package:ksica/config/style.dart';
import 'package:ksica/providers/chatroom_ws.dart';
import 'package:provider/provider.dart';
import '../layouts/main_layout.dart';
import '../config/url.dart';
import '../providers/auth.dart';
import '../services/chatroom.dart';
import '../services/user_info.dart';
import '../utils/space.dart';
import '../components/profile/user_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const storage = FlutterSecureStorage();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey targetKey = GlobalKey();

  final storage = const FlutterSecureStorage();

  late ChatroomWebSocketManager webSocketManager;

  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    try {
      webSocketManager.closeWebSocket();
    } catch (e) {
      print("channel has not been initialized");
    }
    super.dispose();
  }

  List<dynamic> unreadMessageCounts = [];

  void refreshCallback(double prevPosition) async {
    setState(() {});
    Timer(
      const Duration(milliseconds: 100),
      () => _controller.jumpTo(prevPosition),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentScreen: HOME_SCREEN,
      child: FutureBuilder<dynamic>(
        future: Future.wait([
          getClients(),
          fetchAllChatrooms(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
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
                    if (snapshot.hasData) {
                      unreadMessageCounts = json.decode(snapshot.data)[0];
                    }
                    return SearchedClients(
                      clients: clients,
                      chatrooms: chatrooms,
                      unreadMessageCounts: unreadMessageCounts,
                      scrollController: _controller,
                      refreshCallback: refreshCallback,
                    );
                  },
                );
              });
            },
          );
        },
      ),
    );
  }
}

class SearchedClients extends StatefulWidget {
  final List<dynamic> clients;
  final List<dynamic> chatrooms;
  final List<dynamic> unreadMessageCounts;
  final ScrollController scrollController;
  final void Function(double) refreshCallback;
  const SearchedClients(
      {required this.clients,
      required this.chatrooms,
      required this.unreadMessageCounts,
      required this.scrollController,
      required this.refreshCallback,
      super.key});

  @override
  State<SearchedClients> createState() => _SearchedClientsState();
}

class _SearchedClientsState extends State<SearchedClients> {
  final TextEditingController searchController = TextEditingController();
  String searchString = "";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clients = widget.clients;
    List<dynamic> filteredClients = clients.where((client) {
      return client["username"].contains(searchString);
    }).toList();
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          hspace(10.0),
          Container(
            padding: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 3.0),
            height: 60.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: mainWhite,
            ),
            child: TextField(
              onChanged: (text) {
                setState(() {
                  searchString = text;
                });
              },
              style: const TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w400,
                color: mainBlack,
              ),
              controller: searchController,
              textAlignVertical: TextAlignVertical.bottom,
              decoration: const InputDecoration(
                hintText: "사용자를 입력하세요",
                border: InputBorder.none,
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
          ),
          hspace(40.0),
          Expanded(
            child: SingleChildScrollView(
              controller: widget.scrollController,
              child: UserBoxes(
                users: filteredClients,
                chatrooms: widget.chatrooms,
                unreadMessageCounts: widget.unreadMessageCounts,
                scrollController: widget.scrollController,
                refreshCallback: widget.refreshCallback,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
