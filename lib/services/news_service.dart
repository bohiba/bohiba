import '/dist/app_enums.dart';
import '/model/news_model.dart';
import '/services/db_service.dart';

class NewsService {
  // static final DioService _dioService = DioService();
  static final DBService _dbService = DBService();

  static Future<NewsModel?> getNews(
      {MethodType type = MethodType.local, required NewsModel news}) async {
    NewsModel? newsModel = await _dbService.getData(tblNews, '${news.id}');
    return newsModel;
  }

  static Future<List<NewsModel>> getAllNews(
      {MethodType type = MethodType.local}) async {
    if (type == MethodType.local) {
      return await _dbService.getAllData(tblNews);
    } else {
      return [];
    }
  }
}
