import 'package:norq/product_project/core/usecase.dart';
import 'package:norq/product_project/data/remote/modals/response/product_response_modal.dart';
import 'package:norq/product_project/data/repository/app_repository.dart';

class ProductsUseCase extends UseCase<List<ProductResponseModal>, NoParams> {
  final AppRepository appRepository;

  ProductsUseCase(this.appRepository);

  @override
  Future<List<ProductResponseModal>> call(NoParams params) {
    return appRepository.getProductS();
  }
}
