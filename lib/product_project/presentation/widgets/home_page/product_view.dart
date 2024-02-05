import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:norq/injector.dart';
import 'package:norq/product_project/data/remote/modals/response/product_response_modal.dart';
import 'package:norq/product_project/domain/entities/Cart_Modal.dart';
import 'package:norq/product_project/presentation/manager/controller/cart_cntlr.dart';
import 'package:norq/product_project/presentation/manager/controller/product_cntlr.dart';
import 'package:norq/product_project/presentation/pages/dashboard/product_descriptionPage.dart';
import 'package:norq/product_project/presentation/routes/app_pages.dart';
import 'package:norq/product_project/presentation/themes/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:norq/product_project/presentation/widgets/custom/custome_alert_dialogue.dart';

class ProductViewMenu extends StatefulWidget {
  const ProductViewMenu({super.key});

  @override
  State<ProductViewMenu> createState() => _ProductViewMenuState();
}

class _ProductViewMenuState extends State<ProductViewMenu> {
  final productController = Get.put(ProductCntlr(sl()));
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.sizeOf(context).width;
    double h = MediaQuery.sizeOf(context).height;
    return Obx(
      () => productController.isproductLoading.value
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: h * 0.3,
                ),
                Center(child: const CircularProgressIndicator()),
              ],
            )
          : GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: productController.productList.length,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: w / (h / 1.35),
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20),
              itemBuilder: (context, index) {
                return ProductViewItem(
                  productResponseModal: productController.productList[index],
                );
              },
            ),
    );
  }
}

class ProductViewItem extends StatelessWidget {
  ProductViewItem({super.key, required this.productResponseModal});
  final ProductResponseModal productResponseModal;
  final cartController = Get.put(CartCntlr());
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.sizeOf(context).width;
    double h = MediaQuery.sizeOf(context).height;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: GestureDetector(
        onTap: () {
          Get.to(ProductDescriptionPage(
              productResponseModal: productResponseModal));
        },
        child: SizedBox(
          height: h * 0.4,
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
                  child: CachedNetworkImage(
                    imageUrl: productResponseModal.image,
                    fit: BoxFit.fill,
                    placeholder: (context, url) => SizedBox(
                      height: h * 0.1,
                      width: w * 0.05,
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: w * 0.005, right: w * 0.01),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productResponseModal.title,
                          maxLines: 2,
                          style: GoogleFonts.poppins(
                              color: AppColors.black,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: h * 0.01,
                        ),
                        Text(
                          productResponseModal.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(color: AppColors.black),
                        ),
                        SizedBox(
                          height: h * 0.01,
                        ),
                        Text(
                          "₹${productResponseModal.price}",
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
                                  if (cartController.cartList
                                      .map((element) =>
                                          element.productResponseModal)
                                      .contains(productResponseModal)) {
                                    customAlertDialogue(
                                        title: "",
                                        content: "item already in cart",
                                        txtbuttonName1: "Back",
                                        txtbuttonName2: "view cart",
                                        txtbutton2Action: () {
                                          Get.toNamed(AppPages.cartPage);
                                        },
                                        txtbutton1Action: () {
                                          Get.back();
                                        });
                                  } else {
                                    final subTotal =
                                        productResponseModal.price * 1;
                                    cartController.addToCart(
                                        productResponseModal, 1, subTotal);
                                  }
                                },
                                child: Text(
                                  "Add To cart",
                                  style: GoogleFonts.poppins(fontSize: 10),
                                ),
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  foregroundColor: AppColors.black,
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
    );
  }
}
