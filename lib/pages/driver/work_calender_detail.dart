import '/services/global_service.dart';
import '/theme/bohiba_theme.dart';

import '/dist/component_exports.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class WorkCalendarPage extends StatefulWidget {
  const WorkCalendarPage({super.key});

  @override
  State<WorkCalendarPage> createState() => WorkCalendarPageState();
}

class WorkCalendarPageState extends State<WorkCalendarPage> {
  CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;

  // Generate work status from 2024 till now
  final Map<DateTime, String> workStatus = {};

  @override
  void initState() {
    super.initState();
    generateWorkStatus();
  }

  @override
  Widget build(BuildContext context) {
    var summary = getMonthlySummary(_focusedDay.year, _focusedDay.month);
    return Scaffold(
      appBar: TitleAppbar(title: "Work Schedule"),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TableCalendar(
              rangeSelectionMode: _rangeSelectionMode,
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              firstDay: DateTime(2024, 1, 1),
              lastDay: DateTime.now(),
              focusedDay: _focusedDay,
              calendarFormat: calendarFormat,
              onDayLongPressed: (selectedDay, focusedDay) {
                if (_rangeSelectionMode == RangeSelectionMode.toggledOn) {
                  _rangeSelectionMode = RangeSelectionMode.toggledOff;
                  _rangeStart = null;
                  _rangeEnd = null;
                  GlobalService.showAppToast(message: 'Turned Off');
                } else {
                  _rangeSelectionMode = RangeSelectionMode.toggledOn;
                  _rangeStart = selectedDay;
                  _rangeEnd = selectedDay;
                  GlobalService.showAppToast(
                      message: 'Range selection started');
                }
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                setState(() {});
              },
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onRangeSelected: (start, end, focusedDay) {
                _selectedDay = null;
                _focusedDay = focusedDay;
                _rangeStart = start;
                _rangeEnd = end;
                setState(() {});
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _rangeStart = null;
                  _rangeEnd = null;
                  setState(() {});
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
                setState(() {});
              },
              onFormatChanged: (summary) {
                if (calendarFormat != summary) {
                  setState(() {
                    calendarFormat = summary;
                  });
                }
              },
              headerStyle: HeaderStyle(titleCentered: true),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  return Container(
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      // color: getStatusColor(day),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        "${day.day}",
                        // style: TextStyle(
                        //   color: getStatusColor(day) == Colors.transparent
                        //       ? Colors.black
                        //       : Colors.white,
                        //   fontWeight: FontWeight.bold,
                        // ),
                      ),
                    ),
                  );
                },
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: BohibaColors.primaryColor,
                  shape: BoxShape.circle,
                ),
                todayTextStyle: TextStyle(
                  fontFamily: bohibaTheme.textTheme.titleSmall!.fontFamily,
                  color: BohibaColors.black,
                ),
                todayDecoration: BoxDecoration(
                  border: Border.all(
                    width: 1.0,
                    color: BohibaColors.primaryColor,
                  ),
                  color: BohibaColors.transparent,
                  shape: BoxShape.circle,
                ),
                rangeHighlightColor: const Color(0xFFBBDDFF),
              ),
            ),
            SizedBox(height: 20),
            Divider(),
            Text(
              "Summary for ${_focusedDay.month}-${_focusedDay.year}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSummaryCard("Full Days", summary["full"]!, Colors.green),
                _buildSummaryCard("Half Days", summary["half"]!, Colors.yellow),
                _buildSummaryCard("Holidays", summary["holiday"]!, Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, int count, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: color,
          child: Text(
            "$count",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 5),
        Text(title, style: TextStyle(fontSize: 14)),
      ],
    );
  }

  void generateWorkStatus() {
    DateTime startDate = DateTime(2024, 1, 1);
    DateTime endDate = DateTime.now();

    for (DateTime date = startDate;
        date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
        date = date.add(Duration(days: 1))) {
      if (date.weekday == DateTime.sunday) {
        workStatus[date] = "holiday";
      } else if (date.day % 7 == 0) {
        workStatus[date] = "half";
      } else {
        workStatus[date] = "full";
      }
    }
  }

  // Function to get color based on work status
  Color getStatusColor(DateTime day) {
    String? status = workStatus[DateTime(day.year, day.month, day.day)];
    if (status == "full") return Color(0xFF88E788);
    if (status == "half") return Colors.yellow;
    if (status == "holiday") return Colors.red;
    return Colors.transparent;
  }

  // Count work days summary per month
  Map<String, int> getMonthlySummary(int year, int month) {
    int fullDays = 0, halfDays = 0, holidays = 0;
    workStatus.forEach((date, status) {
      if (date.year == year && date.month == month) {
        if (status == "full") fullDays++;
        if (status == "half") halfDays++;
        if (status == "holiday") holidays++;
      }
    });
    return {"full": fullDays, "half": halfDays, "holiday": holidays};
  }
}
