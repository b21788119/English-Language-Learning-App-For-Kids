import 'package:first_app/app/data/providers/category/provider.dart';
import 'package:first_app/app/data/providers/content/provider.dart';
import 'package:first_app/app/data/providers/game/provider.dart';
import 'package:first_app/app/data/providers/word/provider.dart';
import 'package:first_app/app/data/services/category/category_repository.dart';
import 'package:first_app/app/data/services/content/content_repository.dart';
import 'package:first_app/app/data/services/game/game_repository.dart';
import 'package:get/get.dart';
import 'controller.dart';

class GamesBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => GamesController(
        categoryRepository: CategoryRepository(
          categoryProvider: CategoryProvider(),
          wordProvider: WordProvider(),
        ),
        gameRepository: GameRepository(
          gameProvider: GameProvider(),
        ),
        contentRepository: ContentRepository(
          contentProvider: ContentProvider(),
        ),
      ),
    );
  }
}
