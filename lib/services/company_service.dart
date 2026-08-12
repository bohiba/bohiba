import 'package:bohiba/services/favourite_service.dart';

import '/dist/enums/app_enums.dart';
import '/services/device_info_service.dart';
import '/services/global_service.dart';

import 'db2_service.dart';

import '/model/company_model.dart';
import '/services/api_end_point.dart';
import '/core/network/dio_serivce.dart';
import 'minerals_service.dart';

class CompanyService {
  static final DatabaseService _databaseService = DatabaseService();
  static final DioService _dioService = DioService();

  static Future<List<CompanyModel>> searchCompanies(String query) async {
    return _search(ApiEndPoint.apiSearchCompany, query);
  }

  static Future<List<CompanyModel>> searchMines(String query) async {
    return _search(ApiEndPoint.apiSearchMines, query);
  }

  static Future<List<CompanyModel>> searchPlants(String query) async {
    return _search(ApiEndPoint.apiSearchPlants, query);
  }

  static Future<List<CompanyModel>> searchTransporters(String query) async {
    return _search(ApiEndPoint.apiSearchTransporters, query);
  }

  static Future<List<CompanyModel>> _search(
      String endpoint, String query) async {
    if (query.length < 2) return [];
    try {
      final ApiResponse response = await _dioService.get(
        endpoint,
        queryParams: {'search': query, 'limit': '20'},
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

  static Future<bool> markFav({required Map<String, dynamic> favObj}) async {
    bool success = await FavouriteService.addOrRemoveFav(favObj);
    String strUpdate =
        ''' UPDATE $tblMines SET isFav = ${success == true ? 1 : 0} WHERE id = ${favObj['asset_id']}''';
    int i = await _databaseService.updateData(strUpdate);

    if (i > 0) {
      GlobalService.printHandler('Chnaged succesfully');
    }
    return success;
  }

  static Future<CompanyModel?> get(
      {required int id, MethodType type = MethodType.local}) async {
    CompanyModel? companyModel;
    if (type == MethodType.local) {
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
    } else {
      if (!await DeviceInfoService.hasInternet()) return null;
      ApiResponse response =
          await _dioService.get("${ApiEndPoint.apiCompanies}/$id");
      if (response.status && response.data != null) {
        companyModel = CompanyModel.fromJSON(response.data);

        Map<String, dynamic> companyDB = CompanyModel.toDB(response.data);
        String? strMineralIds = companyDB['mineralId'];
        List<String> arrStrMineralId = [];
        if (strMineralIds != null && strMineralIds.isNotEmpty) {
          arrStrMineralId = strMineralIds.split(',');
        }
        List<MineralModel>? arrMineralModel;
        if (arrStrMineralId.isNotEmpty) {
          arrMineralModel =
              await MineralsService.getMineralsByIds(strMineralIds ?? '');
          companyModel.minerals = arrMineralModel;
        }
        int sucessInsert = await insert(companyDB);
        if (sucessInsert > 0) {
          GlobalService.printHandler(
              "Company Service:  Insert Company Data: $sucessInsert");
        }
      }
    }
    return companyModel;
  }

  static Future<({List<CompanyModel> items, bool hasMore})?>
      getCompaniesPaginated({
    required int page,
    int perPage = 10,
  }) async {
    try {
      final res = await _dioService.get(
        ApiEndPoint.apiCompaniesPaged(page, perPage),
      );
      if (res.statusCode != 200 || res.data == null) return null;
      final body = res.data as Map<String, dynamic>;
      final list = (body['data'] as List? ?? [])
          .map((e) => CompanyModel.fromJSON(e as Map<String, dynamic>))
          .toList();
      // Support both envelope shapes:
      //   { data: [...], meta: { last_page: N, current_page: N } }
      //   { data: [...], last_page: N, current_page: N }
      final meta = body['meta'] as Map<String, dynamic>? ?? body;
      final lastPage = (meta['last_page'] as num?)?.toInt() ?? 1;
      return (items: list, hasMore: page < lastPage);
    } catch (_) {
      return null;
    }
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

  static Future<int> insert(Map<String, dynamic> companyDB) async {
    String strInsert = '''
      INSERT OR REPLACE INTO $tblMines (
        id,
        isFav,
        uuid,
        logo,
        name,
        nameCode,
        website,
        type,
        status,
        mineralId,
        address,
        state,
        district,
        country,
        pinCode,
        latitude,
        longitude
        ) VALUES (
        ${sqlValue(companyDB['id'])},
        ${sqlValue(companyDB['isFav'])},
        ${sqlValue(companyDB['uuid'])},
        ${sqlValue(companyDB['logo'])},
        ${sqlValue(companyDB['name'])},
        ${sqlValue(companyDB['nameCode'])},
        ${sqlValue(companyDB['website'])},
        ${sqlValue(companyDB['type'])},
        ${sqlValue(companyDB['status'])},
        ${sqlValue(companyDB['mineralId'])},
        ${sqlValue(companyDB['address'])},
        ${sqlValue(companyDB['state'])},
        ${sqlValue(companyDB['district'])},
        ${sqlValue(companyDB['country'])},
        ${sqlValue(companyDB['pinCode'])},
        ${sqlValue(companyDB['latitude'])},
        ${sqlValue(companyDB['longitude'])}
        )
    ''';
    int sucessInsert = await _databaseService.insertData(strInsert);
    return sucessInsert;
  }

  static Future<int> clearAll() async {
    String strClearQuery = ''' DELETE FROM $tblMines''';
    int sucessQuery = await _databaseService.delete(strClearQuery);

    return sucessQuery;
  }
}
