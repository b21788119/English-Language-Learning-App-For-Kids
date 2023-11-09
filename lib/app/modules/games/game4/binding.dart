import 'package:get/get.dart';
import 'controller.dart';

class Game4Binding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Game4Controller());
  }
}
