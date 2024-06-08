import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:norq/product_project/domain/entities/onboarding/onboarding_modal.dart';
import 'package:norq/product_project/presentation/manager/controller/auth/auth_cntlr.dart';
import 'package:norq/product_project/presentation/routes/app_pages.dart';
import 'package:norq/product_project/presentation/themes/app_colors.dart';
import 'package:norq/product_project/presentation/widgets/custom/custom_gradient_button.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final authController = Get.put(AuthCntlr());

  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      backgroundColor: authController.currentOnboardingPage.value == 3
          ? Theme.of(context).primaryColor
          : AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: h * 0.17,
            ),
            Container(
              height: h * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: authController.currentOnboardingPage.value == 0
                      ? Radius.circular(350)
                      : authController.currentOnboardingPage.value == 2
                          ? Radius.circular(250)
                          : Radius.circular(0),
                  topLeft: authController.currentOnboardingPage.value == 1
                      ? Radius.circular(350)
                      : authController.currentOnboardingPage.value == 2
                          ? Radius.circular(250)
                          : Radius.circular(0),
                ),
                color: () {
                  switch (authController.currentOnboardingPage.value) {
                    case 0:
                      return Theme.of(context).primaryColor;
                    case 1:
                      return Theme.of(context).primaryColorLight;
                    case 2:
                      return Theme.of(context).primaryColorDark;
                    case 3:
                      return Theme.of(context).primaryColor;
                    default:
                      return AppColors.white;
                  }
                }(),
              ),
              child: Column(
                children: [
                  Expanded(
                      child: PageView.builder(
                    controller: pageController,
                    itemBuilder: (context, index) {
                      return OnBoardingPage(
                          onBoardingModal:
                              authController.onboardingPageData[index]);
                    },
                    itemCount: authController.onboardingPageData.length,
                    onPageChanged: (int page) {
                      setState(() {
                        authController.currentOnboardingPage.value = page;
                      });
                    },
                  )),
                  Obx(() => PageViewDotIndicator(
                        selectedColor: AppColors.white,
                        unselectedColor: AppColors.greyText,
                        currentItem: authController.currentOnboardingPage.value,
                        count: authController.onboardingPageData.length,
                        size: Size(w * 0.02, h * 0.02),
                        unselectedSize: Size(w * 0.02, h * 0.02),
                      )),
                  SizedBox(
                    height: h * 0.03,
                  ),
                  Obx(
                    () => authController.currentOnboardingPage.value == 3
                        ? Column(
                            children: [
                              CustomGradientButton(
                                  title: "Get Started",
                                  buttonFColor:
                                      Theme.of(context).primaryColorDark,
                                  buttonSColor:
                                      Theme.of(context).primaryColorDark,
                                  buttonTColor:
                                      Theme.of(context).primaryColorDark,
                                  onPressed: () {
                                    Get.offAllNamed(AppPages.signIn);
                                  }),
                              SizedBox(
                                height: h * 0.05,
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Get.offAllNamed(AppPages.signIn);
                                  },
                                  child: Text(
                                    "Skip",
                                    style: TextStyle(color: AppColors.white),
                                  )),
                              CustomGradientButton(
                                title: "Next",
                                width: w * 0.3,
                                onPressed: () {
                                  setState(() {
                                    authController.currentOnboardingPage.value =
                                        authController
                                                .currentOnboardingPage.value +
                                            1;
                                  });
                                },
                                boxShadow: false,
                                buttonFColor: () {
                                  switch (authController
                                      .currentOnboardingPage.value) {
                                    case 0:
                                      return Theme.of(context).primaryColor;
                                    case 1:
                                      return Theme.of(context)
                                          .primaryColorLight;
                                    case 2:
                                      return Theme.of(context).primaryColorDark;

                                    default:
                                      return Theme.of(context).primaryColorDark;
                                  }
                                }(),
                                buttonSColor: () {
                                  switch (authController
                                      .currentOnboardingPage.value) {
                                    case 0:
                                      return Theme.of(context).primaryColor;
                                    case 1:
                                      return Theme.of(context)
                                          .primaryColorLight;
                                    case 2:
                                      return Theme.of(context).primaryColorDark;

                                    default:
                                      return Theme.of(context).primaryColorDark;
                                  }
                                }(),
                                buttonTColor: () {
                                  switch (authController
                                      .currentOnboardingPage.value) {
                                    case 0:
                                      return Theme.of(context).primaryColor;
                                    case 1:
                                      return Theme.of(context)
                                          .primaryColorLight;
                                    case 2:
                                      return Theme.of(context).primaryColorDark;

                                    default:
                                      return Theme.of(context).primaryColorDark;
                                  }
                                }(),
                              )
                            ],
                          ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key, required this.onBoardingModal});
  final OnBoardingModal onBoardingModal;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: h * 0.3,
          width: w * 0.8,
          decoration: BoxDecoration(
              // color: AppColors.green,
              image: DecorationImage(
                  image: AssetImage(onBoardingModal.image), fit: BoxFit.cover)),
        ),
        SizedBox(
          height: h * 0.05,
        ),
        Text(
          onBoardingModal.title,
          style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              fontFamily: "PoppinsBold",
              fontSize: w * 0.05),
        ),
        SizedBox(
          height: h * 0.05,
        ),
        Container(
            width: w * 0.95,
            // color: AppColors.red,
            child: Text(
              onBoardingModal.description,
              style: TextStyle(
                  fontSize: w * 0.05,
                  color: AppColors.white,
                  fontFamily: "DancingScriptvariable"),
            )),
      ],
    );
  }
}
