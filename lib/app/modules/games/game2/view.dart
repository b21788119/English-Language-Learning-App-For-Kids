import 'package:audioplayers/audioplayers.dart';
import 'package:first_app/app/core/utils/extensions.dart';
import 'package:first_app/app/core/values/colors.dart';
import 'package:first_app/app/data/models/word.dart';
import 'package:first_app/app/modules/games/widgets/game_button.dart';
import 'package:first_app/app/modules/games/widgets/game_title.dart';
import 'package:first_app/app/widgets/file_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'controller.dart';

class Game2Page extends GetView<Game2Controller> {
  Game2Page({super.key});

  static const pageName = "/game2";
  AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayer choice_audio_player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          getBackgroundImage(),
          Column(
            children: [
              SizedBox(
                height: 1.0.hp,
              ),
              getScoreTable(),
              SizedBox(
                height: 5.0.hp,
              ),
              getWordVoiceButtons(),
              getImages(),
              getNextAndMenuButton(),
              SizedBox(
                height: 5.0.hp,
              )
            ],
          ),
        ]),
      ),
    );
  }

  Widget getBackgroundImage() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/backgroundGame2.jpg"),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  Widget getWordVoiceButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ...controller.randomWordsWithotMissing.value.map((word) {
              return getGameButton(
                Icons.play_arrow_outlined,
                () {
                  var src = getAudioSource(word.isNew, word.audioSrc);
                  if (src == null) {
                    return;
                  }
                  audioPlayer.play(src);
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget getImages() {
    return Expanded(
      child: SizedBox(
        width: 400,
        child: Center(
          child: Obx(
            () => GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                ...controller.randomWords.value
                    .map((word) => getSquareImage(word))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getSquareImage(Word word) {
    return GestureDetector(
      onTap: () async {
        if (word.wordID == controller.getMissingWord().wordID) {
          await controller.correctAnswer();
          if (choice_audio_player.state.toString() == "PlayerState.playing") {
            choice_audio_player.stop();
          }
          choice_audio_player.play(AssetSource("audios/game_1/correct.mp3"));

          // Get dialogs
          if (controller.gameOver.value) {
            await getEndGameDialog();
          } else {
            await getCorrectAnswerDialog();
            controller.getNextGame();
          }
        } else {
          EasyLoading.showError("Wrong");
          if (choice_audio_player.state.toString() == "PlayerState.playing") {
            choice_audio_player.stop();
          }
          choice_audio_player.play(AssetSource("audios/game_5/wrong.mp3"));
          controller.wrongAnswer();
        }
      },
      child: Container(
        margin: EdgeInsets.all(2.0.hp),
        decoration: BoxDecoration(
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
          image: getImage(word.isNew, word.pictureSrc),
        ),
      ),
    );
  }

  Widget getNextAndMenuButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          getMenuButton(),
          getGameButton(
            Icons.navigate_next,
            () async {
              controller.getNextGame();
              // Get dialogs
              if (controller.gameOver.value) {
                await getEndGameDialog();
              }
            },
          ),
        ],
      ),
    );
  }

  Future getCorrectAnswerDialog() async {
    await Get.defaultDialog(
      barrierDismissible: false,
      radius: 5,
      title: "CORRECT",
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
                getGameButton(
                  Icons.navigate_next,
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
