import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:norq/product_project/presentation/manager/controller/auth_cntlr.dart';
import 'package:norq/product_project/presentation/manager/controller/cart_cntlr.dart';
import 'package:norq/product_project/presentation/widgets/home_page/product_view.dart';

import '../../routes/app_pages.dart';
import '../../themes/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final authcontroller = Get.put(AuthCntlr());
    return SafeArea(
        child: Scaffold(
      appBar: HomePageAppBar(
        appBarTitle: "Norq",
        onPressed: () {
          authcontroller.signOut();
        },
      ),
      body: ListView(
        children: [
          SizedBox(
            height: h * 0.05,
          ),
          ProductViewMenu(),
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
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: w * 0.02, top: h * 0.01),
                child: IconButton(
                  onPressed: onPressed,
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(w * 0.1, 0, 0, h * 0.015),
                child: Text(
                  appBarTitle,
                  style: const TextStyle(
                    letterSpacing: 1,
                    color: AppColors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          Padding(
              padding: EdgeInsets.only(right: w * 0.1),
              child: IconButton(
                onPressed: () {
                  Get.toNamed(AppPages.cartPage);
                },
                icon: Stack(children: [
                  Icon(Icons.shopping_cart),
                  Positioned(
                      right: 0,
                      child: Obx(() {
                        if (cartcontroller.cartList.isEmpty) {
                          return SizedBox();
                        } else {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: AppColors.red,
                            ),
                            constraints: BoxConstraints(
                              minHeight: 12,
                              minWidth: 12,
                            ),
                            child: Center(
                              child: Text(
                                "${cartcontroller.cartList.length} ",
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                      }))
                ]),
                color: AppColors.white,
              ))
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 60);
}
