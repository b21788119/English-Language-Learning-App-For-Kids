import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:first_app/app/data/models/word.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

ImageProvider getImage(bool isnew, String src) {
  try {
    final file = File(src);
    if (isnew) {
      var check = file.existsSync();
      if (!check) {
        return const AssetImage("assets/images/game/mark.png");
      }
    }
    return isnew ? FileImage(file) as ImageProvider : AssetImage(src);
  } catch (e) {
    return const AssetImage("assets/images/game/mark.png");
  }
}

Source? getAudioSource(bool isnew, String src) {
  try {
    final file = File(src);
    if (isnew) {
      var check = file.existsSync();
      if (!check) {
        return null;
      }
    }
    return isnew ? DeviceFileSource(src) : AssetSource(src);
  } catch (e) {
    return null;
  }
}

void deleteFile(String path) {
  try {
    final file = File(path);
    if (file.existsSync()) {
      file.deleteSync();
    }
  } catch (e) {
    return;
  }
}

Future<String?> pickImage(ImageSource soruce) async {
  try {
    final image = await ImagePicker().pickImage(
      source: soruce,
    );
    if (image == null) return null;

    return image.path;
  } on PlatformException catch (e) {
    return null;
  }
}

Future<String?> postVoiceRequest(
    Word word, String recordedAudioPath, String recordedFileName) async {
  try {
    var request = http.MultipartRequest(
        "POST",
        Uri.parse(
            "http://${Platform.isAndroid ? "10.0.2.2" : "127.0.0.1"}:5000/"));
    File recordedAudioFile = File(recordedAudioPath);
    Uint8List audioBytes = recordedAudioFile.readAsBytesSync();
    var testAudio = http.MultipartFile.fromBytes("audio", audioBytes,
        filename: recordedFileName);
    String referenceAudioPath = word.audioSrc;
    String referenceFileName = referenceAudioPath.split('/').last;
    ByteData referenceData;
    if (word.isNew) {
      var file = File(word.audioSrc);
      ByteBuffer buffer = Uint8List.fromList(await file.readAsBytes()).buffer;
      referenceData = ByteData.view(buffer);
    } else {
      referenceData = await rootBundle.load("assets/${word.audioSrc}");
    }

    List<int> referenceBytes = referenceData.buffer.asUint8List();
    var referenceAudio = http.MultipartFile.fromBytes(
        "reference", referenceBytes,
        filename: referenceFileName);
    request.files.add(testAudio);
    request.files.add(referenceAudio);
    request.fields["word"] = word.name;

    var flag = word.isNew ? "1" : "0";
    request.fields["flag"] = flag;

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    return utf8.decode(responseData);
    // var result = utf8.decode(responseData);
    // var results = result.split("+");
    // double.parse(results[1]) / 100;
  } catch (e) {
    return null;
  }
}

Future<String?> saveFilePermenantAndGetThePath(String? inputFilepath,
    {String? recordName = "Test"}) async {
  try {
    if (inputFilepath == null) {
      return null;
    }
    final directory = await getApplicationDocumentsDirectory();

    final ext = extension(inputFilepath);
    var uuid = const Uuid();
    final name = '$recordName-${uuid.v4()}$ext';
    String outputFilePath = '${directory.path}/$name';

    final inputFile = File(inputFilepath);
    await inputFile.copy(outputFilePath);

    return outputFilePath;
  } catch (e) {
    return null;
  }
}
