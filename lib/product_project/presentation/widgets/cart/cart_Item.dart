import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:norq/product_project/data/remote/modals/response/product_response_modal.dart';
import 'package:norq/product_project/domain/entities/Cart_Modal.dart';
import 'package:norq/product_project/presentation/manager/controller/cart_cntlr.dart';
import 'package:norq/product_project/presentation/themes/app_colors.dart';

class CartMenu extends StatefulWidget {
  const CartMenu({super.key});

  @override
  State<CartMenu> createState() => _CartMenuState();
}

class _CartMenuState extends State<CartMenu> {
  final cartController = Get.put(CartCntlr());
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
                    child: Lottie.asset("assets/lottie/emptycart.json",
                        fit: BoxFit.cover),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "your cart is empty",
                    style: TextStyle(color: AppColors.grey, fontSize: 18),
                  ),
                ])
          : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: cartController.cartList.length,
              itemBuilder: (context, index) {
                final cartlist = cartController.cartList;
                return CartItem(
                  model: cartlist[index],
                  countNotifier: ValueNotifier<int>(cartlist[index].quantity),
                );
              },
            ),
    );
  }
}

class CartItem extends StatelessWidget {
  CartItem({super.key, required this.model, required this.countNotifier});
  final CartModal model;
  final ValueNotifier<int> countNotifier;

  final cartController = Get.put(CartCntlr());

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.sizeOf(context).width;
    double h = MediaQuery.sizeOf(context).height;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                        imageUrl: model.productResponseModal.image,
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
                      padding:
                          const EdgeInsets.only(left: 10, top: 10, right: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.productResponseModal.title,
                            style: const TextStyle(
                                color: AppColors.black,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "₹${model.subtotal}",
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
                        Container(
                          height: 30,
                          decoration: BoxDecoration(
                            color: AppColors.maincolor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                iconSize: 10,
                                onPressed: () {
                                  if (countNotifier.value > 0) {
                                    countNotifier.value--;
                                    debugPrint(
                                        "count notifier=${countNotifier.value}");
                                    cartController.removeFromcart(
                                        model.productResponseModal,
                                        countNotifier.value,
                                        cartController.subtotalcalculation(
                                            model.productResponseModal.price,
                                            countNotifier.value));
                                  }
                                },
                                icon: const Icon(
                                  Icons.remove,
                                  color: AppColors.white,
                                ),
                              ),
                              ValueListenableBuilder(
                                valueListenable: countNotifier,
                                builder: (context, value, child) {
                                  return Text(
                                    "${countNotifier.value}",
                                    style:
                                        const TextStyle(color: AppColors.white),
                                  );
                                },
                              ),
                              IconButton(
                                iconSize: 10,
                                onPressed: () {
                                  countNotifier.value++;
                                  cartController.addToCart(
                                      model.productResponseModal,
                                      countNotifier.value,
                                      cartController.subtotalcalculation(
                                          model.productResponseModal.price,
                                          countNotifier.value));
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
                right: -10,
                top: -15,
                child: IconButton(
                  onPressed: () {
                    cartController.deletefromcart(model);
                  },
                  icon: const Icon(
                    Icons.delete_outlined,
                    size: 15,
                    color: AppColors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
