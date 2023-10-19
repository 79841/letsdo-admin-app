import 'package:flutter/material.dart';

import '../../config/style.dart';
import '../../utils/space.dart';
import 'profile_image.dart';

class SimpleProfileStyle {
  static const double userBoxFontSize = 20.0;
  static const FontWeight nameFontWeight = FontWeight.w500;
}

class SimpleProfile extends StatelessWidget {
  final dynamic user;
  final double profileSize;
  const SimpleProfile(
      {required this.user, required this.profileSize, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfileImage(
          profileImageSize: profileSize,
          userId: user["id"],
        ),
        wspace(20.0),
        Text(
          user["username"],
          style: const TextStyle(
            color: mainBlack,
            fontSize: SimpleProfileStyle.userBoxFontSize,
            fontWeight: SimpleProfileStyle.nameFontWeight,
          ),
        ),
      ],
    );
  }
}
