import 'package:get/get.dart';
import 'controller.dart';

class Game3Binding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Game3Controller());
  }
}
