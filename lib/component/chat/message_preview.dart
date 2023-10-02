import 'package:flutter/material.dart';

import '../../config/style.dart';
import '../../utils/navigator.dart';
import '../profile/horizontal_simple_profile.dart';

class MessagePreviewboxStyle {
  static const double height = 80.0;
  static const double padding = 12.5;
  static const double margin = 10.0;
  static const double unreadMessageSignSize = 18.0;
  static const double profileImageSize = 40.0;
  static const double messageFontSize = 20.0;
  static const FontWeight messageFontWeight = FontWeight.w400;
}

class MessagePreviewBox extends StatelessWidget {
  final int chatroomId;
  final dynamic client;
  final dynamic message;
  final int unreadMessageCount;
  final ScrollController scrollController;
  final void Function(double) refreshCallback;
  const MessagePreviewBox({
    required this.chatroomId,
    required this.client,
    required this.message,
    required this.unreadMessageCount,
    required this.scrollController,
    required this.refreshCallback,
    super.key,
  });

  String _truncateString(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget unreadMessageSign = unreadMessageCount > 0
        ? Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 10.0, 0),
            width: MessagePreviewboxStyle.unreadMessageSignSize,
            height: MessagePreviewboxStyle.unreadMessageSignSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                MessagePreviewboxStyle.unreadMessageSignSize / 2,
              ),
              color: darkBlue,
            ),
          )
        : Container();
    String messageContent =
        message != null ? _truncateString(message["content"], 13) : "";

    return GestureDetector(
      onTap: () {
        double currentPosition = scrollController.position.pixels;
        goToChat(
          context,
          chatroomId,
          () => refreshCallback(currentPosition),
        );
      },
      child: Container(
        height: MessagePreviewboxStyle.height,
        decoration: const BoxDecoration(
          color: mainWhite,
          // borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.fromLTRB(MessagePreviewboxStyle.padding, 0,
            MessagePreviewboxStyle.padding, 0),
        margin:
            const EdgeInsets.fromLTRB(0, 0, 0, MessagePreviewboxStyle.margin),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 110.0,
                  child: SimpleProfile(
                    client: client,
                    profileSize: MessagePreviewboxStyle.profileImageSize,
                  ),
                ),
                // wspace(20.0),
                Text(
                  messageContent,
                  style: const TextStyle(
                    fontSize: MessagePreviewboxStyle.messageFontSize,
                    fontWeight: MessagePreviewboxStyle.messageFontWeight,
                  ),
                ),
              ],
            ),
            unreadMessageSign,
          ],
        ),
      ),
    );
  }
}
