import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:norq/product_project/core/api_provider.dart';
import 'package:norq/product_project/core/connection_checker.dart';
import 'package:norq/product_project/core/hive_service.dart';
import 'package:norq/product_project/domain/repositories/app_repositoryimpl.dart';
import 'package:norq/product_project/domain/usecase/products_useCase.dart';

import 'product_project/data/remote/data_source/appdata_source.dart';
import 'product_project/data/repository/app_repository.dart';

final sl = GetIt.instance;
Future<void> setUp() async {
  //core
  sl.registerLazySingleton<ApiProvider>(() => ApiProvider());
  sl.registerLazySingleton<HiveService>(() => HiveService());
  sl.registerLazySingleton<AppDataSource>(() => AppDataSourceImpl(sl()));
  sl.registerLazySingleton<AppRepository>(() => AppRepositoryImpl(sl()));
  sl.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker());
  sl.registerLazySingleton<ConnectionChecker>(
      () => ConnectionCheckerImpl(sl()));
  sl.registerLazySingleton<ProductsUseCase>(() => ProductsUseCase(sl()));
}
