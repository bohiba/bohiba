import '/model/user_model.dart';
import '/services/api_end_point.dart';
import '/services/dio_serivce.dart';

class SearchService {
  static final DioService _dioService = DioService();
  static Future<List<UserModel>> searchUser(String keyword) async {
    if (keyword.trim().isEmpty) return [];

    ApiResponse res = await _dioService.get('${ApiEndPoint.apiSearchUser}?search=$keyword');

    if (res.statusCode == 200 && res.data != null) {
      List<dynamic> arrRes = res.data;
      List<UserModel> searchResult = arrRes.map((user) {
        return UserModel(
          id: user['id'],
          profile: UserProfile(
            name: user['name'],
            image: user['profile_image'],
            roleId: user['role_id'],
            driverUuid: user['uuid'],
          ),
          licenseDetail: LicenseDetail(
            licenseNumber: user['dl_number'],
          ),
        );
      }).toList();
      return searchResult;
    } else {
      return [];
    }
  }
}
