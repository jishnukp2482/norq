import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:norq/app.dart';
import 'package:norq/firebase_options.dart';
import 'package:norq/injector.dart';
import 'package:norq/product_project/presentation/widgets/custom/custom_error_widget.dart';

import 'product_project/data/remote/modals/response/product_response_modal.dart';
import 'product_project/domain/entities/cart/Cart_Modal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFireBase();
  await initializeHive();
  await setUp();
  runApp(const MyApp());
}

/// Initializes Firebase
Future<void> initializeFireBase() async {
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    if (!kReleaseMode) {
      debugPrint('Error initializing Firebase: $e');
    }
  }
}

/// Initializes Hive and registers adapters
Future<void> initializeHive() async {
  try {
    await Hive.initFlutter();
    Hive.registerAdapter(CartModalAdapter());
    Hive.registerAdapter(ProductResponseModalAdapter());
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(RatingAdapter());
  } catch (e) {
    if (!kReleaseMode) {
      debugPrint('Error initializing Hive: $e');
    }
  }
}
