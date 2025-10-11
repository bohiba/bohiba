import '/model/rating_model.dart';
import '/services/db_service.dart';

class RatingService {
  static final DBService _dbService = DBService();
  // static final DioService _dioService = DioService();

  static Future<int> addAllRating(
      {required List<RatingModel> ratingList}) async {
    Map<String, RatingModel> ratingMap = {
      for (RatingModel rating in ratingList) '${rating.id}': rating
    };
    int insertSuccess =
        await _dbService.putAllData<RatingModel>(tblRating, ratingMap);
    return insertSuccess;
  }
}
