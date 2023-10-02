import 'package:flutter/material.dart';
import 'package:ksica/component/profile/horizontal_simple_profile.dart';
import 'package:ksica/config/style.dart';

import '../utils/navigator.dart';

class ClientStyle {
  static const double clientBoxHeight = 70.0;
  static const double clientBoxPadding = 12.5;
  static const double clientBoxMargin = 20.0;
  static const double clientBoxProfileSize = 40.0;
}

class Clients extends StatelessWidget {
  final List<dynamic> clients;
  final List<dynamic> chatrooms;
  final List<dynamic> unreadMessageCounts;
  final ScrollController scrollController;
  final void Function(double) refreshCallback;
  const Clients({
    required this.clients,
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
        children: clients.map((e) {
          bool hasChatroom = chatroomsMap.containsKey(e["id"]);
          int? chatroomId =
              hasChatroom ? chatroomsMap[e["id"]]!["chatroom_id"] : null;
          // Widget chatButton = chatroomId != null
          //     ? _ChatButton(chatroomId: chatroomId)
          //     : Container();

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

          return ClientBox(
            client: e,
            // chatroomId: chatroomId,
            // unreadMessageCount: unreadMessageCount,
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

class ClientBox extends StatelessWidget {
  final dynamic client;
  final Widget chatButton;
  final int? chatroomId;
  final ScrollController scrollController;
  final void Function(double) refreshCallback;
  // final int? chatroomId;
  // final int unreadMessageCount;
  const ClientBox({
    required this.client,
    required this.chatButton,
    required this.chatroomId,
    required this.scrollController,
    required this.refreshCallback,
    // required this.chatroomId,
    // required this.unreadMessageCount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        double currentPosition = scrollController.position.pixels;

        goToUserInfo(
          context,
          client,
          chatroomId,
          () => refreshCallback(currentPosition),
        );
      },
      child: Container(
        height: ClientStyle.clientBoxHeight,
        decoration: BoxDecoration(
          color: mainWhite,
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.fromLTRB(
            ClientStyle.clientBoxPadding, 0, ClientStyle.clientBoxPadding, 0),
        margin: const EdgeInsets.fromLTRB(0, 0, 0, ClientStyle.clientBoxMargin),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SimpleProfile(
              client: client,
              profileSize: ClientStyle.clientBoxProfileSize,
            ),
            // chatroomId != null
            //     ? _ChatButton(
            //         chatroomId: chatroomId!,
            //         unreadMessageCount: unreadMessageCount,
            //       )
            //     : Container(),
            chatButton,
          ],
        ),
      ),
    );
  }
}

// class _ChatButton extends StatelessWidget {
//   final int chatroomId;
//   final int unreadMessageCount;
//   final VoidCallback callbackForRefresh;
//   const _ChatButton({
//     required this.chatroomId,
//     required this.unreadMessageCount,
//     required this.callbackForRefresh,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final Icon chatIcon = unreadMessageCount > 0
//         ? const Icon(Icons.mark_chat_unread_outlined)
//         : const Icon(Icons.chat_bubble_outline);

//     return IconButton(
//       icon: chatIcon,
//       onPressed: () => goToChat(
//         context,
//         chatroomId,
//         callbackForRefresh,
//       ),
//     );
//   }
// }

// class _SimpleProfile extends StatelessWidget {
//   final dynamic client;
//   const _SimpleProfile({required this.client});

//   Widget defaultProfile() {
//     return Container(
//       width: ClientStyle.clientBoxProfileSize,
//       height: ClientStyle.clientBoxProfileSize,
//       decoration: BoxDecoration(
//         borderRadius:
//             BorderRadius.circular(ClientStyle.clientBoxProfileSize / 2),
//         color: mainGray,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final String profileImageUrl = "$SERVER_URL/profile/id/${client["id"]}";
//     return Row(
//       children: [
//         // FutureBuilder<Uint8List>(
//         //   future: fetchProfileImage(client["id"]),
//         //   builder: (context, snapshot) {
//         //     return SizedBox(
//         //       height: ClientStyle.clientBoxProfileSize,
//         //       width: ClientStyle.clientBoxProfileSize,
//         //       child: ClipOval(
//         //         child: Image.network(
//         //           fit: BoxFit.cover,
//         //           profileImageUrl,
//         //           loadingBuilder: (BuildContext context, Widget child,
//         //               ImageChunkEvent? loadingProgress) {
//         //             if (loadingProgress == null) {
//         //               return child;
//         //             } else {
//         //               return const CircularProgressIndicator();
//         //             }
//         //           },
//         //           errorBuilder:
//         //               (BuildContext context, Object error, StackTrace? stackTrace) {
//         //             return defaultProfile();
//         //           },
//         //         ),
//         //       ),
//         //     );
//         //   }
//         // ),
//         ProfileImage(
//           profileImageSize: ClientStyle.clientBoxProfileSize,
//           userId: client["id"],
//         ),
//         wspace(20.0),
//         Text(
//           client["username"],
//           style: const TextStyle(
//             color: mainBlack,
//             fontSize: ClientStyle.clientBoxFontSize,
//           ),
//         ),
//       ],
//     );
//   }
// }
