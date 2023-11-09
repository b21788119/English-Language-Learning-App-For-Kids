import 'package:get/get.dart';
import 'controller.dart';

class Game1Binding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Game1Controller());
  }
}
