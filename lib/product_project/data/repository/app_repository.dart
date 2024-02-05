import '../remote/modals/response/product_response_modal.dart';

abstract class AppRepository {
  Future<List<ProductResponseModal>> getProductS();
}
