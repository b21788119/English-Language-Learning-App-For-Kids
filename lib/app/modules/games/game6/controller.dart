import 'dart:io';
import 'dart:math';

import 'package:first_app/app/core/utils/DataHelper.dart';
import 'package:first_app/app/data/models/content.dart';
import 'package:first_app/app/data/models/game_user.dart';
import 'package:first_app/app/data/models/user.dart';
import 'package:first_app/app/data/models/word.dart';
import 'package:first_app/app/widgets/file_operations.dart';
import 'package:flutter_sound/flutter_sound.dart';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class Game6Controller extends GetxController {
  late List<Content> avaliableContents;
  late Rx<Content> selectedContent;

  final Rx<FlutterSoundRecorder> recorder = Rx(FlutterSoundRecorder());

  // all words coming from the chosen categories
  late List<Word> words;

  final currentGameIndex = 0.obs;

  late String gameMode;

  // randomWords chosen words for the game from words list
  Rx<List<Word>> randomWords = Rx<List<Word>>([]);

  final totalScore = 0.0.obs;
  final totalCoinCount = 0.obs;

  // it depends on the words count
  final baseScore = 0.0.obs;

  final questionCount = 2;

  // check wheter if the game is ended
  final gameOver = false.obs;

  late DateTime startTime;

  // wheather if the pronunciation is open
  var isPronunciationOpen = false.obs;
  final chosenWordIndex = 0.obs;

  final predictionClassName = "Yanlış".obs;

  @override
  void onInit() {
    super.onInit();
    initRecorder();

    // get arguments
    words = Get.arguments[0] as List<Word>;
    gameMode = Get.arguments[1] as String;
    avaliableContents = Get.arguments[2] as List<Content>;

    startGame();
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
    recorder.refresh();

    String? result;
    if (Platform.isIOS) {
      result = await postVoiceRequest(
        randomWords.value.elementAt(chosenWordIndex.value),
        cachPath ?? "",
        "record.wav",
      );
    } else if (Platform.isAndroid) {
      result = await postVoiceRequest(
        randomWords.value.elementAt(chosenWordIndex.value),
        cachPath ?? "",
        "record.m4a",
      );
    }
    if (result == null) {
      return;
    }

    print(result);
    correctAnswer(int.parse(result.split("+")[0]));
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

  void startGame() {
    choseContent();
    startTime = DateTime.now();
    gameOver.value = false;
    totalScore.value = 0;
    totalCoinCount.value = 0;
    currentGameIndex.value = 0;
    isPronunciationOpen.value = false;

    words.shuffle();

    // choise first game questions
    randomWords.value = _getRandomWords();

    // fill base score according to game mode
    baseScore.value = words.length.toDouble();
    if (gameMode == "Easy") {
      baseScore.value *= 2;
    } else if (gameMode == "Normal") {
      baseScore.value *= 5;
    } else if (gameMode == "Hard") {
      baseScore.value *= 10;
    } else if (gameMode == "Extreme") {
      baseScore.value *= 15;
    }
  }

  void choseContent() {
    Random random = Random();
    int index = random.nextInt(avaliableContents.length);
    var content = avaliableContents.elementAt(index);
    selectedContent = Rx(content);
  }

  Future correctAnswer(int predictionClass) async {
    // get coin if s/he knows the answer in the first try

    switch (predictionClass) {
      case 1:
        predictionClass = 5;
        predictionClassName.value = "Harikulade";
        break;
      case 2:
        predictionClass = 3;
        predictionClassName.value = "Güzel";
        break;
      case 3:
        predictionClass = 1;
        predictionClassName.value = "Biraz Gayret";
        break;
      case 4:
        predictionClass = 0;
        predictionClassName.value = "Tekrar dene";
        break;
      default:
        predictionClass = 0;
        break;
    }

    if (gameMode == "Easy") {
      totalCoinCount.value += 2 * predictionClass;
    } else if (gameMode == "Normal") {
      totalCoinCount.value += 5 * predictionClass;
    } else if (gameMode == "Hard") {
      totalCoinCount.value += 10 * predictionClass;
    } else if (gameMode == "Extreme") {
      totalCoinCount.value += 15 * predictionClass;
    }

    // get score
    totalScore.value += baseScore.value;
    // game over
    if (currentGameIndex.value + 1 >= questionCount) {
      gameOver.value = true;
      await insertGameInfo();
    }
  }

  Future insertGameInfo() async {
    final elapsed = DateTime.now().difference(startTime);
    await DataHelper.instance.insert(
      "GameUser",
      GameUser(
        1,
        6,
        totalScore.value,
        elapsed.inSeconds,
        DateTime.now().toUtc(),
        gameOver.value,
      ),
    );

    // get user and update her/his coins
    var userMap = await DataHelper.instance.getAll("User");
    List<User> users = List.generate(userMap.length, (i) {
      return User.fromJson(userMap[i]);
    });
    var user = users.elementAt(0);

    await DataHelper.instance.update(
      "User",
      User(
        user.userID,
        user.name,
        user.surname,
        user.age,
        user.coin + totalCoinCount.value,
      ),
    );
  }

  void wrongAnswer() {}

  void getNextGame() async {
    if (currentGameIndex.value + 1 >= questionCount) {
      gameOver.value = true;
      await insertGameInfo();
    } else {
      currentGameIndex.value++;
      isPronunciationOpen.value = false;
      randomWords.value = _getRandomWords();
    }
  }

  List<Word> _getRandomWords() {
    switch (gameMode) {
      case "Easy":
        return _getRandomWordsWithCount(9);
      case "Normal":
        return _getRandomWordsWithCount(4);
      case "Hard":
        return _getRandomWordsWithCount(2);
      case "Extreme":
        return _getRandomWordsWithCount(1);
      default:
    }
    return List.empty();
  }

  List<Word> _getRandomWordsWithCount(int count) {
    List<Word> result = <Word>[];

    Random random = Random();

    for (int i = 0; i < count; i++) {
      int index = random.nextInt(words.length);
      var word = words.elementAt(index);

      // aynısı eklendiyse tekrar gir for'a
      if (result.contains(word)) {
        i--;
      } else {
        result.add(word);
      }
    }
    result.shuffle();
    return result;
  }

  int getCrossAxisCount() {
    if (isPronunciationOpen.value) {
      return 1;
    }
    if (gameMode == "Easy") {
      return 3;
    } else if (gameMode == "Normal") {
      return 2;
    } else if (gameMode == "Hard") {
      return 2;
    } else if (gameMode == "Extreme") {
      return 1;
    }
    return 2;
  }
}
