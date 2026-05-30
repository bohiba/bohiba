import '/model/company_model.dart';
import 'db2_service.dart';

class MineralsService {
  static final DatabaseService _databaseService = DatabaseService();

  static Future<List<MineralModel>> getMinerals() async {
    String strQuery = '''SELECT * FROM $tblMinerals''';
    List<Map<String, dynamic>>? arrMapMinerals =
        await _databaseService.executeQuery(strQuery);
    if (arrMapMinerals != null) {
      List<MineralModel> mineralsModel = arrMapMinerals.map((e) {
        return MineralModel.fromDB(e);
      }).toList();
      return mineralsModel;
    }
    return [];
  }

  static Future<int> insertAll(List<Map<String, dynamic>> listMinerals) async {
    await clearAll();
    int sucessInsert =
        await _databaseService.insertAllData(tblMinerals, listMinerals);
    return sucessInsert;
  }

  static Future<int> clearAll() async {
    String strClearQuery = ''' DELETE FROM $tblMinerals''';
    int sucessQuery = await _databaseService.delete(strClearQuery);

    return sucessQuery;
  }

  static Future<List<MineralModel>?> getMineralsByIds(
      String strMineralIds) async {
    if (strMineralIds.isEmpty) return [];
    String strQuery =
        '''SELECT * FROM $tblMinerals WHERE id IN ($strMineralIds)''';
    List<Map<String, dynamic>>? arrMapMinerals =
        await _databaseService.executeQuery(strQuery);
    if (arrMapMinerals != null) {
      List<MineralModel> mineralsModel = arrMapMinerals.map((e) {
        return MineralModel.fromDB(e);
      }).toList();
      return mineralsModel;
    }
    return [];
  }
}
