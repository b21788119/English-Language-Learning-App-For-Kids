import 'package:audioplayers/audioplayers.dart';
import 'package:first_app/app/core/utils/extensions.dart';
import 'package:first_app/app/core/values/colors.dart';
import 'package:first_app/app/modules/games/widgets/game_button.dart';
import 'package:first_app/app/modules/games/widgets/game_title.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';

class Game5Page extends GetView<Game5Controller> {
  Game5Page({super.key});

  static const pageName = "/game5";
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          getBackgroundImage(),
          Column(
            children: [
              SizedBox(height: 5.0.hp),
              getScoreTable(),
              SizedBox(height: 2.0.hp),
              getGameImage(),
              SizedBox(height: 2.0.hp),
              getCorrectWrongButtons(),
              SizedBox(height: 2.0.hp),
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
          image: AssetImage("assets/images/game5background.jpeg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget getGameImage() {
    return Column(
      children: [
        Stack(children: [
          Container(
            constraints: BoxConstraints(maxHeight: 45.0.hp, maxWidth: 45.0.hp),
            margin: const EdgeInsets.fromLTRB(20, 5, 20, 20),
            padding: const EdgeInsets.all(5),
            width: 90.0.wp,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 107, 107, 107),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10.0,
                  spreadRadius: 2.0,
                ),
              ],
            ),
            child: Obx(() => ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset(
                    controller
                        .gameWords.value[controller.wordIndex.value].pictureSrc,
                    fit: BoxFit.fill,
                  ),
                )),
          ),
          Positioned(
            left: (Get.width / 2) - (15.0.hp / 2),
            bottom: 0,
            child: Obx(() => Container(
                  alignment: Alignment.center,
                  width: 15.0.hp,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.green),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(80)),
                  child: controller.currentButton.value,
                )),
          )
        ]),
      ],
    );
  }

  Widget getCorrectWrongButtons() {
    return Obx(() => Expanded(
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 40.0.wp,
                  decoration: BoxDecoration(
                    color: controller.correctButton.value,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                  child: MaterialButton(
                    minWidth: 120.0,
                    height: 60.0,
                    onPressed: controller.is_correct_clickable.value
                        ? () {
                            controller.handleUserSelect(true, () {
                              if (controller.gameOver.value == true) {
                                getEndGameDialog();
                              }
                            });
                            // Handle button 1 press
                          }
                        : null,
                    child: Text(
                      'Correct',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 40.0.wp,
                  decoration: BoxDecoration(
                    color: controller.wrongButton.value,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                  child: MaterialButton(
                    minWidth: 120.0,
                    height: 60.0,
                    onPressed: controller.is_wrong_clickable.value
                        ? () {
                            controller.handleUserSelect(false, () {
                              if (controller.gameOver.value == true) {
                                getEndGameDialog();
                              }
                            });
                            // Handle button 1 press
                          }
                        : null,
                    child: Text(
                      'Wrong',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
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
              if (controller.is_next_clickable.value) {
                // Get dialogs
                if (controller.gameOver.value) {
                  await getEndGameDialog();
                } else {
                  controller.getNextGame();
                }
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
                    if (controller.is_restart_clickable.value) {
                      Get.back();
                      await controller.insertGameInfo();
                      controller.startGame();
                    }
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
