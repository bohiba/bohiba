import 'package:remixicon/remixicon.dart';

import '/component/screen_utils.dart';
import '/extensions/bohiba_extension.dart';
import '/model/trip_model.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class TripExpenseSection extends StatelessWidget {
  final List<TripExpense>? expenses;
  final void Function(TripExpense expense)? onExpenseTap;
  const TripExpenseSection({super.key, this.expenses, this.onExpenseTap});

  @override
  Widget build(BuildContext context) {
    if (expenses?.isEmpty ?? true) return SizedBox.shrink();
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
            'Expenses',
            style: bohibaTheme.textTheme.headlineMedium,
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(
            left: ScreenUtils.width15,
            right: ScreenUtils.width15,
          ),
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemCount: expenses?.length ?? 0,
          itemBuilder: (context, index) {
            TripExpense expense = expenses![index];
            return InkWell(
              onTap: onExpenseTap == null
                  ? null
                  : () {
                      onExpenseTap!(expense);
                    },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: ScreenUtils.height10,
                ),
                width: ScreenUtils.width,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: bohibaTheme.cardColor,
                      child: Icon(
                        Remix.arrow_up_circle_line,
                        color: bohibaTheme.colorScheme.tertiary,
                      ),
                    ),
                    Gap(ScreenUtils.height15),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          expense.expenseType?.toCapitalizedLabel() ?? '',
                          maxLines: 1,
                          style: bohibaTheme.textTheme.bodyMedium,
                        ),
                        Text(
                          expense.expenseDate ?? '',
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
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '- ₹ ${expense.paid}',
                            style: TextStyle(
                              color: bohibaTheme.colorScheme.tertiary,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${expense.paymentMode}',
                            style: TextStyle(
                              fontSize:
                                  bohibaTheme.textTheme.bodySmall!.fontSize,
                              fontWeight:
                                  bohibaTheme.textTheme.bodySmall!.fontWeight,
                              color: bohibaTheme.textTheme.titleMedium!.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(10.w),
                    Icon(Remix.arrow_right_s_line),
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
