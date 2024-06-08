import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:norq/product_project/presentation/themes/app_assets.dart';
import 'package:norq/product_project/presentation/themes/app_colors.dart';

class ErrorWidgetClass extends StatelessWidget {
  const ErrorWidgetClass(this.errorDetails, this.onPressed, {super.key});
  final FlutterErrorDetails errorDetails;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      errorMessage: errorDetails.exceptionAsString(),
      onPressed: onPressed,
    );
  }
}

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget(
      {super.key, required this.errorMessage, required this.onPressed});
  final String errorMessage;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: h * 0.2,
          width: w,
          child: Lottie.asset(
            AppAssets.error,
            height: h * 0.2,
            width: w,
            alignment: Alignment.center,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(
          height: h * 0.01,
        ),
        Text(
          'Error Occurred!',
          style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.white),
        ),
        SizedBox(
          height: h * 0.02,
        ),
        Text(
          errorMessage,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(color: AppColors.white, fontSize: 15),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "please try again later or ",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.white,
              ),
            ),
            TextButton(
                onPressed: onPressed,
                child: const Text(
                  "contact us",
                  style: TextStyle(
                      color: AppColors.red,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.red),
                ))
          ],
        )
      ],
    ));
  }
}
