import '/core/network/dio_serivce.dart';
import '/model/location_model.dart';
import '/services/api_end_point.dart';

// Thin wrapper around GET /api/locations.
// The server caches the payload for 24 h; the client holds it in memory for
// the session (LocationData is a few hundred KB at most for all Indian
// districts). Do NOT cache to SharedPreferences — district/state IDs are
// reference data, not user data, and there is no security concern about
// stale data surviving across sessions.
class LocationDataService {
  static final DioService _dio = DioService();

  // In-memory session cache — avoids a redundant network call if another
  // controller (e.g. address-auth) already fetched it this session.
  static LocationData? _cache;

  static Future<LocationData?> fetchLocations({bool forceRefresh = false}) async {
    if (_cache != null && !forceRefresh) return _cache;
    final res = await _dio.get(ApiEndPoint.apiLocations);
    if (res.statusCode == 200 && res.data is Map<String, dynamic>) {
      _cache = LocationData.fromJson(res.data as Map<String, dynamic>);
      return _cache;
    }
    return null;
  }

  // Convenience: get the cached data synchronously (null if not yet fetched).
  static LocationData? get cached => _cache;
}
