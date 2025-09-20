import '/services/db_service.dart';

import '/model/profile_model.dart';

class ProfileService {
  static DBService dBService = DBService();

  static Future<ProfileModel?> retrieveProfile() async {
    return await dBService.getData(tblProfile, profileKey);
  }

  static Future<int> updateProfile({required ProfileModel profile}) async {
    return await dBService.putData(tblProfile, profileKey, profile);
  }
}
