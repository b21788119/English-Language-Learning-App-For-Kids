import 'package:get/get.dart';

import '../../widgets/AudioController.dart';
import 'controller.dart';

class ListenWordBinding implements Bindings {
  AudioPlayerController audioPlayerController;
  ListenWordBinding(this.audioPlayerController) {}
  @override
  void dependencies() {
    Get.lazyPut(
        () => ListenwordController(audioController: audioPlayerController));
  }
}
