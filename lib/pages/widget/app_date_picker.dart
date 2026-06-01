import '/component/bohiba_buttons/primary_button.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../component/bohiba_dropdown/app_search_dropdown_button.dart';
import '/dist/component_exports.dart';
import '/component/screen_utils.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';

class AppDatePicker extends StatefulWidget {
  final String title;
  final DateTime? lastDateTime;
  final DateTime? startDateTime;

  const AppDatePicker({
    super.key,
    required this.title,
    this.lastDateTime,
    this.startDateTime,
  });

  @override
  State<AppDatePicker> createState() => _AppDatePickerState();
}

class _AppDatePickerState extends State<AppDatePicker> {
  DateTime dTFocusedDate = DateTime.now();
  DateTime pickedDate = DateTime.now();
  int selectedYear = DateTime.now().year;
  DateTime lastDate = DateTime.now();
  DateTime startDate = DateTime.now();

  late final List<int> _yearList;
  late List<int> _monthList;

  int startMonth = 1;
  int endMonth = 12;

  int _daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

  @override
  void initState() {
    super.initState();
    lastDate = widget.lastDateTime ?? DateTime.now();
    startDate = widget.startDateTime ?? DateTime(1950);
    if (widget.lastDateTime != null) {
      pickedDate = lastDate;
      dTFocusedDate = pickedDate;
      selectedYear = lastDate.year;
    }

    getMonthList(selectedYear);

    _yearList = List.generate(
        (lastDate.year - startDate.year) + 1, (i) => startDate.year + i);
  }

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
                  AppDropdownSearch<int>(
                    width: ScreenUtils.width * 0.45,
                    menuHeight: ScreenUtils.height * 0.3,
                    initialValue: pickedDate.month,
                    padding: EdgeInsets.zero,
                    // items: List.generate(12, (index) => index + 1),
                    items: _monthList,
                    labelBuilder: (m) =>
                        DateFormat.MMMM().format(DateTime(0, m)),
                    onChanged: (m) {
                      if (m == null) return;
                      // Clamp day so e.g. Jan-31 → Feb doesn't overflow to Mar
                      final clampedDay = pickedDate.day
                          .clamp(1, _daysInMonth(selectedYear, m));
                      final newDate = DateTime(selectedYear, m, clampedDay);
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
                  AppDropdownSearch<int>(
                    width: ScreenUtils.width * 0.275,
                    menuHeight: ScreenUtils.height * 0.3,
                    initialValue: selectedYear,
                    padding: EdgeInsets.zero,
                    items: _yearList,
                    labelBuilder: (y) {
                      return y.toString();
                    },
                    onChanged: (y) {
                      if (y == null) return;
                      getMonthList(y);
                      // Resolve month and day for the new year before setState
                      final newMonth = _monthList.contains(pickedDate.month)
                          ? pickedDate.month
                          : _monthList.first;
                      final clampedDay =
                          pickedDate.day.clamp(1, _daysInMonth(y, newMonth));
                      final newDate = DateTime(y, newMonth, clampedDay);
                      setState(() {
                        selectedYear = y;
                        pickedDate = newDate;
                        dTFocusedDate = newDate;
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
              firstDay: startDate,
              lastDay: lastDate,
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

  List<int> getMonthList(int year) {
    startMonth = (year == startDate.year) ? startDate.month : 1;
    // Cap at lastDate.month so the dropdown never offers months beyond the
    // allowed range — selecting them would fail the isBefore guard and the
    // calendar would silently refuse to scroll.
    endMonth = (year == lastDate.year) ? lastDate.month : 12;

    _monthList = List.generate(
      (endMonth - startMonth) + 1,
      (i) => startMonth + i,
    );

    return _monthList;
  }
}
