import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:norq/product_project/data/remote/modals/response/product_response_modal.dart';
import 'package:norq/product_project/presentation/routes/LocalStorageNames.dart';
import 'package:norq/product_project/presentation/routes/app_pages.dart';
import 'package:norq/product_project/presentation/widgets/custom/custome_alert_dialogue.dart';

import '../../../domain/entities/Cart_Modal.dart';

class CartCntlr extends GetxController {
  @override
  void onInit() {
    loadFromHive();
    super.onInit();
  }

  final cartList = <CartModal>[].obs;
  addToCart(ProductResponseModal modal, int quantity, subTotal) {
    CartModal cartModal = CartModal(modal, quantity, subTotal);
    int existingIndex = cartList.indexWhere((element) =>
        element.productResponseModal == cartModal.productResponseModal);
    if (existingIndex != -1) {
      CartModal existingCartModal = cartList[existingIndex];
      cartList.remove(existingCartModal);

      existingCartModal = CartModal(
        modal,
        existingCartModal.quantity + 1,
        subTotal,
      );

      cartList.add(existingCartModal);
    } else {
      cartList.add(cartModal);
      customAlertDialogue(
          title: "success",
          content: "item added to cart",
          txtbuttonName1: "Back",
          txtbutton2Action: () {
            Get.toNamed(AppPages.cartPage);
          },
          txtbuttonName2: "view cart",
          txtbutton1Action: () {
            Get.back();
          });
    }
    cartList.refresh();
    getTotal();
    cartList.sort(
      (a, b) {
        return a.productResponseModal.title
            .compareTo(b.productResponseModal.title);
      },
    );
  }

  removeFromcart(ProductResponseModal modal, int quantity, subTotal) {
    CartModal cartModal = CartModal(modal, quantity, subTotal);
    int existingIndex = cartList.indexWhere((element) =>
        element.productResponseModal == cartModal.productResponseModal);
    if (existingIndex != -1) {
      CartModal existingCartModal = cartList[existingIndex];
      cartList.remove(existingCartModal);
      if (quantity > 0) {
        existingCartModal = CartModal(
          modal,
          existingCartModal.quantity - 1,
          subTotal,
        );

        cartList.add(existingCartModal);
      } else if (quantity == 0) {
        cartList.remove(existingCartModal);
      } else {
        existingCartModal = CartModal(
          modal,
          existingCartModal.quantity - 1,
          subTotal,
        );

        cartList.add(existingCartModal);
      }
    }
    cartList.refresh();
    getTotal();
    cartList.sort(
      (a, b) {
        return a.productResponseModal.title
            .compareTo(b.productResponseModal.title);
      },
    );
  }

  deletefromcart(CartModal modal) {
    cartList.remove(modal);
    cartList.refresh();
  }

  double subtotalcalculation(double subtotal, int quantitiy) {
    return subtotal * quantitiy.toDouble();
  }

  final savehiveisLoading = false.obs;
  void saveToHive(List<CartModal> cartList) async {
    String? userUID = FirebaseAuth.instance.currentUser?.uid;
    savehiveisLoading.value = true;
    var box =
        await Hive.openBox<CartModal>("${LocalStorageNames.cartbox}$userUID");
    await box.clear();
    for (var cartItem in cartList) {
      await box.add(cartItem);
    }
    if (!kReleaseMode) {
      debugPrint("hive save==$box");
      debugPrint("saved successfully to box");
    }
    savehiveisLoading.value = false;
  }

  final loadhiveisLoading = false.obs;
  Future<void> loadFromHive() async {
    String? userUID = FirebaseAuth.instance.currentUser?.uid;
    loadhiveisLoading.value = true;
    var box =
        await Hive.openBox<CartModal>("${LocalStorageNames.cartbox}$userUID");
    var loadedcartList = box.values.toList();
    cartList.clear();
    cartList.addAll(loadedcartList);
    if (!kReleaseMode) {
      debugPrint("data retrieved successfully from box");
      debugPrint("hive load ==$loadedcartList");
    }
    loadhiveisLoading.value = false;
    getTotal();
  }

  var total = 0.0;
  getTotal() {
    total = 0.0;
    for (var i in cartList) {
      total = total + i.subtotal;
    }
  }
}
