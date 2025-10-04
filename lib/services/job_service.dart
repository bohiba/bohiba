import '/services/global_service.dart';
import '/services/api_end_point.dart';
import '/services/device_info_service.dart';
import '/services/dio_serivce.dart';

class JobService {
  static final DioService _dioService = DioService();

  static Future<void> updateJob(
      {required Map<dynamic, dynamic> jobInfo}) async {
    return;
  }

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

  static Future<int> updateJobPost({required Map jobInfo}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    Map<String, dynamic> bodyMap = {
      "start_from": jobInfo['start_from'],
      "status": jobInfo['status'],
      "job_title": jobInfo['job_title'],
      "location": jobInfo['location'],
      "regd_number": jobInfo['regd_number'],
      "license_type": jobInfo['license_type'],
      "job_type": jobInfo['job_type'],
      "description": jobInfo['description'],
    };

    GlobalService.showProgress();
    ApiResponse response = await _dioService
        .post("${ApiEndPoint.apiEditJob}/${jobInfo['id']}", body: bodyMap);
    GlobalService.dismissProgress();

    switch (response.statusCode) {
      case 200:
        GlobalService.showAppToast(message: response.message);
        return 1;
      case 401:
        GlobalService.showAppToast(message: response.message);
        return 0;
      default:
        GlobalService.showAppToast(message: 'Something went wrong');
        return 0;
    }
  }
}
