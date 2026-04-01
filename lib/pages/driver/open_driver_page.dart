import '/routes/app_route.dart';
import '/model/rating_model.dart';
import '/component/bohiba_buttons/primary_button.dart';
import '/dist/component_exports.dart';
import '/pages/widget/linear_box_widget.dart';
import '/theme/bohiba_theme.dart';
import '/controllers/open_driver_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OpenDriverPage extends GetView<OpenDriverController> {
  const OpenDriverPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigateState = Navigator.of(context);
    return Obx(
      () {
        return Scaffold(
          appBar: TitleAppbar(
            title: controller.openDriver.value.profile?.name ?? '',
            popResult: controller.popResult.value,
          ),
          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: ScreenUtils.height10,
                      left: ScreenUtils.width15,
                      right: ScreenUtils.width15,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: ScreenUtils.height * 0.14,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: ScreenUtils.height * 0.14,
                                decoration: BoxDecoration(
                                  color: bohibaTheme.cardColor,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              Gap(30.w),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.h),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          BohibaMarqueeText(
                                            width: ScreenUtils.width * 0.5,
                                            text: controller.openDriver.value.profile?.name ?? '',
                                            overflowText: controller.openDriver.value.profile?.name ?? '',
                                            style: TextStyle(
                                              fontSize: bohibaTheme.textTheme.headlineSmall!.fontSize,
                                              fontWeight: bohibaTheme.textTheme.headlineSmall!.fontWeight,
                                              color: bohibaTheme.textTheme.headlineSmall!.color,
                                            ),
                                            preserFontSize: [bohibaTheme.textTheme.headlineSmall!.fontSize!],
                                          ),
                                          Text(
                                            controller.openDriver.value.profile?.driverUuid ?? '',
                                            style: bohibaTheme.textTheme.titleMedium,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Total Trip',
                                                style: TextStyle(
                                                  fontSize: bohibaTheme.textTheme.titleLarge!.fontSize,
                                                  fontWeight: bohibaTheme.textTheme.titleLarge!.fontWeight,
                                                  color: bohibaTheme.textTheme.titleMedium!.color,
                                                ),
                                              ),
                                              Text(
                                                '${controller.openDriver.value.trips ?? 0}',
                                                style: bohibaTheme.textTheme.headlineSmall,
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Avg. Rating',
                                                style: TextStyle(
                                                  fontSize: bohibaTheme.textTheme.titleLarge!.fontSize,
                                                  fontWeight: bohibaTheme.textTheme.titleLarge!.fontWeight,
                                                  color: bohibaTheme.textTheme.titleMedium!.color,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    controller.avgRating.value.toString(),
                                                    style: bohibaTheme.textTheme.headlineSmall,
                                                  ),
                                                  Gap(5.w),
                                                  Icon(
                                                    Icons.star,
                                                    size: 22,
                                                    color: bohibaTheme.colorScheme.surface,
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        PrimaryButton(
                          padding: EdgeInsets.only(
                            top: ScreenUtils.height20,
                            bottom: ScreenUtils.height15,
                          ),
                          height: 35,
                          width: ScreenUtils.width,
                          label: controller.openDriver.value.profile?.connect == null
                              ? 'Send Connect Request'
                              : controller.openDriver.value.profile?.connect?.toString().toLowerCase() == 'pending'
                                  ? 'Sent'
                                  : controller.openDriver.value.profile?.connect?.toString().toLowerCase() == 'accept'
                                      ? 'Call Driver'
                                      : 'Null',
                          color: controller.openDriver.value.profile?.connect == null
                              ? bohibaTheme.colorScheme.primary
                              : controller.openDriver.value.profile?.connect?.toString().toLowerCase() == 'pending'
                                  ? bohibaTheme.colorScheme.onSurface
                                  : bohibaTheme.colorScheme.onPrimary,
                          onPressed: () async => await controller.connect(),
                        ),
                        Text(
                          'Basic Info',
                          style: bohibaTheme.textTheme.headlineMedium,
                        ),
                        LinearBoxWidget(
                          header: 'UUID',
                          title: controller.openDriver.value.profile?.driverUuid ?? '',
                        ),
                        LinearBoxWidget(
                          header: 'D.O.B',
                          title: controller.openDriver.value.profile?.dob ?? '',
                        ),
                        LinearBoxWidget(
                          header: 'Active Status',
                          title: controller.openDriver.value.profile?.isActive.toString() ?? '',
                        ),
                        LinearBoxWidget(
                          header: 'Last Sync',
                          title: controller.openDriver.value.updatedAt ?? '',
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: ScreenUtils.height20),
                          child: Text(
                            'Address',
                            style: bohibaTheme.textTheme.headlineMedium,
                          ),
                        ),
                        Container(
                          width: ScreenUtils.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            // 'House no, Locality, City, Street, District, State, Country, Pincode',
                            '${controller.openDriver.value.address?.houseNo?.trim() ?? ''} ${controller.openDriver.value.address?.locality?.trim() ?? ''} ${controller.openDriver.value.address?.street?.trim() ?? ''} ${controller.openDriver.value.address?.city?.trim() ?? ''} ${controller.openDriver.value.address?.district?.trim() ?? ''} ${controller.openDriver.value.address?.state?.trim() ?? ''} ${controller.openDriver.value.address?.country?.trim() ?? ''} ${controller.openDriver.value.address?.pinCode?.trim() ?? ''}',

                            style: TextStyle(
                              fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                              fontWeight: bohibaTheme.textTheme.bodyLarge!.fontWeight,
                              color: bohibaTheme.textTheme.titleLarge!.color,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: ScreenUtils.height20),
                          child: Text(
                            'License & Vehicle Details',
                            style: bohibaTheme.textTheme.headlineMedium,
                          ),
                        ),
                        LinearBoxWidget(
                          header: 'Driving License',
                          title: controller.openDriver.value.licenseDetail?.licenseNumber ?? '',
                        ),
                        LinearBoxWidget(
                          header: 'License Status',
                          title: controller.openDriver.value.licenseDetail?.status?.capitalizeFirst ?? '',
                        ),
                        LinearBoxWidget(
                          header: 'COV',
                          title: controller.openDriver.value.licenseDetail?.cov?.toUpperCase() ?? '',
                        ),
                        LinearBoxWidget(header: 'Issued', title: controller.openDriver.value.licenseDetail?.validityFrom ?? ''),
                        LinearBoxWidget(
                          header: 'Expiry',
                          title: controller.openDriver.value.licenseDetail?.validityTill ?? '',
                        ),
                        if (controller.openDriver.value.rating?.isEmpty ?? true)
                          SizedBox.shrink()
                        else
                          Padding(
                            padding: EdgeInsets.only(top: ScreenUtils.height20),
                            child: Text(
                              'Ratings',
                              style: bohibaTheme.textTheme.headlineMedium,
                            ),
                          ),
                        if ((controller.openDriver.value.rating?.isEmpty ?? true) || controller.openDriver.value.rating == null)
                          SizedBox.shrink()
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: controller.openDriver.value.rating?.length ?? 0,
                            padding: EdgeInsets.only(top: ScreenUtils.height15),
                            itemBuilder: (context, index) {
                              RatingModel ratings = controller.openDriver.value.rating![index];
                              return Container(
                                margin: EdgeInsets.only(bottom: ScreenUtils.height10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 15.w,
                                      backgroundColor: bohibaTheme.dividerColor,
                                    ),
                                    Gap(8.w),
                                    SizedBox(
                                      width: ScreenUtils.width * 0.55.w,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ratings.reviewerName ?? '',
                                            style: bohibaTheme.textTheme.labelLarge,
                                          ),
                                          ReadMoreText(
                                            ratings.feedback ?? '',
                                            trimLines: 2,
                                            trimMode: TrimMode.Line,
                                            trimCollapsedText: ' Read more',
                                            trimExpandedText: ' Show less',
                                            style: TextStyle(
                                              fontSize: bohibaTheme.textTheme.labelMedium!.fontSize,
                                              color: bohibaTheme.textTheme.titleMedium!.color,
                                            ),
                                            moreStyle: TextStyle(
                                              fontSize: bohibaTheme.textTheme.labelMedium!.fontSize,
                                              fontWeight: FontWeight.bold,
                                              color: bohibaTheme.primaryColor,
                                            ),
                                            lessStyle: TextStyle(
                                              fontSize: bohibaTheme.textTheme.labelMedium!.fontSize,
                                              fontWeight: FontWeight.bold,
                                              color: bohibaTheme.primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      height: 35.h,
                                      alignment: Alignment.center,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ratings.rating?.toString() ?? '',
                                            style: bohibaTheme.textTheme.labelLarge,
                                          ),
                                          const Icon(
                                            Icons.star_rounded,
                                            color: Colors.amber,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        Gap(110.h)
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: ScreenUtils.width15,
                      right: ScreenUtils.width15,
                    ),
                    child: PrimaryButton(
                      onPressed: () {
                        navigateState
                            .pushNamed(
                          AppRoute.ratingDriver,
                          arguments: controller.openDriver,
                        )
                            .then((onValue) {
                          if (onValue != null) {
                            // controller.isRated();
                          }
                        });
                      },
                      label: 'Rate Driver',
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
