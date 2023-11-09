import 'package:first_app/app/core/utils/extensions.dart';
import 'package:first_app/app/core/values/colors.dart';
import 'package:first_app/app/modules/games/widgets/game_button.dart';
import 'package:first_app/app/modules/games/widgets/game_title.dart';
import 'package:first_app/app/widgets/file_operations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/word.dart';
import 'controller.dart';

class Game1Page extends GetView<Game1Controller> {
  Game1Page({super.key});

  static const pageName = "/game1";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            getBackgroundImage(),
            Column(
              children: [
                Column(
                  children: [
                    SizedBox(height: 1.0.hp),
                    getScoreTable(),
                  ],
                ),
                getGameTable(),
                getMenuButton(),
                SizedBox(
                  height: 3.0.hp,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getBackgroundImage() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/backgroundGame1.jpg"),
          fit: BoxFit.fitHeight,
          alignment: Alignment.centerRight,
        ),
      ),
    );
  }

  Widget getGameTable() {
    return Expanded(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(5.0.wp),
          child: Obx(
            () => GridView.builder(
              shrinkWrap: true,
              itemCount: controller.gameTable.keys.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemBuilder: (context, index) {
                Word currentWord = controller.gameWords[index];
                return GestureDetector(
                  onTap: () async {
                    controller.handleCardClick(index);
                    if (controller.gameOver.value) {
                      await getEndGameDialog();
                    }
                  },
                  child: getImageCard(currentWord, index),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Container getImageCard(Word currentWord, int index) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: controller.gameTable[index]!.isOpened
              ? getImage(currentWord.isNew, currentWord.pictureSrc)
              : const AssetImage(
                  "assets/images/game/mark.png",
                ),
          fit: BoxFit.cover,
        ),
        color: Colors.amber,
        border: Border.all(
          color: Colors.pink,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget getMenuButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          getGameButton(
            Icons.menu_outlined,
            () async {
              if (controller.gameOver.value) {
                await getEndGameDialog();
              } else {
                await getMenuDialog();
              }
            },
          )
        ],
      ),
    );
  }

  Future getEndGameDialog() async {
    await Get.defaultDialog(
      barrierDismissible: false,
      radius: 5,
      title: "GAME OVER",
      backgroundColor: brightBlue50,
      content: SizedBox(
        height: 25.0.hp,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    controller.selectedContent.value.pictureSrc,
                    fit: BoxFit.cover,
                    width: 25.0.wp,
                  ),
                  const Expanded(
                    child: Text("Mesajınızı giriniz"),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.0.hp),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // GO TO MENU
                getGameButton(
                  Icons.menu,
                  () async {
                    await controller.insertGameInfo();
                    Get.back();
                    Get.back();
                  },
                ),
                // RESTART GAME
                getGameButton(
                  Icons.restart_alt,
                  () async {
                    Get.back();
                    await controller.insertGameInfo();
                    controller.startGame();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future getMenuDialog() async {
    await Get.defaultDialog(
      barrierDismissible: true,
      radius: 5,
      title: "PAUSED",
      backgroundColor: brightBlue50,
      content: SizedBox(
        height: 25.0.hp,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    controller.selectedContent.value.pictureSrc,
                    fit: BoxFit.cover,
                    width: 25.0.wp,
                  ),
                  const Expanded(
                    child: Text("Enter your message"),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.0.hp),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // GO TO MENU
                getGameButton(
                  Icons.menu,
                  () async {
                    await controller.insertGameInfo();
                    Get.back();
                    Get.back();
                  },
                ),
                // RESTART GAME
                getGameButton(
                  Icons.restart_alt,
                  () async {
                    Get.back();
                    await controller.insertGameInfo();
                    controller.startGame();
                  },
                ),

                // CONTINUE
                getGameButton(
                  Icons.pause_sharp,
                  () {
                    Get.back();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getScoreTable() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            darkBlue300,
            darkBlue100,
            darkBlue100,
            darkBlue300,
          ],
        ),
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      padding: EdgeInsets.all(3.0.wp),
      child: Obx(
        () => SizedBox(
          width: 100.0.wp,
          height: 10.0.hp,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 2.0.wp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    getIconAndTextInfo(Icons.monetization_on,
                        "Coins: ${controller.totalCoinCount.value}"),
                    getIconAndTextInfo(Icons.sports_volleyball,
                        controller.gameMode.toUpperCase()),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.0.wp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    getIconAndTextInfo(Icons.medical_services_outlined,
                        "Move: ${controller.guessCount.value}"),
                    getIconAndTextInfo(Icons.scoreboard,
                        "Score: ${controller.totalScore.value.toStringAsFixed(2)}"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getIconAndTextInfo(IconData data, String text) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            data,
            size: 3.0.hp,
            color: brightBlue50,
          ),
          SizedBox(width: 2.0.wp),
          Text(
            text,
            style: TextStyle(
              overflow: TextOverflow.fade,
              color: brightBlue50,
              fontSize: 2.0.hp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
