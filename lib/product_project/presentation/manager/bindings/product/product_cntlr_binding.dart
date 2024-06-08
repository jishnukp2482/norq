import 'package:get/get.dart';
import 'package:norq/product_project/presentation/manager/controller/product/product_cntlr.dart';

import '../../../../../injector.dart';

class ProductCntlrBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductCntlr(sl()));
  }
}
