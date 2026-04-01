import 'package:bohiba/services/dio_serivce.dart';

import 'global_service.dart';
import 'pref_utils.dart';
import 'package:dio/dio.dart';

class ApiInterceptor extends Interceptor {
  static final PrefUtils _prefUtils = PrefUtils();
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    bool withToken = options.extra['withToken'] ?? true;

    if (withToken) {
      String? token = await getToken();
      if (token != null) {
        options.headers["Authorization"] = "Bearer $token";
      }
    }

    GlobalService.printHandler("REQUEST[${options.method}] => PATH: ${options.path}");
    GlobalService.printHandler("HEADERS: ${options.headers}");
    GlobalService.printHandler("DATA: ${options.data}");

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    GlobalService.printHandler("RESPONSE[${response.statusCode}] => DATA: ${response.data}");

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
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
    // fetch from storage / hive / shared prefs
    return _prefUtils.getString(PrefUtils.token);
  }

  void logoutUser() {
    // logout logic
  }
}
