import 'package:flutter/material.dart';
import 'package:ksica/screen/chatroom_list.dart';
import 'package:ksica/screen/login_register_screen.dart';
import 'package:ksica/screen/user_checklist_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screen/chat_screen.dart';
import '../screen/profile_screen.dart';

void goToHome(
  BuildContext context,
) {
  // Navigator.of(context).pop();
  // Navigator.of(context).pushReplacement(
  //   MaterialPageRoute(
  //     builder: (context) => const HomeScreen(),
  //   ),
  // );
  Navigator.of(context).popUntil((route) => route.isFirst);
}

void goToChat(BuildContext context, int chatroomId,
    [VoidCallback? callback]) async {
  callback ??= () {};
  Navigator.of(context)
      .push(
        MaterialPageRoute(
          builder: (BuildContext context) => ChatScreen(
            chatroomId: chatroomId,
          ),
        ),
      )
      .then((value) => callback!());
}

void goToChatroomList(BuildContext context, [VoidCallback? callback]) async {
  callback ??= () {};
  Navigator.of(context)
      .push(
        MaterialPageRoute(
          builder: (BuildContext context) => const ChatroomList(),
        ),
      )
      .then((value) => callback!());
}

void goToUserInfo(BuildContext context, dynamic client, int? chatroomId,
    [VoidCallback? callback]) {
  callback ??= () {};
  Navigator.of(context)
      .push(
        MaterialPageRoute(
          builder: (context) =>
              UserChecklistScreen(client: client, chatroomId: chatroomId),
        ),
      )
      .then((value) => callback!());
}

void goToWebSite() {
  launchUrl(
    Uri.parse('http://www.kscia.org/kscia/'),
  );
}

void goToWebSiteNotification() {
  launchUrl(
    Uri.parse(
        'http://www.kscia.org/kscia/bbs/board.php?bo_table=bo_01&sca=%EA%B3%B5%EA%B3%A0'),
  );
}

void goToProfile(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (BuildContext context) => const ProfileScreen(),
    ),
  );
}

void goToLogin(BuildContext context) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (BuildContext context) => const LoginScreen(),
    ),
  );
}
