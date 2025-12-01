import '/dist/app_enums.dart';
import '/extensions/bohiba_extension.dart';
import '/services/global_service.dart';

import '/component/image_path.dart';
import '/component/bohiba_appbar/truck_appbar.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/component/bohiba_buttons/secoundary_button.dart';

import '/routes/app_route.dart';
import '/theme/bohiba_theme.dart';
import '/dist/component_exports.dart';
import '/services/launcher_service.dart';
import '/pages/widget/role_widget.dart';
import '/pages/widget/linear_box_widget.dart';
import '/controllers/truck_controller.dart';

import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class TruckPage extends GetView<TruckController> {
  const TruckPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Scaffold(
          appBar: TruckAppbar(truck: controller.truckModel.value),
          body: SafeArea(
            child: SmartRefresher(
              onRefresh: () async => await controller.onRefreshTruckPage(),
              controller: controller.refreshTruckPage,
              child: (controller.truckModel.value == null)
                  ? TruckNotFoundSection()
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          TruckImageSection(),
                          Padding(
                            padding: EdgeInsets.only(
                              top: ScreenUtils.height10,
                              left: ScreenUtils.width15,
                              right: ScreenUtils.width15,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RelatedPersonSection(),
                                ImportantDateSection(),
                                VehicleDetailSection(),
                                InsuranceSection(),
                              ],
                            ),
                          ),
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

class TruckNotFoundSection extends GetView<TruckController> {
  const TruckNotFoundSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtils.height,
      width: ScreenUtils.width,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            controller.strErrorTitle.value,
            style: bohibaTheme.textTheme.headlineMedium,
          ),
          Text(
            controller.strErrorDes.value,
            textAlign: TextAlign.center,
            style: bohibaTheme.textTheme.titleMedium,
          )
        ],
      ),
    );
  }
}

