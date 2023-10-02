import 'package:flutter/material.dart';
import 'package:ksica/config/style.dart';
import 'package:ksica/utils/navigator.dart';

class UserInfoButton extends StatelessWidget {
  final dynamic client;
  final int chatroomId;
  final double iconSize;
  const UserInfoButton(
      {required this.client,
      required this.chatroomId,
      required this.iconSize,
      super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        goToUserInfo(context, client, chatroomId);
      },
      icon: Icon(
        Icons.account_circle_outlined,
        size: iconSize,
        color: mainBlack,
      ),
    );
  }
}
