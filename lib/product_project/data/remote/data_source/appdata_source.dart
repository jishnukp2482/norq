import 'package:norq/product_project/core/api_provider.dart';
import 'package:norq/product_project/data/remote/modals/response/product_response_modal.dart';
import 'package:norq/product_project/data/remote/remote_routes/app_remote_routes.dart';

abstract class AppDataSource {
  Future<List<ProductResponseModal>> getProductS();
}

class AppDataSourceImpl extends AppDataSource {
  final ApiProvider apiProvider;

  AppDataSourceImpl(this.apiProvider);

  @override
  Future<List<ProductResponseModal>> getProductS() async {
    final response = await apiProvider.get(AppRemoteRoutes.products);

    final List<ProductResponseModal> products = [];

    for (final productJson in response) {
      products.add(ProductResponseModal.fromJson(productJson));
    }

    return products;
  }
}
