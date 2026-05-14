import 'package:bohiba/component/screen_utils.dart';
import 'package:bohiba/extensions/ext_truck_waiting_status.dart';
import 'package:bohiba/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MinesLiveQueueStatus extends StatelessWidget {
  final List<QueueStatusList> queueList;
  final List<QueueHeader> header;

  const MinesLiveQueueStatus({
    super.key,
    this.queueList = const [],
    this.header = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ScreenUtils.height15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LIVE QUEUE STATUS',
            style: bohibaTheme.textTheme.headlineLarge,
          ),
          Container(
            // height: 30,
            padding: EdgeInsets.symmetric(vertical: ScreenUtils.height10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: bohibaTheme.dividerColor),
              ),
            ),
            alignment: Alignment.center,
            child: Row(
              children: header.map((toElement) {
                return Expanded(
                  flex: toElement.flex ?? 1,
                  child: Text(
                    toElement.name ?? '',
                    textAlign: toElement.textAlign,
                    style: TextStyle(
                      fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
                      fontWeight: bohibaTheme.textTheme.headlineLarge!.fontWeight,
                      color: bohibaTheme.textTheme.titleSmall!.color,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: queueList.length,
            itemBuilder: (context, rowIndex) {
              final item = queueList[rowIndex];
              return Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: item.owned == 1 ? Colors.grey.shade200 : null,
                  border: Border(
                    bottom: BorderSide(color: bohibaTheme.dividerColor),
                  ),
                ),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        item.id.toString(),
                        style: TextStyle(
                          fontSize: bohibaTheme.textTheme.titleSmall!.fontSize,
                          fontWeight: bohibaTheme.textTheme.headlineLarge!.fontWeight,
                          color: bohibaTheme.textTheme.headlineLarge!.color,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        item.vechileId ?? '',
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 15.w,
                          vertical: 4.h,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                        ),
                        decoration: BoxDecoration(
                          color: item.status?.truckWaitingStatusColor.withAlpha(10),
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(
                            color: item.status?.truckWaitingStatusColor.withAlpha(70) ?? bohibaTheme.colorScheme.error,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          item.status?.truckWaitingStatusName ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: bohibaTheme.textTheme.labelSmall!.fontSize,
                            fontWeight: bohibaTheme.textTheme.headlineLarge!.fontWeight,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(
                          '${item.watingTime ?? ''} min',
                          style: TextStyle(
                            fontSize: bohibaTheme.textTheme.labelSmall!.fontSize,
                            fontWeight: bohibaTheme.textTheme.headlineLarge!.fontWeight,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class QueueHeader {
  int? flex;
  String? name;
  TextAlign? textAlign;
  QueueHeader({this.flex = 1, this.name, this.textAlign});
}

class QueueStatusList {
  int? id;
  String? vechileId;
  String? reachedTime;
  String? entryTime;
  String? exitTime;
  String? watingTime;
  int? status;
  int? owned;

  QueueStatusList({
    this.id,
    this.vechileId,
    this.reachedTime,
    this.entryTime,
    this.exitTime,
    this.watingTime,
    this.status,
    this.owned,
  });
}
