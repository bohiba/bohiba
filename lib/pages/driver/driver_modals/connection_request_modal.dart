import 'package:bohiba/services/pref_utils.dart';

import '/dist/app_enums.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/component/screen_utils.dart';
import 'package:bohiba/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConnectionRequestModal extends StatefulWidget {
  final ConnectionType connectionType;
  final Function()? onAction;

  const ConnectionRequestModal({
    super.key,
    required this.connectionType,
    this.onAction,
  });

  @override
  State<ConnectionRequestModal> createState() => _ConnectionRequestModalState();
}

class _ConnectionRequestModalState extends State<ConnectionRequestModal> {
  final PrefUtils _prefUtils = PrefUtils();
  bool showAgain = true;
  @override
  void initState() {
    super.initState();
    showAgain = _prefUtils.getBool(PrefUtils.showConnectDialog);
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(12.r),
      ),
      title: Center(
        child: Text(
          widget.connectionType == ConnectionType.accept
              ? 'Accept Request'
              : 'Reject Request',
        ),
      ),
      titleTextStyle: TextStyle(
        fontSize: bohibaTheme.textTheme.displaySmall!.fontSize,
        color: widget.connectionType == ConnectionType.accept
            ? bohibaTheme.colorScheme.onSurface
            : bohibaTheme.colorScheme.error,
        fontFamily: bohibaTheme.textTheme.titleLarge!.fontFamily,
        fontWeight: bohibaTheme.textTheme.headlineMedium!.fontWeight,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: ScreenUtils.width25,
        vertical: ScreenUtils.height15,
      ),
      alignment: Alignment.center,
      children: [
        Text(
          widget.connectionType == ConnectionType.accept
              ? 'Are you sure you want to share you contact information with this truck owner?'
              : 'Are you sure you don\'t want to share you contact information with this truck owner?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: bohibaTheme.textTheme.titleLarge!.fontSize,
            fontFamily: bohibaTheme.textTheme.titleLarge!.fontFamily,
            fontWeight: bohibaTheme.textTheme.bodyLarge!.fontWeight,
            color: bohibaTheme.textTheme.titleLarge!.color,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                materialTapTargetSize: MaterialTapTargetSize.padded,
                value: showAgain,
                onChanged: (v) {
                  if (v != null) {
                    showAgain = v;
                  }
                  setState(() {});
                },
              ),
              Text(
                "Don't ask me again",
                style: TextStyle(
                  fontSize: bohibaTheme.textTheme.titleLarge!.fontSize,
                  fontFamily: bohibaTheme.textTheme.titleLarge!.fontFamily,
                  fontWeight: bohibaTheme.textTheme.bodyLarge!.fontWeight,
                  color: bohibaTheme.textTheme.titleLarge!.color,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PrimaryButton(
              width: 120.w,
              height: 32.h,
              label: 'NO',
              color: bohibaTheme.colorScheme.primary,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            PrimaryButton(
                width: 120.w,
                height: 32.h,
                label: widget.connectionType == ConnectionType.accept
                    ? 'ACCEPT'
                    : 'REJECT',
                color: widget.connectionType == ConnectionType.accept
                    ? bohibaTheme.colorScheme.onSurface
                    : bohibaTheme.colorScheme.error,
                onPressed: widget.onAction)
          ],
        )
      ],
    );
  }
}
