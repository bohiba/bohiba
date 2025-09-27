import '/dist/app_enums.dart';
import '/model/profile_model.dart';
import '/services/global_service.dart';
import '/services/profile_service.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class UpdateContactInfoController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  Rx<ProfileModel> profileModel = ProfileModel().obs;

  Rx<AddAssetUsing> addAsset = AddAssetUsing.uuid.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      await getProfileInfo();
    });
  }

  Future<void> updateContact({required Map parameter}) async {
    if (parameter.containsKey('email')) {
      profileModel.value.email = parameter['email'];
    }
    if (parameter.containsKey('mobile_number')) {
      profileModel.value.mobileNumber = parameter['mobile_number'];
    }
    int updateSuccess =
        await ProfileService.updateProfile(profile: profileModel.value);
    if (updateSuccess > 0) {
      Get.back();
    }
  }

  Future<void> getProfileInfo() async {
    ProfileModel? profile = await ProfileService.getProfile();
    if (profile != null) {
      profileModel.value = profile;
      emailController.text = profileModel.value.email ?? '';
      phoneController.text = profileModel.value.mobileNumber ?? '';
    } else {
      GlobalService.showAppToast(message: 'Something went wrong');
    }
  }
}
