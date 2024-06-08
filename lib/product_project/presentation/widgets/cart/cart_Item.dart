import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:norq/product_project/data/remote/modals/response/product_response_modal.dart';
import 'package:norq/product_project/domain/entities/cart/Cart_Modal.dart';
import 'package:norq/product_project/presentation/manager/bindings/cart/cart_cntlr_binding.dart';
import 'package:norq/product_project/presentation/manager/controller/cart/cart_cntlr.dart';
import 'package:norq/product_project/presentation/themes/app_assets.dart';
import 'package:norq/product_project/presentation/themes/app_colors.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../pages/home/description/product_descriptionPage.dart';

class CartMenu extends StatefulWidget {
  const CartMenu({super.key});

  @override
  State<CartMenu> createState() => _CartMenuState();
}

class _CartMenuState extends State<CartMenu> {
  final cartController = Get.find<CartCntlr>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => cartController.cartList.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.2,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Lottie.asset(AppAssets.emptycart, fit: BoxFit.cover),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "your cart is empty",
                    style: TextStyle(color: AppColors.grey, fontSize: 18),
                  ),
                ])
          : AnimationLimiter(
              child: Obx(
                () => cartController.isRemoveCart.value
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: cartController.cartList.length,
                        itemBuilder: (context, index) {
                          final cartlist = cartController.cartList;
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            delay: Duration(milliseconds: 100),
                            child: SlideAnimation(
                              duration: Duration(milliseconds: 2500),
                              curve: Curves.fastLinearToSlowEaseIn,
                              verticalOffset: -250,
                              child: ScaleAnimation(
                                duration: Duration(milliseconds: 1500),
                                curve: Curves.fastLinearToSlowEaseIn,
                                child: CartItem(
                                  model: cartlist[index],
                                  countNotifier: ValueNotifier<int>(
                                      cartlist[index].quantity),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
    );
  }
}

class CartItem extends StatefulWidget {
  CartItem({super.key, required this.model, required this.countNotifier});
  final CartModal model;
  final ValueNotifier<int> countNotifier;
  ValueNotifier<bool> isSelected = ValueNotifier<bool>(false);

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  final cartController = Get.put(CartCntlr());

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.sizeOf(context).width;
    double h = MediaQuery.sizeOf(context).height;
    return Obx(
      () => cartController.isSelectedCartItemsListLoading.value
          ? SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: GestureDetector(
                onLongPress: cartController.selectedcartItemsList.isEmpty
                    ? () {
                        setState(() {
                          widget.isSelected.value = true;
                          cartController.addItemsToselection(widget.model);
                        });
                      }
                    : null,
                onTap: () {
                  if (cartController.selectedcartItemsList.isEmpty) {
                    Get.to(
                        () => ProductDescriptionPage(
                            productResponseModal:
                                widget.model.productResponseModal),
                        binding: CartCntlrBinding());
                  } else {
                    setState(() {
                      if (widget.isSelected.value) {
                        widget.isSelected.value = false;
                        cartController.addItemsToselection(widget.model);
                      } else {
                        widget.isSelected.value = true;
                        cartController.addItemsToselection(widget.model);
                      }
                    });
                  }
                },
                child: Card(
                  color: widget.isSelected.value
                      ? AppColors.lightBlue.withOpacity(0.5)
                      : AppColors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 60,
                                width: 50,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      widget.model.productResponseModal.image,
                                  fit: BoxFit.fill,
                                  placeholder: (context, url) => SizedBox(
                                    height: h * 0.045,
                                    width: w * 0.1,
                                    child: const CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, top: 10, right: 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.model.productResponseModal.title,
                                      style: const TextStyle(
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "₹${widget.model.subtotal.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                          color: AppColors.maincolor,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: h * 0.05,
                                  ),
                                  Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: AppColors.maincolor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          iconSize: 10,
                                          onPressed: widget.isSelected.value
                                              ? null
                                              : () {
                                                  if (widget
                                                          .countNotifier.value >
                                                      0) {
                                                    widget
                                                        .countNotifier.value--;
                                                    debugPrint(
                                                        "count notifier=${widget.countNotifier.value}");
                                                    cartController.removeFromcart(
                                                        widget.model
                                                            .productResponseModal,
                                                        widget.countNotifier
                                                            .value,
                                                        cartController.subtotalcalculation(
                                                            widget
                                                                .model
                                                                .productResponseModal
                                                                .price,
                                                            widget.countNotifier
                                                                .value));
                                                  }
                                                },
                                          icon: const Icon(
                                            Icons.remove,
                                            color: AppColors.white,
                                          ),
                                        ),
                                        ValueListenableBuilder(
                                          valueListenable: widget.countNotifier,
                                          builder: (context, value, child) {
                                            return Text(
                                              "${widget.countNotifier.value}",
                                              style: const TextStyle(
                                                  color: AppColors.white),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          iconSize: 10,
                                          onPressed: widget.isSelected.value
                                              ? null
                                              : () {
                                                  widget.countNotifier.value++;
                                                  cartController.addToCart(
                                                      widget.model
                                                          .productResponseModal,
                                                      widget
                                                          .countNotifier.value,
                                                      cartController.subtotalcalculation(
                                                          widget
                                                              .model
                                                              .productResponseModal
                                                              .price,
                                                          widget.countNotifier
                                                              .value));
                                                },
                                          icon: const Icon(
                                            Icons.add,
                                            color: AppColors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Positioned(
                            right: 0,
                            top: 0,
                            child: widget.isSelected.value
                                ? (widget.isSelected.value &&
                                        cartController
                                            .selectedcartItemsList.isNotEmpty
                                    ? Icon(Icons.radio_button_checked)
                                    : Icon(Icons.radio_button_unchecked))
                                : (cartController
                                        .selectedcartItemsList.isNotEmpty
                                    ? Icon(Icons.radio_button_unchecked)
                                    : IconButton(
                                        onPressed: () {
                                          cartController
                                              .deletefromcart(widget.model);
                                        },
                                        icon: const Icon(
                                          Icons.delete_outlined,
                                          size: 15,
                                          color: AppColors.black,
                                        ),
                                      ))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
