import 'package:first_app/app/modules/word/controller.dart';
import 'package:get/get.dart';

class WordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WordController());
  }
}
