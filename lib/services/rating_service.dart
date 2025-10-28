import 'api_end_point.dart';
import 'device_info_service.dart';
import 'dio_serivce.dart';
import 'global_service.dart';
import 'db2_service.dart';
import '/dist/app_enums.dart';
import '/model/rating_model.dart';
import 'package:get/get.dart';

class RatingService {
  static final DioService _dioService = DioService();
  static final DatabaseService _databaseService = DatabaseService();

  static Future<List<RatingModel>?> allRating() async {
    if (!await DeviceInfoService.hasInternet()) {
      return null;
    }
    GlobalService.showProgress();
    ApiResponse res = await _dioService.get(ApiEndPoint.apiGetRating);
    switch (res.statusCode) {
      case 200:
        GlobalService.dismissProgress();
        List arrRating = res.data;
        List<Map<String, dynamic>> arrMapRating = arrRating.map((e) {
          return RatingModel.toDB(e);
        }).toList();

        int successInsert = await insertAll(ratingList: arrMapRating);
        if (successInsert > 0) {
          List<RatingModel> arrRatingModel = arrMapRating.map((e) {
            return RatingModel.fromDB(e);
          }).toList();

          return arrRatingModel;
        }
        return null;
      case 401:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          title: 'Rating',
          desc: res.message,
        );
        return null;
      default:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          title: 'Rating',
          desc: res.message,
        );
        return null;
    }
  }

  static Future<int> deleteRating({required int ratingId}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }

    GlobalService.showProgress();
    ApiResponse res =
        await _dioService.delete('${ApiEndPoint.apiDeleteRating}/$ratingId');
    switch (res.statusCode) {
      case 200:
        String strDelQuery = '''DELETE $tblRating WHERE id = $ratingId''';
        int success = await _databaseService.delete(strDelQuery);
        GlobalService.dismissProgress();
        if (success > 0) {
          GlobalService.showSnackBar(
            status: AlertStatus.success,
            title: 'Rating',
            desc: res.message,
          );
        }
        return success;
      case 401:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
          status: AlertStatus.success,
          title: 'Rating',
          desc: res.message,
        );
        return 0;
      default:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
          status: AlertStatus.success,
          title: 'Rating',
          desc: 'Failed to delete rating',
        );
        return 0;
    }
  }

  static Future<int> rateDriver({
    required String reviewerUuid,
    required double rating,
    required String feedback,
  }) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    if (rating == 0.0) {
      GlobalService.showAppToast(message: 'Please rate the user');
      return 0;
    }

    if (feedback.isEmpty) {
      GlobalService.showAppToast(message: 'Please share your feedback');
      return 0;
    }
    GlobalService.closeKeyboard();
    GlobalService.showProgress();
    Map<String, dynamic> bodyObj = {
      'reviewee_uuid': reviewerUuid,
      'rating': rating,
      'feedback': feedback,
    };
    ApiResponse response =
        await _dioService.post(ApiEndPoint.apiRateDriver, body: bodyObj);

    switch (response.statusCode) {
      case 201:
        Get.back();
        GlobalService.dismissProgress();
        GlobalService.showDialog(
          status: AlertStatus.success,
          title: 'SUCCESS',
          description: 'Thank you for sharing your experience with us.',
          buttonTxt: 'CLOSE',
          onExit: () {
            Get.back(result: true);
          },
        );
        return 1;
      case 401:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
            status: AlertStatus.warning,
            title: 'Rate Driver',
            desc: response.message);
        return 0;
      default:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
            status: AlertStatus.failure,
            title: 'Rate Driver',
            desc: 'Something went wrong');
        return 0;
    }
  }

  static Future<int> insertAll(
      {required List<Map<String, dynamic>> ratingList}) async {
    int successInsert =
        await _databaseService.insertAllData(tblRating, ratingList);

    return successInsert;
  }
}
