import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/controllers/subscription_plan_controller.dart';
import '/theme/bohiba_theme.dart';
import '/component/screen_utils.dart';
import '/component/bohiba_buttons/primary_button.dart';

class SubscriptionPlanScreen extends GetView<SubscriptionPlanController> {
  const SubscriptionPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bohibaTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeader(),
                    Gap(ScreenUtils.height20),
                    _buildPlanSelector(),
                    Gap(ScreenUtils.height20),
                    _buildSelectedPlanDetails(),
                    Gap(ScreenUtils.height30),
                    _buildTrustSection(),
                    Gap(80.h), // Space for sticky CTA
                  ],
                ),
              ),
            ),
            _buildStickyCTA(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon:
                    Icon(Icons.close, color: bohibaTheme.colorScheme.onSurface),
                onPressed: () => Get.back(),
              ),
            ],
          ),
          Gap(10.h),
          Text(
            'Choose the Plan That Fits Your Business',
            style: bohibaTheme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 22.sp,
            ),
            textAlign: TextAlign.center,
          ),
          Gap(8.h),
          Text(
            'Start free. Upgrade only when your business grows.',
            style: bohibaTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPlanSelector() {
    return SizedBox(
      height: 28.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: controller.plans.length,
        itemBuilder: (context, index) {
          return Obx(() {
            final isSelected = controller.selectedPlanIndex.value == index;
            final plan = controller.plans[index];
            return GestureDetector(
              onTap: () => controller.onPlanSelected(index),
              child: Container(
                margin: EdgeInsets.only(right: 12.w),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? bohibaTheme.primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isSelected
                        ? bohibaTheme.primaryColor
                        : Colors.grey[300]!,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  plan.name.split(' ').first, // Short name for tabs
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[700],
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildSelectedPlanDetails() {
    return Obx(() {
      final plan = controller.plans[controller.selectedPlanIndex.value];
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (plan.isPopular)
              Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Text(
                  'Most Popular',
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Text(
              plan.name,
              style: bohibaTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(8.h),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: plan.priceMonthly,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if (plan.priceYearly.isNotEmpty)
                    TextSpan(
                      text: '  ${plan.priceYearly}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
            Gap(8.h),
            Text(
              plan.audienceDescription,
              style: TextStyle(
                  color: Colors.grey[600], fontStyle: FontStyle.italic),
            ),
            Divider(height: 30.h),
            ...plan.limits.map((limit) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Row(
                    children: [
                      Icon(limit.icon,
                          size: 20.sp, color: bohibaTheme.primaryColor),
                      Gap(12.w),
                      Text(limit.text, style: TextStyle(fontSize: 14.sp)),
                    ],
                  ),
                )),
            Divider(height: 30.h),
            ...plan.features.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500],
                      letterSpacing: 1.0,
                    ),
                  ),
                  Gap(12.h),
                  ...entry.value.map((feature) => Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Row(
                          children: [
                            Icon(
                              feature.isIncluded
                                  ? Icons.check_circle
                                  : Icons.lock_outline,
                              size: 18.sp,
                              color: feature.isIncluded
                                  ? Colors.green
                                  : Colors.grey[400],
                            ),
                            Gap(12.w),
                            Expanded(
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      feature.text,
                                      style: TextStyle(
                                        color: feature.isIncluded
                                            ? Colors.black
                                            : Colors.grey[500],
                                      ),
                                    ),
                                  ),
                                  if (feature.tooltip != null)
                                    Padding(
                                      padding: EdgeInsets.only(left: 6.w),
                                      child: Icon(Icons.info_outline,
                                          size: 14.sp, color: Colors.grey[400]),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                  Gap(10.h),
                ],
              );
            }),
            if (plan.isFree)
              Container(
                margin: EdgeInsets.only(top: 10.h),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue, size: 20.sp),
                    Gap(10.w),
                    Expanded(
                      child: Text(
                        'Reports include watermark. Some advanced features are locked.',
                        style:
                            TextStyle(color: Colors.blue[800], fontSize: 12.sp),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildStickyCTA() {
    return Obx(() {
      final plan = controller.plans[controller.selectedPlanIndex.value];
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: PrimaryButton(
            label: plan.ctaText,
            onPressed: () {
              // Handle CTA Logic here (e.g., Navigate to Payment or Contact Form)
              Get.snackbar('Action', 'Selected: ${plan.name}');
            },
            color: plan.isFree ? Colors.white : bohibaTheme.primaryColor,
            // borderColor: plan.isFree ? bohibaTheme.primaryColor : Colors.transparent,
          ),
        ),
      );
    });
  }

  Widget _buildTrustSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(FontAwesomeIcons.shield,
                size: 16.sp, color: Colors.grey[600]),
            Gap(8.w),
            Text('No auto-deduction without confirmation',
                style: TextStyle(color: Colors.grey[600], fontSize: 12.sp)),
          ],
        ),
        Gap(4.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(FontAwesomeIcons.arrowsRotate,
                size: 16.sp, color: Colors.grey[600]),
            Gap(8.w),
            Text('Cancel or downgrade anytime',
                style: TextStyle(color: Colors.grey[600], fontSize: 12.sp)),
          ],
        ),
      ],
    );
  }
}
