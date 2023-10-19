import 'package:flutter/material.dart';
import 'package:ksica/components/profile/horizontal_simple_profile.dart';
import 'package:ksica/config/style.dart';

import '../../utils/navigator.dart';

class UserBoxStyle {
  static const double userBoxHeight = 70.0;
  static const double userBoxPadding = 12.5;
  static const double userBoxMargin = 20.0;
  static const double userBoxProfileSize = 40.0;
}

class UserBoxes extends StatelessWidget {
  final List<dynamic> users;
  final List<dynamic> chatrooms;
  final List<dynamic> unreadMessageCounts;
  final ScrollController scrollController;
  final void Function(double) refreshCallback;
  const UserBoxes({
    required this.users,
    required this.chatrooms,
    required this.unreadMessageCounts,
    required this.scrollController,
    required this.refreshCallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Map<int, Map<String, dynamic>> chatroomsMap = {};
    for (var item in chatrooms) {
      chatroomsMap[item["user_id"]] = item;
    }
    Map<int, Map<String, dynamic>> unreadMessageCountsMap = {};
    for (var item in unreadMessageCounts) {
      unreadMessageCountsMap[item["chatroom_id"]] = item;
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: users.map((e) {
          bool hasChatroom = chatroomsMap.containsKey(e["id"]);
          int? chatroomId =
              hasChatroom ? chatroomsMap[e["id"]]!["chatroom_id"] : null;

          int unreadMessageCount =
              hasChatroom && unreadMessageCountsMap.containsKey(chatroomId)
                  ? unreadMessageCountsMap[chatroomId]!["unread_message_count"]
                  : 0;

          final Icon chatIcon = unreadMessageCount > 0
              ? const Icon(Icons.mark_chat_unread_outlined)
              : const Icon(Icons.chat_bubble_outline);

          Widget chatButton = hasChatroom
              ? IconButton(
                  icon: chatIcon,
                  onPressed: () {
                    double currentPosition = scrollController.position.pixels;
                    goToChat(
                      context,
                      chatroomId!,
                      () => refreshCallback(currentPosition),
                    );
                  },
                )
              : Container();

          return UserBox(
            user: e,
            chatButton: chatButton,
            chatroomId: chatroomId,
            scrollController: scrollController,
            refreshCallback: refreshCallback,
          );
        }).toList(),
      ),
    );
  }
}

class UserBox extends StatelessWidget {
  final dynamic user;
  final Widget chatButton;
  final int? chatroomId;
  final ScrollController scrollController;
  final void Function(double) refreshCallback;
  const UserBox({
    required this.user,
    required this.chatButton,
    required this.chatroomId,
    required this.scrollController,
    required this.refreshCallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        double currentPosition = scrollController.position.pixels;

        goToUserInfo(
          context,
          user,
          chatroomId,
          () => refreshCallback(currentPosition),
        );
      },
      child: Container(
        height: UserBoxStyle.userBoxHeight,
        decoration: BoxDecoration(
          color: mainWhite,
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.fromLTRB(
            UserBoxStyle.userBoxPadding, 0, UserBoxStyle.userBoxPadding, 0),
        margin: const EdgeInsets.fromLTRB(0, 0, 0, UserBoxStyle.userBoxMargin),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SimpleProfile(
              user: user,
              profileSize: UserBoxStyle.userBoxProfileSize,
            ),
            chatButton,
          ],
        ),
      ),
    );
  }
}
