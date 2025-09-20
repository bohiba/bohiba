import '/dist/app_enums.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';
import '/component/bohiba_buttons/primary_button.dart';

class InfoScreen extends StatelessWidget {
  final String? subtitle;
  final String buttonText;
  final StatusMessage? status;
  final VoidCallback? onPressed;
  const InfoScreen({
    super.key,
    this.subtitle,
    this.buttonText = "Ok",
    this.onPressed,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (status) {
      case StatusMessage.success:
        content = SuccessStatusWidget(
          subtitle: subtitle,
          buttonText: buttonText,
          onPressed: onPressed,
        );
        break;
      case StatusMessage.failure:
        content = FailureStatusWidget(
          subtitle: subtitle,
          buttonText: buttonText,
          onPressed: onPressed,
        );
        break;
      case StatusMessage.warning:
        content = WarningStatusWidget(
          subtitle: subtitle,
          buttonText: buttonText,
          onPressed: onPressed,
        );
      default:
        content = Container();
    }
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: Container(
          width: ScreenUtils.width,
          height: ScreenUtils.height,
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtils.width20,
          ),
          child: content,
        ),
      ),
    );
  }
}

class FailureStatusWidget extends StatelessWidget {
  final String? subtitle;
  final String buttonText;
  final VoidCallback? onPressed;
  const FailureStatusWidget({
    super.key,
    this.subtitle,
    this.buttonText = "Ok",
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Color infoColor = BohibaColors.errorColor;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Spacer(),
        CircleAvatar(
            radius: 65,
            backgroundColor: infoColor.withValues(alpha: 0.25),
            child: Icon(EvaIcons.alertTriangle, size: 55, color: infoColor)),
        Gap(ScreenUtils.height25),
        Text(
          'Failed',
          style: TextStyle(
            fontSize: bohibaTheme.textTheme.displayMedium!.fontSize,
            color: infoColor,
          ),
        ),
        Text(
          subtitle ?? '',
          style: TextStyle(
            fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
            fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
            color: bohibaTheme.textTheme.titleSmall!.color,
          ),
          textAlign: TextAlign.center,
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.only(bottom: ScreenUtils.height30),
          child: PrimaryButton(
            onPressed: onPressed,
            label: buttonText,
            color: infoColor,
          ),
        ),
      ],
    );
  }
}

class WarningStatusWidget extends StatelessWidget {
  final String? subtitle;
  final String buttonText;
  final VoidCallback? onPressed;
  const WarningStatusWidget({
    super.key,
    this.subtitle,
    this.buttonText = 'Ok',
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Color infoColor = BohibaColors.warningColor;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Spacer(),
        CircleAvatar(
            radius: 65,
            backgroundColor: infoColor.withValues(alpha: 0.25),
            child: Icon(EvaIcons.alertTriangle, size: 55, color: infoColor)),
        Gap(ScreenUtils.height25),
        Text(
          "Warning",
          style: TextStyle(
            fontSize: bohibaTheme.textTheme.displayMedium!.fontSize,
            color: infoColor,
          ),
        ),
        Text(
          subtitle ?? '',
          style: TextStyle(
            fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
            fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
            color: bohibaTheme.textTheme.titleSmall!.color,
          ),
          textAlign: TextAlign.center,
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.only(bottom: ScreenUtils.height30),
          child: PrimaryButton(
            onPressed: onPressed,
            label: buttonText,
            color: infoColor,
          ),
        ),
      ],
    );
  }
}

class SuccessStatusWidget extends StatelessWidget {
  final String? subtitle;
  final String buttonText;
  final VoidCallback? onPressed;
  const SuccessStatusWidget({
    super.key,
    this.subtitle,
    this.buttonText = "Ok",
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Color infoColor = BohibaColors.successColor;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Spacer(),
        CircleAvatar(
            radius: 65,
            backgroundColor: infoColor.withValues(alpha: 0.25),
            child:
                Icon(Remix.checkbox_circle_fill, size: 80, color: infoColor)),
        Gap(ScreenUtils.height25),
        Text(
          "Success",
          style: TextStyle(
            fontSize: bohibaTheme.textTheme.displayMedium!.fontSize,
            color: infoColor,
          ),
        ),
        Text(
          subtitle ?? '',
          style: TextStyle(
            fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
            fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
            color: bohibaTheme.textTheme.titleSmall!.color,
          ),
          textAlign: TextAlign.center,
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.only(bottom: ScreenUtils.height30),
          child: PrimaryButton(
            onPressed: onPressed,
            label: buttonText,
            color: infoColor,
          ),
        ),
      ],
    );
  }
}
