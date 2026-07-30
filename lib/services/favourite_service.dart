import 'package:bohiba/core/network/dio_serivce.dart';
import 'package:bohiba/dist/enums/api_status_code.dart';
import 'package:bohiba/dist/enums/enum_favourite_type.dart';
import 'package:bohiba/services/api_end_point.dart';
import 'package:bohiba/services/device_info_service.dart';

import '/model/user_fav_model.dart';
import '/services/global_service.dart';

import 'db2_service.dart';

class FavouriteService {
  static final DatabaseService _databaseService = DatabaseService();
  static final DioService _dioService = DioService();

  static Future<List<FavouriteModel>> getFavouriteList() async {
    String strQuery = ''' SELECT * FROM $tblUserFav ''';
    List<Map<String, dynamic>> arrFav =
        await _databaseService.executeQuery(strQuery) ?? [];
    List<FavouriteModel> arrFavModel = arrFav.map((e) {
      return FavouriteModel.fromDB(e);
    }).toList();
    return arrFavModel;
  }

  static Future<bool> addOrRemoveFav(Map<String, dynamic> fav) async {
    try {
      if (!await DeviceInfoService.hasInternet()) return false;

      GlobalService.showProgress();
      ApiResponse apiResponse =
          await _dioService.post(ApiEndPoint.apiFavourite, body: fav);
      GlobalService.dismissProgress();
      StatusCode statusCode = StatusCode.fromCode(apiResponse.statusCode);
      switch (statusCode) {
        case StatusCode.unauthorized:
          GlobalService.showAppToast(message: apiResponse.errorMessage);
          return false;
        case StatusCode.created || StatusCode.ok:
          GlobalService.showAppToast(message: apiResponse.message);
          Map<String, dynamic> resObj = apiResponse.data;

          if (resObj['is_fav'] == true) {
            Map<String, dynamic> favRes = FavouriteModel.toDB(resObj);
            await syncFavLocally(favRes);
            return resObj['is_fav'];
          } else {
            await removeFavourite(fav);
            return resObj['is_fav'];
          }
        default:
          GlobalService.showAppToast(message: apiResponse.message);
          return false;
      }
    } catch (e) {
      GlobalService.showAppToast(message: 'Something went wrong');
      return false;
    }
  }

  static Future<int> syncFavLocally(Map<String, dynamic> fav) async {
    // sqlValue() handles null → SQL NULL and escapes single quotes.
    // INSERT OR REPLACE fires on the PK (id) OR on the UNIQUE columns
    // (userTruckId / userDriverId / companyId), preventing duplicates even
    // when the server returns a null/different id for the same favourite.
    String strInsertQuery = ''' INSERT OR REPLACE INTO $tblUserFav (
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
      ${sqlValue(fav['id'])}
    , ${sqlValue(fav['userTruckId'])}
    , ${sqlValue(fav['truckId'])}
    , ${sqlValue(fav['userDriverId'])}
    , ${sqlValue(fav['driverId'])}
    , ${sqlValue(fav['companyId'])}
    , ${sqlValue(fav['isFav'])}
    , ${sqlValue(fav['name'])}
    , ${sqlValue(fav['image'])}
    , ${sqlValue(fav['nameCode'])}
    , ${sqlValue(fav['type'])}
    )
    ''';
    int insertSuccess = await _databaseService.insertData(strInsertQuery);
    return insertSuccess;
  }

  static Future<int> removeFavourite(Map<String, dynamic> fav) async {
    final int assetType = fav['asset_type'] as int;
    final int assetId = fav['asset_id'] as int;
    int result = 0;
    if (assetType == EnumFavouriteType.truck.index) {
      result = await _databaseService.delete(
        ''' DELETE FROM $tblUserFav WHERE type = $assetType AND userTruckId = $assetId ''',
      );
    } else if (assetType == EnumFavouriteType.driver.index) {
      result = await _databaseService.delete(
        ''' DELETE FROM $tblUserFav WHERE type = $assetType AND userDriverId = $assetId ''',
      );
    } else if (assetType == EnumFavouriteType.mines.index) {
      result = await _databaseService.delete(
        ''' DELETE FROM $tblUserFav WHERE type = $assetType AND companyId = $assetId ''',
      );
    }
    return result;
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
