import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:norq/injector.dart';
import 'package:norq/product_project/presentation/manager/controller/cart/cart_cntlr.dart';
import 'package:norq/product_project/presentation/manager/controller/product/product_cntlr.dart';
import 'package:norq/product_project/presentation/routes/LocalStorageNames.dart';
import 'package:norq/product_project/presentation/routes/app_pages.dart';
import 'package:norq/product_project/presentation/routes/app_routes.dart';
import 'package:norq/product_project/presentation/themes/app_theme.dart';
import 'package:norq/product_project/presentation/widgets/custom/custom_error_widget.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // builder: (context, child) {
      //   ErrorWidget.builder = (details) {
      //     return ErrorWidgetClass(details, () {});
      //   };
      //   return child!;
      // },
      onDispose: () {
        saveDataToDatabase();
      },
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.splashScreen,
      getPages: AppRoutes.routes,
    );
  }

  void saveDataToDatabase() {
    final cartcontroller = Get.put(CartCntlr());
    final productController = Get.put(ProductCntlr(sl()));
    cartcontroller.saveCartListToFireBase(
        cartcontroller.box.read(LocalStorageNames.userid));
    productController.saveWishListToFireBase(productController.userID);
  }
}
