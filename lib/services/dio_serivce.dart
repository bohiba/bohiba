import 'dart:io';
import 'package:bohiba/services/api_end_point.dart';
import 'package:bohiba/services/device_info_service.dart';
import 'package:bohiba/services/global_service.dart';
import 'package:bohiba/services/pref_utils.dart';
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
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (options.extra['withToken'] == true && _token != null) {
            options.headers['Authorization'] = 'Bearer $_token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) {
          final statusCode = error.response?.statusCode ?? 401;
          final responseData = error.response?.data;

          if (statusCode == 498) {
            handler.resolve(
              Response(
                requestOptions: error.requestOptions,
                statusCode: 498,
                data: responseData ??
                    {
                      'status': false,
                      'message': 'Invalid token',
                    },
              ),
            );
          } else {
            handler.resolve(
              Response(
                requestOptions: error.requestOptions,
                statusCode: statusCode,
                data: responseData ??
                    {
                      'status': false,
                      'message': 'Something went wrong',
                    },
              ),
            );
          }
        },
      ),
    );
  }

  void setToken(String token) {
    clearToken();
    _token = token;
  }

  void clearToken() {
    _token = null;
  }

  Future<ApiResponse> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    bool withToken = true,
  }) async {
    final response = await dio.get(
      endpoint,
      queryParameters: queryParams,
      options: Options(extra: {'withToken': withToken}),
    );
    return _handleResponse(response);
  }

  Future<ApiResponse> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? headers,
    bool withToken = true,
  }) async {
    final Response response = await dio.post(
      endpoint,
      data: body,
      options: Options(
        headers: headers,
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
    Map<String, dynamic> fields,
    List<File> files, {
    String fileField = 'image',
    bool withToken = true,
  }) async {
    final formData = FormData();

    fields.forEach((key, value) {
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
    GlobalService.showProgress();
    ApiResponse serviceResponse =
        await _instance.post(ApiEndPoint.apiRefreshToken);
    GlobalService.dismissProgress();
    switch (serviceResponse.statusCode) {
      case 401:
        return false;
      case 200:
        String token = serviceResponse.data['token'];
        _instance.setToken(token);
        _prefUtils.clearPreferencesData();
        await _prefUtils.saveString(PrefUtils.token, token);
        GlobalService.printHandler("Refresh Token: $token");
        return true;
      default:
        return false;
    }
  }

  ApiResponse _handleResponse(Response<dynamic> response) {
    dynamic data = response.data;
    if (response.data == null) {
      return ApiResponse(
        status: false,
        statusCode: 401,
        message: 'Unknown error occurred',
      );
    } else if (response.statusCode == 200 && response.data != null ||
        response.statusCode == 201 && data['status'] == true) {
      return ApiResponse(
        status: data["status"] ?? true,
        statusCode: response.statusCode ?? 200,
        message: data['message'] ?? "Success",
        data: data['data'],
      );
    } else {
      return ApiResponse(
        status: response.data["status"] ?? false,
        statusCode: response.statusCode ?? 401,
        message: response.data['message'] ?? 'An error occurred',
      );
    }
  }
}

class ApiResponse {
  final bool status;
  final int statusCode;
  final String message;
  final dynamic data;

  ApiResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    this.data,
  });
}

/*
   =========================================
   ||               API                   ||
   ========================================= 
  */
