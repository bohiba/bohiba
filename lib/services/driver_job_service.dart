import '../model/user_model.dart';

import 'api_end_point.dart';
import 'device_info_service.dart';
import 'global_service.dart';
import '../core/network/dio_serivce.dart';

import '../dist/enums/app_enums.dart';
import '/model/job_detail_model.dart';

class DriverJobService {
  static final DioService _dioService = DioService();
  static int _currentPage = 1;
  static int _lastPage = 1;
  static int _currentAppliedPage = 1;
  static int _lastAppliedPage = 1;

  static Future<int> updateStatus(ConnectionType type, int id) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }

    GlobalService.showProgress();
    Map<String, dynamic> bodyMap = {'status': type.name};
    ApiResponse res = await _dioService.post('${ApiEndPoint.apiAllRespond}/$id', body: bodyMap);
    GlobalService.dismissProgress();
    switch (res.statusCode) {
      case 200:
        return 1;
      case 401:
        return 0;
      default:
        return 0;
    }
  }

  static Future<List<UserModel>?> getAllRecivedRequest({
    bool showProgress = true,
    bool reset = false,
  }) async {
    if (!await DeviceInfoService.hasInternet()) {
      return null;
    }

    if (reset) {
      _currentPage = 1;
      _lastPage = 1;
    }

    if (_currentPage > _lastPage) {
      return null;
    }
    if (showProgress) GlobalService.showProgress();
    ApiResponse res = await _dioService.get(ApiEndPoint.apiAllRecvdReq);
    if (showProgress) GlobalService.dismissProgress();
    switch (res.statusCode) {
      case 200:
        List arrDriverJob = res.data;
        List<UserModel> arrJobDetailModel = arrDriverJob.map((e) {
          return UserModel.fromJson(e);
        }).toList();

        return arrJobDetailModel;
      case 401:
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          title: 'Job',
          desc: res.message,
        );
        return null;
      default:
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          title: 'Job',
          desc: res.message,
        );
        return null;
    }
  }

  static Future<List<JobDetailModel>?> getAllDriverJob({
    MethodType type = MethodType.local,
    bool showProgress = true,
    bool reset = false,
  }) async {
    if (!await DeviceInfoService.hasInternet()) {
      return null;
    }

    if (reset) {
      _currentPage = 1;
      _lastPage = 1;
    }

    if (_currentPage > _lastPage) {
      return null;
    }
    if (showProgress) GlobalService.showProgress();
    ApiResponse res = await _dioService.get(ApiEndPoint.apiDriverJob);
    if (showProgress) GlobalService.dismissProgress();
    switch (res.statusCode) {
      case 200:
        List arrDriverJob = res.data;
        List<Map<String, dynamic>> arrMapDriverJob = arrDriverJob.map((e) {
          return JobDetailModel.toDB(e);
        }).toList();

        List<JobDetailModel> arrJobDetailModel = arrMapDriverJob.map((e) {
          return JobDetailModel.fromDB(e);
        }).toList();

        return arrJobDetailModel;
      case 401:
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          title: 'Job',
          desc: res.message,
        );
        return null;
      default:
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          title: 'Job',
          desc: res.message,
        );
        return null;
    }
  }

  Future<void> getDriverJob() async {}

  static Future<int> applyToJob({required int jobId}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    GlobalService.showProgress();
    ApiResponse res = await _dioService.post('${ApiEndPoint.apiApplyToJob}/$jobId');
    GlobalService.dismissProgress();
    switch (res.statusCode) {
      case 200:
        GlobalService.showSnackBar(
          status: AlertStatus.success,
          title: 'Job',
          desc: 'Applied',
        );
        return 1;

      case 401:
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          title: 'Job',
          desc: res.message,
        );
        return 0;
      default:
        GlobalService.showSnackBar(
          status: AlertStatus.failure,
          title: 'Job',
          desc: 'Failed to apply. Retry Again',
        );
        return 0;
    }
  }

  static Future<List<JobDetailModel>?> getAppliedJobs({
    bool showProgress = true,
    bool reset = false,
  }) async {
    if (!await DeviceInfoService.hasInternet()) {
      return null;
    }

    if (reset) {
      _currentAppliedPage = 1;
      _lastAppliedPage = 1;
    }

    if (_currentAppliedPage > _lastAppliedPage) {
      return null;
    }
    if (showProgress) GlobalService.showProgress();
    ApiResponse res = await _dioService.get(ApiEndPoint.apiAppliedJob);
    if (showProgress) GlobalService.dismissProgress();
    switch (res.statusCode) {
      case 200:
        List arrDriverJob = res.data;
        List<Map<String, dynamic>> arrMapDriverJob = arrDriverJob.map((e) {
          return JobDetailModel.toDB(e);
        }).toList();

        List<JobDetailModel> arrJobDetailModel = arrMapDriverJob.map((e) {
          return JobDetailModel.fromDB(e);
        }).toList();

        return arrJobDetailModel;
      case 401:
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          title: 'Job',
          desc: res.message,
        );
        return null;
      default:
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          title: 'Job',
          desc: res.message,
        );
        return null;
    }
  }

  /*static Future<JobDetailModel?> getJob({
    required int jobId,
    bool showProgress = true,
    bool reset = false,
  }) async {
    if (!await DeviceInfoService.hasInternet()) {
      return null;
    }

    if (reset) {
      _currentAppliedPage = 1;
      _lastAppliedPage = 1;
    }

    if (_currentAppliedPage > _lastAppliedPage) {
      return null;
    }
    if (showProgress) GlobalService.showProgress();
    ApiResponse res = await _dioService.get(ApiEndPoint);
    if (showProgress) GlobalService.dismissProgress();
    switch (res.statusCode) {
      case 200:
        JobDetailModel jobDetailModel = JobDetailModel.fromMap(res.data);
        return jobDetailModel;
      case 401:
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          title: 'Job',
          desc: res.message,
        );
        return null;
      default:
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          title: 'Job',
          desc: res.message,
        );
        return null;
    }
  }*/
}
