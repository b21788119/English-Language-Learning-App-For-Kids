import 'package:first_app/app/core/utils/extensions.dart';
import 'package:first_app/app/core/values/colors.dart';
import 'package:first_app/app/widgets/file_operations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'controller.dart';

class ListenWordPage extends GetView<ListenwordController> {
  ListenWordPage({super.key});

  static const pageName = "/listenWord";
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                blue,
                lightBlue,
              ],
            ),
          ),
          child: Column(
            children: [
              getScoreTitleBackButton(),
              getProgressBar(const Duration(milliseconds: 300)),
              Expanded(child: Center(child: getWordImage())),
              getPrevNext(),
              SizedBox(height: 5.0.hp),
              getRecordButton(),
              SizedBox(height: 5.0.hp),
            ],
          ),
        ),
      ),
    );
  }

  Widget getScoreTitleBackButton() {
    return Container(
      decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [blue, lightBlue],
          ),
          boxShadow: [
            BoxShadow(
              color: darkBlue100,
              blurRadius: 10,
              spreadRadius: 1.7.hp,
            )
          ]),
      padding: EdgeInsets.only(
        bottom: 2.0.wp,
        left: 1.0.wp,
        right: 5.0.wp,
        top: 5.0.wp,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            //color: Colors.yellow,
            margin: EdgeInsets.only(top: 0.5.hp),
            //width: 13.0.hp,
            height: 4.0.hp,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.monetization_on,
                  color: Colors.yellowAccent,
                  size: 8.0.wp,
                ),
                SizedBox(width: 0.1.hp),
                Obx(() => Text(
                      '${controller.totalCoins.value}',
                      style: TextStyle(
                        fontSize: 16.0.sp,
                        color: Colors.white,
                      ),
                    )),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                //color: Colors.red,
                width: 20.0.hp,
                alignment: Alignment.center,
                child: Obx(
                  () => Text(
                    "${controller.currentWordIndex.value + 1}/${controller.selectedCategory.words.length}",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 242, 253, 240),
                      fontSize: 10.0.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                //color: Colors.red,
                width: 20.0.hp,
                //padding: EdgeInsets.only(right: 8.0.hp),
                alignment: Alignment.center,
                child: Text(
                  controller.selectedCategory.name.toUpperCase(),
                  style: TextStyle(
                    color: const Color.fromARGB(255, 242, 253, 240),
                    fontSize: 16.0.sp,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            width: 7.0.wp,
            height: 7.0.wp,
            child: IconButton(
              onPressed: () {
                controller.updateDatabase();
                Get.back();
              },
              icon: Icon(
                Icons.close,
                size: 7.wp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getProgressBar(Duration animationDuration) {
    return Obx(
      () => AnimatedContainer(
        duration: animationDuration,
        height: 1.5.hp,
        width: double.infinity,

        // decoration: BoxDecoration(
        //     //color: Colors.grey[300],
        //     //borderRadius: BorderRadius.circular(10),
        //     ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: controller.getProgress(),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color.fromARGB(255, 100, 228, 248),
                  Color.fromARGB(255, 34, 230, 252),
                ],
              ),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(100),
                bottomRight: Radius.circular(100),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getWordImage() {
    var wordS = controller.selectedCategory.words;
    return Stack(
      children: [
        Obx(() => Align(
              alignment: Alignment.center,
              child: CircularPercentIndicator(
                animation: true,
                animationDuration: 1000,
                radius: 17.0.hp,
                lineWidth: 3.0.hp,
                percent: controller.pronunciationScore.value,
                progressColor: Color.fromARGB(161, 9, 219, 19),
                backgroundColor: blue200,
              ),
            )),
        Align(
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {
              var curWord = wordS.elementAt(controller.currentWordIndex.value);
              var src = getAudioSource(curWord.isNew, curWord.audioSrc);
              if (src == null) return;

              audioPlayer.play(src, volume: 5);
            },
            child: Obx(
              () => controller.isCurrentImageVisible.value
                  ? Container(
                      height: 30.0.hp,
                      width: 30.0.hp,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            30.0.hp,
                          ),
                        ),
                        color: darkBlue100,
                        image: DecorationImage(
                          image: getImage(
                            wordS
                                .elementAt(controller.currentWordIndex.value)
                                .isNew,
                            wordS
                                .elementAt(controller.currentWordIndex.value)
                                .pictureSrc,
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    )
                  : Container(
                      height: 30.0.hp,
                      width: 30.0.hp,
                      alignment: Alignment.center,
                      child: Text(
                        "%${(controller.pronunciationScore.value * 100).toStringAsFixed(2)}",
                        style:
                            TextStyle(fontSize: 40.0.sp, color: Colors.black),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            30.0.hp,
                          ),
                        ),
                        color: darkBlue100,
                        image: const DecorationImage(
                          opacity: 0.5,
                          image:
                              AssetImage("assets/images/word_images/white.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            margin: EdgeInsets.only(left: 28.0.hp, bottom: 28.0.hp),
            width: 7.0.hp,
            height: 7.0.hp,
            decoration:
                const BoxDecoration(shape: BoxShape.circle, color: darkBlue200),
            child: IconButton(
              onPressed: () {
                var curWord =
                    wordS.elementAt(controller.currentWordIndex.value);
                var src = getAudioSource(curWord.isNew, curWord.audioSrc);
                if (src == null) return;

                audioPlayer.play(src, volume: 5);
              },
              icon: Icon(
                Icons.volume_up_sharp,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getWordName() {
    var wordS = controller.selectedCategory.words;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(
          () => Text(
            wordS.elementAt(controller.currentWordIndex.value).name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 26.0.sp,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
              shadows: const [
                Shadow(
                  color: Colors.grey,
                  offset: Offset(1, 2),
                  blurRadius: 1,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget getPrevNext() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.0.wp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              controller.decreaseCurrentWordIndex();
            },
            style: ElevatedButton.styleFrom(
              elevation: 2,
              shape: const CircleBorder(),
              backgroundColor: brightBlue300,
              padding: EdgeInsets.all(5.0.wp),
            ),
            child: Obx(
              () => Icon(
                Icons.arrow_back,
                color: controller.currentWordIndex.value == 0
                    ? darkBlue100
                    : Colors.white,
              ),
            ),
          ),
          getWordName(),
          ElevatedButton(
            onPressed: () {
              controller.increaseCurrentWordIndex();
            },
            style: ElevatedButton.styleFrom(
              elevation: 2,
              shape: const CircleBorder(),
              backgroundColor: brightBlue300,
              padding: EdgeInsets.all(5.0.wp),
            ),
            child: Obx(
              () => Icon(
                Icons.arrow_forward,
                color: controller.currentWordIndex.value ==
                        controller.selectedCategory.words.length - 1
                    ? darkBlue100
                    : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getRecordButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloatingActionButton.large(
          onPressed: () {
            controller.handleButtonPress();
          },
          backgroundColor: Colors.red,
          child: const Icon(Icons.mic),
        ),
      ],
    );
  }

  Widget getScoreBoard() {
    return Container(
      margin: EdgeInsets.fromLTRB(20.0.wp, 0.0.wp, 20.0.wp, 0.0.wp),
      width: 100.0.wp,
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star,
            color: Colors.yellow,
            size: 24.0,
          ),
          SizedBox(width: 8.0),
          Obx(() => Text(
                'Score: ${controller.pronunciationScore.value}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              )),
        ],
      ),
    );
  }
}
