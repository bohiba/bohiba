import 'package:bohiba/dist/app_enums.dart';
import 'package:bohiba/model/profile_model.dart';
import 'package:bohiba/services/encryption_service.dart';
import 'package:bohiba/services/profile_service.dart';
import 'package:get/get.dart';

class UserQrController extends GetxController {
  Rxn<ProfileModel> profileModel = Rxn<ProfileModel>();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      await getProfileModel();
    });
  }

  Future<ProfileModel?> getProfileModel({
    MethodType methodType = MethodType.local,
    bool showLoading = false,
  }) async {
    ProfileModel? profile = await ProfileService.getProfile(
        type: methodType, showProgress: showLoading);
    if (profile != null) {
      profileModel.value = profile;
      return profile;
    }
    return null;
  }

  String encryptUuid() {
    return _encryptString();
  }

  String _encryptString() {
    if (profileModel.value == null || profileModel.value?.uuid == null) {
      return '';
    }
    final String uuid = profileModel.value!.uuid!;

    return EncryptionService.encryptText(uuid);
  }
}
