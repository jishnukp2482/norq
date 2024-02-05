import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:norq/product_project/core/respose_classify.dart';
import 'package:norq/product_project/core/usecase.dart';
import 'package:norq/product_project/data/remote/modals/response/product_response_modal.dart';
import 'package:norq/product_project/domain/usecase/products_useCase.dart';

class ProductCntlr extends GetxController {
  @override
  void onInit() {
    getproducts();
    super.onInit();
  }

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
        debugPrint("product list length==${productList.length}");
      }
      isproductLoading.value = false;
    } catch (e) {
      productState.value = ResponseClassify.error("e");
    }
  }
}
