// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class BohibaDropDown extends StatefulWidget {
  final List<String> items;
  final String hint;
  late String? dropDownValue;

  BohibaDropDown({
    Key? key,
    this.hint = "Label",
    this.items = const [],
    this.dropDownValue,
  }) : super(key: key);

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
          style: Theme.of(context).textTheme.bodyMedium,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: widget.items.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(
                items,
                style: Theme.of(context).textTheme.bodyLarge,
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
