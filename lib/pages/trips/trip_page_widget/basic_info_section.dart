import '/component/screen_utils.dart';
import '/extensions/bohiba_extension.dart';
import '/model/trip_model.dart';
import '/pages/widget/linear_box_widget.dart';
import '/pages/widget/role_widget.dart';
import '/pages/widget/status_box_widget.dart';
import '/routes/app_route.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';

class BasicInfoSection extends StatelessWidget {
  final TripModel? tripInfo;
  final Color? statusLabelColor;
  const BasicInfoSection({
    super.key,
    this.tripInfo,
    this.statusLabelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: ScreenUtils.height15,
        right: ScreenUtils.height15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: ScreenUtils.height20),
            child: Text(
              'Basic Info',
              style: bohibaTheme.textTheme.headlineMedium,
            ),
          ),
          LinearBoxWidget(
            onClick: () {},
            header: 'Transporter',
            title: tripInfo?.transporter?.toDisplayLabel(),
          ),
          LinearBoxWidget(
            onClick: () {
              Navigator.pushNamed(
                context,
                AppRoute.truck,
                arguments: tripInfo?.truck!.regdNumber,
              );
            },
            header: 'Truck',
            title: tripInfo?.truck?.regdNumber,
          ),
          RoleWidget(
            truckOwnerWidget: LinearBoxWidget(
              header: 'Driver',
              title: tripInfo?.driver?.name ?? 'No driver',
            ),
            driverWidget: LinearBoxWidget(
              header: 'Owner',
              title: tripInfo?.owner?.name,
            ),
          ),
          StatusBoxWidget(
            header: 'Status',
            title: tripInfo?.tripStatus ?? '',
            statusColor: statusLabelColor,
          ),
        ],
      ),
    );
  }
}
