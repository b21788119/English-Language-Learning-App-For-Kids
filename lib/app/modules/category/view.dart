import 'package:first_app/app/core/utils/extensions.dart';
import 'package:first_app/app/data/models/category.dart';
import 'package:first_app/app/modules/category/controller.dart';
import 'package:first_app/app/modules/category/widgets/add_category.dart';
import 'package:first_app/app/modules/category/widgets/category_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../core/values/colors.dart';

class CategoryPage extends GetView<CategoryController> {
  CategoryPage({super.key});

  static const pageName = "/category";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            title(), // my categories
            categoriesAndAddCategoryCard(),
            SizedBox(height: 5.0.hp),
            getBackButton(),
            SizedBox(height: 5.0.hp)
          ],
        ),
      ),
      floatingActionButton: deleteCategoryAndAddCategoryButton(),
    );
  }

  Widget title() {
    return Padding(
      padding: EdgeInsets.all(4.0.wp),
      child: Text(
        "My Categories",
        style: TextStyle(
          fontSize: 24.0.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget getBackButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: yellow,
        //primary: blue, backroundla aynı sanırım
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        minimumSize: const Size(150, 40),
      ),
      child: const Text("BACK"),
      onPressed: () {
        Get.back();
      },
    );
  }

  Widget categoriesAndAddCategoryCard() {
    return Obx(
      () => Expanded(
        child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: [
            ...controller.categories
                .map(
                  (element) => LongPressDraggable(
                    data: element,
                    onDragStarted: () => controller.changeDeleting(true),
                    onDraggableCanceled: (velocity, offset) =>
                        controller.changeDeleting(false),
                    onDragEnd: (details) => controller.changeDeleting(false),
                    feedback: Opacity(
                      opacity: 0.8,
                      child: CategoryCard(category: element),
                    ),
                    child: CategoryCard(category: element),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget deleteCategoryAndAddCategoryButton() {
    return DragTarget<Category>(
      builder: (context, candidateData, rejectedData) => Obx(
        () => FloatingActionButton(
          onPressed: () {
            if (controller.categories.isEmpty) {
              EasyLoading.showInfo("Create a Category first");
              return;
            }
            controller.editController.clear();
            Get.to(
              () => AddCategory(),
              transition: Transition.downToUp,
            );
          },
          backgroundColor: controller.deleting.value ? Colors.red : Colors.blue,
          child: Icon(controller.deleting.value ? Icons.delete : Icons.add),
        ),
      ),
      onAccept: (category) async {
        var result = await controller.deleteCategory(category);
        if (result == -1) {
          EasyLoading.showError("Something goes wrong");
          return;
        }
        EasyLoading.showSuccess("Delete Success");
      },
    );
  }
}
