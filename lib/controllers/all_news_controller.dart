import '../dist/enums/app_enums.dart';

import '/model/news_model.dart';
import '/services/news_service.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class AllNewsController extends GetxController {
  RefreshController refreshNewsController = RefreshController();
  List<NewsModel> arrNews = <NewsModel>[].obs;
  @override
  void onInit() {
    super.onInit();

    Future.delayed(Duration.zero, () async {
      await getAllNews();
    });
  }

  Future<List<NewsModel>?> getAllNews({
    MethodType methodType = MethodType.local,
    bool showLoading = true,
  }) async {
    List<NewsModel>? newsList = await NewsService.getAllNews(
      type: methodType,
      showProgress: showLoading,
    );
    if (newsList != null) {
      arrNews.clear();
      arrNews.addAll(newsList);
    }
    return newsList;
  }
}
