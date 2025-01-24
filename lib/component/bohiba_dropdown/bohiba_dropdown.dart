// ignore_for_file: must_be_immutable

import 'package:bohiba/theme/light_theme.dart';
import 'package:flutter/material.dart';

class BohibaDropDown extends StatefulWidget {
  final List<String> items;
  final String hint;
  late String? dropDownValue;

  BohibaDropDown({
    super.key,
    this.hint = "Dropdown",
    this.items = const [],
    this.dropDownValue,
  });

  @override
  State<BohibaDropDown> createState() => _BohibaDropDownState();
}

class _BohibaDropDownState extends State<BohibaDropDown> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      height: 47,
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(width: 1.0, color: Colors.grey.shade300)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          hint: Text(widget.hint),
          value: widget.dropDownValue,
          style: TextStyle(
            fontSize: bohibaTheme.textTheme.bodyLarge!.fontSize,
            color: bohibaTheme.textTheme.bodyLarge!.color,
            letterSpacing: 1.2,
          ),
          icon: const Icon(Icons.keyboard_arrow_down),
          items: widget.items.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(
                items,
                style: TextStyle(
                  fontSize: bohibaTheme.textTheme.bodyLarge!.fontSize,
                  color: bohibaTheme.textTheme.bodyLarge!.color,
                  letterSpacing: 1.2,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              widget.dropDownValue = newValue!;
            });
            debugPrint(widget.dropDownValue);
          },
        ),
      ),
    );
  }
}
