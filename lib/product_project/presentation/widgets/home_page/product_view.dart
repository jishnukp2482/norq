import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:norq/product_project/data/remote/modals/response/product_response_modal.dart';
import 'package:norq/product_project/presentation/manager/bindings/cart/cart_cntlr_binding.dart';
import 'package:norq/product_project/presentation/manager/bindings/product/product_cntlr_binding.dart';
import 'package:norq/product_project/presentation/manager/controller/cart/cart_cntlr.dart';
import 'package:norq/product_project/presentation/manager/controller/product/product_cntlr.dart';
import 'package:norq/product_project/presentation/pages/home/description/product_descriptionPage.dart';
import 'package:norq/product_project/presentation/routes/app_pages.dart';
import 'package:norq/product_project/presentation/themes/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:norq/product_project/presentation/widgets/custom/custom_Print.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

class ProductViewMenu extends StatefulWidget {
  const ProductViewMenu({super.key});

  @override
  State<ProductViewMenu> createState() => _ProductViewMenuState();
}

class _ProductViewMenuState extends State<ProductViewMenu> {
  final productController = Get.find<ProductCntlr>();
  final cartController = Get.find<CartCntlr>();
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.sizeOf(context).width;
    double h = MediaQuery.sizeOf(context).height;
    return Obx(
      () => productController.isproductLoading.value
          ? GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 50,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  // childAspectRatio: w / (h / 1.35),
                  childAspectRatio: w / (h / 1.37),
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20),
              itemBuilder: (context, index) {
                return ProductViewItemShimmer();
              },
            )
          : AnimationLimiter(
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: productController.productList.length,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    // childAspectRatio: w / (h / 1.35),
                    childAspectRatio: w / (h / 1.37),
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20),
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredGrid(
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    columnCount: 2,
                    child: ScaleAnimation(
                      duration: const Duration(milliseconds: 900),
                      curve: Curves.fastLinearToSlowEaseIn,
                      child: FadeInAnimation(
                        child: ProductViewItem(
                          productResponseModal:
                              productController.productList[index],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class ProductViewItem extends StatefulWidget {
  ProductViewItem({super.key, required this.productResponseModal});
  final ProductResponseModal productResponseModal;

  @override
  State<ProductViewItem> createState() => _ProductViewItemState();
}

class _ProductViewItemState extends State<ProductViewItem> {
  final cartController = Get.find<CartCntlr>();
  final productController = Get.find<ProductCntlr>();
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.sizeOf(context).width;
    double h = MediaQuery.sizeOf(context).height;
    var isFav = productController.wishList.any((element) =>
        element.productResponseModal.id == widget.productResponseModal.id);
    var existingItem = cartController.cartList.any((p0) =>
        (p0.productResponseModal.id == widget.productResponseModal.id) == true);
    customPrint("existing item in product view==$existingItem");
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: GestureDetector(
        onTap: () {
          Get.to(
              () => ProductDescriptionPage(
                  productResponseModal: widget.productResponseModal),
              binding: CartCntlrBinding());
        },
        child: SizedBox(
          // height: h * 0.2,
          width: w,
          child: Card(
            elevation: 8,
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: h * 0.15,
                          width: w * 0.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: widget.productResponseModal.image,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => SizedBox(
                              height: h * 0.15,
                              width: w * 0.01,
                              child: const Center(
                                  child: CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        Positioned(
                          right: w * 0.01,
                          top: -h * 0.08,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                productController.addToWishList(
                                    widget.productResponseModal.id);
                              });
                            },
                            onLongPress: () {
                              Get.toNamed(AppPages.wishList);
                            },
                            child: Obx(
                              () => productController.isWishListLoading.value
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : Container(
                                      height: h * 0.2,
                                      width: w * 0.07,
                                      decoration: const BoxDecoration(
                                          color: AppColors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.black,
                                              blurRadius: 20,
                                              blurStyle: BlurStyle.outer,
                                            ),
                                          ]),
                                      child: Center(
                                          child: Icon(
                                        isFav
                                            ? Icons.favorite
                                            : Icons.favorite_outline_outlined,
                                        size: 17,
                                        color: isFav
                                            ? AppColors.red
                                            : AppColors.black,
                                      )),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: w * 0.005, right: w * 0.01),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.productResponseModal.title,
                              maxLines: 2,
                              style: GoogleFonts.poppins(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: h * 0.01,
                            ),
                            Text(
                              widget.productResponseModal.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  GoogleFonts.poppins(color: AppColors.black),
                            ),
                            SizedBox(
                              height: h * 0.01,
                            ),
                            Text(
                              "₹${widget.productResponseModal.price}",
                              style: GoogleFonts.poppins(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: SizedBox(
                                height: h * 0.05,
                                width: w * 0.3,
                                child: OutlinedButton(
                                    onPressed: () {
                                      if (existingItem == true) {
                                        Get.toNamed(AppPages.cartPage);
                                      } else {
                                        setState(() {
                                          final subTotal = widget
                                                  .productResponseModal.price *
                                              1;
                                          cartController.addToCart(
                                              widget.productResponseModal,
                                              1,
                                              subTotal);
                                        });
                                      }
                                    },
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      foregroundColor: AppColors.black,
                                    ),
                                    child: Text(
                                      existingItem
                                          ? "view cart"
                                          : "Add To cart",
                                      style: GoogleFonts.poppins(fontSize: 10),
                                    )),
                              ),
                            )
                          ]),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

///////shimmer

class ProductViewItemShimmer extends StatefulWidget {
  ProductViewItemShimmer({
    super.key,
  });

  @override
  State<ProductViewItemShimmer> createState() => _ProductViewItemShimmerState();
}

class _ProductViewItemShimmerState extends State<ProductViewItemShimmer> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.sizeOf(context).width;
    double h = MediaQuery.sizeOf(context).height;

    return Shimmer.fromColors(
      baseColor: AppColors.grey.shade300,
      highlightColor: AppColors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: GestureDetector(
          onTap: () {
            // Get.to(
            //     () => ProductDescriptionPage(
            //         productResponseModal: widget.productResponseModal),
            //     binding: CartCntlrBinding());
          },
          child: SizedBox(
            // height: h * 0.2,
            width: w,
            child: Card(
              elevation: 8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: h * 0.15,
                    width: w * 0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: const Text(""),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: w * 0.005, right: w * 0.01),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "",
                            maxLines: 2,
                            style: GoogleFonts.poppins(
                                color: AppColors.black,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: h * 0.01,
                          ),
                          Text(
                            "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(color: AppColors.black),
                          ),
                          SizedBox(
                            height: h * 0.01,
                          ),
                          Text(
                            "₹${""}",
                            style: GoogleFonts.poppins(
                                color: AppColors.black,
                                fontWeight: FontWeight.w500),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: SizedBox(
                              height: h * 0.05,
                              width: w * 0.3,
                              child: OutlinedButton(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    foregroundColor: AppColors.black,
                                  ),
                                  child: Text(
                                    "view cart",
                                    style: GoogleFonts.poppins(fontSize: 10),
                                  )),
                            ),
                          )
                        ]),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
