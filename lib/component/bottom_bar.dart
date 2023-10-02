import 'package:flutter/material.dart';
import 'package:ksica/config/const.dart';
import 'package:ksica/config/style.dart';
import 'package:ksica/utils/space.dart';

import '../utils/navigator.dart';

class BottomBarStyle {
  static const double height = 70.0;
  static const double iconSize = 35.0;
  static const Color bgColor = Colors.white;
  static const Color homebuttonColor = Color(0xff3b699e);
}

class BottomBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String currentScreen;
  const BottomBar(
      {required this.scaffoldKey, required this.currentScreen, super.key});

  @override
  Widget build(BuildContext context) {
    IconData homeIcon = Icons.home;
    IconData chatIcon = Icons.chat_bubble_outline;
    Color homeColor = darkBlue;
    Color chatColor = mainBlack;

    switch (currentScreen) {
      case HOME_SCREEN:
        homeIcon = Icons.home;
        chatIcon = Icons.chat_bubble_outline;
        homeColor = darkBlue;
        chatColor = mainBlack;
        break;
      case CHATROOM_LIST_SCREEN:
        homeIcon = Icons.home_outlined;
        chatIcon = Icons.chat_bubble;
        homeColor = mainBlack;
        chatColor = darkBlue;
        break;
      default:
        homeIcon = Icons.home;
        chatIcon = Icons.chat_bubble_outline;
        homeColor = darkBlue;
        chatColor = mainBlack;
    }

    return Container(
      color: BottomBarStyle.bgColor,
      height: BottomBarStyle.height,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {
                  if (currentScreen == HOME_SCREEN) return;
                  // Navigator.of(context).pop(context);
                  goToHome(context);
                },
                icon: Icon(
                  homeIcon,
                  size: BottomBarStyle.iconSize,
                  color: homeColor,
                ),
              ),
              IconButton(
                icon: Icon(
                  chatIcon,
                  size: BottomBarStyle.iconSize,
                  color: chatColor,
                ),
                onPressed: () {
                  if (currentScreen == CHATROOM_LIST_SCREEN) return;
                  goToChatroomList(context);
                },
              ),
              // const ChatButton(
              //   iconSize: BottomBarStyle.iconSize,
              // ),
              IconButton(
                icon: const Icon(
                  Icons.menu,
                  size: BottomBarStyle.iconSize,
                  color: mainBlack,
                ),
                onPressed: () {
                  scaffoldKey.currentState?.openEndDrawer();
                },
              ),
            ],
          ),
          hspace(20.0),
        ],
      ),
    );
  }
}
