import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:norq/product_project/presentation/manager/controller/cart_cntlr.dart';
import 'package:norq/product_project/presentation/widgets/cart/cart_Item.dart';
import 'package:norq/product_project/presentation/widgets/custom/custom_gradient_button.dart';
import 'package:norq/product_project/presentation/widgets/custom/custome_alert_dialogue.dart';
import 'package:norq/product_project/presentation/widgets/home_page/product_view.dart';

import '../../routes/app_pages.dart';
import '../../themes/app_colors.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});
  final cartcontroller = Get.put(CartCntlr());
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: CartPageAppBar(
        appBarTitle: "cart",
        onPressed: () {
          Get.back();
        },
      ),
      body: ListView(
        children: [
          CartMenu(),
          Obx(() {
            if (cartcontroller.cartList.isEmpty) {
              return SizedBox.shrink();
            } else {
              return Padding(
                padding: EdgeInsets.only(
                    left: w * 0.05, right: w * 0.05, top: h * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Total : ${cartcontroller.total.toStringAsFixed(2)}"),
                    CustomGradientButton(
                        title: "save",
                        onPressed: () {
                          cartcontroller.saveToHive(cartcontroller.cartList);
                          Get.offNamed(AppPages.homePage);
                        }),
                  ],
                ),
              );
            }
          }),
        ],
      ),
    ));
  }
}

class CartPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  CartPageAppBar({Key? key, required this.appBarTitle, this.onPressed})
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
          Obx(
            () => cartcontroller.cartList.isEmpty
                ? SizedBox.shrink()
                : IconButton(
                    onPressed: () {
                      customAlertDialogue(
                          title: "confirm",
                          content: "Are you sure to delete all items in cart",
                          txtbutton1Action: () {
                            cartcontroller.cartList.clear();
                          },
                          txtbuttonName1: "clear",
                          txtbuttonName2: "back",
                          txtbutton2Action: () {
                            Get.back();
                          });
                    },
                    icon: Icon(
                      Icons.delete_outline,
                      color: AppColors.white,
                    )),
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 60);
}
