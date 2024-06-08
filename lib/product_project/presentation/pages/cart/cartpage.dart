import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:norq/product_project/presentation/manager/controller/cart/cart_cntlr.dart';
import 'package:norq/product_project/presentation/manager/controller/product/product_cntlr.dart';
import 'package:norq/product_project/presentation/routes/LocalStorageNames.dart';
import 'package:norq/product_project/presentation/widgets/cart/cart_Item.dart';
import 'package:norq/product_project/presentation/widgets/custom/custom_Print.dart';
import 'package:norq/product_project/presentation/widgets/custom/custom_gradient_button.dart';
import 'package:norq/product_project/presentation/widgets/custom/custome_alert_dialogue.dart';
import 'package:norq/product_project/presentation/widgets/home_page/product_view.dart';

import '../../routes/app_pages.dart';
import '../../themes/app_colors.dart';

class CartPage extends StatefulWidget {
  CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final cartcontroller = Get.find<CartCntlr>();
  final productController = Get.find<ProductCntlr>();
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
            appBar: CartPageAppBar(
              appBarTitle: "cart",
              onPressed: () {
                customPrint("cart back pressed");
                //   productController.getproducts();
                Get.back();
                // Get.offAllNamed(AppPages.homePage);
              },
            ),
            body: PopScope(
              canPop: true,
              onPopInvoked: (didPop) {
                productController.getproducts();
                //  Get.back();
              },
              child: ListView(
                children: [
                  const CartMenu(),
                ],
              ),
            ),
            bottomNavigationBar: Obx(
              () => cartcontroller.isSelectedCartItemsListLoading.value
                  ? const SizedBox.shrink()
                  : Container(
                      height: cartcontroller.selectedcartItemsList.isEmpty
                          ? h * 0.07
                          : h * 0.09,
                      // color: AppColors.green,
                      child: Obx(() {
                        if (cartcontroller.cartList.isEmpty) {
                          return const SizedBox.shrink();
                        } else {
                          return Padding(
                            padding: EdgeInsets.only(
                                top: h * 0.002,
                                left: w * 0.02,
                                right: w * 0.02,
                                bottom: h * 0.002),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        cartcontroller
                                                .selectedcartItemsList.isEmpty
                                            ? Column(
                                                children: [
                                                  Text(
                                                    "Total :",
                                                    textAlign: TextAlign.left,
                                                    style: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: h * 0.005,
                                                  ),
                                                  Obx(
                                                    () =>
                                                        cartcontroller
                                                                .isTotalLoading
                                                                .value
                                                            ? const SizedBox
                                                                .shrink()
                                                            : Text(
                                                                " ₹ ${cartcontroller.total.toStringAsFixed(2)}",
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: GoogleFonts.poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  Text(
                                                    "Total :",
                                                    textAlign: TextAlign.left,
                                                    style: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Obx(
                                                    () =>
                                                        cartcontroller
                                                                .isTotalLoading
                                                                .value
                                                            ? const SizedBox
                                                                .shrink()
                                                            : Text(
                                                                " ₹ ${cartcontroller.total.toStringAsFixed(2)}",
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: GoogleFonts.poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                  ),
                                                ],
                                              ),
                                      ],
                                    ),
                                    cartcontroller
                                            .selectedcartItemsList.isNotEmpty
                                        ? const SizedBox.shrink()
                                        : CustomGradientButton(
                                            width: w * 0.3,
                                            height: h * 0.05,
                                            title: "Place Order",
                                            titleFontSize: w * 0.035,
                                            uppercase: false,
                                            onPressed: () {
                                              // cartcontroller
                                              //     .saveToHive(cartcontroller.cartList);
                                              Get.offNamed(AppPages.homePage);
                                            }),
                                  ],
                                ),
                                cartcontroller.selectedcartItemsList.isEmpty
                                    ? const SizedBox.shrink()
                                    : Column(
                                        children: [
                                          SizedBox(
                                            height: h * 0.005,
                                          ),
                                          Container(
                                            height: h * 0.05,
                                            width: w,
                                            decoration: BoxDecoration(
                                              //  color: AppColors.blue,
                                              border: Border.all(
                                                  color: AppColors.grey),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        for (var i in cartcontroller
                                                            .selectedcartItemsList) {
                                                          customPrint(
                                                              "selected item removing item==${i.productResponseModal.id}");
                                                          cartcontroller
                                                              .deletefromcart(
                                                                  i);
                                                        }
                                                        cartcontroller
                                                            .selectedcartItemsList
                                                            .clear();
                                                        customPrint(
                                                            "items in selectedcartlist=${cartcontroller.selectedcartItemsList.map((element) => element.productResponseModal.id)}");
                                                      });
                                                    },
                                                    child: SizedBox(
                                                      width: w * 0.3,
                                                      // color: AppColors.darkOrange,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .delete_outline,
                                                            size: w * 0.05,
                                                            color:
                                                                AppColors.black,
                                                          ),
                                                          Text(
                                                            "Remove",
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    fontSize: w *
                                                                        0.03,
                                                                    color: AppColors
                                                                        .black),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Center(
                                                    child: Container(
                                                      height: h * 0.05,
                                                      width: w * 0.003,
                                                      color: AppColors.grey,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    width: w * 0.3,
                                                    // color: AppColors.darkOrange,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .flash_on_outlined,
                                                          size: w * 0.05,
                                                          color:
                                                              AppColors.black,
                                                        ),
                                                        Text(
                                                          cartcontroller
                                                                      .selectedcartItemsList
                                                                      .length ==
                                                                  1
                                                              ? "Buy this Item"
                                                              : "Buy these Items",
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  fontSize:
                                                                      w * 0.03,
                                                                  color: AppColors
                                                                      .black),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                              ],
                            ),
                          );
                        }
                      }),
                    ),
            )));
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
          SizedBox(
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
                  padding: EdgeInsets.fromLTRB(w * 0.02, 0, w * 0.02, 0),
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
          // Obx(
          //   () => cartcontroller.cartList.isEmpty
          //       ? const SizedBox.shrink()
          //       : IconButton(
          //           onPressed: () {
          //             customAlertDialogue(
          //                 title: "confirm",
          //                 content: "Are you sure to delete all items in cart",
          //                 txtbutton1Action: () {
          //                   cartcontroller.cartList.clear();

          //                   Get.back();
          //                 },
          //                 txtbuttonName1: "clear",
          //                 txtbuttonName2: "Cancel",
          //                 txtbutton2Action: () {
          //                   Get.back();
          //                 });
          //           },
          //           icon: const Icon(
          //             Icons.delete_outline,
          //             color: AppColors.white,
          //           )),
          // )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 35);
}
