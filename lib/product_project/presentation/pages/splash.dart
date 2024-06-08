import 'dart:async';

import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';

import 'package:norq/product_project/presentation/pages/onboarding/onboarding_page.dart';
import 'package:norq/product_project/presentation/themes/app_assets.dart';
import 'package:norq/product_project/presentation/themes/app_colors.dart';
import 'package:norq/product_project/presentation/widgets/custom/custom_Print.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: FlutterSplashScreen(
                duration: const Duration(seconds: 2),
                nextScreen: const OnBoardingScreen(),
                backgroundColor: Theme.of(context).primaryColorLight,
                splashScreenBody: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: h * 0.1,
                    ),
                    Center(
                      child: RippleAnimation(
                        child: CircleAvatar(
                          minRadius: w * 0.2,
                          maxRadius: w * 0.2,
                          backgroundImage: AssetImage(AppAssets.apklogo),
                        ),
                        color: AppColors.white,
                        delay: const Duration(milliseconds: 200),
                        repeat: true,
                        minRadius: w * 0.2,
                        ripplesCount: 7,
                        duration: const Duration(
                          milliseconds: 6 * 300,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: h * 0.1,
                    ),
                    SplashName(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SplashName extends StatefulWidget {
  const SplashName({super.key});

  @override
  State<SplashName> createState() => _SplashNameState();
}

class _SplashNameState extends State<SplashName>
    with SingleTickerProviderStateMixin {
  String text = "";
  int index = 0;
  final String fullText = "Getit";

  @override
  void initState() {
    super.initState();

    updateText();
  }

  void updateText() {
    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        if (index < fullText.length) {
          text += fullText[index];
          index++;
          customPrint("text==$text");
          customPrint("index in splas==$index");
          updateText();
        } else {
          customPrint("splashname cancel");
        }
      });
    });
  }

  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return SizedBox(
      height: h * 0.2,
      child: Opacity(
        opacity: 1.0,
        child: Text(
          text,
          style: TextStyle(
            color: AppColors.white,
            fontSize: w * 0.15,
            fontFamily: "DancingScriptBold",
          ),
        ),
      ),
    );
  }
}
