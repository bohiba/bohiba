import 'package:bohiba/dist/app_enums.dart';

import '/model/news_model.dart';
import '/services/news_service.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class NewsController extends GetxController {
  RefreshController newsRefresher = RefreshController();
  Rx<NewsModel> newsDetail = NewsModel().obs;

  @override
  void onInit() {
    NewsModel newsInfo = Get.arguments;
    super.onInit();
    Future.delayed(Duration.zero, () async {
      if (newsInfo.id != null) {
        await getNews(newsId: newsInfo.id!);
      }
    });
  }

  Future<void> onRefreshNewsPage() async {
    await getNews(
        newsId: newsDetail.value.id!,
        methodType: MethodType.api,
        showLoading: false);
    newsRefresher.refreshCompleted();
  }

  Future<void> getNews({
    required int newsId,
    MethodType methodType = MethodType.local,
    bool showLoading = true,
  }) async {
    NewsModel? newsModel = await NewsService.getNews(
      id: newsId,
      type: methodType,
      showProgress: showLoading,
    );
    if (newsModel != null) {
      newsDetail.value = newsModel;
    }
  }
}
