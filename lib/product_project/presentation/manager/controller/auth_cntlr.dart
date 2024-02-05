import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import '../../routes/app_pages.dart';
import '../../widgets/custom/custome_alert_dialogue.dart';

class AuthCntlr extends GetxController {
  final signupMailController = TextEditingController();
  final signupNameController = TextEditingController();
  final signupPasswordController = TextEditingController();
  final signupConfirmPasswordController = TextEditingController();
  final signInPasswordController = TextEditingController();
  final signInMailController = TextEditingController();
  final GlobalKey<FormState> signupGlobalKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signInGlobalKey = GlobalKey<FormState>();
  final isSignUpLoading = false.obs;
  final isSignInLoading = false.obs;
  final box = GetStorage();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<void> signUp(String name, String email, String password) async {
    try {
      if (signupGlobalKey.currentState!.validate()) {
        isSignUpLoading.value = true;
        await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);

        Get.snackbar(
          'Success',
          'Account created successfully',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.green,
        );
        isSignUpLoading.value = false;
        Get.offAllNamed(AppPages.signIn);
      }
    } catch (e) {
      isSignUpLoading.value = false;
      customAlertDialogue(
          title: "Failed",
          content: "$e",
          txtbuttonName1: "TryAgain",
          txtbutton1Action: () {
            Get.back();
          });
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
    Get.offAllNamed(AppPages.signIn);
  }

  Future<void> signIn(String email, String password) async {
    try {
      if (signInGlobalKey.currentState!.validate()) {
        isSignInLoading.value = true;
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        isSignUpLoading.value = false;
        Get.offAllNamed(AppPages.homePage);
      }
    } catch (e) {
      isSignUpLoading.value = false;
      customAlertDialogue(
          title: "Failed",
          content: "$e",
          txtbuttonName1: "TryAgain",
          txtbutton1Action: () {
            Get.back();
          });
    }
  }
}
