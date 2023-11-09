import 'package:get/get.dart';
import 'controller.dart';

class Game2Binding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Game2Controller());
  }
}
