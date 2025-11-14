import 'api_end_point.dart';
import 'dio_serivce.dart';
import 'device_info_service.dart';
import 'global_service.dart';
import 'db2_service.dart';

import '/dist/app_enums.dart';
import '/model/news_model.dart';

class NewsService {
  static final DioService _dioService = DioService();
  static final DatabaseService _databaseService = DatabaseService();

  static Future<NewsModel?> getNews({
    MethodType type = MethodType.local,
    bool showProgress = false,
    required int id,
  }) async {
    if (type == MethodType.local) {
      String strGetQuery = ''' SELECT * FROM $tblNews WHERE id = $id ''';
      List<Map<String, dynamic>>? newsMapList =
          await _databaseService.executeQuery(strGetQuery);

      if (newsMapList != null && newsMapList.isNotEmpty) {
        NewsModel newsModel = NewsModel.fromDB(newsMapList.first);
        return newsModel;
      }
      return null;
    } else {
      if (!await DeviceInfoService.hasInternet()) {
        return null;
      }
      if (showProgress) GlobalService.showProgress();
      ApiResponse res = await _dioService.get('${ApiEndPoint.apiNews}/$id');
      if (showProgress) GlobalService.dismissProgress();

      switch (res.statusCode) {
        case 200:
          Map<String, dynamic> newsObj = NewsModel.toDB(res.data);

          int insertSuccess = await _databaseService.upsertData(
              tableName: tblNews, data: newsObj);
          if (insertSuccess > 0) {
            NewsModel newsModel = NewsModel.fromDB(newsObj);
            return newsModel;
          }
          return null;
        case 401:
          if (showProgress) GlobalService.dismissProgress();
          return null;
        default:
          if (showProgress) GlobalService.dismissProgress();
          return null;
      }
    }
  }

  static Future<List<NewsModel>?> getAllNews({
    MethodType type = MethodType.local,
    bool showProgress = false,
  }) async {
    if (type == MethodType.local) {
      String strNewsQuery = ''' SELECT * FROM $tblNews ''';
      List<Map<String, dynamic>> arrNews =
          await _databaseService.executeQuery(strNewsQuery) ?? [];

      List<NewsModel> newsModelList = arrNews.map((e) {
        return NewsModel.fromDB(e);
      }).toList();
      return newsModelList;
    } else {
      if (!await DeviceInfoService.hasInternet()) {
        return null;
      }

      if (showProgress) GlobalService.showProgress();
      ApiResponse res = await _dioService.get(ApiEndPoint.apiNewsAll);
      if (showProgress) GlobalService.dismissProgress();

      switch (res.statusCode) {
        case 200:
          await clearAllNews();
          List<dynamic> newsList = res.data;
          List<Map<String, dynamic>> arrNewsMap = newsList.map((news) {
            return NewsModel.toDB(news);
          }).toList();

          int insertSuccess = await insertAll(arrNewsMap);
          if (insertSuccess > 0) {
            List<NewsModel> arrNewsModel = arrNewsMap.map((e) {
              return NewsModel.fromDB(e);
            }).toList();

            return arrNewsModel;
          }
          return null;
        case 401:
          if (showProgress) GlobalService.dismissProgress();
          return null;
        default:
          if (showProgress) GlobalService.dismissProgress();
          return null;
      }
    }
  }

  static Future<int> insertAll(List<Map<String, dynamic>> listNews) async {
    int insert = await _databaseService.insertAllData(tblNews, listNews);
    return insert;
  }

  static Future<int> clearAllNews() async {
    String strDeleteQuery = ''' DELETE FROM $tblNews ''';
    int deleteSuccess = await _databaseService.delete(strDeleteQuery);
    if (deleteSuccess > 0) {
      GlobalService.printHandler('TABLE NEWS CLEARED');
    }
    return deleteSuccess;
  }
}
