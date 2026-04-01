import '../dist/enums/app_enums.dart';
import '/model/job_detail_model.dart';

import '/services/global_service.dart';
import '/services/api_end_point.dart';
import '/services/device_info_service.dart';
import '/services/dio_serivce.dart';

class OwnerJobService {
  static final DioService _dioService = DioService();

  static Future<List<InterestedDriver>?> allApplicant({required int jobId, bool showLoading = false}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return null;
    }
    if (showLoading) GlobalService.showProgress();
    ApiResponse response = await _dioService.get("${ApiEndPoint.apiApplicants}/$jobId");
    if (showLoading) GlobalService.dismissProgress();
    switch (response.statusCode) {
      case 200:
        if (response.data is List) {
          List<dynamic> arrFetch = response.data;
          List<InterestedDriver> arrIntDriver = arrFetch.map((e) {
            return InterestedDriver.fromMap(e);
          }).toList();
          return arrIntDriver;
        } else {
          return null;
        }
      case 401:
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          title: 'Jobs',
          desc: response.message,
        );
        return null;
      default:
        GlobalService.showSnackBar(
          status: AlertStatus.failure,
          title: 'Jobs',
          desc: 'Failed to fetch jobs',
        );
        return null;
    }
  }

  static Future<void> updateJob({required Map<dynamic, dynamic> jobInfo}) async {
    return;
  }

  static Future<JobDetailModel?> getJob({required int jobId}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return null;
    }
    GlobalService.showProgress();
    ApiResponse response = await _dioService.get('${ApiEndPoint.apiGetJob}/$jobId');
    GlobalService.dismissProgress();
    switch (response.statusCode) {
      case 200:
        if (response.data is Map) {
          JobDetailModel jobDetailModel = JobDetailModel.fromMap(response.data);
          return jobDetailModel;
        } else {
          return null;
        }
      case 401:
        GlobalService.showAppToast(message: response.message);
        return null;
      default:
        GlobalService.showAppToast(message: 'Failed to get jobs');
        return null;
    }
  }

  static Future<int> createJob({required Map<String, dynamic> bodyMap}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    GlobalService.showProgress();
    ApiResponse response = await _dioService.post(ApiEndPoint.apiCreateJobs, body: bodyMap);
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

  static Future<List<JobDetailModel>?> allJobs() async {
    if (!await DeviceInfoService.hasInternet()) {
      return null;
    }

    GlobalService.showProgress();
    ApiResponse response = await _dioService.get(ApiEndPoint.apiAllJobs);
    GlobalService.dismissProgress();
    switch (response.statusCode) {
      case 200:
        if (response.data is List) {
          List<dynamic> arrFetch = response.data;
          List<JobDetailModel> arrJobDetail = arrFetch.map((e) {
            return JobDetailModel.fromMap(e);
          }).toList();
          return arrJobDetail;
        } else {
          return null;
        }
      case 401:
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          title: 'Jobs',
          desc: response.message,
        );
        return null;
      default:
        GlobalService.showSnackBar(
          status: AlertStatus.failure,
          title: 'Jobs',
          desc: 'Failed to fetch jobs',
        );
        return null;
    }
  }

  static Future<int> updateJobPost({required JobDetailModel jobInfo, required String status}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    Map<String, dynamic> bodyMap = {
      "start_from": jobInfo.startFrom,
      "status": status,
      "job_title": jobInfo.jobTitle,
      "location": jobInfo.location,
      "regd_number": jobInfo.regdNumber,
      "license_type": jobInfo.licenseType,
      "job_type": jobInfo.jobType,
      "description": jobInfo.description,
    };

    GlobalService.showProgress();
    ApiResponse response = await _dioService.post("${ApiEndPoint.apiEditJob}/${jobInfo.id}", body: bodyMap);
    GlobalService.dismissProgress();

    switch (response.statusCode) {
      case 200:
        GlobalService.showAppToast(message: response.message);
        return 1;
      case 401:
        GlobalService.showAppToast(message: response.message);
        return 0;
      default:
        GlobalService.showAppToast(message: 'Failed to get job service');
        return 0;
    }
  }
}
