import 'package:first_app/app/core/utils/extensions.dart';
import 'package:first_app/app/core/values/colors.dart';
import 'package:first_app/app/data/models/game_user.dart';
import 'package:first_app/app/modules/admin/game_ist/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameStatDetailPage extends StatelessWidget {
  GameStatDetailPage({super.key});

  static const pageName = "/gameStat";
  var controller = Get.find<GameStatController>();

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
              ...controller.gameStats.map((game) {
                return getStatCard(game);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget getStatCard(GameUser game) {
    return Card(
      color: brightBlue50,
      elevation: 3,
      shadowColor: brightBlue100,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.wp),
        margin: EdgeInsets.all(2.wp),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          title: Text(game.score.toString()),
          subtitle: Text("game-${game.gameID}"),
          trailing: Icon(Icons.ondemand_video_sharp),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 1.5),
            ),
            child: Text("game"),
          ),
          //contentPadding: EdgeInsets.all(2.wp),
          //dense: true,
          //enabled: false,
          onTap: () async {
            await controller.chooseGame(game.gameID);
            Get.to(
              () => GameStatDetailPage(),
              transition: Transition.downToUp,
            );
          },
          onLongPress: () {},
          //tileColor: blue,
          textColor: Colors.black,
          iconColor: Colors.black,
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
        controller.games.elementAt(controller.chosenGameInedx.value).name,
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
