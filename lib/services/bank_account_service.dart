import '/core/network/dio_serivce.dart';
import '/model/bank_account_model.dart';
import '/services/api_end_point.dart';
import '/services/device_info_service.dart';
import '/services/global_service.dart';
import '/dist/enums/app_enums.dart';

class BankAccountService {
  static final DioService _dioService = DioService();

  static Future<List<BankAccountModel>?> getAllAccounts() async {
    if (!await DeviceInfoService.hasInternet()) return null;
    GlobalService.showProgress();
    final res = await _dioService.get(ApiEndPoint.apiBankAccounts);
    GlobalService.dismissProgress();
    if (res.statusCode == 200) {
      final List list = res.data as List;
      return list
          .map((e) => BankAccountModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    GlobalService.showSnackBar(
      status: AlertStatus.failure,
      title: 'Bank Accounts',
      desc: res.message,
    );
    return null;
  }

  static Future<BankAccountModel?> addAccount(Map<String, dynamic> body) async {
    if (!await DeviceInfoService.hasInternet()) return null;
    GlobalService.showProgress();
    final res = await _dioService.post(ApiEndPoint.apiBankAccounts, body: body);
    GlobalService.dismissProgress();
    if (res.statusCode == 201 || res.statusCode == 200) {
      GlobalService.showSnackBar(
        status: AlertStatus.success,
        title: 'Bank Accounts',
        desc: res.message,
      );
      return BankAccountModel.fromJson(res.data as Map<String, dynamic>);
    }
    GlobalService.showSnackBar(
      status: AlertStatus.failure,
      title: 'Bank Accounts',
      desc: res.message,
    );
    return null;
  }

  static Future<BankAccountModel?> editAccount(
      int id, Map<String, dynamic> body) async {
    if (!await DeviceInfoService.hasInternet()) return null;
    GlobalService.showProgress();
    final res =
        await _dioService.put('${ApiEndPoint.apiBankAccounts}/$id', body: body);
    GlobalService.dismissProgress();
    if (res.statusCode == 200) {
      GlobalService.showSnackBar(
        status: AlertStatus.success,
        title: 'Bank Accounts',
        desc: res.message,
      );
      return BankAccountModel.fromJson(res.data as Map<String, dynamic>);
    }
    GlobalService.showSnackBar(
      status: AlertStatus.failure,
      title: 'Bank Accounts',
      desc: res.message,
    );
    return null;
  }

  static Future<bool> setPrimary(int id) async {
    if (!await DeviceInfoService.hasInternet()) return false;
    GlobalService.showProgress();
    final res = await _dioService
        .put('${ApiEndPoint.apiBankAccounts}/$id/primary', body: {});
    GlobalService.dismissProgress();
    if (res.statusCode == 200) {
      GlobalService.showSnackBar(
        status: AlertStatus.success,
        title: 'Bank Accounts',
        desc: 'Primary account updated',
      );
      return true;
    }
    GlobalService.showSnackBar(
      status: AlertStatus.failure,
      title: 'Bank Accounts',
      desc: res.message,
    );
    return false;
  }

  static Future<bool> deleteAccount(int id) async {
    if (!await DeviceInfoService.hasInternet()) return false;
    GlobalService.showProgress();
    final res = await _dioService.delete('${ApiEndPoint.apiBankAccounts}/$id');
    GlobalService.dismissProgress();
    if (res.statusCode == 200) {
      GlobalService.showSnackBar(
        status: AlertStatus.success,
        title: 'Bank Accounts',
        desc: res.message,
      );
      return true;
    }
    GlobalService.showSnackBar(
      status: AlertStatus.failure,
      title: 'Bank Accounts',
      desc: res.message,
    );
    return false;
  }
}
