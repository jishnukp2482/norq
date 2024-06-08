import 'package:norq/product_project/data/remote/modals/response/product_response_modal.dart';

class WishModal {
  final ProductResponseModal productResponseModal;

  WishModal(this.productResponseModal);

  Map<String, dynamic> toJson() {
    return {
      "productResponseModal": productResponseModal.toJson(),
    };
  }
}
