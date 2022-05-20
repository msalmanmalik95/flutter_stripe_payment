import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

showSnackBar(String title, String message) {
  Get.snackbar(
    title,
    message,
    duration: const Duration(seconds: 2),
    snackPosition: SnackPosition.BOTTOM,
    backgroundGradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xBF000000), Color(0x40000000), Color(0xBF000000)],
    ),
    barBlur: 50.0,
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    colorText: Colors.black,
  );
}
