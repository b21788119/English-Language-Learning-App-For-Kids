import 'package:first_app/app/data/providers/game/provider.dart';
import 'package:first_app/app/data/services/game/game_repository.dart';
import 'package:first_app/app/modules/admin/game_ist/controller.dart';
import 'package:get/get.dart';

class GameStatBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => GameStatController(
        gameRepository: GameRepository(
          gameProvider: GameProvider(),
        ),
      ),
    );
  }
}
