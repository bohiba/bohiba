import 'dart:io';

import '/core/network/dio_serivce.dart';
import '/dist/enums/app_enums.dart';
import '/model/owner_company_model.dart';
import '/services/api_end_point.dart';
import '/services/device_info_service.dart';
import '/services/global_service.dart';

class OwnerCompanyService {
  static final DioService _dio = DioService();

  // GET /companies/owner — 404 means no company created yet (not an error)
  static Future<OwnerCompanyModel?> fetchCompany() async {
    if (!await DeviceInfoService.hasInternet()) return null;
    final res = await _dio.get(ApiEndPoint.apiOwnerCompany);
    if (res.statusCode == 200) {
      return OwnerCompanyModel.fromJson(res.data as Map<String, dynamic>);
    }
    // 404 is expected when the owner hasn't created a company yet
    if (res.statusCode != 404) {
      GlobalService.showSnackBar(
        status: AlertStatus.failure,
        title: 'Company',
        desc: res.message,
      );
    }
    return null;
  }

  // POST /companies/owner — enforces BR-01 server-side
  static Future<OwnerCompanyModel?> createCompany({
    required String name,
    String? email,
    String? phone,
    String? website,
  }) async {
    if (!await DeviceInfoService.hasInternet()) return null;
    GlobalService.showProgress();
    final res = await _dio.post(
      ApiEndPoint.apiOwnerCompany,
      body: {
        'name': name,
        if (email != null && email.isNotEmpty) 'email': email,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
        if (website != null && website.isNotEmpty) 'website': website,
      },
    );
    GlobalService.dismissProgress();
    if (res.statusCode == 200 || res.statusCode == 201) {
      GlobalService.showSnackBar(
        status: AlertStatus.success,
        title: 'Company',
        desc: res.message,
      );
      return OwnerCompanyModel.fromJson(res.data as Map<String, dynamic>);
    }
    GlobalService.showSnackBar(
      status: AlertStatus.failure,
      title: 'Company',
      desc: res.message,
    );
    return null;
  }

  static Future<bool> updateCompany({
    required String name,
    String? email,
    String? phone,
    String? website,
  }) async {
    if (!await DeviceInfoService.hasInternet()) return false;
    GlobalService.showProgress();
    final res = await _dio.put(
      ApiEndPoint.apiOwnerCompany,
      body: {
        'name': name,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (website != null) 'website': website,
      },
    );
    GlobalService.dismissProgress();
    if (res.statusCode == 200) {
      GlobalService.showSnackBar(
        status: AlertStatus.success,
        desc: res.message,
      );
      return true;
    }
    GlobalService.showSnackBar(
      status: AlertStatus.failure,
      desc: res.message,
    );
    return false;
  }

  static Future<String?> uploadLogo(File imageFile) async {
    if (!await DeviceInfoService.hasInternet()) return null;
    GlobalService.showProgress();
    final res = await _dio.upload(
      ApiEndPoint.apiOwnerCompanyLogo,
      [imageFile],
      fileField: 'logo',
    );
    GlobalService.dismissProgress();
    if (res.statusCode == 200) {
      GlobalService.showSnackBar(
        status: AlertStatus.success,
        title: 'Logo',
        desc: res.message,
      );
      return res.data['logo'] as String?;
    }
    GlobalService.showSnackBar(
      status: AlertStatus.failure,
      title: 'Logo',
      desc: res.message,
    );
    return null;
  }

  static Future<CompanyAddress?> upsertAddress(
      Map<String, dynamic> body) async {
    if (!await DeviceInfoService.hasInternet()) return null;

    GlobalService.showProgress();
    final res = await _dio.post(ApiEndPoint.apiOwnerCompanyAddress, body: body);
    GlobalService.dismissProgress();
    if (res.statusCode == 200 || res.statusCode == 201) {
      GlobalService.showSnackBar(
        status: AlertStatus.success,
        title: 'Address',
        desc: res.message,
      );
      return CompanyAddress.fromJson(
          res.data['address'] as Map<String, dynamic>);
    }
    GlobalService.showSnackBar(
      status: AlertStatus.failure,
      title: 'Address',
      desc: res.message,
    );
    return null;
  }

  static Future<CompanyLegal?> submitLegal(Map<String, dynamic> body) async {
    if (!await DeviceInfoService.hasInternet()) return null;
    GlobalService.showProgress();
    final res = await _dio.post(ApiEndPoint.apiOwnerCompanyLegal, body: body);
    GlobalService.dismissProgress();
    if (res.statusCode == 200 || res.statusCode == 201) {
      GlobalService.showSnackBar(
        status: AlertStatus.success,
        title: 'Legal Details',
        desc: res.message,
      );
      return CompanyLegal.fromJson(res.data as Map<String, dynamic>);
    }
    GlobalService.showSnackBar(
      status: AlertStatus.failure,
      title: 'Legal Details',
      desc: res.message,
    );
    return null;
  }

  // POST /companies/owner/contacts
  static Future<List<CompanyContact>?> addContact(
      Map<String, dynamic> body) async {
    if (!await DeviceInfoService.hasInternet()) return null;
    GlobalService.showProgress();
    final res =
        await _dio.post(ApiEndPoint.apiOwnerCompanyContacts, body: body);
    GlobalService.dismissProgress();
    if (res.statusCode == 200 || res.statusCode == 201) {
      GlobalService.showSnackBar(
        status: AlertStatus.success,
        title: 'Contact',
        desc: res.message,
      );

      final List<CompanyContact> contacts = (res.data['contacts'] as List)
          .map((e) => CompanyContact.fromJson(e as Map<String, dynamic>))
          .toList();
      return contacts;
    }
    GlobalService.showSnackBar(
      status: AlertStatus.failure,
      title: 'Contact',
      desc: res.message,
    );
    return null;
  }

  // PUT /companies/owner/contacts/{id}
  static Future<List<CompanyContact>?> updateContact(
      int id, Map<String, dynamic> body) async {
    if (!await DeviceInfoService.hasInternet()) return null;
    GlobalService.showProgress();
    final res = await _dio.put(
      ApiEndPoint.apiOwnerCompanyContact(id),
      body: body,
    );
    GlobalService.dismissProgress();
    if (res.statusCode == 200) {
      GlobalService.showSnackBar(
        status: AlertStatus.success,
        title: 'Contact',
        desc: res.message,
      );

      final List<CompanyContact> contacts = (res.data['contacts'] as List)
          .map((e) => CompanyContact.fromJson(e as Map<String, dynamic>))
          .toList();
      return contacts;
    }
    GlobalService.showSnackBar(
      status: AlertStatus.failure,
      title: 'Contact',
      desc: res.message,
    );
    return null;
  }

  // DELETE /companies/owner/contacts/{id}
  static Future<bool> deleteContact(int id) async {
    if (!await DeviceInfoService.hasInternet()) return false;
    GlobalService.showProgress();
    final res = await _dio.delete(ApiEndPoint.apiOwnerCompanyContact(id));
    GlobalService.dismissProgress();
    if (res.statusCode == 200) {
      GlobalService.showSnackBar(
        status: AlertStatus.success,
        title: 'Contact',
        desc: res.message,
      );
      return true;
    }
    GlobalService.showSnackBar(
      status: AlertStatus.failure,
      title: 'Contact',
      desc: res.message,
    );
    return false;
  }
}
