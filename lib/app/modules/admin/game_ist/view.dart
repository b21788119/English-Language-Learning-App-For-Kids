import 'package:first_app/app/core/utils/extensions.dart';
import 'package:first_app/app/core/values/colors.dart';
import 'package:first_app/app/data/models/game.dart';
import 'package:first_app/app/modules/admin/game_ist/widgets/details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class GameStatPage extends GetView<GameStatController> {
  GameStatPage({super.key});

  static const pageName = "/gameStat";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brightBlue50,
      body: SafeArea(
        child: Obx(
          () => ListView(
            children: [
              backButton(),
              getTitle(),
              ...controller.games.map((game) {
                return getGameCard(game);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget getGameCard(Game game) {
    return Card(
      color: brightBlue50,
      elevation: 3,
      shadowColor: brightBlue100,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.wp),
        margin: EdgeInsets.all(2.wp),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: blue,
        ),
        child: ListTile(
          title: Text(game.name),
          subtitle: Text("game-${game.gameID}"),
          trailing: Icon(Icons.ondemand_video_sharp),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(game.pictureSrc), fit: BoxFit.cover),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 1.5)),
          ),
          //contentPadding: EdgeInsets.all(2.wp),
          //dense: true,
          //enabled: false,
          onTap: () {
            controller.chooseGame(game.gameID);
            Get.to(
              () => GameStatDetailPage(),
              transition: Transition.downToUp,
            );
          },
          onLongPress: () {},
          //tileColor: blue,
          textColor: Colors.white,
          iconColor: Colors.white,
        ),
      ),
    );
  }

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

  Widget getTitle() {
    return Center(
      child: Text(
        "Choose Game",
        style: TextStyle(
          fontSize: 5.0.hp,
          fontWeight: FontWeight.w900,
          color: darkBlue100,
          shadows: const [
            Shadow(
              color: blue,
              offset: Offset(2, 3),
              blurRadius: 5,
            ),
          ],
          letterSpacing: 1.0.wp,
        ),
      ),
    );
  }
}
