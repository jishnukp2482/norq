import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:norq/product_project/data/remote/modals/response/product_response_modal.dart';
import 'package:norq/product_project/presentation/manager/controller/cart/cart_cntlr.dart';
import 'package:norq/product_project/presentation/manager/controller/product/product_cntlr.dart';
import 'package:norq/product_project/presentation/routes/app_pages.dart';
import 'package:norq/product_project/presentation/themes/app_assets.dart';
import 'package:norq/product_project/presentation/themes/app_colors.dart';

import '../../manager/bindings/cart/cart_cntlr_binding.dart';
import '../../pages/home/description/product_descriptionPage.dart';

class WishListMenu extends StatelessWidget {
  WishListMenu({super.key});
  final productController = Get.find<ProductCntlr>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => productController.isWishListLoading.value
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
                    "WishList is empty",
                    style: TextStyle(color: AppColors.grey, fontSize: 18),
                  ),
                ])
          : AnimationLimiter(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: productController.wishList.length,
                itemBuilder: (context, index) {
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
                        child: WishListItem(
                            productResponseModal: productController
                                .wishList[index].productResponseModal),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class WishListItem extends StatefulWidget {
  WishListItem({
    super.key,
    required this.productResponseModal,
  });
  final ProductResponseModal productResponseModal;

  @override
  State<WishListItem> createState() => _WishListItemState();
}

class _WishListItemState extends State<WishListItem> {
  final productController = Get.find<ProductCntlr>();
  final cartController = Get.find<CartCntlr>();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.sizeOf(context).width;
    double h = MediaQuery.sizeOf(context).height;
    var existItem = cartController.cartList.any((element) =>
        element.productResponseModal.id == widget.productResponseModal.id);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: GestureDetector(
        onTap: () {
          Get.to(
              () => ProductDescriptionPage(
                  productResponseModal: widget.productResponseModal),
              binding: CartCntlrBinding());
        },
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                          imageUrl: widget.productResponseModal.image,
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
                      flex: 4,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 10, top: 10, right: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.productResponseModal.title,
                              style: const TextStyle(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "₹${widget.productResponseModal.price.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  color: AppColors.maincolor, fontSize: 15),
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
                        ],
                      ),
                    )
                  ],
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        productController
                            .addToWishList(widget.productResponseModal.id);
                      });
                    },
                    child: Container(
                      height: h * 0.03,
                      width: w * 0.07,
                      //color: AppColors.blue,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: AppColors.black,
                        //     blurRadius: 20,
                        //     blurStyle: BlurStyle.outer,
                        //   ),
                        // ]
                      ),
                      child: const Center(
                          child: Icon(
                        Icons.favorite,
                        size: 17,
                        color: AppColors.red,
                      )),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: SizedBox(
                    height: h * 0.035,
                    width: w * 0.31,
                    child: OutlinedButton(
                      onPressed: () {
                        if (existItem) {
                          Get.toNamed(AppPages.cartPage);
                        } else {
                          setState(() {
                            cartController.addToCart(
                                widget.productResponseModal,
                                1,
                                widget.productResponseModal.price);
                          });
                        }
                      },
                      child: Text(
                        existItem ? "view in Cart" : "Add to Cart",
                        style: TextStyle(color: AppColors.black, fontSize: 12),
                      ),
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: Theme.of(context).primaryColor)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
