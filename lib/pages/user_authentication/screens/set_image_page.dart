import '/controllers/user_profile_config_controller.dart';
import 'package:get/get.dart';
import '/component/image_upload_widget.dart';
import '/routes/app_route.dart';
import 'package:widgets_easier/widgets_easier.dart';
import '/dist/app_enums.dart';
import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';
import '/component/bohiba_buttons/primary_button.dart';
import 'package:flutter/material.dart';

class SetImagePage extends GetView<UserProfileConfigController> {
  const SetImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        Widget content = SizedBox();
        UploadStatus checkStatus = controller.status.value;
        if (checkStatus == UploadStatus.initial) {
          content = InitialImageUploadWidget<UserProfileConfigController>();
        } else if (checkStatus == UploadStatus.uploading) {
          content = OnUploadingImageWidget<UserProfileConfigController>();
        } else if (checkStatus == UploadStatus.success) {
          content = OnFetchingImageSuccessWidget<UserProfileConfigController>();
        } else if (checkStatus == UploadStatus.failure) {
          content = OnFetchingImageErrorWidget<UserProfileConfigController>();
        } else {
          content = SizedBox();
        }

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) {
              return;
            }
          },
          child: Scaffold(
            body: SafeArea(
              child: Container(
                height: ScreenUtils.height,
                width: ScreenUtils.width,
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtils.width25,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Upload your photo',
                                style: bohibaTheme.textTheme.displayMedium,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Enhance your visibility with your image',
                                style: TextStyle(
                                  fontSize:
                                      bohibaTheme.textTheme.bodySmall!.fontSize,
                                  fontWeight: bohibaTheme
                                      .textTheme.bodySmall!.fontWeight,
                                  color:
                                      bohibaTheme.textTheme.titleLarge!.color,
                                ),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: (controller.selectedImg == null ||
                                  (controller.uploadPrgs.value * 100).toInt() !=
                                      100)
                              ? () {
                                  Navigator.of(context)
                                      .pushNamed(AppRoute.roleType);
                                }
                              : null,
                          child: Text(
                            'Skip for now',
                            style: TextStyle(
                              fontSize:
                                  bohibaTheme.textTheme.titleLarge!.fontSize,
                              fontWeight:
                                  bohibaTheme.textTheme.bodySmall!.fontWeight,
                              color: (controller.selectedImg == null) ||
                                      ((controller.uploadPrgs.value * 100)
                                              .toInt() !=
                                          100)
                                  ? bohibaTheme.textTheme.bodySmall!.color
                                  : bohibaTheme.textTheme.titleSmall!.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: ScreenUtils.height * 0.35,
                      width: double.maxFinite,
                      margin:
                          EdgeInsets.symmetric(vertical: ScreenUtils.height30),
                      decoration: ShapeDecoration(
                        shape: DashedBorder(
                          radius: 12.0,
                          width: 1.5,
                          color: BohibaColors.borderColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: content,
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(bottom: ScreenUtils.height47),
                      child: PrimaryButton(
                        onPressed: (controller.selectedImg == null) ||
                                ((controller.uploadPrgs * 100).toInt() != 100)
                            ? null
                            : () {
                                Navigator.of(context)
                                    .popAndPushNamed(AppRoute.roleType);
                              },
                        label: 'Submit',
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
