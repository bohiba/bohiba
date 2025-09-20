import '/model/user_fav_model.dart';
import 'api_end_point.dart';
import 'db_service.dart';
import 'device_info_service.dart';
import 'dio_serivce.dart';
import 'global_service.dart';

class FavService {
  static DBService dbService = DBService();
  static final DioService dioService = DioService();

  static Future<UserFavouriteModel?> createFav(
      {required String assetType, required int assetId}) async {
    if (!await DeviceInfoService.hasInternet()) return null;
    GlobalService.showProgress();
    Map<String, dynamic> bodyObj = {
      'asset_type': assetType,
      'asset_id': assetId,
    };
    ApiResponse response =
        await dioService.post(ApiEndPoint.apiAddFav, body: bodyObj);

    switch (response.statusCode) {
      case 200:
        if (response.data != null) {
          UserFavouriteModel favModel =
              UserFavouriteModel.fromJson(response.data);
          int dbSuccess = await dbService.putData<UserFavouriteModel>(
              tblUserFav, favModel.id.toString(), favModel);
          GlobalService.dismissProgress();
          GlobalService.printHandler('Fav added: $dbSuccess');
          return favModel;
        }
        return null;
      case 401:
        GlobalService.dismissProgress();
        GlobalService.printHandler(response.message);
        return null;
      default:
        GlobalService.dismissProgress();
        GlobalService.printHandler('Failed to mark as favourite.');
        return null;
    }
  }

  static Future<List<UserFavouriteModel>?> retriveAllFav() async {
    if (!await DeviceInfoService.hasInternet()) return null;
    ApiResponse apiResponse = await dioService.get(ApiEndPoint.apiAllFav);
    switch (apiResponse.statusCode) {
      case 200:
        List<UserFavouriteModel> arrFavList =
            UserFavouriteModel.listFromJson(apiResponse.data);
        Map<String, UserFavouriteModel> favListMap = {
          for (UserFavouriteModel dm in arrFavList) "${dm.id}": dm
        };
        int insertFavList = await dbService.putAllData<UserFavouriteModel>(
            tblUserFav, favListMap);
        GlobalService.printHandler('Insert Fav Model $insertFavList');
        return arrFavList;
      case 401:
        GlobalService.printHandler("Favourite: ${apiResponse.message}");
        return null;
      default:
        GlobalService.printHandler("Favourite: ${apiResponse.message}");
        return null;
    }
  }

  static Future<UserFavouriteModel?> findFavourite(
    int assetId,
    String assetType,
  ) async {
    final List<UserFavouriteModel>? results =
        await dbService.filterList<UserFavouriteModel>(
      tblUserFav,
      (fav) => fav.assetId == assetId && fav.assetType == assetType,
    );
    return results != null && results.isNotEmpty ? results.first : null;
  }

  static Future<bool> findDeleteFav(
    int assetId,
    String assetType,
  ) async {
    UserFavouriteModel? findFav = await findFavourite(assetId, assetType);
    if (findFav == null) {
      return false;
    } else {
      return await deleteFav(findFav.id!);
    }
  }

  static Future<bool> deleteFav(int favId) async {
    ApiResponse apiResponse =
        await dioService.delete('${ApiEndPoint.apiDeleteFav}/$favId');
    switch (apiResponse.statusCode) {
      case 200:
        GlobalService.showAppToast(message: apiResponse.message);
        return await dbService.deleteData<UserFavouriteModel>(
                    tblUserFav, "$favId") ==
                1
            ? true
            : false;

      default:
        GlobalService.showAppToast(message: 'Failed to remove fav.');
        return false;
    }
  }

  static Future<List<UserFavouriteModel>> localFavList() async {
    return await dbService.getAllData<UserFavouriteModel>(tblUserFav);
  }
}
