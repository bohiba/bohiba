import 'package:bohiba/utils/bohiba_colors.dart';
import 'package:bohiba/utils/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:bohiba/utils/bohiba_icon.dart';
import 'package:remixicon/remixicon.dart';

class ChooseVehicleWheel extends StatefulWidget {
  const ChooseVehicleWheel({Key? key}) : super(key: key);

  @override
  State<ChooseVehicleWheel> createState() => _ChooseVehicleWheelState();
}

class _ChooseVehicleWheelState extends State<ChooseVehicleWheel> {
  String? wheel = "6";

  // List of items in our dropdown menu
  var items = [
    '6',
    '12',
    '14',
    '16',
    '22',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: BohibaResponsiveScreen.width * 0.27,
      height: 47,
      margin: EdgeInsets.symmetric(
        vertical: BohibaResponsiveScreen.height5,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: BohibaResponsiveScreen.height10,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          width: 1.0,
          color: bohibaColors.borderColor,
        ),
      ),
      child: Row(
        children: [
          ImageIcon(
            AssetImage(BohibaIcons.twoWheel),
            color: bohibaColors.primaryColor,
            size: 24,
          ),
          const VerticalDivider(
            thickness: 1.2,
            endIndent: 5,
            indent: 5,
          ),
          const Spacer(),
          DropdownButtonHideUnderline(
            child: DropdownButton(
              value: wheel,
              borderRadius: BorderRadius.circular(10.0),
              icon: Icon(
                Remix.arrow_down_s_line,
                color: Colors.grey.shade400,
              ),
              items: items.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(
                    items,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  wheel = newValue!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
