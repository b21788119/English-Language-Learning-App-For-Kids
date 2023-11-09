import 'package:first_app/app/core/utils/extensions.dart';
import 'package:first_app/app/core/values/colors.dart';
import 'package:first_app/app/modules/admin/game_ist/view.dart';
import 'package:first_app/app/modules/category/view.dart';
import 'package:first_app/app/modules/games/widgets/choose_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import 'controller.dart';

class AdminPage extends GetView<AdminController> {
  AdminPage({super.key});

  static const pageName = "/admin";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brightBlue50,
      body: SafeArea(
        child: Column(
          children: [
            backButton(),
            getAdminTitle(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getAdminButton(
                    "Word/Category",
                    Icons.category,
                    () {
                      Get.toNamed(CategoryPage.pageName);
                    },
                  ),
                  SizedBox(height: 5.hp),
                  getAdminButton(
                    "Word Statistics",
                    Icons.wordpress_sharp,
                    () {},
                  ),
                  SizedBox(height: 5.hp),
                  getAdminButton(
                    "Game Statistics",
                    Icons.gamepad,
                    () {
                      Get.toNamed(GameStatPage.pageName);
                    },
                  ),
                  SizedBox(height: 5.hp),
                  getAdminButton(
                    "Language",
                    Icons.language,
                    () {},
                  ),
                  SizedBox(height: 5.hp),
                  getAdminButton(
                    "Password",
                    Icons.password,
                    () {},
                  ),
                ],
              ),
            ),
          ],
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

  Widget getAdminButton(
      String title, IconData iconData, VoidCallback onPressed) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkBlue200,
          minimumSize: Size.fromHeight(10.0.hp),
          textStyle: TextStyle(fontSize: 3.0.hp),
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(1.0.wp),
              child: Icon(iconData, size: 5.0.hp),
            ),
            SizedBox(width: 5.0.wp),
            Expanded(child: Text(title))
          ],
        ),
      ),
    );
  }

  Widget getAdminTitle() {
    return Center(
      child: Text(
        "ADMIN",
        style: TextStyle(
          fontSize: 7.0.hp,
          fontWeight: FontWeight.w900,
          color: darkBlue100,
          shadows: const [
            Shadow(
              color: blue,
              offset: Offset(2, 3),
              blurRadius: 5,
            ),
          ],
          letterSpacing: 2.0.wp,
        ),
      ),
    );
  }
}
