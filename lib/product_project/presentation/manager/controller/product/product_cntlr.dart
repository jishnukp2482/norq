import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:norq/product_project/core/respose_classify.dart';
import 'package:norq/product_project/core/usecase.dart';
import 'package:norq/product_project/data/remote/modals/response/product_response_modal.dart';
import 'package:norq/product_project/domain/entities/WishModal.dart';
import 'package:norq/product_project/domain/usecase/products_useCase.dart';
import 'package:norq/product_project/presentation/routes/LocalStorageNames.dart';
import 'package:norq/product_project/presentation/widgets/custom/custom_Print.dart';

class ProductCntlr extends GetxController {
  @override
  void onInit() {
    getUserid();
    getproducts();

    super.onInit();
  }

  getUserid() {
    userID = getStorage.read(LocalStorageNames.userid);
    customPrint("userid == $userID");
    loadWishData(userID);
  }

  late String userID;
  GetStorage getStorage = GetStorage();
  final ProductsUseCase productsUseCase;

  ProductCntlr(this.productsUseCase);

  final productState =
      ResponseClassify<List<ProductResponseModal>>.error("").obs;
  final productList = <ProductResponseModal>[];
  final isproductLoading = false.obs;
  getproducts() async {
    productState.value = ResponseClassify.loading();
    isproductLoading.value = true;
    try {
      productState.value =
          ResponseClassify.completed(await productsUseCase.call(NoParams()));
      productList.clear();
      if (!kReleaseMode) {
        debugPrint("product list cleared");
      }

      productList.addAll(productState.value.data!);

      if (!kReleaseMode) {
        debugPrint("product list length==${productList.length}");
      }
      isproductLoading.value = false;
    } catch (e) {
      productState.value = ResponseClassify.error("$e");
    }
  }

//to set the rating stars
  final rate = 0.0.obs;
  final numberOfFullStars = 0.obs;
  final remainder = 0.0.obs;
  final israteLoading = false.obs;
  void setRate(double newRate) {
    israteLoading.value = true;
    rate.value = newRate;
    numberOfFullStars.value = newRate.floor();
    remainder.value = newRate - numberOfFullStars.value;
    israteLoading.value = false;
    customPrint("numberOfFullStars==$numberOfFullStars");
    customPrint("remainder==$remainder");
  }

  ///to add wishlist
  final wishList = <WishModal>[].obs;
  final isWishListLoading = false.obs;
  addToWishList(int id) {
    isWishListLoading.value = true;
    if (wishList.any((p0) => p0.productResponseModal.id == id)) {
      wishList.removeWhere((element) => element.productResponseModal.id == id);
    } else {
      ProductResponseModal product =
          productList.firstWhere((element) => element.id == id);
      if (product != null) {
        wishList.add(WishModal(product));
      }
    }
    wishList.sort((a, b) =>
        a.productResponseModal.title.compareTo(b.productResponseModal.title));
    isWishListLoading.value = false;
  }

  ///save wishlist to firebase
  final CollectionReference wishListCollection =
      FirebaseFirestore.instance.collection(LocalStorageNames.wishCollection);
  Future<void> saveWishListToFireBase(String userid) async {
    try {
      customPrint("in try save wish list");
      await wishListCollection.doc(userid).set({
        "wishItems": wishList.map((element) => element.toJson()).toList(),
      });

      customPrint("wishList saved to FireBase");
    } catch (e) {
      customPrint("error saving wishList to firebase==$e");
    }
  }

  /// Load wishlist data from Firebase based on user ID
  // Future<void> loadWishData(String userId) async {
  //   // try {
  //   DocumentSnapshot documentSnapshot =
  //       await wishListCollection.doc(userId).get();
  //   if (documentSnapshot.exists) {
  //     customPrint("wish data exist");
  //     wishList.clear();
  //     customPrint("wishlist cleared");
  //     if (documentSnapshot.data() != null) {
  //       if (documentSnapshot.data() is Map<dynamic, dynamic>) {
  //         var tempWishlist = documentSnapshot.data() as Map<dynamic, dynamic>;
  //         if (tempWishlist.containsKey("wishItems") == true) {
  //           customPrint(
  //               "temp wish length ==${tempWishlist["wishItems"].toString()}");
  //           customPrint("id==${tempWishlist["wishItems"].first["id"]}");
  //           customPrint("image==${tempWishlist["wishItems"].first["image"]}");
  //           customPrint(
  //               "description==${tempWishlist["wishItems"].first["description"]}");
  //           customPrint("title==${tempWishlist["wishItems"].first["title"]}");
  //           customPrint(
  //               "category==${tempWishlist["wishItems"].first["category"]}");
  //           customPrint("rating==${tempWishlist["wishItems"].first["rating"]}");

  //           tempWishlist["wishItems"].forEach((element) {
  //             final productResponse = element["ProductResponseModal"];
  //             if (productResponse != null) {
  //               wishList.add(productResponse);
  //             } else {
  //               customPrint("productResponse is null");
  //             }
  //           });

  //           // var firstItem = wishList.first.toJson();
  //           // customPrint("wishlist==$firstItem");
  //           customPrint("tempwishList length==${tempWishlist.length}");
  //           customPrint("before adding wish data to temp wish list");
  //           customPrint("wishlist length=${wishList.length}");
  //           customPrint("wish items loaded from firebase to List");
  //         } else {
  //           customPrint("wish items field not found");
  //         }
  //       } else {
  //         customPrint("document data is not a Map");
  //       }
  //     } else {
  //       customPrint("document data is null");
  //     }
  //   } else {
  //     customPrint("wish items empty");
  //   }
  //   // } catch (e) {
  //   customPrint('Error loading wish data: e');
  //   // }
  // }

  Future<void> loadWishData(String userId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await wishListCollection.doc(userId).get();
      if (documentSnapshot.exists) {
        customPrint("wish data exist");
        wishList.clear();
        customPrint("wishlist cleared");
        var tempWishlist = documentSnapshot["wishItems"];
        if (tempWishlist != null && tempWishlist is List) {
          customPrint("tempwishList length==${tempWishlist.length}");
          customPrint("before adding wish data to temp wish list");

          tempWishlist.forEach((element) {
            wishList.add(WishModal(ProductResponseModal.fromJson(
                element["productResponseModal"])));
          });
          customPrint("wishlist length=${wishList.length}");
          for (var i in wishList) {
            customPrint("title==${i.productResponseModal.title}");
          }
          customPrint("wish items loaded from firebase to List");
        } else {
          customPrint("wish items empty or not a list");
        }
      } else {
        customPrint("wish items empty");
      }
    } catch (e) {
      customPrint('Error loading wish data: $e');
    }
  }
}
