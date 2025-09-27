import '/component/bohiba_colors.dart';
import '/component/screen_utils.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import '/component/image_path.dart';
import 'package:remixicon/remixicon.dart';

class ChooseVehicleWheel extends StatefulWidget {
  const ChooseVehicleWheel({super.key});

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
      width: ScreenUtils.width * 0.27,
      height: 47,
      margin: EdgeInsets.symmetric(
        vertical: ScreenUtils.height5,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtils.width10,
        vertical: ScreenUtils.height10,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          width: 1.0,
          color: BohibaColors.borderColor,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ImageIcon(
            AssetImage(ImagePath.twoWheel),
            color: BohibaColors.primaryColor,
            size: 24,
          ),
          const VerticalDivider(
            thickness: 1.2,
            endIndent: 5,
            indent: 5,
          ),
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
                    style: bohibaTheme.textTheme.bodyMedium,
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