import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final CollectionReference users =
      FirebaseFirestore.instance.collection("users");
  // final PrefUtils _prefUtils = PrefUtils();
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 3), () async {
      await checkRouteSetting();
    });
  }

  Future<void> checkRouteSetting() async {}
}
