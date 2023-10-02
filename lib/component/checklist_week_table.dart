import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ksica/utils/space.dart';

import '../config/style.dart';
import '../query/check_list.dart';
import '../query/todo_list.dart';

class ChecklistWeekTableStyle {
  static const double normalFontSize = 17.0;
  static const FontWeight normalFontWeight = FontWeight.w300;
  static const double tableHeaderDayFontSize = 15.0;
  static const FontWeight tableHeaderDayFontWeight = FontWeight.w400;
  static const double dayFontSize = 15.0;
  static const FontWeight dayFontWeight = FontWeight.w500;
  static const double todoIndexFontSize = 17.0;
  static const FontWeight todoIndexFontWeight = FontWeight.w600;
  static const double defaultTableCellHeight = 33.0;
}

class ChecklistWeekTable extends StatefulWidget {
  final int userId;
  final DateTime startOfWeek;
  final DateTime endOfWeek;
  const ChecklistWeekTable(
      {required this.userId,
      required this.startOfWeek,
      required this.endOfWeek,
      super.key});

  @override
  State<ChecklistWeekTable> createState() => _ChecklistWeekTableState();
}

class _ChecklistWeekTableState extends State<ChecklistWeekTable> {
  List<String> daysOfWeek = ["일", "월", "화", "수", "목", "금", "토"];

  Widget _checkedBox() {
    return Container(
      height: ChecklistWeekTableStyle.defaultTableCellHeight,
      color: darkBlue,
      child: const Icon(
        Icons.check,
        color: mainWhite,
      ),
    );
  }

  String _dateToStr(DateTime date) {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    return dateFormat.format(date);
  }

  @override
  Widget build(BuildContext context) {
    String strStartOfWeek = _dateToStr(widget.startOfWeek);
    String strEndOfWeek = _dateToStr(widget.endOfWeek);
    return FutureBuilder(
      future: Future.wait([
        fetchTodoList(),
        fetchUserCheckListForPeriod(
          widget.userId,
          strStartOfWeek,
          strEndOfWeek,
        )
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Failed to load client'),
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
          return const Center(child: Text('No client yet.'));
        }
        print(snapshot.data);

        List<dynamic> todoList = snapshot.data![0];
        List<dynamic> checkStates = snapshot.data![1];

        List<TableCell> tableHeader = [];
        daysOfWeek.asMap().forEach(
          (i, e) {
            Color textColor = mainBlack;
            if (i == 0) {
              textColor = Colors.red;
            } else if (i == 6) {
              textColor = darkBlue;
            }
            tableHeader.add(
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      Text(
                        e,
                        style: TextStyle(
                          fontSize: ChecklistWeekTableStyle.normalFontSize,
                          fontWeight: ChecklistWeekTableStyle.normalFontWeight,
                          color: textColor,
                        ),
                      ),
                      Text(
                        (widget.startOfWeek.day + i).toString(),
                        style: TextStyle(
                          fontSize:
                              ChecklistWeekTableStyle.tableHeaderDayFontSize,
                          fontWeight:
                              ChecklistWeekTableStyle.tableHeaderDayFontWeight,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );

        List<TableRow> tableContent = [];
        Map<String, dynamic> checkStatesMap = {};
        for (var checkState in checkStates) {
          checkStatesMap[checkState["date"]] = checkState;
        }

        todoList.asMap().forEach(
          (i, e) {
            tableContent.add(
              TableRow(
                children: [
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Container(
                      height: ChecklistWeekTableStyle.defaultTableCellHeight,
                      alignment: Alignment.center,
                      child: Text(
                        (i + 1).toString(),
                        style: const TextStyle(
                          fontSize: ChecklistWeekTableStyle.todoIndexFontSize,
                          fontWeight:
                              ChecklistWeekTableStyle.todoIndexFontWeight,
                        ),
                      ),
                    ),
                  ),
                  ...List.generate(7, (index) => index).map((index) {
                    String strDate = _dateToStr(
                        widget.startOfWeek.add(Duration(days: index)));
                    // Widget cell = checkStatesMap.containsKey(strDate) &&
                    //         checkStatesMap[strDate]["code"] == e["code"] &&
                    //         checkStatesMap[strDate]["done"] == true
                    //     ? _checkedBox()
                    //     : Container();
                    bool isDone = false;
                    for (var checkState in checkStates) {
                      if (checkState["date"] == strDate &&
                          checkState["code"] == e["code"] &&
                          checkState["done"] == true) {
                        isDone = true;
                      }
                    }

                    return TableCell(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          border: Border(
                            right: BorderSide(
                              color: darkBlue,
                            ),
                          ),
                        ),
                        child: isDone ? _checkedBox() : Container(),
                      ),
                    );
                  }).toList(),
                ],
              ),
            );
          },
        );

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: mainWhite,
          ),
          child: Column(
            children: [
              Table(
                defaultColumnWidth: const FlexColumnWidth(1.0),
                columnWidths: const {
                  0: FlexColumnWidth(1.6),
                },
                children: [
                  TableRow(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: lightBlue),
                      ),
                      // color: mainWhite,
                    ),
                    children: [
                      TableCell(child: Container()),
                      ...tableHeader,
                    ],
                  ),
                ],
              ),
              Table(
                defaultColumnWidth: const FlexColumnWidth(1.0),
                columnWidths: const {
                  0: FlexColumnWidth(1.6),
                },
                border: const TableBorder(
                  verticalInside: BorderSide(color: lightBlue, width: 1.0),
                ),
                children: tableContent,
              ),
              hspace(20.0),
            ],
          ),
        );
      },
    );
  }
}
