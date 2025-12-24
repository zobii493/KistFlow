import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final navIndexProvider = StateProvider<int>((ref) => 0);

class BackPressHandler {
  DateTime? lastPressed;

  bool canExit() {
    if (lastPressed == null ||
        DateTime.now().difference(lastPressed!) > const Duration(seconds: 2)) {
      lastPressed = DateTime.now();
      return false;
    }
    return true;
  }
}

final backHandlerProvider = Provider<BackPressHandler>((ref) {
  return BackPressHandler();
});
