import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ksica/component/checklist_today_table.dart';

import 'checklist_week_table.dart';

class CheckListWeekChartStyle {
  static const double weekNumberFontSize = 17.0;
  static const FontWeight weekNumberFontWeight = FontWeight.w600;
  static const double normalFontSize = 17.0;
  static const FontWeight normalFontWeight = FontWeight.w300;
  static const double arrowIconSize = 40.0;
  static const double iconSize = 15.0;
}

class DailyCheckList {
  final String day;
  final String date;
  int count;

  DailyCheckList(this.day, this.date, this.count);
}

class CheckListWeekChart extends StatefulWidget {
  final int userId;
  const CheckListWeekChart({required this.userId, super.key});

  @override
  State<CheckListWeekChart> createState() => _CheckListWeekChartState();
}

class _CheckListWeekChartState extends State<CheckListWeekChart> {
  // DateTime now = DateTime.now();

  bool isWeekTable = true;

  DateTime today = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);

  int _getWeekNumber(DateTime today) {
    final firstDayOfMonth = DateTime(today.year, today.month, 1);
    DateTime firstDayOfWeek = _getStartOfWeek(firstDayOfMonth);
    // print("weeknumber");
    // print(_dateToStr(firstDayOfWeek));
    final weekNumber = (today.difference(firstDayOfWeek).inDays / 7).ceil() + 1;

    return weekNumber;
  }

  void _goBackWeek() {
    setState(() {
      today = today.subtract(const Duration(days: 7));
    });
  }

  void _goForwardWeek() {
    setState(() {
      today = today.add(const Duration(days: 7));
    });
  }

  DateTime _getStartOfWeek(DateTime today) {
    int currentWeekday = today.weekday % 7;

    DateTime startOfWeek = today.subtract(Duration(days: currentWeekday));
    return startOfWeek;
  }

  DateTime _getEndOfWeek(DateTime today) {
    DateTime startOfWeek = _getStartOfWeek(today);
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
    return endOfWeek;
  }

  String _dateToStr(DateTime date) {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    return dateFormat.format(date);
  }

  @override
  Widget build(BuildContext context) {
    int weekNumber = _getWeekNumber(today);
    DateTime startOfWeek = _getStartOfWeek(today);
    DateTime endOfWeek = _getEndOfWeek(today);
    // print(startOfWeek.day);
    // String strStartOfWeek = _dateToStr(startOfWeek);
    // String strEndOfWeek = _dateToStr(_getEndOfWeek(today));

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => _goBackWeek(),
              icon: const Icon(
                Icons.arrow_left_rounded,
                size: CheckListWeekChartStyle.arrowIconSize,
              ),
            ),
            Row(
              children: [
                Text(
                  "${today.month}월 $weekNumber주차 ",
                  style: const TextStyle(
                    fontSize: CheckListWeekChartStyle.weekNumberFontSize,
                    fontWeight: CheckListWeekChartStyle.weekNumberFontWeight,
                  ),
                ),
                const Text(
                  "달성도",
                  style: TextStyle(
                    fontSize: CheckListWeekChartStyle.normalFontSize,
                    fontWeight: CheckListWeekChartStyle.normalFontWeight,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () => _goForwardWeek(),
              icon: const Icon(
                Icons.arrow_right_rounded,
                size: CheckListWeekChartStyle.arrowIconSize,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isWeekTable = !isWeekTable;
            });
          },
          child: isWeekTable
              ? ChecklistWeekTable(
                  userId: widget.userId,
                  startOfWeek: startOfWeek,
                  endOfWeek: endOfWeek,
                )
              : CheckListTodayTable(userId: widget.userId),
        ),
      ],
    );
  }
}
