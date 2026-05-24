import 'db2_service.dart';

import '../model/company_model.dart';

class CompanyService {
  static final DatabaseService _databaseService = DatabaseService();

  static Future<List<CompanyModel>?> getMinesList() async {
    String strQuery = '''SELECT * FROM $tblMines''';
    List<Map>? arrMapMines = await _databaseService.executeQuery(strQuery);
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
