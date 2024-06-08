import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:norq/product_project/presentation/widgets/custom/custom_label_text_Filed.dart';

import '../../manager/controller/auth/auth_cntlr.dart';
import '../../routes/app_pages.dart';
import '../../themes/app_colors.dart';
import '../../widgets/custom/custom_gradient_button.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});
  final authController = Get.find<AuthCntlr>();
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    final w = MediaQuery.sizeOf(context).width;

    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColorLight,
                        Theme.of(context).primaryColorDark,
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      w * 0.05,
                      h * 0.01,
                      w * 0.05,
                      h * 0.05,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Create your",
                                  style: GoogleFonts.lora(
                                      color: AppColors.white,
                                      fontSize: w * 0.1,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: h * 0.005,
                                ),
                                Text(
                                  "Account",
                                  style: GoogleFonts.lora(
                                      color: AppColors.white,
                                      fontSize: w * 0.12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: h * 0.75,
                    width: w,
                    padding: EdgeInsets.fromLTRB(
                      w * 0.05,
                      h * 0.05,
                      w * 0.05,
                      h * 0.05,
                    ),
                    decoration: const BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35),
                        )),
                    child: SingleChildScrollView(
                      child: Form(
                        key: authController.signupGlobalKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LabelCustomTextField(
                              hintText: "enter your Name",
                              textFieldLabel: "Full Name",
                              controller: authController.signupNameController,
                              textFieldLabelColor:
                                  Theme.of(context).primaryColor,
                              validator: (p0) {
                                if (p0.isEmpty) {
                                  return 'please enter your name.';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: h * 0.025,
                            ),
                            LabelCustomTextField(
                              hintText: "enter your E-mail",
                              textFieldLabel: "G-Mail",
                              controller: authController.signupMailController,
                              textFieldLabelColor:
                                  Theme.of(context).primaryColor,
                              validator: (p0) {
                                final emailRegex = RegExp(
                                    r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
                                if (!emailRegex.hasMatch(p0)) {
                                  return 'Enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: h * 0.025,
                            ),
                            LabelCustomTextField(
                              hintText: "enter your Password",
                              textFieldLabel: "Password",
                              controller:
                                  authController.signupPasswordController,
                              passwordfield: true,
                              textFieldLabelColor:
                                  Theme.of(context).primaryColor,
                              validator: (p0) {
                                if (p0.isEmpty) {
                                  return 'please enter a password';
                                } else if (p0.length < 8) {
                                  return 'Password must be at least 8 characters long';
                                } else if (!p0.contains(RegExp(r'[A-Z]'))) {
                                  return 'Password must contain at least one uppercase letter';
                                } else if (!p0.contains(RegExp(r'[a-z]'))) {
                                  return 'Password must contain at least one lowercase letter';
                                } else if (!p0.contains(RegExp(r'[0-9]'))) {
                                  return 'Password must contain at least one digit';
                                } else if (!p0.contains(
                                    RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                                  return 'Password must contain at least one special character';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: h * 0.025,
                            ),
                            LabelCustomTextField(
                                hintText: "enter your Password",
                                textFieldLabel: "Confirm password",
                                controller: authController
                                    .signupConfirmPasswordController,
                                passwordfield: true,
                                textFieldLabelColor:
                                    Theme.of(context).primaryColor,
                                validator: (p0) {
                                  if (p0 !=
                                      authController
                                          .signupPasswordController.text) {
                                    return 'password and confirm Password do not match';
                                  }
                                  return null;
                                }),
                            SizedBox(
                              height: h * 0.025,
                            ),
                            Align(
                                alignment: Alignment.center,
                                child: Obx(
                                  () => authController.isSignUpLoading.value
                                      ? SizedBox(
                                          height: h * 0.045,
                                          width: w * 0.1,
                                          child: CircularProgressIndicator(),
                                        )
                                      : CustomGradientButton(
                                          title: "Sign up",
                                          onPressed: () {
                                            authController.signUp(
                                                authController
                                                    .signupNameController.text,
                                                authController
                                                    .signupMailController.text,
                                                authController
                                                    .signupPasswordController
                                                    .text);
                                          }),
                                )),
                            SizedBox(
                              height: h * 0.025,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(AppPages.signIn);
                                  },
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "if you already have an account?",
                                        style: TextStyle(
                                            color: AppColors.grey,
                                            fontSize: 14),
                                      ),
                                      Text(
                                        "Sign in",
                                        style: TextStyle(
                                            color: AppColors.black,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }
}
