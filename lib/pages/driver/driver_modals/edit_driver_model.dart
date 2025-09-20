import 'package:get/get.dart';
import '/component/bohiba_inputfield/text_inputfield.dart';
import '/component/bohiba_modal/modal_sub_info_tile.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/component/ui/tile_decorative.dart';
import '/component/screen_utils.dart';
import '/theme/bohiba_theme.dart';
import '/controllers/driver_controller.dart';

class DriverEditModel extends GetView<DriverController> {
  final int index;
  final String name;
  final String mobileNumber;
  final String dob;
  final String vechileNumber;
  final String licenseNumber;
  final String validTill;
  final String cov;
  final String type;
  final bool isFav;
  const DriverEditModel({
    super.key,
    required this.index,
    this.name = '',
    this.dob = '',
    this.mobileNumber = '',
    this.licenseNumber = '',
    this.vechileNumber = '',
    this.validTill = "",
    this.cov = '',
    this.type = "",
    this.isFav = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 5.0,
            width: ScreenUtils.width * 0.25,
            margin: EdgeInsets.symmetric(vertical: ScreenUtils.height10),
            decoration: TileDecorative(),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: ScreenUtils.width15,
              right: ScreenUtils.width15,
              top: ScreenUtils.height15,
              bottom: ScreenUtils.height15,
            ),
            child: Text(
              name,
              style: bohibaTheme.textTheme.headlineMedium,
            ),
          ),
          // Divider(),
          Gap(ScreenUtils.height10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtils.width15),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mobile Number',
                    style: bohibaTheme.textTheme.titleLarge,
                  ),
                  TextInputField(
                    hintText: "Mobile Number",
                    keyboardType: TextInputType.number,
                  ),
                  Text(
                    'Vechile Number',
                    style: bohibaTheme.textTheme.titleLarge,
                  ),
                  SubInfoTile(
                    title: "Mark as favourite",
                    widget: Switch(
                      value: false,
                      onChanged: (value) {
                        // controller.notifyFavouriteListner(markedFav: value);
                      },
                      activeTrackColor: const Color(0xFF047BFC),
                      activeColor: Colors.white,
                    ),
                    enableBorder: false,
                    padding: EdgeInsets.symmetric(
                      vertical: ScreenUtils.height10,
                    ),
                  ),
                  Gap(ScreenUtils.height10),
                  PrimaryButton(
                    width: ScreenUtils.width,
                    label: 'UPDATE',
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Gap(ScreenUtils.height30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
