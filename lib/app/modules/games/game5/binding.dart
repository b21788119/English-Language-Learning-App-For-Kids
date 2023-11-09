import 'package:get/get.dart';
import 'controller.dart';

class Game5Binding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Game5Controller());
  }
}
