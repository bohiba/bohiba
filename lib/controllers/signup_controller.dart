import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bohiba/services/pref_utils.dart';

class SignUpController extends GetxController {
  // final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection("users");
  final PrefUtils prefUtils = PrefUtils();

  final GlobalKey<FormState> signupKey = GlobalKey<FormState>();
  bool showPassword = true;
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  bool isCreatingUser = false;

  Future<void> signUp(String email, String phone, String password) async {
    // validate 
    // 1. Phone number of 10 digit
    // 2. Email format
    // 3. Password strength
  }

  Future<String> getToken(String userID, String password) async {
    String token = "";

    debugPrint("\n=================\n| Token: $token |\n=================\n");
    return token;
  }

  String uniqueIDGenerator() {
    String characters = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    String uniqueId = '';

    for (int i = 0; i < 6; i++) {
      uniqueId += characters[Random().nextInt(characters.length)];
    }
    return uniqueId;
  }
}
