import 'package:bohiba/utils/bohiba_colors.dart';
import 'package:bohiba/utils/screen_utils.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateInputField extends StatefulWidget {
  final String? restorationId;
  final TextEditingController? controller;
  final String? hintText;
  const DateInputField({
    super.key,
    this.restorationId,
    this.controller,
    this.hintText,
  });

  @override
  State<DateInputField> createState() => _DateInputFieldState();
}

class _DateInputFieldState extends State<DateInputField> with RestorationMixin {
  DateFormat dateFormatter = DateFormat('d-MM-yyyy');

  @override
  String? get restorationId => widget.restorationId;
  final RestorableDateTime _selectedDate = RestorableDateTime(DateTime.now());
  late final RestorableRouteFuture<DateTime?> _restorableDateTimeRouteFuture =
      RestorableRouteFuture<DateTime>(
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
    onComplete: _selectDate,
  );

  @pragma('vm:entry-point')
  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? argument,
  ) {
    DateTime now = DateTime.now();
    DateTime lastDate = DateTime(now.year - 18, now.month, now.day);
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialDate: lastDate,
          firstDate: DateTime(1800),
          lastDate: lastDate,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: BohibaResponsiveScreen.width * 0.63,
      height: 47,
      margin: EdgeInsets.symmetric(
        vertical: BohibaResponsiveScreen.height5,
      ),
      child: TextFormField(
        readOnly: true,
        controller: widget.controller,
        onTap: () {
          _restorableDateTimeRouteFuture.present();
        },
        onChanged: (value) {
          setState(() {
            widget.controller!.text =
                dateFormatter.format(_selectedDate.value).toString();
          });
        },
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: Icon(
            EvaIcons.calendarOutline,
            color: bohibaColors.primaryColor,
          ),
        ),
      ),
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDateTimeRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate == null) {
      setState(() {
        _selectedDate.value = DateTime.now();
        widget.controller!.text = dateFormatter.format(DateTime.now());
      });
    } else {
      setState(() {
        _selectedDate.value = newSelectedDate;
        widget.controller!.text =
            dateFormatter.format(_selectedDate.value).toString();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
        ));
      });
    }
  }
}
