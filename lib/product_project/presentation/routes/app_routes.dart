import 'package:get/get.dart';
import 'package:norq/product_project/presentation/manager/bindings/auth_cntlr_binding.dart';
import 'package:norq/product_project/presentation/pages/authentication/signIn_page.dart';
import 'package:norq/product_project/presentation/pages/authentication/signup_page.dart';
import 'package:norq/product_project/presentation/pages/splash.dart';
import 'package:norq/product_project/presentation/routes/app_pages.dart';

import '../pages/cart/cartpage.dart';
import '../pages/dashboard/homepage.dart';

class AppRoutes {
  static List<GetPage> routes = [
    GetPage(name: AppPages.splashScreen, page: () => SplashScreen()),
    GetPage(
        name: AppPages.signIn,
        page: () => SignIn(),
        binding: AuthCntlrBinding()),
    GetPage(
        name: AppPages.signUp,
        page: () => SignUp(),
        binding: AuthCntlrBinding()),
    GetPage(name: AppPages.homePage, page: () => HomePage()),
    GetPage(name: AppPages.cartPage, page: () => CartPage()),
  ];
}
