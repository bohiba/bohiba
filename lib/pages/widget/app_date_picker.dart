import 'package:bohiba/component/bohiba_dropdown/app_dropdown_button.dart';
import 'package:bohiba/dist/component_exports.dart';

import '/component/screen_utils.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';

class AppDatePicker extends StatefulWidget {
  final String title;
  const AppDatePicker({super.key, required this.title});

  @override
  State<AppDatePicker> createState() => _AppDatePickerState();
}

class _AppDatePickerState extends State<AppDatePicker> {
  DateTime dTFocusedDate = DateTime.now();
  DateTime pickedDate = DateTime.now();
  int selectedYear = DateTime.now().year;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12.r),
          topLeft: Radius.circular(12.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: ScreenUtils.height15,
              right: ScreenUtils.height15,
              top: ScreenUtils.height20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppDropdown<int>(
                  width: ScreenUtils.width * 0.24,
                  menuHeight: ScreenUtils.height * 0.3,
                  dropDownValue: selectedYear,
                  padding: EdgeInsets.zero,
                  items:
                      List.generate((DateTime.now().year - 2000 + 1), (index) {
                    int year = 2000 + index;
                    return year;
                  }),
                  labelBuilder: (y) {
                    return y.toString();
                  },
                  onChanged: (y) {
                    if (y == null) return;
                    setState(() {
                      selectedYear = y;
                      dTFocusedDate = DateTime(
                        selectedYear,
                        pickedDate.month,
                        pickedDate.day,
                      );
                    });
                  },
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context, pickedDate);
                  },
                  icon: Icon(Icons.close),
                )
              ],
            ),
          ),
          TableCalendar(
            currentDay: DateTime.now(),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                pickedDate = selectedDay;
                dTFocusedDate = focusedDay;
              });
            },
            onFormatChanged: (format) {},
            selectedDayPredicate: (day) {
              return isSameDay(pickedDate, day);
            },
            onPageChanged: (focusedDay) {
              setState(() {
                dTFocusedDate = focusedDay;
                selectedYear = focusedDay.year;
              });
            },
            headerStyle: HeaderStyle(
              titleCentered: true,
              leftChevronVisible: false,
              rightChevronVisible: false,
              formatButtonVisible: false,
              headerPadding:
                  EdgeInsets.symmetric(vertical: ScreenUtils.height10),
              titleTextStyle: TextStyle(
                fontSize: bohibaTheme.textTheme.headlineLarge!.fontSize,
                color: bohibaTheme.textTheme.bodySmall!.color,
              ),
            ),
            focusedDay: dTFocusedDate,
            firstDay: DateTime(1800),
            lastDay: DateTime.now(),
            // currentDay: pickedDate,
            calendarFormat: CalendarFormat.month,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              selectedTextStyle: TextStyle(
                fontFamily: bohibaTheme.textTheme.titleSmall!.fontFamily,
                color: bohibaTheme.textTheme.displayLarge!.color,
              ),
              selectedDecoration: BoxDecoration(
                color: bohibaTheme.primaryColor,
                shape: BoxShape.circle,
              ),
              todayTextStyle: TextStyle(
                fontFamily: bohibaTheme.textTheme.titleSmall!.fontFamily,
                color: bohibaTheme.textTheme.labelSmall!.color,
              ),
              todayDecoration: BoxDecoration(
                color: bohibaTheme.disabledColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
