import 'package:get/get.dart';
import 'package:norq/product_project/presentation/manager/bindings/auth/auth_cntlr_binding.dart';
import 'package:norq/product_project/presentation/manager/bindings/cart/cart_cntlr_binding.dart';
import 'package:norq/product_project/presentation/manager/bindings/product/product_cntlr_binding.dart';
import 'package:norq/product_project/presentation/pages/authentication/signIn_page.dart';
import 'package:norq/product_project/presentation/pages/authentication/signup_page.dart';
import 'package:norq/product_project/presentation/pages/home/wishlist/wishList_page.dart';
import 'package:norq/product_project/presentation/pages/onboarding/onboarding_page.dart';
import 'package:norq/product_project/presentation/pages/splash.dart';
import 'package:norq/product_project/presentation/routes/app_pages.dart';

import '../pages/bottom_nav/bottom_nav.dart';
import '../pages/cart/cartpage.dart';
import '../pages/home/homepage.dart';

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
    GetPage(name: AppPages.homePage, page: () => HomePage(), bindings: [
      AuthCntlrBinding(),
      ProductCntlrBinding(),
      CartCntlrBinding()
    ]),
    GetPage(
        name: AppPages.cartPage,
        page: () => CartPage(),
        transition: Transition.fade,
        binding: CartCntlrBinding()),
    GetPage(
        name: AppPages.onboardingPage,
        page: () => OnBoardingScreen(),
        binding: AuthCntlrBinding()),
    GetPage(name: AppPages.bottomNavPage, page: () => BottomNav(), bindings: [
      AuthCntlrBinding(),
      ProductCntlrBinding(),
      CartCntlrBinding()
    ]),
    GetPage(
        name: AppPages.wishList,
        page: () => WishListPage(),
        bindings: [ProductCntlrBinding(), CartCntlrBinding()]),
  ];
}
