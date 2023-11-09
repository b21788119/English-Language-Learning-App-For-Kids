import 'package:audioplayers/audioplayers.dart';
import 'package:first_app/app/core/utils/extensions.dart';
import 'package:first_app/app/data/models/category.dart';
import 'package:first_app/app/modules/category/controller.dart';
import 'package:first_app/app/modules/word/controller.dart';
import 'package:first_app/app/widgets/file_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddWord extends GetView<WordController> {
  final categoryController = Get.find<CategoryController>();

  AddWord({super.key});

  static const pageName = "/addword";

  AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: categoryController.fromKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              closeAndDoneButtons(),
              getTitle(),
              SizedBox(height: 5.0.hp),
              getInputField(),
              SizedBox(height: 2.0.hp),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
                child: Row(
                  children: [
                    getRecorderButton(),
                    SizedBox(width: 2.0.wp),
                    getListenButton(),
                    SizedBox(width: 2.0.wp),
                    getRecordTime(),
                  ],
                ),
              ),
              SizedBox(height: 2.0.hp),
              getGaleryCameraButtons(),
              Obx(() {
                final path = controller.wordImageFilePath.value;
                return Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0.wp),
                    width: double.infinity,
                    child: path != null
                        ? Image(image: getImage(true, path))
                        : Container(),
                  ),
                );
              }),
            ],
          ),
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
              // clear Cach
              deleteFile(controller.wordImageFilePath.value ?? "");
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
              if (controller.wordAudioFilePath.value == null) {
                EasyLoading.showError("Please record a voice");
                return;
              }
              if (controller.wordImageFilePath.value == null) {
                EasyLoading.showError("Please select an image");
                return;
              }
              var success = await controller.insertWord();
              if (success) {
                EasyLoading.showSuccess(
                  "Word is added",
                );
                deleteFile(controller.wordImageFilePath.value ?? "");
                Get.back();
              } else {
                EasyLoading.showError("Word name is already exist");
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
          "Create New Word",
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
          hintText: "Enter your word Name",
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

  Widget getRecorderButton() {
    return Obx(
      () => ElevatedButton(
        onPressed: () async {
          if (controller.recorder.value.isRecording) {
            await controller.stop();
          } else {
            await controller.record();
          }
        },
        child: Icon(
          controller.recorder.value.isRecording ? Icons.stop : Icons.mic,
          size: 10.0.wp,
        ),
      ),
    );
  }

  Widget getListenButton() {
    return ElevatedButton(
      onPressed: () async {
        if (controller.wordAudioFilePath.value == null) {
          return;
        }
        audioPlayer.play(
          DeviceFileSource(controller.wordAudioFilePath.value!),
        );
      },
      child: Icon(
        Icons.play_arrow,
        size: 10.0.wp,
      ),
    );
  }

  Widget getRecordTime() {
    return Obx(
      () => StreamBuilder<RecordingDisposition>(
        stream: controller.recorder.value.onProgress,
        builder: (context, snapshot) {
          final duration =
              snapshot.hasData ? snapshot.data!.duration : Duration.zero;
          return Text('00:${duration.inSeconds}');
        },
      ),
    );
  }

  Widget getGaleryCameraButtons() {
    return Row(
      children: [
        SizedBox(width: 5.0.wp),
        Expanded(
          child: getPickerButton(Icons.image, "Galery", () async {
            // clear cach
            if (controller.wordImageFilePath.value != null) {
              deleteFile(controller.wordImageFilePath.value!);
            }
            controller.wordImageFilePath.value =
                await pickImage(ImageSource.gallery);
            return;
          }),
        ),
        SizedBox(width: 3.0.wp),
        Expanded(
          child: getPickerButton(Icons.camera_alt, "Camera", () async {
            // clear cach
            if (controller.wordImageFilePath.value != null) {
              deleteFile(controller.wordImageFilePath.value!);
            }
            controller.wordImageFilePath.value =
                await pickImage(ImageSource.camera);
            return;
          }),
        ),
        SizedBox(width: 5.0.wp),
      ],
    );
  }

  Widget getPickerButton(
      IconData iconData, String title, VoidCallback onClicked) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(20.0.sp),
          textStyle: TextStyle(fontSize: 14.0.sp)),
      onPressed: onClicked,
      child: Row(
        children: [
          Icon(iconData, size: 10.0.wp),
          SizedBox(width: 5.0.wp),
          Expanded(child: Text(title))
        ],
      ),
    );
  }
}
