import 'package:bohiba/services/pref_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  final CollectionReference users =
      FirebaseFirestore.instance.collection("users");
  final PrefUtils prefUtils = PrefUtils();
  final userIDController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final isVerifying = false.obs;

  Future<void> resetPassword() async {}

  Future<void> signIn(String userID, String password) async {
    // Check Aadhar & PAN card has been uploaded or not
    /// If not uploaded move to [UserAuthScreen]
  }

  @override
  void onClose() {
    userIDController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
