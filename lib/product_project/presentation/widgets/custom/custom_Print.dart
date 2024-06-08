import 'package:flutter/foundation.dart';

void customPrint(String message) {
  if (!kReleaseMode) {
    print(message);
  }
}
