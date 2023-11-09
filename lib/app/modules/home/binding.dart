import 'package:first_app/app/data/providers/content/provider.dart';
import 'package:first_app/app/data/services/content/content_repository.dart';
import 'package:first_app/app/widgets/AudioController.dart';
import 'package:get/get.dart';
import 'controller.dart';

class HomeBinding implements Bindings {
  AudioPlayerController audioPlayerController;
  HomeBinding(this.audioPlayerController) {}
  @override
  void dependencies() {
    Get.lazyPut(
      () => HomeController(
          contentRepository: ContentRepository(
            contentProvider: ContentProvider(),
          ),
          audioController: audioPlayerController),
    );
  }
}
