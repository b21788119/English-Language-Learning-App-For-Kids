import 'package:first_app/app/core/utils/DataHelper.dart';
import 'package:first_app/app/core/utils/extensions.dart';
import 'package:first_app/app/data/models/content.dart';
import 'package:first_app/app/data/models/user.dart';
import 'package:first_app/app/data/services/content/content_repository.dart';
import 'package:first_app/app/data/services/user/user_reposiory.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreController extends GetxController {
  ContentRepository contentRepository;
  UserRepository userRepository;

  StoreController({
    required this.contentRepository,
    required this.userRepository,
  });

  var earnedCoins = 0.obs;
  var availableContents = <Content>[].obs;
  var purchasedContents = <Content>[].obs;
  var inUsedContents = <Content>[].obs;
  var categories = <String>[
    'Tüm Kategoriler', // 0
    'Candy', // 1
    'Müzik', // 2
    'Animasyon', // 3
    'Video', // 4
    'Sticker', // 5
    'Avatar', // 6
    'Rozet', // 7
  ];
  var selectedCategory = 0.obs;
  var filteredContents = <Content>[].obs;
  var purchasedFilterContents = <Content>[].obs;
  var inUsedFilterContents = <Content>[].obs;

  final selectedContent = Rx<Content?>(null);

  @override
  void onInit() async {
    super.onInit();
    // get coin data
    User user = await userRepository.readUser();
    earnedCoins.value = user.coin;

    // fill contents
    List<Content> data = await contentRepository.readContents();
    availableContents.assignAll(
        data.where((content) => content.isPurchased == false).toList());
    purchasedContents.assignAll(
        data.where((content) => content.isPurchased == true).toList());
    inUsedContents.assignAll(data
        .where((contet) => contet.isPurchased == true && contet.inUsed == true)
        .toList());
    filterByCategory(0);
  }

  String getCorrectImagePath() {
    if (selectedContent.value == null) {
      return "assets/images/game/mark.png";
    }
    // video
    if (selectedContent.value!.category == 4) {
      return "assets/images/awards/video/default.png";
    }

    if (selectedContent.value!.category == 2) {
      return "assets/images/awards/music/default.png";
    }
    return selectedContent.value!.pictureSrc;
  }

  Image getCorrectImage(Content cnt, {int? widths}) {
    // video
    if (cnt.category == 4) {
      return Image.asset(
        "assets/images/awards/video/default.png",
        fit: BoxFit.cover,
      );
    }

    // music
    if (cnt.category == 2) {
      return Image.asset(
        "assets/images/awards/music/default.png",
        fit: BoxFit.cover,
      );
    }
    //others
    if (widths != null) {
      return Image.asset(
        cnt.pictureSrc,
        fit: BoxFit.cover,
        width: 25.0.wp,
      );
    }
    return Image.asset(
      cnt.pictureSrc,
      fit: BoxFit.cover,
    );
  }

  List<Content> getSortedContent(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return filteredContents.toList()
          ..sort((a, b) => a.price.compareTo(b.price));
      case 1:
        return purchasedFilterContents.toList()
          ..sort((a, b) => a.price.compareTo(b.price));
      case 2:
        return inUsedFilterContents.toList()
          ..sort((a, b) => a.price.compareTo(b.price));
      default:
        return [];
    }
  }

  void buyContent(Content content) async {
    if (earnedCoins.value >= content.price &&
        !purchasedContents.contains(content)) {
      earnedCoins.value -= content.price;
      purchasedContents.add(content);
      availableContents.remove(content);

      filterByCategory(selectedCategory.value);

      // update user conins
      User user = await userRepository.readUser();
      user.coin -= content.price;
      await DataHelper.instance.update("User", user);

      // update content
      content.isPurchased = true;
      await DataHelper.instance.update("Content", content);
    }
  }

  void filterByCategory(int categoryIndex) {
    if (categoryIndex == 0) {
      filteredContents.assignAll(availableContents);
      purchasedFilterContents.assignAll(purchasedContents);
      inUsedFilterContents.assignAll(inUsedContents);
    } else {
      filteredContents.assignAll(
        availableContents.where((content) => content.category == categoryIndex),
      );
      purchasedFilterContents.assignAll(
        purchasedContents.where((content) => content.category == categoryIndex),
      );
      inUsedFilterContents.assignAll(
        inUsedContents.where((content) => content.category == categoryIndex),
      );
    }
    selectedCategory.value = categoryIndex;
  }

  bool isContentPurchased(Content content) {
    return purchasedContents.contains(content);
  }

  canAffordContent(Content content) {
    return earnedCoins.value >= content.price;
  }

  bool isSelectedContentInUsed() {
    return selectedContent.value?.inUsed ?? false;
  }

  void unUseSelectedContent() {
    if (selectedContent.value == null) {
      return;
    }
    // Content newContent = Content(
    //   selectedContent.value!.id,
    //   selectedContent.value!.name,
    //   selectedContent.value!.pictureSrc,
    //   true,
    //   false,
    //   selectedContent.value!.price,
    //   selectedContent.value!.category,
    // );
    selectedContent.value!.inUsed = false;
    selectedContent.value!.isPurchased = true;
    contentRepository.updateContent(selectedContent.value!);
    inUsedContents.remove(selectedContent.value);
    filterByCategory(selectedCategory.value);
  }

  void useSelectedContent() {
    if (selectedContent.value == null) {
      return;
    }
    // Content newContent = Content(
    //   selectedContent.value!.id,
    //   selectedContent.value!.name,
    //   selectedContent.value!.pictureSrc,
    //   true,
    //   true,
    //   selectedContent.value!.price,
    //   selectedContent.value!.category,
    // );
    selectedContent.value!.inUsed = true;
    selectedContent.value!.isPurchased = true;
    contentRepository.updateContent(selectedContent.value!);
    inUsedContents.add(selectedContent.value!);
    filterByCategory(selectedCategory.value);
  }
}
