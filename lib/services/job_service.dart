import 'package:bohiba/dist/controller_exports.dart';
import 'package:bohiba/services/api_end_point.dart';
import 'package:bohiba/services/device_info_service.dart';
import 'package:bohiba/services/dio_serivce.dart';

class JobService {
  static final DioService _dioService = DioService();

  static Future<Map<dynamic, dynamic>?> getJob({required int jobId}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return null;
    }
    GlobalService.showProgress();
    ApiResponse response =
        await _dioService.get('${ApiEndPoint.apiGetJob}/$jobId');
    GlobalService.dismissProgress();
    switch (response.statusCode) {
      case 200:
        if (response.data is Map) {
          return response.data as Map;
        } else {
          return null;
        }
      case 401:
        GlobalService.showAppToast(message: response.message);
        return null;
      default:
        GlobalService.showAppToast(message: 'Something went wrong');
        return null;
    }
  }

  static Future<int> createJob({required Map<String, dynamic> bodyMap}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    GlobalService.showProgress();
    ApiResponse response =
        await _dioService.post(ApiEndPoint.apiCreateJobs, body: bodyMap);
    GlobalService.dismissProgress();
    switch (response.statusCode) {
      case 200 || 201:
        return 1;
      case 401:
        GlobalService.showAppToast(message: response.message);
        return 0;
      default:
        return 0;
    }
  }

  static Future<List<dynamic>> allJobs() async {
    if (!await DeviceInfoService.hasInternet()) {
      return [];
    }

    GlobalService.showProgress();
    ApiResponse response = await _dioService.get(ApiEndPoint.apiAllJobs);
    GlobalService.dismissProgress();
    switch (response.statusCode) {
      case 200:
        if (response.data is List) {
          return response.data;
        } else {
          return [];
        }
      case 401:
        GlobalService.showAppToast(message: response.message);
        return [];
      default:
        GlobalService.showAppToast(message: 'Something went wrong');
        return [];
    }
  }
}
