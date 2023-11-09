import 'package:first_app/app/modules/admin/controller.dart';
import 'package:get/get.dart';

class AdminBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => AdminController(),
    );
  }
}
