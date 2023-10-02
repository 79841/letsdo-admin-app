import 'package:flutter/material.dart';

import '../../config/style.dart';
import '../../utils/space.dart';
import '../profile_image.dart';

class SimpleProfileStyle {
  static const double clientBoxFontSize = 20.0;
  static const FontWeight nameFontWeight = FontWeight.w500;
}

class SimpleProfile extends StatelessWidget {
  final dynamic client;
  final double profileSize;
  const SimpleProfile(
      {required this.client, required this.profileSize, super.key});

  // Widget defaultProfile() {
  //   return Container(
  //     width: profileSize,
  //     height: profileSize,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(profileSize / 2),
  //       color: const Color(0xffD9D9D9),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // final String profileImageUrl = "$SERVER_URL/profile/id/${client["id"]}";
    return Row(
      children: [
        ProfileImage(
          profileImageSize: profileSize,
          userId: client["id"],
        ),
        wspace(20.0),
        Text(
          client["username"],
          style: const TextStyle(
            color: mainBlack,
            fontSize: SimpleProfileStyle.clientBoxFontSize,
            fontWeight: SimpleProfileStyle.nameFontWeight,
          ),
        ),
      ],
    );
  }
}
