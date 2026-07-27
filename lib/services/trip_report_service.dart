import 'package:bohiba/model/pdf_generate_model.dart';

import '/core/network/dio_serivce.dart';
import '/model/trip_report_model.dart';
import '/services/api_end_point.dart';
import '/services/device_info_service.dart';
import '/services/global_service.dart';
import '/dist/enums/app_enums.dart';

class TripReportService {
  static final DioService _dioService = DioService();

  static Future<List<TripReportModel>?> searchTrips(
      TripReportFilter filter) async {
    if (!await DeviceInfoService.hasInternet()) return null;
    GlobalService.showProgress();
    final res = await _dioService.get(
      ApiEndPoint.apiTripReportFilter,
      queryParams: filter.toJson(),
    );
    GlobalService.dismissProgress();
    if (res.statusCode == 200) {
      final list = res.data as List? ?? [];
      return list
          .map((e) => TripReportModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    GlobalService.showSnackBar(
      status: AlertStatus.failure,
      title: 'Trip Report',
      desc: res.message,
    );
    return null;
  }

  static Future<PdfGenerateModel?> generateReport(List<int> tripIds) async {
    if (!await DeviceInfoService.hasInternet()) return null;
    final res = await _dioService.post(
      ApiEndPoint.apiTripReportGenerate,
      body: {'trip_ids': tripIds},
    );
    if (res.statusCode == 200) {
      return PdfGenerateModel.fromJson(res.data as Map<String, dynamic>);
    }
    GlobalService.showSnackBar(
      status: AlertStatus.failure,
      title: 'Trip Report',
      desc: res.errorMessage,
    );
    return null;
  }
}
