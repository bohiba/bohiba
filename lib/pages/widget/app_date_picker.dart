import '/component/bohiba_buttons/primary_button.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '/component/bohiba_dropdown/app_dropdown_button.dart';
import '/dist/component_exports.dart';
import '/component/screen_utils.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';

class AppDatePicker extends StatefulWidget {
  final String title;
  final DateTime? lastDateTime;

  const AppDatePicker({
    super.key,
    required this.title,
    this.lastDateTime,
  });

  @override
  State<AppDatePicker> createState() => _AppDatePickerState();
}

class _AppDatePickerState extends State<AppDatePicker> {
  DateTime dTFocusedDate = DateTime.now();
  DateTime pickedDate = DateTime.now();
  int selectedYear = DateTime.now().year;
  DateTime lastDate = DateTime.now();

  late final List<int> _yearList;

  @override
  void initState() {
    super.initState();
    lastDate = widget.lastDateTime ?? DateTime.now();
    if (widget.lastDateTime != null) {
      pickedDate = lastDate;
      dTFocusedDate = pickedDate;
      selectedYear = lastDate.year;
    }

    _yearList = List.generate((lastDate.year - 1950) + 1, (i) => 1950 + i);
  }

  /*@override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.title.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(
                  left: ScreenUtils.height15,
                  right: ScreenUtils.height15,
                  top: ScreenUtils.height20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: bohibaTheme.textTheme.headlineMedium,
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtils.height15,
                vertical: ScreenUtils.height10,
              ),
              child: Row(
                children: [
                  AppDropdown<int>(
                    width: ScreenUtils.width * 0.45,
                    menuHeight: ScreenUtils.height * 0.3,
                    dropDownValue: pickedDate.month,
                    padding: EdgeInsets.zero,
                    items: List.generate(12, (index) => index + 1),
                    labelBuilder: (m) =>
                        DateFormat.MMMM().format(DateTime(0, m)),
                    onChanged: (m) {
                      if (m == null) return;
                      final newDate = DateTime(selectedYear, m, pickedDate.day);
                      if (newDate.isBefore(lastDate) ||
                          isSameDay(newDate, lastDate)) {
                        setState(() {
                          pickedDate = newDate;
                          dTFocusedDate = newDate;
                        });
                      }
                    },
                  ),
                  Gap(10.w),
                  AppDropdown<int>(
                    width: ScreenUtils.width * 0.275,
                    menuHeight: ScreenUtils.height * 0.3,
                    dropDownValue: selectedYear,
                    padding: EdgeInsets.zero,
                    items: _yearList,
                    labelBuilder: (y) => y.toString(),
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
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtils.height15),
              child: SizedBox(
                height: ScreenUtils.height * 0.45, // 👈 IMPORTANT
                child: TableCalendar(
                  currentDay: DateTime.now(),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      pickedDate = selectedDay;
                      dTFocusedDate = focusedDay;
                    });
                  },
                  selectedDayPredicate: (day) => isSameDay(pickedDate, day),
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
                  lastDay: widget.lastDateTime ?? DateTime.now(),
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
              ),
            ),
            PrimaryButton(
              width: ScreenUtils.width * 0.85,
              label: 'Submit',
              onPressed: () => Navigator.pop(context, pickedDate),
            ),
          ],
        ),
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.r),
            topLeft: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                  Text(
                    widget.title,
                    style: bohibaTheme.textTheme.headlineMedium,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: ScreenUtils.height15,
                right: ScreenUtils.height15,
                top: ScreenUtils.height10,
              ),
              child: Row(
                children: [
                  AppDropdown<int>(
                    width: ScreenUtils.width * 0.45,
                    menuHeight: ScreenUtils.height * 0.3,
                    dropDownValue: pickedDate.month,
                    padding: EdgeInsets.zero,
                    items: List.generate(12, (index) => index + 1),
                    labelBuilder: (m) =>
                        DateFormat.MMMM().format(DateTime(0, m)),
                    onChanged: (m) {
                      if (m == null) return;

                      DateTime newDate =
                          DateTime(selectedYear, m, pickedDate.day);
                      if (newDate.isBefore(lastDate) ||
                          isSameDay(newDate, lastDate)) {
                        setState(() {
                          pickedDate = newDate;
                          dTFocusedDate = newDate;
                        });
                      } else {
                        return;
                      }
                    },
                  ),
                  Gap(10.w),
                  AppDropdown<int>(
                    width: ScreenUtils.width * 0.275,
                    menuHeight: ScreenUtils.height * 0.3,
                    dropDownValue: selectedYear,
                    padding: EdgeInsets.zero,
                    items: _yearList,
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
              lastDay: widget.lastDateTime ?? DateTime.now(),
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
            PrimaryButton(
              padding: EdgeInsets.only(
                top: ScreenUtils.height10,
                left: ScreenUtils.height15,
                right: ScreenUtils.height15,
              ),
              label: 'Submit',
              onPressed: () {
                Navigator.pop(context, pickedDate);
              },
            ),
          ],
        ),
      ),
    );
  }
}
