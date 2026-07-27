import 'db2_service.dart';

import '/model/company_model.dart';
import '/services/api_end_point.dart';
import '/core/network/dio_serivce.dart';
import 'minerals_service.dart';

class CompanyService {
  static final DatabaseService _databaseService = DatabaseService();
  static final DioService _dioService = DioService();

  /// Generic company search — all entity types.
  /// Endpoint: GET /companies/search?search=QUERY
  static Future<List<CompanyModel>> searchCompanies(String query) async {
    return _search(ApiEndPoint.apiSearchCompany, query);
  }

  /// Mines-only search (entity_type = MINE) — use for trip origin.
  /// Endpoint: GET /companies/search/mines?search=QUERY
  static Future<List<CompanyModel>> searchMines(String query) async {
    return _search(ApiEndPoint.apiSearchMines, query);
  }

  /// Plants-only search (entity_type = PLANT) — use for trip destination.
  /// Endpoint: GET /companies/search/plants?search=QUERY
  static Future<List<CompanyModel>> searchPlants(String query) async {
    return _search(ApiEndPoint.apiSearchPlants, query);
  }

  /// Transporters-only search (entity_type = TRANSPORTER).
  /// Endpoint: GET /companies/search/transporter?search=QUERY
  static Future<List<CompanyModel>> searchTransporters(String query) async {
    return _search(ApiEndPoint.apiSearchTransporters, query);
  }

  // API requires minimum 2 chars; returns [] on any error (silent fallback).
  static Future<List<CompanyModel>> _search(String endpoint, String query) async {
    if (query.length < 2) return [];
    try {
      final ApiResponse response = await _dioService.get(
        endpoint,
        queryParams: {'search': query, 'limit': '20'},
      );
      if (response.status && response.data != null) {
        return (response.data as List)
            .map((e) => CompanyModel.fromJSON(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  static Future<CompanyModel?> getCompany(int id) async {
    String companyQuery = '''
      SELECT * FROM $tblMines WHERE id = $id
    ''';
    List<Map<String, dynamic>>? companyMaps =
        await _databaseService.executeQuery(companyQuery);
    if (companyMaps == null || companyMaps.isEmpty) {
      return null;
    }

    String? strMineralIds = companyMaps.first['mineralId'];
    List<String> arrStrMineralId = [];
    if (strMineralIds != null && strMineralIds.isNotEmpty) {
      arrStrMineralId = strMineralIds.split(',');
    }
    List<MineralModel>? arrMineralModel;
    CompanyModel companyModel = CompanyModel.fromDB(companyMaps.first);
    if (arrStrMineralId.isNotEmpty) {
      arrMineralModel =
          await MineralsService.getMineralsByIds(strMineralIds ?? '');
      companyModel.minerals = arrMineralModel;
    }
    return companyModel;
  }

  /// Server-side paginated companies list.
  /// Returns (items, hasMore). Returns null on network error so callers can
  /// distinguish "empty page" (items=[], hasMore=false) from failure.
  static Future<({List<CompanyModel> items, bool hasMore})?> getCompaniesPaginated({
    required int page,
    int perPage = 10,
  }) async {
    try {
      final res = await _dioService.get(
        ApiEndPoint.apiCompaniesPaged(page, perPage),
      );
      if (res.statusCode != 200 || res.data == null) return null;
      final body = res.data as Map<String, dynamic>;
      final list = (body['data'] as List? ?? [])
          .map((e) => CompanyModel.fromJSON(e as Map<String, dynamic>))
          .toList();
      // Support both envelope shapes:
      //   { data: [...], meta: { last_page: N, current_page: N } }
      //   { data: [...], last_page: N, current_page: N }
      final meta = body['meta'] as Map<String, dynamic>? ?? body;
      final lastPage = (meta['last_page'] as num?)?.toInt() ?? 1;
      return (items: list, hasMore: page < lastPage);
    } catch (_) {
      return null;
    }
  }

  static Future<List<CompanyModel>?> getMinesList() async {
    String strQuery = '''SELECT * FROM $tblMines''';
    List<Map<String, dynamic>>? arrMapMines =
        await _databaseService.executeQuery(strQuery);
    if (arrMapMines != null) {
      List<CompanyModel> minesModel = arrMapMines.map((e) {
        return CompanyModel.fromDB(e);
      }).toList();
      return minesModel;
    }
    return null;
  }

  static Future<int> insertAll(List<Map<String, dynamic>> listMines) async {
    int sucessInsert =
        await _databaseService.insertAllData(tblMines, listMines);
    return sucessInsert;
  }

  static Future<int> clearAll() async {
    String strClearQuery = ''' DELETE FROM $tblMines''';
    int sucessQuery = await _databaseService.delete(strClearQuery);

    return sucessQuery;
  }
}
