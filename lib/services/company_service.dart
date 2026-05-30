import 'db2_service.dart';

import '/model/company_model.dart';
import 'minerals_service.dart';

class CompanyService {
  static final DatabaseService _databaseService = DatabaseService();

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
