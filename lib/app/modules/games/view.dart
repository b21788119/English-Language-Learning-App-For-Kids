import 'package:first_app/app/core/utils/extensions.dart';
import 'package:first_app/app/core/values/colors.dart';
import 'package:first_app/app/data/models/word.dart';
import 'package:first_app/app/modules/games/game1/view.dart';
import 'package:first_app/app/modules/games/game2/view.dart';
import 'package:first_app/app/modules/games/game3/view.dart';
import 'package:first_app/app/modules/games/game4/view.dart';
import 'package:first_app/app/modules/games/game6/view.dart';
import 'package:first_app/app/modules/games/widgets/choose_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'controller.dart';
import 'game5/view.dart';

class GamesPage extends GetView<GamesController> {
  GamesPage({super.key});

  static const pageName = "/games";
  final caroController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brightBlue50,
      body: SafeArea(
        child: Column(
          children: [
            backButton(),
            chooseCategoryButton(),
            gameModeDropdown(),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  gameImageSlider(),
                  SizedBox(height: 5.0.hp),
                  sliderDots(),
                  SizedBox(height: 5.0.hp),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      previousNextButton(Icons.arrow_left, false),
                      playButton(),
                      previousNextButton(Icons.arrow_right, true),
                    ],
                  ),
                  SizedBox(height: 5.0.hp),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Widget backButton() {
  //   return Padding(
  //     padding: EdgeInsets.all(1.0.wp),
  //     child: Row(
  //       children: [
  //         IconButton(
  //           onPressed: () {
  //             Get.back();
  //           },
  //           icon: const Icon(
  //             Icons.arrow_back,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget backButton() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(1.0.wp),
      child: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: Icon(
          Icons.arrow_back,
          size: 7.wp,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget chooseCategoryButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(10.0.hp),
          textStyle: TextStyle(fontSize: 3.0.hp),
        ),
        onPressed: () {
          Get.to(
            () => ChooseCategory(),
            transition: Transition.downToUp,
          );
        },
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(1.0.wp),
              child: Icon(Icons.category, size: 5.0.hp),
            ),
            SizedBox(width: 5.0.wp),
            const Expanded(child: Text("Choose Category"))
          ],
        ),
      ),
    );
  }

  Widget gameModeDropdown() {
    var choseList = ["Easy", "Normal", "Hard", "Extreme"];
    return Container(
      decoration: const BoxDecoration(
        color: darkBlue100,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      //alignment: AlignmentDirectional.center,
      padding: EdgeInsets.symmetric(horizontal: 10.0.wp),
      width: 50.0.wp,
      child: Obx(
        () => DropdownButton(
          isExpanded: true,
          iconEnabledColor: Colors.white,
          underline: Container(),
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
          dropdownColor: Colors.blue,
          focusColor: Colors.blue,
          iconSize: 5.0.wp,
          value: controller.chosenGameMode.value,
          onChanged: (value) {
            controller.chosenGameMode.value = value ?? choseList.first;
          },
          items: choseList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value.toUpperCase(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget gameImageSlider() {
    //var gameList = controller.games.elementAt(0);
    return GestureDetector(
      onDoubleTap: () => goToGame(controller.activeIndexOfDot.value),
      child: Obx(
        () => CarouselSlider(
          carouselController: caroController,
          options: CarouselOptions(
            height: 40.0.hp,
            initialPage: 0,
            //autoPlay: true,
            //autoPlayInterval: const Duration(seconds: 5),
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.height,
            onPageChanged: (index, reason) {
              controller.activeIndexOfDot.value = index;
            },
          ),
          items: [
            ...controller.games.map((element) {
              return Container(
                height: 40.0.hp,
                //width: 40.0.hp,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 2,
                    color: brightBlue200,
                    strokeAlign: BorderSide.strokeAlignInside,
                  ),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(element.pictureSrc),
                  ),
                ),
                margin: EdgeInsets.symmetric(horizontal: 4.0.wp),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget sliderDots() {
    return Obx(
      () => AnimatedSmoothIndicator(
        activeIndex: controller.activeIndexOfDot.value,
        count: controller.games.length,
        onDotClicked: (index) => {
          controller.activeIndexOfDot.value = index,
          caroController.animateToPage(index),
        },
        effect: JumpingDotEffect(
          dotWidth: 4.0.hp,
          dotColor: darkBlue100,
          activeDotColor: brightBlue100,
        ),
      ),
    );
  }

  Widget previousNextButton(IconData? data, bool next) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: blue,
      ),
      onPressed: () {
        if (next) {
          caroController.nextPage();
          return;
        }
        caroController.previousPage();
      },
      child: Icon(
        data,
        size: 5.0.hp,
        color: Colors.white,
      ),
    );
  }

  Widget playButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
      ),
      onPressed: () => goToGame(controller.activeIndexOfDot.value),
      child: Container(
        constraints: BoxConstraints(maxWidth: 40.0.wp, maxHeight: 30.0.wp),
        padding: EdgeInsets.all(0.5.hp),
        child: Text(
          "PLAY",
          style: TextStyle(
            color: Colors.white,
            fontSize: 3.0.hp,
          ),
        ),
      ),
    );
  }

  void goToGame(int value) {
    try {
      if (controller.selectedCategoryIDs.value.isEmpty) {
        Get.to(
          () => ChooseCategory(),
          transition: Transition.downToUp,
        );
        return;
      }

      List<Word> words = controller.getWordsFromChosenCategories();

      switch (value) {
        case 0:
          Get.toNamed(Game1Page.pageName, arguments: [
            words,
            controller.chosenGameMode.value,
            controller.availableContents
          ]);
          break;
        case 1:
          Get.toNamed(Game2Page.pageName, arguments: [
            words,
            controller.chosenGameMode.value,
            controller.availableContents
          ]);
          break;
        case 2:
          Get.toNamed(Game3Page.pageName, arguments: [
            words,
            controller.chosenGameMode.value,
            controller.availableContents
          ]);
          break;
        case 3:
          Get.toNamed(Game4Page.pageName, arguments: [
            words,
            controller.chosenGameMode.value,
            controller.availableContents
          ]);
          break;
        case 4:
          Get.toNamed(Game5Page.pageName, arguments: [
            words,
            controller.chosenGameMode.value,
            controller.availableContents
          ]);
          break;
        case 5:
          Get.toNamed(Game6Page.pageName, arguments: [
            words,
            controller.chosenGameMode.value,
            controller.availableContents
          ]);
          break;
        default:
      }
    } catch (e) {
      EasyLoading.showError("something goes wrong");
      return;
    }
  }
}
