import '/model/mines_model.dart';
import '/services/db_service.dart';

class MinesService {
  static final DBService _dbService = DBService();

  static Future<List<MinesModel>> getMinesList() async {
    List<MinesModel> minesList = await _dbService.getAllData(tblMines);
    return minesList;
  }
}
