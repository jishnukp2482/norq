import 'package:hive/hive.dart';

import '../../data/remote/modals/response/product_response_modal.dart';
part 'Cart_Modal.g.dart';

@HiveType(typeId: 1)
class CartModal {
  @HiveField(0)
  final ProductResponseModal productResponseModal;
  @HiveField(1)
  final int quantity;
  @HiveField(2)
  final double subtotal;

  CartModal(this.productResponseModal, this.quantity, this.subtotal);
}
