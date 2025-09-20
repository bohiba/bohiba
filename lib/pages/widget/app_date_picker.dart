import '/component/bohiba_colors.dart';
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
  @override
  Widget build(BuildContext context) {
    return Column(
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: bohibaTheme.textTheme.headlineLarge,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context, pickedDate);
                },
                child: Text(
                  'Close',
                  style: TextStyle(
                    fontSize: bohibaTheme.textTheme.headlineMedium!.fontSize,
                    fontWeight:
                        bohibaTheme.textTheme.headlineMedium!.fontWeight,
                    color: BohibaColors.warningColor,
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            left: ScreenUtils.height15,
            right: ScreenUtils.height15,
            bottom: ScreenUtils.height20,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.r),
              topRight: Radius.circular(12.r),
            ),
          ),
          alignment: Alignment.center,
          child: TableCalendar(
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                pickedDate = selectedDay;
                dTFocusedDate = focusedDay;
              });
            },
            onFormatChanged: (format) {

            },
            
            onHeaderTapped: (focusedDay) async {
              int? year = await showDialog<int>(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    title: Text('Select Year'),
                    content: SizedBox(
                      width: 300,
                      height: 300,
                      child: YearPicker(
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                        selectedDate: DateTime(pickedDate.year),
                        onChanged: (DateTime dateTime) {
                          Navigator.pop(ctx, dateTime.year);
                        },
                      ),
                    ),
                  );
                },
              );

              if (year == null) return;
              setState(() {
                dTFocusedDate =
                    DateTime(year, pickedDate.month, pickedDate.day);
              });
            },
            focusedDay: dTFocusedDate,
            firstDay: DateTime(1800),
            lastDay: DateTime.now(),
            currentDay: pickedDate,
            calendarFormat: CalendarFormat.month,
            calendarStyle: CalendarStyle(
              selectedTextStyle: TextStyle(
                fontFamily: bohibaTheme.textTheme.titleSmall!.fontFamily,
                color: bohibaTheme.textTheme.titleLarge!.color,
                
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
                color: BohibaColors.primaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
