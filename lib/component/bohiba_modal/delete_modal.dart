import '/theme/bohiba_theme.dart';
import 'package:get/get.dart';
import '/component/bohiba_buttons/secoundary_button.dart';
import '/dist/component_exports.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../bohiba_buttons/primary_button.dart';

class DeleteModal extends GetView {
  final String title;
  final String? subTitle;
  final String description;
  final VoidCallback? onDelete;
  const DeleteModal(
      {super.key,
      this.title = "",
      this.subTitle,
      this.description = "",
      this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtils.width15),
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
              ),
              child: Text(
                title,
                style: bohibaTheme.textTheme.displaySmall,
              ),
            ),
            Text(
              subTitle ?? "",
              textAlign: TextAlign.center,
              style: bohibaTheme.textTheme.bodySmall,
            ),
            Gap(ScreenUtils.height10),
            Padding(
              padding: EdgeInsets.only(
                left: ScreenUtils.width15,
                right: ScreenUtils.width15,
                top: ScreenUtils.height15,
                bottom: ScreenUtils.height15,
              ),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: bohibaTheme.textTheme.titleLarge,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: ScreenUtils.height15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PrimaryButton(
                    width: ScreenUtils.width * 0.65,
                    label: 'DELETE',
                    color: BohibaColors.warningColor,
                    onPressed: onDelete,
                  ),
                  SecoundaryButton(
                    width: ScreenUtils.width * 0.25,
                    label: "NO",
                    textColor: BohibaColors.primaryColor,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
