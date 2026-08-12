import '/component/screen_utils.dart';
import '/dist/enums/enum_trip_payment.dart';
import '/extensions/bohiba_extension.dart';
import '/model/trip_model.dart';
import '/theme/bohiba_theme.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TripPaymentSection extends StatelessWidget {
  final List<TripPayment>? payments;
  final void Function(TripPayment payment)? onPaymentTap;
  const TripPaymentSection({super.key, this.payments, this.onPaymentTap});

  @override
  Widget build(BuildContext context) {
    if (payments?.isEmpty ?? true) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: ScreenUtils.height20,
            left: ScreenUtils.height15,
            right: ScreenUtils.height15,
          ),
          child: Text(
            'Payments',
            style: bohibaTheme.textTheme.headlineMedium,
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: payments?.length ?? 0,
          padding: EdgeInsets.only(
            left: ScreenUtils.height15,
            right: ScreenUtils.height15,
          ),
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemBuilder: (context, index) {
            final TripPayment payment = payments![index];
            return InkWell(
              onTap: onPaymentTap != null
                  ? () {
                      onPaymentTap!(payment);
                    }
                  : null,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: ScreenUtils.height10,
                ),
                width: ScreenUtils.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: bohibaTheme.cardColor,
                      child: Icon(
                        Remix.money_rupee_circle_line,
                        color: bohibaTheme.colorScheme.onPrimary,
                      ),
                    ),
                    Gap(ScreenUtils.height15),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          payment.paidBy?.toDisplayLabel() ?? '',
                          maxLines: 1,
                          style: bohibaTheme.textTheme.bodyMedium,
                        ),
                        Text(
                          payment.paymentTime?.toCapitalizedLabel() ?? '',
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                            fontWeight:
                                bohibaTheme.textTheme.bodySmall!.fontWeight,
                            color: bohibaTheme.textTheme.titleMedium!.color,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          payment.amount == null
                              ? ''
                              : '₹ ${payment.amount ?? ''}',
                          style: TextStyle(
                            color: bohibaTheme.colorScheme.onPrimary,
                          ),
                        ),
                        payment.paymentType == null
                            ? const SizedBox.shrink()
                            : Text(
                                EnumTripPaymentTypeExt.fromIndex(
                                      payment.paymentType!,
                                    )?.displayName ??
                                    '',
                                style: TextStyle(
                                  fontSize:
                                      bohibaTheme.textTheme.bodySmall!.fontSize,
                                  fontWeight: bohibaTheme
                                      .textTheme.bodySmall!.fontWeight,
                                  color:
                                      bohibaTheme.textTheme.titleMedium!.color,
                                ),
                              ),
                      ],
                    ),
                    Gap(10.w),
                    Icon(Icons.arrow_forward_ios_rounded)
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
