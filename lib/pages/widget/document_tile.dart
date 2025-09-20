import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';

import '/dist/component_exports.dart';

class DocumentTile extends StatelessWidget {
  final String vehicleDocument;
  final String expiryDate;
  final VoidCallback? onPressed;
  final Widget? trailing;
  const DocumentTile({
    super.key,
    this.vehicleDocument = "Document Name",
    this.expiryDate = "expiryDate",
    this.onPressed,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: ScreenUtils.height10,
        horizontal: ScreenUtils.width15,
      ),
      color: BohibaColors.lightGreyColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            vehicleDocument,
            style: bohibaTheme.textTheme.bodyMedium,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                expiryDate,
                style: TextStyle(
                  fontSize: bohibaTheme.textTheme.labelMedium!.fontSize,
                  color: bohibaTheme.textTheme.bodySmall!.color,
                ),
              ),
              Container(
                height: ScreenUtils.height30,
                width: 85,
                // color: Colors.amber,
                alignment: Alignment.center,
                child: trailing,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
