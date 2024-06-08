import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:norq/product_project/presentation/widgets/custom/custom_Appbar.dart';
import 'package:norq/product_project/presentation/widgets/wishlist/wislist_item.dart';

import '../../../manager/controller/product/product_cntlr.dart';

class WishListPage extends StatefulWidget {
  const WishListPage({super.key});

  @override
  State<WishListPage> createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  final productController = Get.find<ProductCntlr>();
  @override
  void dispose() {
    productController.saveWishListToFireBase(productController.userID);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(
        appBarTitle: "WishList",
        onPressed: () {
          Get.back();
        },
      ),
      body: ListView(
        children: [
          WishListMenu(),
        ],
      ),
    ));
  }
}
