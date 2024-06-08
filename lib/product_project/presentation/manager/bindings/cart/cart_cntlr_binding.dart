import 'package:get/get.dart';
import 'package:norq/product_project/presentation/manager/controller/cart/cart_cntlr.dart';

class CartCntlrBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CartCntlr());
  }
}
