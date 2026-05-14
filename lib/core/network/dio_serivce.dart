import 'dart:io';
import 'package:bohiba/core/network/dio_interceptor.dart';

import '/services/api_end_point.dart';
import '/services/device_info_service.dart';
import '/services/pref_utils.dart';
import 'package:dio/dio.dart';

class DioService {
  static final DioService _instance = DioService._internal();
  factory DioService() => _instance;
  final PrefUtils _prefUtils = PrefUtils();

  late Dio dio;
  String? _token;

  DioService._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndPoint.baseUrl,
        headers: {
          if (_token != null) 'Authorization': 'Bearer $_token',
        },
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );

    dio.interceptors.add(ApiInterceptor());
  }

  void setToken(String token) {
    clearToken();
    _token = token;
  }

  void clearToken() {
    _token = null;
  }

  Future<MapResponse> getMap(
    String endpoint, {
    Map<String, dynamic>? queryParams,
  }) async {
    final Response response = await dio.get(
      endpoint,
      queryParameters: queryParams,
      cancelToken: CancelToken(),
      options: Options(
        extra: {
          'withToken': false,
        },
      ),
    );
    return _handleMapResponse(response);
  }

  Future<ApiResponse> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    bool withToken = true,
  }) async {
    final Response response = await dio.get(
      endpoint,
      queryParameters: queryParams,
      options: Options(
        extra: {
          'withToken': withToken,
        },
      ),
    );
    return _handleResponse(response);
  }

  Future<ApiResponse> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? headers,
    String? contentType,
    bool withToken = true,
  }) async {
    final Response response = await dio.post(
      endpoint,
      data: body,
      options: Options(
        headers: headers,
        contentType: contentType ?? Headers.jsonContentType,
        extra: {'withToken': withToken},
      ),
    );
    return _handleResponse(response);
  }

  Future<ApiResponse> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool withToken = true,
  }) async {
    final response = await dio.put(
      endpoint,
      data: body,
      options: Options(extra: {'withToken': withToken}),
    );
    return _handleResponse(response);
  }

  Future<ApiResponse> delete(
    String endpoint, {
    Map<String, dynamic>? data,
    bool withToken = true,
  }) async {
    final response = await dio.delete(
      endpoint,
      data: data,
      options: Options(extra: {'withToken': withToken}),
    );
    return _handleResponse(response);
  }

  Future<ApiResponse> upload(
    String endpoint,
    List<File> files, {
    Map<String, dynamic>? body,
    required String fileField,
    bool withToken = true,
  }) async {
    final formData = FormData();

    body?.forEach((key, value) {
      formData.fields.add(MapEntry(key, value.toString()));
    });

    for (var file in files) {
      formData.files.add(
        MapEntry(
          fileField,
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        ),
      );
    }

    final response = await dio.post(
      endpoint,
      data: formData,
      options: Options(extra: {'withToken': withToken}),
    );
    return _handleResponse(response);
  }

  Future<ApiResponse> handleApiWithRetry(Future<ApiResponse> Function() apiCall) async {
    ApiResponse response = await apiCall();

    if (response.statusCode == 498) {
      bool refreshed = await _instance.refreshToken();
      if (refreshed) {
        return await apiCall();
      }
    }
    return response;
  }

  Future<bool> refreshToken() async {
    if (!await DeviceInfoService.hasInternet()) {
      return false;
    }

    final Dio refreshDio = Dio(BaseOptions(
      baseUrl: ApiEndPoint.baseUrl,
    ));

    try {
      final response = await refreshDio.post(ApiEndPoint.apiRefreshToken);

      if (response.statusCode == 200 && response.data['success'] == true) {
        String token = response.data['data']['token'];

        await _prefUtils.saveString(PrefUtils.token, token);

        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  ApiResponse _handleResponse(Response<dynamic> response) {
    final data = response.data;
    if (response.data is String && response.data.toString().contains('<!DOCTYPE html>')) {
      return ApiResponse(
        status: false,
        statusCode: 401,
        message: 'Session expired or unauthorized',
      );
    } else if (data == null) {
      return ApiResponse(
        status: false,
        statusCode: response.statusCode ?? 500,
        message: 'No response from server',
      );
    }

    return ApiResponse(
      status: data["success"] ?? false,
      statusCode: response.statusCode ?? 500,
      message: data["message"] ?? "Unknown",
      data: data["data"],
    );
  }

  MapResponse _handleMapResponse(Response<dynamic> response) {
    final data = response.data;
    if (response.data is String && response.data.toString().contains('<!DOCTYPE html>')) {
      return MapResponse(
        status: false,
        statusCode: 401,
        message: 'Session expired or unauthorized',
      );
    } else if (data == null) {
      return MapResponse(
        status: false,
        statusCode: response.statusCode ?? 500,
        message: 'No response from server',
      );
    }

    return MapResponse(
      status: data["status"] == "OK" ? true : false,
      statusCode: response.statusCode ?? 500,
      message: data["message"] ?? "Unknown",
      data: data["results"],
    );
  }
}

class MapResponse {
  final bool status;
  final int statusCode;
  final String message;
  final dynamic data;

  MapResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    this.data,
  });
}

class ApiResponse {
  final bool status;
  final int statusCode;
  final String message;
  final dynamic data;
  final Map<dynamic, dynamic>? pagination;

  ApiResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    this.data,
    this.pagination,
  });
}
