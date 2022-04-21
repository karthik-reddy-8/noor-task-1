import 'package:flutter/foundation.dart';

void printLog(message) {
  if (!kReleaseMode) {
    debugPrint('$message');
  }
}
