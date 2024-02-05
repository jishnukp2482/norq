import 'package:norq/product_project/data/remote/data_source/appdata_source.dart';
import 'package:norq/product_project/data/remote/modals/response/product_response_modal.dart';
import 'package:norq/product_project/data/repository/app_repository.dart';

class AppRepositoryImpl extends AppRepository {
  final AppDataSource appDataSource;

  AppRepositoryImpl(this.appDataSource);

  @override
  Future<List<ProductResponseModal>> getProductS() {
    return appDataSource.getProductS();
  }
}
