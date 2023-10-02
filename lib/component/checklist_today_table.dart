import 'package:flutter/material.dart';
import 'package:ksica/utils/space.dart';
import '../config/style.dart';
import '../query/check_list.dart';
import '../query/todo_list.dart';

class CheckListTodayTableStyle {
  static const double normalFontSize = 17.0;
  static const FontWeight normalFontWeight = FontWeight.w300;
  static const double tableHeaderDayFontSize = 15.0;
  static const FontWeight tableHeaderDayFontWeight = FontWeight.w400;
  static const double dayFontSize = 15.0;
  static const FontWeight dayFontWeight = FontWeight.w500;
  static const double todoIndexFontSize = 17.0;
  static const FontWeight todoIndexFontWeight = FontWeight.w600;
  static const double todoListFontSize = 14.0;
  static const FontWeight todoListFontWeight = FontWeight.w500;
  static const double defaultTableCellHeight = 33.0;
}

class CheckListTodayTable extends StatefulWidget {
  // final GlobalKey targetKey;
  // final ScrollController controller;
  final int userId;
  const CheckListTodayTable({
    // required this.targetKey,
    // required this.controller,
    required this.userId,
    super.key,
  });

  @override
  State<CheckListTodayTable> createState() => _CheckListTodayTableState();
}

class _CheckListTodayTableState extends State<CheckListTodayTable> {
  DateTime today = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);

  Map<String, dynamic> _getDayOfWeekAndTextColor() {
    int day = today.weekday;
    switch (day) {
      case 1:
        return {"dayOfWeek": '월', "color": mainBlack};
      case 2:
        return {"dayOfWeek": '화', "color": mainBlack};
      case 3:
        return {"dayOfWeek": '수', "color": mainBlack};
      case 4:
        return {"dayOfWeek": '목', "color": mainBlack};
      case 5:
        return {"dayOfWeek": '금', "color": mainBlack};
      case 6:
        return {"dayOfWeek": '토', "color": darkBlue};
      case 7:
        return {"dayOfWeek": '일', "color": Colors.red};
      default:
        return {"dayOfWeek": '', "color": mainBlack};
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        fetchTodoList(),
        fetchUserCheckList(widget.userId),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Failed to load data'),
                ElevatedButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No data yet.'));
        }

        List<dynamic> todoList = snapshot.data![0];
        List<dynamic> checkStates = snapshot.data![1];

        Map<String, dynamic> dayOfWeekInfo = _getDayOfWeekAndTextColor();

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: mainWhite,
          ),
          child: Column(
            children: [
              _tableHeader(dayOfWeekInfo),
              _tableContent(todoList, checkStates),
              hspace(20.0),
            ],
          ),
        );
      },
    );
  }

  Widget _checkedBox() {
    return Container(
      height: CheckListTodayTableStyle.defaultTableCellHeight,
      color: darkBlue,
      child: const Icon(
        Icons.check,
        color: mainWhite,
      ),
    );
  }

  Widget _tableContent(List<dynamic> todoList, List<dynamic> checkStates) {
    List<TableRow> content = [];
    todoList.asMap().forEach(
      (i, e) {
        bool isDone = false;
        for (var checkState in checkStates) {
          if (checkState["code"] == e["code"] && checkState["done"] == true) {
            isDone = true;
          }
        }
        content.add(
          TableRow(
            children: [
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Container(
                  height: CheckListTodayTableStyle.defaultTableCellHeight,
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 16,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            (i + 1).toString(),
                            style: const TextStyle(
                              fontSize:
                                  CheckListTodayTableStyle.todoIndexFontSize,
                              fontWeight:
                                  CheckListTodayTableStyle.todoIndexFontWeight,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 60,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(5.0, 0, 0, 0),
                          child: Text(
                            e["name"],
                            style: const TextStyle(
                              fontSize:
                                  CheckListTodayTableStyle.todoListFontSize,
                              fontWeight:
                                  CheckListTodayTableStyle.todoListFontWeight,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // TableCell(
              //   verticalAlignment: TableCellVerticalAlignment.middle,
              //   child:
              // ),
              TableCell(
                child: isDone ? _checkedBox() : Container(),
              )
            ],
          ),
        );
      },
    );

    return Table(
      defaultColumnWidth: const FlexColumnWidth(1.0),
      columnWidths: const {
        0: FlexColumnWidth(7.6),
      },
      border: const TableBorder(
        verticalInside: BorderSide(color: lightBlue, width: 1.0),
      ),
      children: content,
    );
  }

  Widget _tableHeader(Map<String, dynamic> dayOfWeekInfo) {
    return Table(
      defaultColumnWidth: const FlexColumnWidth(1.0),
      columnWidths: const {
        0: FlexColumnWidth(7.6),
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: lightBlue),
            ),
          ),
          children: [
            TableCell(child: Container()),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Text(
                      dayOfWeekInfo["dayOfWeek"],
                      style: TextStyle(
                        fontSize: CheckListTodayTableStyle.normalFontSize,
                        fontWeight: CheckListTodayTableStyle.normalFontWeight,
                        color: dayOfWeekInfo["color"],
                      ),
                    ),
                    Text(
                      today.day.toString(),
                      style: TextStyle(
                        fontSize:
                            CheckListTodayTableStyle.tableHeaderDayFontSize,
                        fontWeight:
                            CheckListTodayTableStyle.tableHeaderDayFontWeight,
                        color: dayOfWeekInfo["color"],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
