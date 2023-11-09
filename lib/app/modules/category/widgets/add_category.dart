import 'package:first_app/app/core/utils/extensions.dart';
import 'package:first_app/app/modules/category/controller.dart';
import 'package:first_app/app/widgets/file_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddCategory extends StatelessWidget {
  final categoryController = Get.find<CategoryController>();
  AddCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: categoryController.fromKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Close And Done Buttons
              closeAndDoneButtons(),
              // CREATE NEW CATEGORY title
              getTitle(),
              SizedBox(height: 5.0.hp),
              getInputField(),
              SizedBox(height: 2.0.hp),
              getPickerButton(Icons.image, "Pick Galery", () async {
                // cach temizle
                if (categoryController.selectedCategoryImageFilePath.value !=
                    null) {
                  deleteFile(
                      categoryController.selectedCategoryImageFilePath.value!);
                }
                categoryController.selectedCategoryImageFilePath.value =
                    await pickImage(ImageSource.gallery);
                return;
              }),
              SizedBox(height: 2.0.hp),
              getPickerButton(Icons.camera_alt, "Pick Camera", () async {
                // cach temizle
                if (categoryController.selectedCategoryImageFilePath.value !=
                    null) {
                  deleteFile(
                      categoryController.selectedCategoryImageFilePath.value!);
                }
                categoryController.selectedCategoryImageFilePath.value =
                    await pickImage(ImageSource.camera);
                return;
              }),

              Obx(() {
                final path =
                    categoryController.selectedCategoryImageFilePath.value;
                return Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0.wp),
                    width: double.infinity,
                    child: path != null
                        ? Image(image: getImage(true, path))
                        : const FlutterLogo(size: 100),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget getPickerButton(
      IconData iconData, String title, VoidCallback onClicked) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(20.0.sp),
            textStyle: TextStyle(fontSize: 14.0.sp)),
        onPressed: onClicked,
        child: Row(
          children: [
            Icon(iconData, size: 20),
            SizedBox(width: 5.0.wp),
            Text(title)
          ],
        ),
      ),
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
              // clear cach
              deleteFile(
                  categoryController.selectedCategoryImageFilePath.value ?? "");
              categoryController.editController.clear();
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
              if (!categoryController.fromKey.currentState!.validate()) {
                return;
              }
              if (categoryController.selectedCategoryImageFilePath.value ==
                  null) {
                EasyLoading.showError("Please select an image");
                return;
              }
              var success = await categoryController.insertCategory();
              if (success) {
                EasyLoading.showSuccess(
                  "Category is added",
                );
                // clear cach
                deleteFile(
                    categoryController.selectedCategoryImageFilePath.value ??
                        "");
                Get.back();
              } else {
                EasyLoading.showError("Category name is already exist");
              }
              categoryController.editController.clear();
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

  Widget getTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
      child: Center(
        child: Text(
          "Create New Category",
          style: TextStyle(
            fontSize: 20.0.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget getInputField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
      child: TextFormField(
        controller: categoryController.editController,
        decoration: InputDecoration(
          labelText: "Name",
          hintText: "Enter your category Name",
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[400]!),
          ),
        ),
        autofocus: true,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Please enter your word";
          }
          return null;
        },
      ),
    );
  }
}
