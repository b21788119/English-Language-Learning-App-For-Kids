import 'package:audioplayers/audioplayers.dart';
import 'package:first_app/app/core/utils/extensions.dart';
import 'package:first_app/app/core/values/colors.dart';
import 'package:first_app/app/modules/games/widgets/game_button.dart';
import 'package:first_app/app/modules/games/widgets/game_title.dart';
import 'package:first_app/app/widgets/file_operations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class Game4Page extends GetView<Game4Controller> {
  Game4Page({super.key});

  static const pageName = "/game4";
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            getBackgroundImage(),
            Column(
              children: [
                getGameTitle("CANDY CRUSH", 4),
                getScoreTable(),
                getImages(),
                getMenuButton(),
                SizedBox(
                  height: 5.0.hp,
                )
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
          alignment: Alignment.center,
        ),
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

  Widget getImages() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.0.wp),
        child: Center(
          child: Obx(
            () => GridView.builder(
              itemCount: controller.wordMap.keys.length,
              //padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                ExtendedWordGame4? extendedword = controller.wordMap[index];
                return getDraggableImage(extendedword);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget getDraggableImage(ExtendedWordGame4? extendedWord) {
    return LongPressDraggable(
      data: extendedWord,
      feedback: Opacity(
        opacity: 0.8,
        child: getSquareImage(extendedWord),
      ),
      child: getSquareImage(extendedWord),
    );
  }

  Widget getSquareImage(ExtendedWordGame4? extendedWord) {
    var squareWidth = Get.width - 20.0.wp;
    return DragTarget<ExtendedWordGame4>(
      onAccept: (data) async {
        if (extendedWord == null) {
          return;
        }
        controller.handleDrag(extendedWord, data);
        // Get dialogs
        if (controller.gameOver.value) {
          await getEndGameDialog();
        }
      },
      builder: (context, candidateData, rejectedData) {
        return GestureDetector(
          onTap: () async {
            if (extendedWord != null &&
                (!extendedWord.isImage || extendedWord.isCompleted)) {
              var src = getAudioSource(
                  extendedWord.word.isNew, extendedWord.word.audioSrc);
              if (src == null) return;

              audioPlayer.play(src);
            }
          },
          child: Container(
            width: squareWidth / 5,
            height: squareWidth / 5,
            margin: EdgeInsets.all(3.0.wp),
            decoration: BoxDecoration(
              border: (extendedWord != null &&
                      extendedWord.isImage &&
                      extendedWord.isCompleted)
                  ? Border.all(
                      color: Colors.green.shade600,
                      width: 5.0,
                    )
                  : null,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300]!,
                  blurRadius: 7,
                  offset: const Offset(0, 7),
                )
              ],
            ),
            child: Image(
              fit: (extendedWord != null && !extendedWord.isImage)
                  ? BoxFit.fill
                  : null,
              image: (extendedWord != null && extendedWord.isImage)
                  ? getImage(
                      extendedWord.word.isNew, extendedWord.word.pictureSrc)
                  : const AssetImage("assets/images/game/mark.png"),
            ),
          ),
        );
      },
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
                    getIconAndTextInfo(
                        Icons.medical_services_outlined, "Move: ${0}"),
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
