import 'package:first_app/app/core/utils/extensions.dart';
import 'package:first_app/app/core/values/colors.dart';
import 'package:first_app/app/data/models/category.dart';
import 'package:first_app/app/modules/games/controller.dart';
import 'package:first_app/app/widgets/file_operations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChooseCategory extends StatelessWidget {
  ChooseCategory({super.key});

  final controller = Get.find<GamesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brightBlue50,
      body: SafeArea(
          child: Column(
        children: [
          closeAndDoneButtons(),
          getCategoryCards(),
        ],
      )),
    );
  }

  Widget closeAndDoneButtons() {
    return Padding(
      padding: EdgeInsets.all(3.0.wp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // CLOSE BUTTON
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.close),
          ),

          // DONE BUTTON
          TextButton(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
            ),
            onPressed: () async {
              Get.back();
            },
            child: Text(
              "Done",
              style: TextStyle(
                fontSize: 14.0.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getCategoryCards() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.0.wp),
      height: 80.0.hp,
      color: Color.fromARGB(255, 243, 250, 255),
      child: Center(
        child: GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: [
            ...controller.categories.map((category) => getCategortCard(
                  category,
                ))
          ],
        ),
      ),
    );
  }

  Widget getCategortCard(Category category) {
    //var squareWidth = Get.width - 12.0.wp;
    return Obx(
      () => GestureDetector(
        onTap: () {
          controller.toggleChosenCategory(category.ID);
        },
        child: Container(
          //width: squareWidth / 2,
          //height: squareWidth / 2,
          margin: EdgeInsets.all(1.0.wp),
          decoration: BoxDecoration(
            color: controller.checkChosen(category.ID)
                ? brightBlue300
                : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300]!,
                blurRadius: 7,
                offset: const Offset(0, 7),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getCategoryImage(category),
              getCategoryCardInfo(category),
            ],
          ),
        ),
      ),
    );
  }

  Widget getCategoryCardInfo(Category category) {
    return Padding(
      padding: EdgeInsets.only(left: 2.0.wp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12.0.sp,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 1.0.wp),
          Text(
            "${category.words.length} words",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget getCategoryImage(Category category) {
    return Padding(
      padding: EdgeInsets.all(3.0.wp),
      child: Image(
        image: getImage(category.isNew, category.pictureSrc),
        width: 10.0.wp,
        height: 10.0.wp,
        fit: BoxFit.cover,
      ),
    );
  }
}
