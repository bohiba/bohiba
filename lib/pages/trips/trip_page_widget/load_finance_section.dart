import '/component/screen_utils.dart';
import '/component/ui/tile_decorative.dart';
import '/extensions/bohiba_extension.dart';
import '/model/trip_model.dart';
import '/pages/widget/role_widget.dart';
import '/pages/widget/vertical_box.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';

class LoadAndFinanceSection extends StatelessWidget {
  final TripModel? trip;
  const LoadAndFinanceSection({super.key, this.trip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: ScreenUtils.height30,
        left: ScreenUtils.height15,
        right: ScreenUtils.height15,
        bottom: ScreenUtils.height10,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: TileDecorative(
                color: bohibaTheme.cardColor.withValues(alpha: 0.5),
              ),
              padding: EdgeInsets.symmetric(
                vertical: ScreenUtils.height10,
                horizontal: ScreenUtils.width15,
              ),
              margin: EdgeInsets.only(right: ScreenUtils.width10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Load Info',
                    style: bohibaTheme.textTheme.headlineMedium,
                  ),
                  TripInfoItem(
                    label: 'Material Type',
                    value: trip?.loadDetail?.materialType?.toCapitalizedLabel() ?? '',
                  ),
                  TripInfoItem(
                    label: 'Load Weight',
                    value: '${trip?.loadDetail?.loadWeight ?? '0.0'} Ton',
                  ),
                  TripInfoItem(
                    label: 'Short Weight',
                    value: '${trip?.loadDetail?.shortWeight ?? '0.0'} Ton',
                  ),
                  TripInfoItem(
                    label: 'Rate per Ton',
                    value: '₹ ${trip?.loadDetail?.rate ?? '0.0'}',
                  ),
                ],
              ),
            ),
          ),
          RoleWidget(
            truckOwnerWidget: Expanded(
              child: Container(
                decoration: TileDecorative(
                  color: bohibaTheme.cardColor.withValues(alpha: 0.5),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: ScreenUtils.height10,
                  horizontal: ScreenUtils.width15,
                ),
                margin: EdgeInsets.only(left: ScreenUtils.width10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Finance Info',
                      style: bohibaTheme.textTheme.headlineMedium,
                    ),
                    TripInfoItem(
                      label: 'Amount',
                      value: '₹ ${trip?.finance?.amount ?? '0.00'}',
                    ),
                    TripInfoItem(
                      label: 'Total Expense',
                      value: '₹ ${trip?.finance?.tripExpense ?? ''}',
                    ),
                    TripInfoItem(
                      label: 'Total Payment',
                      value: '₹ ${trip?.finance?.tripPayment ?? ''}',
                    ),
                    TripInfoItem(
                      label: 'Total Profit',
                      value: '₹ ${trip?.finance?.tripProfit ?? ''}',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
