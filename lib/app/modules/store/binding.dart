import 'package:first_app/app/data/providers/content/provider.dart';
import 'package:first_app/app/data/providers/user/provider.dart';
import 'package:first_app/app/data/services/content/content_repository.dart';
import 'package:first_app/app/data/services/user/user_reposiory.dart';
import 'package:get/get.dart';
import 'controller.dart';

class StoreBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => StoreController(
        contentRepository: ContentRepository(
          contentProvider: ContentProvider(),
        ),
        userRepository: UserRepository(
          userProvider: UserProvider(),
        ),
      ),
    );
  }
}
