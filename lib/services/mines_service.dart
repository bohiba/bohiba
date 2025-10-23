import 'db2_service.dart';

import '/model/mines_model.dart';

class MinesService {
  static final DatabaseService _databaseService = DatabaseService();

  static Future<List<MinesModel>?> getMinesList() async {
    String strQuery = '''SELECT * FROM $tblMines''';
    List<Map>? arrMapMines = await _databaseService.getAllData(strQuery);
    if (arrMapMines != null) {
      List<MinesModel> minesModel = arrMapMines.map((e) {
        return MinesModel.fromDB(e);
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
