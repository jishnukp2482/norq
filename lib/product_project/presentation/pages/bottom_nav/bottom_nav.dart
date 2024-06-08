import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:norq/product_project/domain/entities/bottom_nav/bottom_Nav_Modal.dart';
import 'package:norq/product_project/presentation/manager/controller/auth/auth_cntlr.dart';
import 'package:norq/product_project/presentation/manager/controller/cart/cart_cntlr.dart';
import 'package:norq/product_project/presentation/pages/cart/cartpage.dart';
import 'package:norq/product_project/presentation/pages/home/homepage.dart';
import 'package:norq/product_project/presentation/widgets/custom/custom_Print.dart';

import '../../themes/app_colors.dart';
import '../home/wishlist/wishList_page.dart';

class BottomNav extends StatefulWidget {
  BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  final authController = Get.find<AuthCntlr>();
  bool isclicked = false;
  @override
  void initState() {
    authController.changePage(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
      body: Obx(() {
        Widget page;
        switch (authController.currentpage.value) {
          case 0:
            page = HomePage();
            break;
          case 1:
            page = Text("serch");
            break;
          case 2:
            page = CartPage();
            break;
          case 3:
            page = WishListPage();
            break;
          case 4:
            page = Text("settings");
            break;
          default:
            page = Text("error");
            break;
        }
        return page;
      }),
      bottomNavigationBar: Container(
          height: h * 0.06,
          width: w * 0.7,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: isclicked ? Alignment.centerLeft : Alignment.centerRight,
                end: isclicked ? Alignment.centerRight : Alignment.centerLeft,
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColorLight,
                  Theme.of(context).primaryColorDark,
                ]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: authController.bottomNavIconList.map((e) {
              return Obx(
                () => authController.isCurrentPageLoading.value
                    ? SizedBox()
                    : BottomNAVIcon(
                        bottomNavModal: e,
                        ontap: () {
                          setState(() {
                            authController.changePage(e.id);
                            customPrint(
                                "current page==${authController.currentpage.value}");
                            isclicked = !isclicked;
                          });
                        }),
              );
            }).toList(),
          )),
    ));
  }
}

class BottomNAVIcon extends StatelessWidget {
  BottomNAVIcon({super.key, required this.ontap, required this.bottomNavModal});
  final BottomNavModal bottomNavModal;

  final Function ontap;
  final cartcontroller = Get.find<CartCntlr>();
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.fromLTRB(w * 0.01, h * 0.01, w * 0.02, h * 0.01),
      child: GestureDetector(
        onTap: () {
          ontap();
        },
        child: Container(
          //color: AppColors.green,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Icon(
                    bottomNavModal.icon,
                    color: bottomNavModal.iconcolor,
                    size: 17,
                  ),
                  bottomNavModal.id == 2
                      ? Positioned(
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
                                  minHeight: 10,
                                  minWidth: 10,
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
                      : SizedBox.shrink(),
                ],
              ),
              SizedBox(
                height: h * 0.002,
              ),
              Container(
                height: h * 0.003,
                width: w * 0.075,
                decoration: BoxDecoration(
                  color: bottomNavModal.iconcolor,
                  borderRadius: BorderRadius.circular(20),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

  // Stack(
        //   children: [
        //     page,
        //     Positioned(
        //       left: w * 0.15,
        //       bottom: h * 0.02,
        //       child:
        //       Container(
        //           height: h * 0.06,
        //           width: w * 0.7,
        //           decoration: BoxDecoration(
        //             gradient: LinearGradient(
        //                 begin: isclicked
        //                     ? Alignment.centerLeft
        //                     : Alignment.centerRight,
        //                 end: isclicked
        //                     ? Alignment.centerRight
        //                     : Alignment.centerLeft,
        //                 colors: [
        //                   Theme.of(context).primaryColor,
        //                   Theme.of(context).primaryColorLight,
        //                   Theme.of(context).primaryColorDark,
        //                 ]),
        //             borderRadius: BorderRadius.circular(20),
        //           ),
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //             children: authController.bottomNavIconList.map((e) {
        //               return Obx(
        //                 () => authController.isCurrentPageLoading.value
        //                     ? SizedBox()
        //                     : BottomNAVIcon(
        //                         icon: e.icon,
        //                         color: e.iconcolor,
        //                         ontap: () {
        //                           setState(() {
        //                             authController.changePage(e.id);
        //                             customPrint(
        //                                 "current page==${authController.currentpage.value}");
        //                             isclicked = !isclicked;
        //                           });
        //                         }),
        //               );
        //             }).toList(),
        //           )),
        //     )
        //   ],
        // );