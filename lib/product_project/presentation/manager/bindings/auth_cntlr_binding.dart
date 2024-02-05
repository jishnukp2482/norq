import 'package:get/get.dart';

import '../controller/auth_cntlr.dart';

class AuthCntlrBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthCntlr());
  }
}