class TruckImageSection extends GetView<TruckController> {
  const TruckImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.truckModel.value?.truckImage == null) {
          return Container(
            width: ScreenUtils.width,
            height: ScreenUtils.width * 0.5,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bohibaTheme.cardColor,
              image: controller.selectedImg.value == null
                  ? null
                  : DecorationImage(
                      image: FileImage(
                        controller.selectedImg.value!,
                      ),
                      fit: BoxFit.cover,
                    ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox.shrink(),
                controller.selectedImg.value == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 20.h,
                            backgroundColor: bohibaTheme.dividerColor,
                            child: Icon(
                              Icons.camera_alt_outlined,
                              size: 20.h,
                              color: bohibaTheme.colorScheme.tertiary,
                            ),
                          ),
                          Gap(5.h),
                          Text(
                            'Upload your truck image',
                            style: bohibaTheme.textTheme.titleMedium,
                          ),
                        ],
                      )
                    : SizedBox.shrink(),
                if (controller.selectedImg.value == null)
                  PrimaryButton(
                    width: 120.w,
                    height: 8.h,
                    label: 'Upload Image',
                    onPressed: () => controller.pickImage(
                      pickertype: PickerType.gallery,
                    ),
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SecoundaryButton(
                        height: 8.h,
                        onPressed: () => controller.deleteImageFile(controller.selectedImg.value!),
                        label: 'Remove',
                        textStyle: TextStyle(
                          fontFamily: bohibaTheme.textTheme.labelLarge!.fontFamily,
                          color: bohibaTheme.textTheme.displayLarge!.color,
                          fontSize: bohibaTheme.textTheme.labelMedium!.fontSize,
                        ),
                        color: bohibaTheme.colorScheme.error,
                      ),
                      PrimaryButton(
                        width: 120.w,
                        height: 8.h,
                        onPressed: () async => await controller.setImage().then((onValue) async {
                          if (onValue > 0) {
                            await controller.getTruckInfo(truckFetchValue: controller.truckModel.value!.id);
                          }
                        }),
                        label: 'Upload',
                        textStyle: TextStyle(
                          fontFamily: bohibaTheme.textTheme.labelLarge!.fontFamily,
                          color: bohibaTheme.textTheme.displayLarge!.color,
                          fontSize: bohibaTheme.textTheme.labelMedium!.fontSize,
                        ),
                      )
                    ],
                  ),
              ],
            ),
          );
        } else {
          return GestureDetector(
            onLongPress: () {
              GlobalService.showAppToast(message: 'message');
            },
            child: CachedNetworkImage(
              imageUrl: '${ImagePath.truckImage}/${controller.truckModel.value?.truckImage}',
              fit: BoxFit.cover,
              width: ScreenUtils.width,
              height: ScreenUtils.width * 0.5,
              alignment: Alignment.center,
              placeholder: (context, url) => Container(
                color: bohibaTheme.cardColor,
              ),
              errorWidget: (context, url, error) => Container(
                width: ScreenUtils.width,
                height: ScreenUtils.width * 0.5,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: bohibaTheme.cardColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 20.h,
                      child: Icon(
                        Icons.broken_image,
                        size: 20.h,
                      ),
                    ),
                    Gap(5.h),
                    SizedBox(
                      width: ScreenUtils.width * 0.75,
                      child: Text(
                        'Unable to find your image. Please upload your truck image again',
                        textAlign: TextAlign.center,
                        style: bohibaTheme.textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class RelatedPersonSection extends GetView<TruckController> {
  const RelatedPersonSection({super.key});

  @override
  Widget build(BuildContext context) {
    final navigateState = Navigator.of(context);
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RoleWidget(
            driverWidget: Text(
              "Owner Info",
              style: bohibaTheme.textTheme.headlineMedium,
            ),
            truckOwnerWidget: Text(
              "Driver Info",
              style: bohibaTheme.textTheme.headlineMedium,
            ),
          ),
          RoleWidget(
            truckOwnerWidget: controller.isDriverAssigned.isFalse
                ? Center(
                    child: PrimaryButton(
                      height: 35,
                      width: ScreenUtils.width,
                      label: 'Assign Driver',
                      onPressed: () {
                        navigateState.pushNamed(AppRoute.editTruck, arguments: controller.truckModel.value!).then(
                          (onValue) async {
                            if (onValue != null) {
                              await controller.getTruckInfo(
                                truckFetchValue: controller.truckModel.value!.regdNumber!,
                              );
                            }
                          },
                        );
                      },
                    ),
                  )
                : Row(
                    children: [
                      Container(
                        height: 32.h,
                        width: 32.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: bohibaTheme.dividerColor,
                        ),
                        child: controller.truckModel.value!.driverImage == null
                            ? Image.network(
                                GlobalService.getAvatarUrl(
                                  controller.truckModel.value?.driverName ?? '',
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(35.r),
                                child: CachedNetworkImage(
                                  imageUrl: '${ImagePath.profileImage}/${controller.truckModel.value!.driverImage}',
                                  fit: BoxFit.cover,
                                  height: 32.h,
                                  width: 32.h,
                                  placeholder: (context, url) => Container(
                                    color: bohibaTheme.cardColor,
                                  ),
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.broken_image,
                                    size: 20,
                                    color: bohibaTheme.cardColor,
                                  ),
                                ),
                              ),
                      ),
                      Gap(ScreenUtils.height15),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BohibaMarqueeText(
                            width: ScreenUtils.width * 0.35,
                            text: controller.truckModel.value?.driverName?.toCapitalizedLabel() ?? '',
                            overflowText: controller.truckModel.value?.driverName?.toCapitalizedLabel() ?? '',
                            style: bohibaTheme.textTheme.bodyLarge,
                            marqueeTextStyle: bohibaTheme.textTheme.bodyLarge,
                            preserFontSize: [bohibaTheme.textTheme.bodyLarge!.fontSize!],
                          ),
                          Text(
                            controller.truckModel.value?.driverUuid ?? '',
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
                              fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                              color: bohibaTheme.textTheme.titleMedium!.color,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Visibility(
                        visible: controller.truckModel.value?.driverMobileNumber != null || controller.truckModel.value?.driverMobileNumber != '',
                        child: GestureDetector(
                          onTap: () async => await LauncherService.makePhoneCall(
                            controller.truckModel.value!.driverMobileNumber!,
                          ),
                          child: Container(
                            height: ScreenUtils.height30.w,
                            width: ScreenUtils.height30.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: bohibaTheme.colorScheme.onPrimary.withValues(alpha: 0.15),
                            ),
                            child: Icon(
                              Icons.phone_sharp,
                              size: 16.w,
                              color: bohibaTheme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                      Gap(10.w),
                      GestureDetector(
                        onTap: () => GlobalService.showAlertDialog(
                          status: AlertStatus.info,
                          title: 'Remove Driver',
                          description: 'Are you sure you want to remove driver from this truck?',
                          discardBtnTxt: 'Remove',
                          onDiscard: () async => {navigateState.pop(), await controller.removeDriver()},
                          saveBtnTxt: 'NO',
                          onSave: () => navigateState.pop(),
                        ),
                        child: Container(
                          height: ScreenUtils.height30.w,
                          width: ScreenUtils.height30.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: bohibaTheme.colorScheme.error.withValues(alpha: 0.15),
                          ),
                          child: Icon(
                            Icons.remove_circle,
                            size: 16.w,
                            color: bohibaTheme.colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
            driverWidget: Row(
              children: [
                Container(
                  height: 32.h,
                  width: 32.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: bohibaTheme.dividerColor,
                  ),
                  child: controller.truckModel.value!.ownerImage == null
                      ? Image.network(
                          GlobalService.getAvatarUrl(
                            controller.truckModel.value?.ownerImage ?? '',
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(35.r),
                          child: CachedNetworkImage(
                            imageUrl: '${ImagePath.profileImage}/${controller.truckModel.value!.ownerImage}',
                            fit: BoxFit.cover,
                            height: 32.h,
                            width: 32.h,
                            placeholder: (context, url) => Container(
                              color: bohibaTheme.cardColor,
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.broken_image,
                              size: 20,
                              color: bohibaTheme.cardColor,
                            ),
                          ),
                        ),
                ),
                Gap(ScreenUtils.height15),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BohibaMarqueeText(
                      width: ScreenUtils.width * 0.35,
                      text: controller.truckModel.value?.ownerName,
                      overflowText: controller.truckModel.value?.ownerName,
                      style: bohibaTheme.textTheme.bodyLarge,
                      marqueeTextStyle: bohibaTheme.textTheme.bodyLarge,
                      preserFontSize: [bohibaTheme.textTheme.bodyLarge!.fontSize!],
                    ),
                    Text(
                      controller.truckModel.value?.ownerUuid ?? '',
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
                        fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                        color: bohibaTheme.textTheme.titleMedium!.color,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Visibility(
                  visible: controller.truckModel.value?.ownerMobileNumber != null || controller.truckModel.value?.ownerMobileNumber != '',
                  child: GestureDetector(
                    onTap: () async => LauncherService.makePhoneCall(
                      controller.truckModel.value!.ownerMobileNumber!,
                    ),
                    child: Container(
                      height: 36.w,
                      width: 36.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: bohibaTheme.colorScheme.onPrimary.withValues(alpha: 0.25),
                      ),
                      child: Icon(
                        Icons.phone_sharp,
                        size: 16.w,
                        color: bohibaTheme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class ImportantDateSection extends GetView<TruckController> {
  const ImportantDateSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: ScreenUtils.height20,
              bottom: ScreenUtils.height5,
            ),
            child: Text(
              'Important Date',
              style: bohibaTheme.textTheme.headlineMedium,
            ),
          ),
          LinearBoxWidget(
            header: 'Regd. Date',
            title: controller.truckModel.value?.regdDate,
          ),
          LinearBoxWidget(
            header: 'Insurance Upto',
            title: controller.truckModel.value?.insuranceUpto,
          ),
          LinearBoxWidget(
            header: 'Tax Upto',
            title: controller.truckModel.value?.taxUpto,
          ),
          LinearBoxWidget(
            header: 'Pucc Upto',
            title: controller.truckModel.value?.puccUpto,
          ),
          LinearBoxWidget(
            header: 'Last synced',
            title: controller.truckModel.value?.updatedAt,
          ),
        ],
      );
    });
  }
}

class VehicleDetailSection extends GetView<TruckController> {
  const VehicleDetailSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: ScreenUtils.height20,
              bottom: ScreenUtils.height5,
            ),
            child: Text(
              'Vehicle Details',
              style: bohibaTheme.textTheme.headlineMedium,
            ),
          ),
          LinearBoxWidget(
            header: 'Fuel',
            title: controller.truckModel.value?.vhFuelType,
          ),
          LinearBoxWidget(
            header: 'Unladen',
            title: "${controller.truckModel.value?.vhUnladenWeight ?? ''}",
          ),
          LinearBoxWidget(
            header: 'Model Number',
            title: controller.truckModel.value?.vhModel,
          ),
          RoleWidget(
            truckOwnerWidget: LinearBoxWidget(
              header: 'Engine Number',
              title: controller.truckModel.value?.vhEngineNo,
            ),
          ),
          RoleWidget(
            truckOwnerWidget: LinearBoxWidget(
              header: 'Chassis',
              title: controller.truckModel.value?.vhChassisNo,
            ),
          ),
          RoleWidget(
            truckOwnerWidget: LinearBoxWidget(
              header: 'Financer',
              title: controller.truckModel.value?.vhFinancer,
            ),
          ),
        ],
      );
    });
  }
}

class InsuranceSection extends GetView<TruckController> {
  const InsuranceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: ScreenUtils.height20,
              bottom: ScreenUtils.height5,
            ),
            child: Text(
              'Insurance Details',
              style: bohibaTheme.textTheme.headlineMedium,
            ),
          ),
          LinearBoxWidget(
            header: 'Insurance Company',
            title: controller.truckModel.value?.vhInsuranceCompany,
          ),
          LinearBoxWidget(
            header: 'Insurance no',
            title: controller.truckModel.value?.vhInsuranceNo,
          ),
          LinearBoxWidget(
            header: 'Valid Upto',
            title: controller.truckModel.value?.insuranceUpto,
          ),
        ],
      );
    });
  }
}

class OtherSection extends StatelessWidget {
  const OtherSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: ScreenUtils.height20,
            bottom: ScreenUtils.height5,
          ),
          child: Text(
            'Other Details',
            style: bohibaTheme.textTheme.headlineMedium,
          ),
        ),
      ],
    );
  }
}
