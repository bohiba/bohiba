import 'dart:convert';
import 'dio_serivce.dart';
import 'package:dio/dio.dart';
import '/services/global_service.dart';
import '/services/pref_utils.dart';

class ApiInterceptor extends Interceptor {
  static final PrefUtils _prefUtils = PrefUtils();
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    bool withToken = options.extra['withToken'] ?? true;

    if (withToken) {
      String? token = await getToken();
      if (options.extra['withToken'] == true &&
          token != null &&
          token.isNotEmpty) {
        options.headers['Accept'] = 'application/json';
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    GlobalService.logger.i('''✅ API REQUEST\n
    METHOD: ${options.method}\n
    URL: ${options.uri}\n
    HEADERS: ${_safeString(_sanitizeHeaders(options.headers))}\n
    BODY: ${_safeString(options.data)}
    ''');

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    GlobalService.logger.i('''✅ API RESPONSE\n
    METHOD: ${response.statusCode}\n
    URL: ${response.requestOptions.uri}\n
    HEADERS: ${_safeString(_sanitizeHeaders(response.headers.map))}\n
    BODY: ${_safeString(response.data)}
    ''');

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    GlobalService.logger.e(''' ❌ API ERROR\n
    TYPE: ${err.type}\n
    STATUS: ${err.response?.statusCode}\n
    METHOD: ${err.requestOptions.method}\n
    URL: ${err.requestOptions.uri}\n
    MESSAGE: ${err.message}\n
    REQUEST: ${_safeString(err.requestOptions.data)}\n
    RESPONSE: ${_safeString(err.response?.data)}
    ''');
    if (err.response?.statusCode == 401) {
      bool refreshed = await DioService().refreshToken();

      if (refreshed) {
        final retryResponse = await Dio().fetch(err.requestOptions);
        return handler.resolve(retryResponse);
      } else {
        logoutUser();
      }
    }

    handler.next(err);
  }

  Future<String?> getToken() async {
    return _prefUtils.getString(PrefUtils.token);
  }

  void logoutUser() {
    // logout logic
  }

  dynamic _sanitizeHeaders(Map<String, dynamic> headers) {
    final sanitized = Map<String, dynamic>.from(headers);

    sanitized.remove('Authorization');
    sanitized.remove('authorization');

    return sanitized;
  }

  String _safeString(dynamic data) {
    try {
      return jsonEncode(data);
    } catch (_) {
      return data.toString();
    }
  }
}
