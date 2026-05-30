import 'package:bohiba/dist/enums/enum_role_validation.dart';

import '../../../dist/enums/app_enums.dart';
import '/services/global_service.dart';

import '/routes/app_route.dart';
import '/theme/bohiba_theme.dart';
import '/pages/widget/icon_text_tile.dart';
import '/component/screen_utils.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/controllers/set_role_controller.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SetRolePage extends GetView<SetRoleController> {
  const SetRolePage({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigateState = Navigator.of(context);
    return Scaffold(
      appBar: null,
      body: Obx(() {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) {
              return;
            } else {
              GlobalService.showAlertDialog(
                status: AlertStatus.failure,
                title: 'Verification',
                description:
                    'Are your sure? You want to discontinue you verification process',
                discardBtnTxt: 'No',
                saveBtnTxt: 'Yes',
                onSave: () {
                  Get.offAllNamed(AppRoute.signIn);
                },
              );
            }
          },
          child: SafeArea(
            child: Container(
              height: ScreenUtils.height,
              width: ScreenUtils.width,
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtils.width20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  Text(
                    'Select User Role',
                    style: bohibaTheme.textTheme.headlineLarge,
                  ),
                  Text(
                    'Choose your user type to rate and connect better',
                    style: TextStyle(
                      fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                      fontWeight: bohibaTheme.textTheme.titleSmall!.fontWeight,
                      color: bohibaTheme.textTheme.titleSmall!.color,
                    ),
                  ),
                  Gap(ScreenUtils.height10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.userRoleList.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          color: controller.roleObj.value?.roleId ==
                                  controller.userRoleList[index].roleId
                              ? bohibaTheme.cardColor
                              : Colors.transparent,
                          child: IconTextTile(
                            padding: EdgeInsets.all(ScreenUtils.width10),
                            onTap: () {
                              controller.roleObj.value =
                                  controller.selectRole(index);
                            },
                            text:
                                controller.userRoleList[index].label.toString(),
                            subtitle: controller.userRoleList[index].subTitle
                                .toString(),
                            widget: RadioGroup(
                              groupValue: controller.selectedIndex.value,
                              onChanged: (v) {
                                if (v == null) {
                                } else {
                                  controller.roleObj.value =
                                      controller.selectRole(index);
                                }
                              },
                              child: Radio(value: index),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(bottom: ScreenUtils.height30),
                    child: PrimaryButton(
                      onPressed: controller.roleObj.value == null
                          ? null
                          : () async {
                              int sucess = await controller.setRole();
                              EnumRoleValidation validationType =
                                  controller.enumRoleValidation.value;

                              UserRoleType role =
                                  UserRoleType.values.firstWhere(
                                (e) =>
                                    e.value == controller.roleObj.value?.roleId,
                                orElse: () => UserRoleType.guest,
                              );

                              if (sucess <= 0) return;

                              switch (validationType) {
                                case EnumRoleValidation.whileSignIn:
                                  switch (role) {
                                    case UserRoleType.truckOwner:
                                      navigateState.pushNamedAndRemoveUntil(
                                        AppRoute.truckOwnerNavBar,
                                        (_) => false,
                                      );
                                      break;
                                    case UserRoleType.driver:
                                      navigateState.pushNamedAndRemoveUntil(
                                        AppRoute.truckDriverNavBar,
                                        (_) => false,
                                      );
                                      break;
                                    default:
                                      navigateState.popUntilWithResult(
                                        (route) =>
                                            route.settings.name ==
                                            AppRoute.signIn,
                                        null,
                                      );
                                  }
                                  break;
                                case EnumRoleValidation.whileSignUp:
                                  navigateState.popAndPushNamed(
                                    AppRoute.userAuthScreen,
                                    arguments: {
                                      "role_id": role.value,
                                      "token": controller.token.value,
                                      "canPop": controller.canPop,
                                    },
                                  );
                                  break;
                                case EnumRoleValidation.whileUpdating:
                                  navigateState.pop();
                                  break;
                                default:
                                  navigateState.popUntilWithResult(
                                    (route) =>
                                        route.settings.name == AppRoute.signIn,
                                    null,
                                  );
                              }
                            },
                      label: "Set Role",
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
