import 'package:flutter/material.dart';
import 'package:ksica/Layout/sub_layout.dart';
import 'package:ksica/component/chat_button.dart';
import 'package:ksica/component/check_list_week_chart.dart';
import 'package:ksica/config/style.dart';

import '../component/check_list_today_chart.dart';
import '../utils/space.dart';

class UserChecklistScreen extends StatefulWidget {
  final dynamic client;
  final int? chatroomId;
  const UserChecklistScreen(
      {required this.client, required this.chatroomId, super.key});

  @override
  State<UserChecklistScreen> createState() => _UserChecklistScreenState();
}

class _UserChecklistScreenState extends State<UserChecklistScreen> {
  ScrollController scrollController = ScrollController();
  final GlobalKey targetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SubLayout(
      action: widget.chatroomId != null
          ? ChatButton(
              chatroomId: widget.chatroomId!,
              iconSize: 25.0,
            )
          : null,
      title: "${widget.client["username"]} 님",
      child: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          padding: const EdgeInsets.all(15.0),
          color: lightBlue,
          child: Column(
            children: [
              CheckListTodayChart(
                controller: scrollController,
                targetKey: targetKey,
                client: widget.client,
              ),
              hspace(30.0),
              CheckListWeekChart(
                userId: widget.client["id"],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
