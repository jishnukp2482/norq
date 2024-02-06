import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:norq/app.dart';
import 'package:norq/firebase_options.dart';
import 'package:norq/injector.dart';

import 'product_project/data/remote/modals/response/product_response_modal.dart';
import 'product_project/domain/entities/Cart_Modal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  Hive.registerAdapter(CartModalAdapter());
  Hive.registerAdapter(ProductResponseModalAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(RatingAdapter());

  await setUp();
  runApp(const MyApp());
}
