import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryMapController extends GetxController
    with GetTickerProviderStateMixin {
  final transCtrl = TransformationController().obs;
  late AnimationController resetAnimation;

  @override
  void onInit() {
    resetAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    super.onInit();
  }
}
