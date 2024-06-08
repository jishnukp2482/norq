import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:norq/product_project/domain/entities/bottom_nav/bottom_Nav_Modal.dart';
import 'package:norq/product_project/domain/entities/onboarding/onboarding_modal.dart';
import 'package:norq/product_project/presentation/pages/onboarding/onboarding_page.dart';
import 'package:norq/product_project/presentation/themes/app_assets.dart';
import 'package:norq/product_project/presentation/themes/app_colors.dart';
import '../../../routes/LocalStorageNames.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/custom/custome_alert_dialogue.dart';

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

        String uid = firebaseAuth.currentUser!.uid;
        box.write(LocalStorageNames.userid, uid);
        Get.offAllNamed(AppPages.bottomNavPage);
      }
    } catch (e) {
      //isSignUpLoading.value = false;
      customAlertDialogue(
          title: "Failed",
          content: "Invalid ",
          txtbuttonName1: "TryAgain",
          txtbutton1Action: () {
            Get.back();
          });
    } finally {
      isSignInLoading.value = false;
    }
  }

  ///onboarding screen
  final currentOnboardingPage = 0.obs;

  final onboardingPageData = <OnBoardingModal>[
    OnBoardingModal(
        "Discover New Local Products",
        AppAssets.onboarding1,
        "Explore a diverse range of locally sourced products right at your fingertips. From artisanal crafts to farm-fresh produce, uncover unique treasures and support local businesses in your community. Start discovering today!",
        () {}),
    OnBoardingModal(
        "Easy & Safe Payment",
        AppAssets.onboarding2,
        "Experience hassle-free transactions with our secure payment system. From credit cards to digital wallets, shop with confidence knowing that your financial information is protected. Enjoy seamless payments and worry-free shopping every time!",
        () {}),
    OnBoardingModal(
        "Personalized Recommendations",
        AppAssets.onboarding3,
        "Receive tailored recommendations based on your preferences and browsing history. Discover new products that match your interests and preferences, ensuring a personalized shopping experience like no other. Start exploring today and uncover hidden gems curated just for you!",
        () {}),
    OnBoardingModal(
        "Enjoy Your Shopping",
        AppAssets.onboarding4,
        "Indulge in a delightful shopping experience with our user-friendly interface and extensive product catalog. Whether you're browsing for essentials or treating yourself to something special, we've got you covered. Sit back, relax, and enjoy the convenience of shopping from the comfort of your own home. Happy shopping!",
        () {}),
  ];

  ///bottom nav
  final currentpage = 0.obs;
  final isCurrentPageLoading = false.obs;
  changePage(int id) {
    isCurrentPageLoading.value = true;
    currentpage.value = id;
    updateColorIcon();
    isCurrentPageLoading.value = false;
  }

  updateColorIcon() {
    for (int i = 0; i < bottomNavIconList.length; i++) {
      bottomNavIconList[i].iconcolor =
          currentpage.value == i ? AppColors.white : AppColors.grey;
    }
  }

  final List bottomNavIconList = <BottomNavModal>[
    BottomNavModal(
      0,
      Icons.home,
      AppColors.grey,
    ),
    BottomNavModal(
      1,
      Icons.search,
      AppColors.grey,
    ),
    BottomNavModal(
      2,
      Icons.shopping_cart,
      AppColors.grey,
    ),
    BottomNavModal(
      3,
      Icons.favorite,
      AppColors.grey,
    ),
    BottomNavModal(
      4,
      Icons.settings,
      AppColors.grey,
    ),
  ];
}
