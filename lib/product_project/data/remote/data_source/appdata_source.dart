import 'package:norq/product_project/core/api_provider.dart';
import 'package:norq/product_project/data/remote/modals/response/product_response_modal.dart';
import 'package:norq/product_project/data/remote/remote_routes/app_remote_routes.dart';
import "package:norq/product_project/data/remote/modals/response/category_response_modal.dart";

abstract class AppDataSource {
  Future<List<ProductResponseModal>> getProductS();
  Future<List<String>> getCategory();
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

  @override
  Future<List<String>> getCategory() async {
    final response = await apiProvider.get(AppRemoteRoutes.category);
    final List<String> categories = [];
    for (final i in response) {
      categories.addAll(categoryModalFromJson(i));
    }
    return categories;
  }
}
