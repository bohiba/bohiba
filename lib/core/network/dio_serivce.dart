import 'dart:async';
import 'dart:io';
import '/services/global_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '/services/api_end_point.dart';
import '/services/device_info_service.dart';
import '/services/pref_utils.dart';
import 'package:dio/dio.dart';

import 'dio_interceptor.dart';

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
    try {
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
    } on TimeoutException catch (e, stack) {
      GlobalService.printHandler(
          'Error On TimeoutException: ${stack.toString()}');
      return MapResponse(
        status: false,
        statusCode: 504,
        message: "Internet is slow please try again",
      );
    } on DioException catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack, fatal: false);
      return MapResponse(
        status: false,
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data?['message'] ??
            e.response?.data?['errors'] ??
            e.response?.statusMessage.toString() ??
            "Something went to wrong",
      );
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
      return MapResponse(
        status: false,
        statusCode: 500,
        message:
            e.toString().isNotEmpty ? e.toString() : "Something went to wrong",
      );
    }
  }

  Future<ApiResponse> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    bool withToken = true,
  }) async {
    try {
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
    } on DioException catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack, fatal: false);
      return ApiResponse(
        status: false,
        statusCode: e.response?.statusCode ?? 500,
        message: 'Failure',
        errorMessage: e.response?.data?['errors'] ??
            e.response?.data?['message'] ??
            "Something went wrong",
      );
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
      return ApiResponse(
        status: false,
        statusCode: 500,
        message: "Failure",
        errorMessage:
            e.toString().isNotEmpty ? e.toString() : "Something went to wrong",
      );
    }
  }

  Future<ApiResponse> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? headers,
    String? contentType,
    bool withToken = true,
  }) async {
    try {
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
    } on DioException catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack, fatal: false);
      return ApiResponse(
        status: false,
        statusCode: e.response?.statusCode ?? 500,
        message: 'Failure',
        errorMessage:
            e.response?.data?['message'] ?? "Something went to wrong $endpoint",
      );
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
      return ApiResponse(
        status: false,
        statusCode: 500,
        message: "Failure",
        errorMessage: "Something went to wrong $endpoint",
      );
    }
  }

  Future<ApiResponse> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool withToken = true,
  }) async {
    try {
      final response = await dio.put(
        endpoint,
        data: body,
        options: Options(extra: {'withToken': withToken}),
      );
      return _handleResponse(response);
    } on DioException catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack, fatal: false);
      return ApiResponse(
        status: false,
        statusCode: e.response?.statusCode ?? 500,
        message: 'Failure',
        errorMessage:
            e.response?.data?['message'] ?? "Something went to wrong $endpoint",
      );
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
      return ApiResponse(
        status: false,
        statusCode: 500,
        message: "Failure",
        errorMessage: "Something went to wrong $endpoint",
      );
    }
  }

  Future<ApiResponse> delete(
    String endpoint, {
    Map<String, dynamic>? data,
    bool withToken = true,
  }) async {
    try {
      final response = await dio.delete(
        endpoint,
        data: data,
        options: Options(extra: {'withToken': withToken}),
      );
      return _handleResponse(response);
    } on DioException catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack, fatal: false);
      return ApiResponse(
        status: false,
        statusCode: e.response?.statusCode ?? 500,
        message: 'Failure',
        errorMessage:
            e.response?.data?['message'] ?? "Something went to wrong $endpoint",
      );
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
      return ApiResponse(
        status: false,
        statusCode: 500,
        message: "Failure",
        errorMessage: "Something went to wrong $endpoint",
      );
    }
  }

  Future<ApiResponse> upload(
    String endpoint,
    List<File> files, {
    Map<String, dynamic>? body,
    required String fileField,
    bool withToken = true,
  }) async {
    try {
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
    } on DioException catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack, fatal: false);
      return ApiResponse(
        status: false,
        statusCode: e.response?.statusCode ?? 500,
        message: 'Failure',
        errorMessage: e.response?.data?['message'] ?? "Something went to wrong",
      );
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
      return ApiResponse(
        status: false,
        statusCode: 500,
        message: "Failure",
        errorMessage: "Something went to wrong",
      );
    }
  }

  Future<ApiResponse> handleApiWithRetry(
      Future<ApiResponse> Function() apiCall) async {
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
    } on DioException catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack, fatal: false);
      return false;
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
      return false;
    }
  }

  ApiResponse _handleResponse(Response<dynamic> response) {
    final data = response.data;
    if (response.data is String &&
        response.data.toString().contains('<!DOCTYPE html>')) {
      return ApiResponse(
        status: false,
        statusCode: 401,
        message: 'Session expired or unauthorized',
        errorMessage: 'Something went wrong.',
      );
    } else if (data == null) {
      return ApiResponse(
        status: false,
        statusCode: response.statusCode ?? 500,
        message: 'No response from server',
        errorMessage: 'No response from server',
      );
    }

    return ApiResponse(
      status: data["success"] ?? false,
      statusCode: response.statusCode ?? 500,
      message: data["message"] ?? data['errors'] ?? "Something went wrong",
      data: data["data"],
      errorMessage: data["errors"] ?? '',
    );
  }

  MapResponse _handleMapResponse(Response<dynamic> response) {
    final data = response.data;
    if (response.data is String &&
        response.data.toString().contains('<!DOCTYPE html>')) {
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
      message: data["message"] ?? "Something went to wrong",
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
  final String errorMessage;
  final Map<dynamic, dynamic>? pagination;

  ApiResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.errorMessage,
    this.data,
    this.pagination,
  });
}
