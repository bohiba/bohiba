import 'db_service.dart';
import 'dio_serivce.dart';

import '/model/open_driver_model.dart';

class OpenDriverService {
  static DBService dbService = DBService();
  static final DioService dioService = DioService();
  static Future<List<OpenDriverModel>> localFavList() async {
    return await dbService.getAllData<OpenDriverModel>(tblOpenDriver);
  }
}
