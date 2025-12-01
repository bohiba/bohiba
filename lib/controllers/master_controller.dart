import '../model/user_model.dart';
import '/model/mines_model.dart';
import '/model/news_model.dart';
import '/model/trip_model.dart';
import '/model/truck_model.dart';
import '/services/main_service.dart';
import '/model/user_fav_model.dart';
import '/dist/app_enums.dart';

import 'package:get/get.dart';

class MasterController extends GetxController {
  final RxList<UserFavouriteModel> arrFavList = <UserFavouriteModel>[].obs;
  final RxList<TripModel> arrTrip = <TripModel>[].obs;
  final RxList<TruckModel> arrTruck = <TruckModel>[].obs;
  final RxList<MinesModel> arrMines = <MinesModel>[].obs;
  final RxList<UserModel> arrDriver = <UserModel>[].obs;
  final RxList arrOwnerExpense = [].obs;
  final RxList arrLookingJob = [].obs;
  final RxList arrPromotion = [].obs;
  final RxList<NewsModel> arrNews = <NewsModel>[].obs;

  Future<Map<String, dynamic>?> mainApi({MethodType type = MethodType.local, bool showLoading = false}) async {
    Map<String, dynamic>? mainObj = await MainService.mainApi(type: type, showProgress: showLoading);

    if (mainObj != null) {
      if (mainObj.containsKey('trips')) {
        arrTrip.addAll(mainObj['trips']);
      }

      if (mainObj.containsKey('trucks')) {
        arrTruck.addAll(mainObj['trucks']);
      }

      if (mainObj.containsKey('drivers')) {
        arrDriver.addAll(mainObj['drivers']);
      }

      if (mainObj.containsKey('mines')) {
        arrMines.addAll(mainObj['mines']);
      }

      if (mainObj.containsKey('owner_expense')) {
        arrOwnerExpense.addAll(mainObj['owner_expense']);
      }

      if (mainObj.containsKey('looking_jobs')) {
        arrLookingJob.addAll(mainObj['looking_jobs']);
      }

      if (mainObj.containsKey('favList')) {
        arrFavList.addAll(mainObj['favList']);
      }

      if (mainObj.containsKey('promotion')) {
        arrPromotion.addAll(mainObj['promotion']);
      }

      if (mainObj.containsKey('news')) {
        arrNews.addAll(mainObj['news']);
      }
    }
    return mainObj;
  }
}
