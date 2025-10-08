import '/controllers/user_profile_config_controller.dart';
import 'package:get/get.dart';
import '/component/image_upload_widget.dart';
import '/routes/app_route.dart';
import '/dist/app_enums.dart';
import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';
import '/component/bohiba_buttons/primary_button.dart';
import 'package:flutter/material.dart';

class SetImagePage extends GetView<UserProfileConfigController> {
  const SetImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigateState = Navigator.of(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
      },
      child: Scaffold(
        body: Obx(() {
          Widget content = SizedBox();
          UploadStatus checkStatus = controller.status.value;
          if (checkStatus == UploadStatus.initial) {
            content = InitialImageUploadWidget<UserProfileConfigController>();
          } else if (checkStatus == UploadStatus.uploading) {
            content = OnUploadingImageWidget<UserProfileConfigController>();
          } else if (checkStatus == UploadStatus.success) {
            content =
                OnFetchingImageSuccessWidget<UserProfileConfigController>();
          } else if (checkStatus == UploadStatus.failure) {
            content = OnFetchingImageErrorWidget<UserProfileConfigController>();
          } else {
            content = SizedBox.shrink();
          }
          return SafeArea(
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
                              style: bohibaTheme.textTheme.headlineLarge,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Enhance your visibility with your image',
                              style: TextStyle(
                                fontSize:
                                    bohibaTheme.textTheme.bodySmall!.fontSize,
                                fontWeight:
                                    bohibaTheme.textTheme.bodySmall!.fontWeight,
                                color: bohibaTheme.textTheme.titleLarge!.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          navigateState.popAndPushNamed(AppRoute.roleType);
                        },
                        child: Text(
                          'Skip for now',
                          style: TextStyle(
                            fontSize:
                                bohibaTheme.textTheme.titleLarge!.fontSize,
                            fontWeight:
                                bohibaTheme.textTheme.bodySmall!.fontWeight,
                            color: bohibaTheme.textTheme.bodySmall!.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  content,
                  Spacer(),
                  PrimaryButton(
                    onPressed: ((controller.uploadPrgs * 100).toInt() != 100)
                        ? null
                        : () async {
                            int isUploaded = await controller.uploadImage();
                            if (isUploaded > 0) {
                              navigateState.popAndPushNamed(AppRoute.roleType);
                            }
                          },
                    label: 'Submit',
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
