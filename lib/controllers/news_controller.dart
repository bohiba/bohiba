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
      await getNews(news: newsInfo);
    });
  }

  Future<void> onRefreshNewsPage() async {
    await getNews(news: newsDetail.value);
    newsRefresher.refreshCompleted();
  }

  Future<void> getNews({required NewsModel news}) async {
    NewsModel? newsModel = await NewsService.getNews(news: news);
    if (newsModel != null) {
      newsDetail.value = newsModel;
    }
  }
}
