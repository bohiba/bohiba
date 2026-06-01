import 'db2_service.dart';

import '/model/company_model.dart';
import '/services/api_end_point.dart';
import '/core/network/dio_serivce.dart';
import 'minerals_service.dart';

class CompanyService {
  static final DatabaseService _databaseService = DatabaseService();
  static final DioService _dioService = DioService();

  /// Searches companies via the remote API.
  /// Endpoint: GET /companies/search — query param: search=QUERY
  /// Returns an empty list on any error (silent fallback — see §4.3 coding standards).
  static Future<List<CompanyModel>> searchCompanies(String query) async {
    try {
      final ApiResponse response = await _dioService.get(
        ApiEndPoint.apiSearchCompany,
        queryParams: {'search': query},
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
