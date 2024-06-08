import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:norq/product_project/data/remote/modals/response/product_response_modal.dart';
import 'package:norq/product_project/presentation/manager/controller/cart/cart_cntlr.dart';
import 'package:norq/product_project/presentation/manager/controller/product/product_cntlr.dart';
import 'package:norq/product_project/presentation/routes/app_pages.dart';
import 'package:norq/product_project/presentation/themes/app_colors.dart';
import 'package:norq/product_project/presentation/widgets/custom/custom_Print.dart';
import 'package:norq/product_project/presentation/widgets/custom/custom_gradient_button.dart';
import 'package:norq/product_project/presentation/widgets/custom/custome_alert_dialogue.dart';

class ProductDescriptionPage extends StatefulWidget {
  ProductDescriptionPage({super.key, required this.productResponseModal});
  final ProductResponseModal productResponseModal;

  @override
  State<ProductDescriptionPage> createState() => _ProductDescriptionPageState();
}

class _ProductDescriptionPageState extends State<ProductDescriptionPage> {
  final cartController = Get.find<CartCntlr>();
  final productController = Get.find<ProductCntlr>();

  @override
  void initState() {
    productController.setRate(widget.productResponseModal.rating.rate);
    super.initState();
    startAnimAtion();
  }

  bool isVisible = true;
  void startAnimAtion() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isVisible = !isVisible;
      });
      startAnimAtion();
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.sizeOf(context).width;
    double h = MediaQuery.sizeOf(context).height;
    var existingItem = cartController.cartList.any((p0) =>
        (p0.productResponseModal.id == widget.productResponseModal.id) == true);

    customPrint("existing item==$existingItem");
    customPrint("Rate==${widget.productResponseModal.rating.rate}");

    return SafeArea(
      child: Scaffold(
        appBar: ProductDescriptionAppBar(
          appBarTitle: "Details",
          onPressed: () {
            Get.back();
          },
        ),
        body: ListView(
          padding: EdgeInsets.all(10),
          children: [
            SizedBox(
              height: h * 0.01,
            ),
            Container(
              height: h * 0.35,
              width: w,
              child: CachedNetworkImage(
                imageUrl: widget.productResponseModal.image,
                fit: BoxFit.cover,
                placeholder: (context, url) => SizedBox(
                  height: h * 0.045,
                  width: w * 0.1,
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            SizedBox(
              height: h * 0.01,
            ),
            Text(
              widget.productResponseModal.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: AppColors.black,
                fontSize: w * 0.04,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: h * 0.01,
            ),
            Text(
              "Rs:${widget.productResponseModal.price}",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: w * 0.05,
                  color: AppColors.black,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: h * 0.01,
            ),
            Text(
              textAlign: TextAlign.center,
              "category : ${widget.productResponseModal.category.name.replaceAll("_", " ")}",
              style: GoogleFonts.poppins(
                  color: AppColors.black, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: h * 0.01,
            ),
            Obx(
              () => productController.israteLoading.value
                  ? SizedBox.shrink()
                  : Row(
                      children: List.generate(5, (index) {
                        if (index < productController.numberOfFullStars.value) {
                          return AnimatedOpacity(
                            duration: Duration(milliseconds: 300),
                            opacity: isVisible ? 1.0 : 0.0,
                            curve: Curves.easeInOut,
                            child: Icon(
                              MdiIcons.star,
                              color: AppColors.yellow,
                            ),
                          );
                        } else if (index ==
                                productController.numberOfFullStars.value &&
                            productController.remainder.value > 0.0) {
                          return AnimatedOpacity(
                            duration: Duration(milliseconds: 300),
                            opacity: isVisible ? 1.0 : 0.0,
                            curve: Curves.easeInOut,
                            child: Icon(MdiIcons.starHalfFull,
                                color: AppColors.yellow),
                          );
                        } else {
                          return Icon(
                            MdiIcons.starOutline,
                            color: AppColors.black,
                          );
                        }
                      }),
                    ),
            ),
            SizedBox(
              height: h * 0.01,
            ),
            Text(
              widget.productResponseModal.description,
              style: GoogleFonts.poppins(
                color: AppColors.black,
              ),
            ),
            SizedBox(
              height: h * 0.05,
            ),
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: h * 0.08,
          // color: AppColors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: h * 0.06,
                // color: AppColors.green,
                child: CustomGradientButton(
                    title: existingItem ? "View Cart" : "Add to cart",
                    onPressed: () {
                      if (existingItem) {
                        Get.toNamed(AppPages.cartPage);
                      } else {
                        setState(() {
                          final subTotal =
                              widget.productResponseModal.price * 1;
                          cartController.addToCart(
                              widget.productResponseModal, 1, subTotal);
                        });
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductDescriptionAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ProductDescriptionAppBar(
      {Key? key, required this.appBarTitle, this.onPressed})
      : super(key: key);

  final String appBarTitle;
  final VoidCallback? onPressed;

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
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 60);
}
