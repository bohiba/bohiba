import '/core/network/dio_serivce.dart';
import '/services/api_end_point.dart';

/// Thin HTTP wrapper for the 6 analytics endpoints.
///
/// Each method returns the parsed `data` map from the standard API envelope
/// `{success, message, data, errors}` on success, or **null** on any failure
/// (network error, 4xx/5xx, empty body, parse exception).
///
/// The controller is responsible for deciding what to display when null is returned.
/// No exception should ever escape these methods — see §4.3 coding standards.
class AnalyticService {
  // Use the shared singleton — never create a bare Dio() (§7.1 arch constraint).
  static final DioService _dio = DioService();

  static Future<Map<String, dynamic>?> fetchSummary(String period) =>
      _get('${ApiEndPoint.apiAnalytic}/summary', period);

  static Future<Map<String, dynamic>?> fetchTrips(String period) =>
      _get('${ApiEndPoint.apiAnalytic}/trips', period);

  static Future<Map<String, dynamic>?> fetchFuel(String period) =>
      _get('${ApiEndPoint.apiAnalytic}/fuel', period);

  static Future<Map<String, dynamic>?> fetchDrivers(String period) =>
      _get('${ApiEndPoint.apiAnalytic}/drivers', period);

  static Future<Map<String, dynamic>?> fetchTrucks(String period) =>
      _get('${ApiEndPoint.apiAnalytic}/trucks', period);

  static Future<Map<String, dynamic>?> fetchFinance(String period) =>
      _get('${ApiEndPoint.apiAnalytic}/finance', period);

  // ── Private helper ────────────────────────────────────────────────────────

  static Future<Map<String, dynamic>?> _get(
      String url, String period) async {
    try {
      final res = await _dio.get(url, queryParams: {'period': period});
      if (res.status && res.data != null) {
        return res.data as Map<String, dynamic>;
      }
      return null;
    } catch (_) {
      // Silent fallback — never propagate a network/cert error to the UI (§4.3).
      return null;
    }
  }
}
