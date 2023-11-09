import 'dart:io';

import 'package:first_app/app/core/utils/DataHelper.dart';
import 'package:first_app/app/data/models/word.dart';
import 'package:first_app/app/modules/category/controller.dart';
import 'package:first_app/app/widgets/file_operations.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class WordController extends GetxController {
  final Rx<FlutterSoundRecorder> recorder = Rx(FlutterSoundRecorder());
  final wordAudioFilePath = Rx<String?>(null);
  final wordImageFilePath = Rx<String?>(null);

  final categoryController = Get.find<CategoryController>();

  @override
  void onInit() async {
    super.onInit();
    initRecorder();
  }

  @override
  void onClose() {
    super.onClose();
    recorder.value.closeRecorder();
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'microfon is not granted';
    }

    final opened = await recorder.value.openRecorder();
    if (opened == null) {
      return;
    }
    recorder.value = opened;

    recorder.value.setSubscriptionDuration(const Duration(microseconds: 500));
  }

  Future stop() async {
    final cachPath = await recorder.value.stopRecorder();
    print('audio cach path is  ----------------- $cachPath');
    wordAudioFilePath.value = cachPath;
    recorder.refresh();
  }

  Future record() async {
    if (Platform.isIOS) {
      await recorder.value
          .startRecorder(toFile: "record.wav", codec: Codec.pcm16WAV);
    } else if (Platform.isAndroid) {
      await recorder.value
          .startRecorder(toFile: "record.m4a", codec: Codec.aacMP4);
    }
    recorder.refresh();
  }

  Future<bool> deleteWord(Word word) async {
    var result = -1;
    if (word.isNew) {
      result = await DataHelper.instance.delete("Word", word);
    } else {
      word.isDeleted = true;
      result = await DataHelper.instance.update("Word", word);
    }
    if (result == -1) {
      return false;
    }

    deleteFile(word.audioSrc);
    deleteFile(word.pictureSrc);

    // UI için
    categoryController.selectedCategory.value!.words.remove(word);
    categoryController.selectedCategory.refresh();
    categoryController.categories.refresh();

    return true;
  }

  Future<bool> insertWord() async {
    final wordName = categoryController.editController.text;

    var nameCheck = categoryController.selectedCategory.value!.words.any(
      (element) => element.name.toLowerCase() == wordName.toLowerCase(),
    );

    if (nameCheck) {
      return false;
    }

    var imagePath = await saveFilePermenantAndGetThePath(
        wordImageFilePath.value,
        recordName: wordName);
    if (imagePath == null) {
      return false;
    }

    var audioPath = await saveFilePermenantAndGetThePath(
        wordAudioFilePath.value,
        recordName: wordName);
    if (audioPath == null) {
      deleteFile(imagePath);
      return false;
    }

    Word word = Word.withoutID(wordName, imagePath, audioPath, 0, 0, 50,
        categoryController.selectedCategory.value!.ID, true, false);

    final result = await DataHelper.instance.insert("Word", word);
    if (result == 0) {
      deleteFile(imagePath);
      deleteFile(audioPath);
      return false;
    }

    // UI için elle ekleme
    categoryController.selectedCategory.value!.words.add(word);
    categoryController.selectedCategory.refresh();
    categoryController.categories.refresh();
    return true;
  }
}
