import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:norq/product_project/presentation/themes/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        scaffoldBackgroundColor: AppColors.backgroundcolor,
        // elevatedButtonTheme: ElevatedButtonThemeData(
        //     style: ButtonStyle(
        //         foregroundColor:
        //             const MaterialStatePropertyAll(AppColors.white),
        //         backgroundColor:
        //             const MaterialStatePropertyAll(AppColors.maincolor),
        //         shape: MaterialStatePropertyAll(
        //           RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(10),
        //           ),
        //         ))),
        inputDecorationTheme: const InputDecorationTheme(
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        primarySwatch: Colors.blue,
        primaryColor: AppColors.maincolor,
        primaryColorLight: AppColors.maincolor2,
        primaryColorDark: AppColors.maincolor3,
      );
}
