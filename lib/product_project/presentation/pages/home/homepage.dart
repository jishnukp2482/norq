import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:norq/product_project/presentation/manager/controller/auth/auth_cntlr.dart';
import 'package:norq/product_project/presentation/manager/controller/cart/cart_cntlr.dart';
import 'package:norq/product_project/presentation/routes/LocalStorageNames.dart';
import 'package:norq/product_project/presentation/widgets/home_page/product_view.dart';

import '../../manager/controller/product/product_cntlr.dart';
import '../../routes/app_pages.dart';
import '../../themes/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final authcontroller = Get.find<AuthCntlr>();
  final productController = Get.find<ProductCntlr>();
  final cartController = Get.find<CartCntlr>();
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cartController.saveCartListToFireBase(
        cartController.box.read(LocalStorageNames.userid));
    productController.saveWishListToFireBase(productController.userID);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Get.offAllNamed(AppPages.signIn);
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
      appBar: HomePageAppBar(
        appBarTitle: "GetIt",
        onPressed: () {
          authcontroller.signOut();
        },
      ),
      body: ListView(
        children: [
          SizedBox(
            height: h * 0.02,
          ),
          const ProductViewMenu(),
          SizedBox(
            height: h * 0.02,
          ),
        ],
      ),
    ));
  }
}

class HomePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  HomePageAppBar({Key? key, required this.appBarTitle, this.onPressed})
      : super(key: key);

  final String appBarTitle;
  final VoidCallback? onPressed;
  final cartcontroller = Get.put(CartCntlr());
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
      width: w,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(60),
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 15,
            color: AppColors.black,
            blurStyle: BlurStyle.outer,
          ),
        ],
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColorLight,
            Theme.of(context).primaryColorDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          tileMode: TileMode.mirror,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: w * 0.02, top: h * 0.01),
            child: SizedBox(
              //color: AppColors.blue,
              child: Row(
                children: [
                  IconButton(
                    onPressed: onPressed,
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(w * 0.02, 0, 0, 0),
                    child: Text(
                      appBarTitle,
                      style: TextStyle(
                        letterSpacing: 1,
                        color: AppColors.white,
                        fontSize: w * 0.08,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(right: w * 0.1),
              child: CircleAvatar(
                radius: w * 0.05,
                backgroundColor: AppColors.white,
                child: Center(
                  child: Icon(
                    Icons.person_outline_outlined,
                    color: AppColors.black,
                  ),
                ),
              ))
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 30);
}
