import '/model/user_fav_model.dart';
import '/services/global_service.dart';

import 'db2_service.dart';

class FavouriteService {
  static final DatabaseService _databaseService = DatabaseService();

  static Future<List<FavouriteModel>> getFavouriteList() async {
    String strQuery = ''' SELECT * FROM $tblUserFav ''';
    List<Map<String, dynamic>> arrFav =
        await _databaseService.executeQuery(strQuery) ?? [];
    List<FavouriteModel> arrFavModel = arrFav.map((e) {
      return FavouriteModel.fromDB(e);
    }).toList();
    return arrFavModel;
  }

  static Future<int> addFavourite(Map<String, dynamic> fav) async {
    // Map<String, dynamic> mapFav = FavouriteModel.toDB(fav);

    String strInsertQuery = ''' INSERT INTO $tblUserFav (
      id
    , userTruckId
    , truckId
    , userDriverId
    , driverId
    , companyId
    , isFav
    , name
    , image
    , nameCode
    , type 
    ) VALUES (
      ${fav['id']}
    , ${fav['userTruckId']}
    , ${fav['truckId']}
    , ${fav['userDriverId']}
    , ${fav['driverId']}
    , ${fav['companyId']}
    , ${fav['isFav']}
    , '${fav['name']}'
    , '${fav['image']}'
    , '${fav['nameCode']}'
    , '${fav['type']}'
    )
    ''';
    int insertSuccess = await _databaseService.insertData(strInsertQuery);
    return insertSuccess;
  }

  static Future<int> removeFavourite() async {
    return 0;
  }

  static Future<int> clearAllData() async {
    String strDeleteQuery = ''' DELETE FROM $tblUserFav ''';
    int deleteSuccess = await _databaseService.delete(strDeleteQuery);
    if (deleteSuccess > 0) {
      GlobalService.printHandler('TABLE USER FAV CLEARED');
    }
    return deleteSuccess;
  }
}
