import '/dist/enums/enum_trip_status.dart';
import '/services/global_service.dart';
import 'package:intl/intl.dart';
import 'package:remixicon/remixicon.dart';

import '../dist/enums/app_enums.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '/model/trip_model.dart';
import '/services/trip_service.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final _amountFmt = NumberFormat('#,##,##0.##', 'en_IN');

class TripController extends GetxController {
  RefreshController refreshController = RefreshController();

  List<EnumTripStatus> tripStatus =
      EnumTripStatus.values.where((e) => e != EnumTripStatus.archived).toList();
  Rxn<TripModel> tripInfo = Rxn<TripModel>();

  RxString strErrorTitle = ''.obs;
  RxString strErrorDesc = ''.obs;

  @override
  void onInit() {
    super.onInit();
    TripModel? t = Get.arguments;
    Future.delayed(Duration.zero, () async {
      if (t != null && t.id != null) {
        await getTripInfo(id: t.id!);
      }
    });
  }

  List<TripCardClassification> get tripCardClassifications {
    final load = tripInfo.value?.loadDetail;
    final finance = tripInfo.value?.finance;
    final totalPayment = tripInfo.value?.payments?.fold<double>(
          0.0,
          (sum, payment) => sum + (payment.amount ?? 0.0),
        ) ??
        0.0;
    final material = load?.materialType ?? '—';
    final loadWeight = '${_amountFmt.format(load?.loadWeight ?? 0)} T';
    final Icon paymentIndicator = _handleTripTileIndicator(
        finance?.amount ?? 0.0, finance?.tripExpense ?? 0.0);
    final revenueIndicator =
        _handleTripTileIndicator(totalPayment, finance?.amount ?? 0.0);
    return <TripCardClassification>[
      TripCardClassification(
        subHeader: material.toUpperCase(),
        header: loadWeight,
        icon: Remix.loader_line,
        color: bohibaTheme.primaryColor,
      ),
      TripCardClassification(
          subHeader: 'REVENUE',
          header: '₹ ${_amountFmt.format(finance?.amount ?? 0)}',
          icon: Remix.money_rupee_circle_line,
          indicatorIcon: paymentIndicator.icon ?? Icons.drag_handle,
          color: bohibaTheme.colorScheme.onPrimary),
      TripCardClassification(
        subHeader: 'PAYMENT',
        header: '₹ ${_amountFmt.format(totalPayment)}',
        icon: Remix.money_rupee_circle_line,
        color: bohibaTheme.colorScheme.error,
        indicatorIcon: revenueIndicator.icon,
      ),
    ];
  }

  Icon _handleTripTileIndicator(double totalAmount, double totalExpense) {
    if (totalAmount == 0) {
      return Icon(
        Icons.drag_handle,
        color: bohibaTheme.colorScheme.onTertiary,
      );
    } else if (totalAmount == 0.0 && totalExpense == 0.0) {
      return Icon(
        Icons.drag_handle,
        color: bohibaTheme.cardColor,
      );
    } else if (totalAmount > totalExpense) {
      return Icon(
        Remix.arrow_up_double_fill,
        color: bohibaTheme.colorScheme.onPrimary,
      );
    } else if (totalAmount < totalExpense) {
      return Icon(
        Remix.arrow_down_double_fill,
        color: bohibaTheme.colorScheme.tertiary,
      );
    } else {
      return Icon(
        Icons.drag_handle,
        color: bohibaTheme.cardColor,
      );
    }
  }

  Future<void> refreshTripPage() async {
    if (tripInfo.value?.id == null || tripInfo.value?.id == 0) {
      GlobalService.printHandler('TRIP ID IS INVALID ${tripInfo.value?.id}');
      GlobalService.showAppToast(
          message: 'Invalid Trip. Please contact for support.');
      return;
    }

    await getTripInfo(
      id: tripInfo.value!.id!,
      methodType: MethodType.api,
      showLoading: false,
    );
    refreshController.refreshCompleted();
  }

  Future<void> getTripInfo({
    MethodType methodType = MethodType.local,
    bool showLoading = true,
    required int id,
  }) async {
    TripModel? tripModel = await TripService.getTrip(
        method: methodType, tripId: id, showProgress: showLoading);
    if (tripModel != null) {
      tripInfo.value = tripModel;
    } else {
      tripInfo.value = null;
      strErrorTitle.value = 'Trip Not Found';
      strErrorDesc.value = 'Sorry we unable to find this trip';
    }
  }

  RxBool isUpdatingStatus = false.obs;

  Future<void> updateTripStatus(EnumTripStatus status) async {
    if (tripInfo.value?.id == null || isUpdatingStatus.value) return;
    isUpdatingStatus.value = true;
    final int tripId = tripInfo.value!.id!;
    final int success = await TripService.updateTripStatus(
      bodyMap: {'trip_status': status.value},
      trip: tripInfo.value!,
    );
    if (success > 0) {
      await getTripInfo(id: tripId, showLoading: false);
    }
    isUpdatingStatus.value = false;
  }

  Future<int> deleteTrip({required int tripId}) async {
    int deleteSucess = await TripService.deleteTrip(tripId: tripId);
    return deleteSucess;
  }

  Color statusColor() => colorForStatus(tripInfo.value?.tripStatus ?? -1);

  Color colorForStatus(int status) {
    switch (status) {
      case 0: // draft
        return bohibaTheme.colorScheme.secondary.withValues(alpha: 0.85);
      case 1: // pending
        return bohibaTheme.colorScheme.onSurface.withValues(alpha: 0.85);
      case 2: // assigned
        return bohibaTheme.colorScheme.secondary.withValues(alpha: 0.85);
      case 3: // scheduled
        return bohibaTheme.colorScheme.error.withValues(alpha: 0.85);
      case 4: // inProgress
        return bohibaTheme.colorScheme.error.withValues(alpha: 0.85);
      case 5: // completed
        return bohibaTheme.colorScheme.onPrimary.withValues(alpha: 0.65);
      case 6: // delayed
        return bohibaTheme.colorScheme.tertiary.withValues(alpha: 0.85);
      case 7: // onHold
        return bohibaTheme.colorScheme.onSurface.withValues(alpha: 0.65);
      case 8: // cancelled
        return bohibaTheme.colorScheme.error.withValues(alpha: 0.65);
      case 9: // aborted
        return bohibaTheme.colorScheme.tertiary.withValues(alpha: 0.65);
      case 10: // failed
        return bohibaTheme.colorScheme.error.withValues(alpha: 0.65);
      case 11: // disputed
        return bohibaTheme.colorScheme.tertiary.withValues(alpha: 0.85);
      case 12: // closed
        return bohibaTheme.colorScheme.onSurface.withValues(alpha: 0.50);
      default:
        return bohibaTheme.colorScheme.primary.withValues(alpha: 0.85);
    }
  }

  @override
  void onClose() {
    tripInfo.close();
    super.onClose();
  }
}

class TripCardClassification {
  final String header;
  final String subHeader;
  final Color color;
  final IconData icon;
  final IconData? indicatorIcon;

  TripCardClassification({
    required this.header,
    required this.subHeader,
    required this.color,
    this.icon = Icons.error,
    this.indicatorIcon,
  });
}
