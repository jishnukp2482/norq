import 'dart:ffi';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:norq/product_project/data/remote/modals/response/product_response_modal.dart';
import 'package:norq/product_project/presentation/routes/LocalStorageNames.dart';
import 'package:norq/product_project/presentation/themes/app_colors.dart';
import 'package:norq/product_project/presentation/widgets/custom/custom_Print.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../domain/entities/cart/Cart_Modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartCntlr extends GetxController {
  @override
  void onInit() {
    box = GetStorage();
    var userid = box.read(LocalStorageNames.userid);
    loadCartData(userid);
    super.onInit();
  }

  late GetStorage box;
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
      Fluttertoast.showToast(
          msg: "Item added to Cart",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.white,
          textColor: AppColors.black,
          fontSize: 12);
    }
    cartList.refresh();
    getTotal(cartList);
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
    getTotal(cartList);
    cartList.sort(
      (a, b) {
        return a.productResponseModal.title
            .compareTo(b.productResponseModal.title);
      },
    );
  }

  final isRemoveCart = false.obs;
  deletefromcart(CartModal modal) {
    isRemoveCart.value = true;
    cartList.remove(modal);
    cartList.refresh();
    getTotal(cartList);
    isRemoveCart.value = false;
  }

  double subtotalcalculation(double subtotal, int quantitiy) {
    return subtotal * quantitiy.toDouble();
  }

  ///save cartllist to firebase based on user id
  final CollectionReference cartCollection =
      FirebaseFirestore.instance.collection(LocalStorageNames.cartCollection);
  Future<void> saveCartListToFireBase(String userId) async {
    customPrint("before try in save cart to firebase");
    try {
      customPrint("inside try in save cart to firebase");

      final DocumentReference documentReference = cartCollection.doc(userId);
      //final DocumentSnapshot documentSnapshot = await documentReference.get();

      await cartCollection.doc(userId).set(
          {"cartItems": cartList.map((element) => element.toJson()).toList()});
      customPrint("CartList saved to firebase");
    } catch (e) {
      customPrint("error saving cartlist to firebase==$e");
    }
  }

  ///Load firebasecart to cartList based on user id
  Future<void> loadCartData(String userId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await cartCollection.doc(userId).get();
      if (documentSnapshot.exists) {
        cartList.clear();
        List tempCartList = documentSnapshot["cartItems"];
        customPrint("before adding cart data to temp cart list");
        tempCartList.forEach((element) {
          cartList.add(CartModal(
              ProductResponseModal.fromJson(element["productResponseModal"]),
              element["quantity"],
              element["subTotal"]));
        });
        getTotal(cartList);
        customPrint("cart items loaded from firebase to List");
      } else {
        customPrint("cart items empty");
      }
    } catch (e) {
      customPrint('Error loading cart data: $e');
    }
  }

  // final savehiveisLoading = false.obs;
  // void saveToHive(List<CartModal> cartList) async {
  //   String? userUID = FirebaseAuth.instance.currentUser?.uid;
  //   savehiveisLoading.value = true;
  //   var box =
  //       await Hive.openBox<CartModal>("${LocalStorageNames.cartbox}$userUID");
  //   await box.clear();
  //   for (var cartItem in cartList) {
  //     await box.add(cartItem);
  //   }
  //   if (!kReleaseMode) {
  //     debugPrint("hive save==$box");
  //     debugPrint("saved successfully to box");
  //   }
  //   savehiveisLoading.value = false;
  // }

  // final loadhiveisLoading = false.obs;
  // Future<void> loadFromHive() async {
  //   String? userUID = FirebaseAuth.instance.currentUser?.uid;
  //   loadhiveisLoading.value = true;
  //   var box =
  //       await Hive.openBox<CartModal>("${LocalStorageNames.cartbox}$userUID");
  //   var loadedcartList = box.values.toList();
  //   cartList.clear();
  //   cartList.addAll(loadedcartList);
  //   if (!kReleaseMode) {
  //     debugPrint("data retrieved successfully from box");
  //     debugPrint("hive load ==$loadedcartList");
  //   }
  //   loadhiveisLoading.value = false;
  //   getTotal();
  // }

  var total = 0.0;
  final isTotalLoading = false.obs;
  getTotal(List<CartModal> list) {
    isTotalLoading.value = true;
    total = 0.0;
    for (var i in list) {
      total = total + i.subtotal;
    }
    isTotalLoading.value = false;
  }

  final selectedcartItemsList = <CartModal>[].obs;
  final isSelectedCartItemsListLoading = false.obs;

  addItemsToselection(CartModal modal) {
    isSelectedCartItemsListLoading.value = true;
    var item = selectedcartItemsList.any(
        (p0) => p0.productResponseModal.id == modal.productResponseModal.id);

    if (item) {
      selectedcartItemsList.remove(modal);
      customPrint("item removed");
      customPrint(
          "removed items ==${selectedcartItemsList.map((element) => element.productResponseModal.title)}");
    } else {
      selectedcartItemsList.add(modal);
      customPrint("item added");
      customPrint(
          "added items ==${selectedcartItemsList.map((element) => element.productResponseModal.title)}");
    }
    if (selectedcartItemsList.isEmpty) {
      getTotal(cartList);
      customPrint("gettotal worked based on cartlist");
    } else {
      getTotal(selectedcartItemsList);
      customPrint("gettotal worked based on selectedList");
    }

    isSelectedCartItemsListLoading.value = false;
  }
}
