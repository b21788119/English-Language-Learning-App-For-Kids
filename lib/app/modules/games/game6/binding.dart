import 'package:get/get.dart';
import 'controller.dart';

class Game6Binding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Game6Controller());
  }
}
