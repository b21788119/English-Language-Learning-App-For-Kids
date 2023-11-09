import 'dart:math';

import 'package:first_app/app/core/utils/DataHelper.dart';
import 'package:first_app/app/data/models/content.dart';
import 'package:first_app/app/data/models/game_user.dart';
import 'package:first_app/app/data/models/user.dart';
import 'package:first_app/app/data/models/word.dart';

import 'package:get/get.dart';

class Game3Controller extends GetxController {
  late List<Content> avaliableContents;
  late Rx<Content> selectedContent;

  // all words coming from the chosen categories
  late List<Word> words;

  // this will store 10 game correct word
  late List<Word> correctWordList;
  final currentCorrectWordIndex = 0.obs;

  late String gameMode;

  // randomWords chosen words for the game from words list
  Rx<List<Word>> randomWords = Rx<List<Word>>([]);

  final totalScore = 0.0.obs;
  final totalCoinCount = 0.obs;

  // it depends on the words count
  final baseScore = 0.0.obs;

  // to decrease the score after wrong choises
  final guestCount = 0.obs;

  final questionCount = 2;

  // check wheter if the game is ended
  final gameOver = false.obs;

  late DateTime startTime;

  @override
  void onInit() {
    super.onInit();

    // get arguments
    words = Get.arguments[0] as List<Word>;
    gameMode = Get.arguments[1] as String;
    avaliableContents = Get.arguments[2] as List<Content>;

    startGame();
  }

  void startGame() {
    choseContent();
    startTime = DateTime.now();
    gameOver.value = false;
    guestCount.value = 0;
    totalScore.value = 0;
    totalCoinCount.value = 0;
    currentCorrectWordIndex.value = 0;

    words.shuffle();

    // create questions correct answers
    correctWordList = words.sublist(0, questionCount);

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

  Word getCorrectWord() {
    return correctWordList.elementAt(currentCorrectWordIndex.value);
  }

  Future correctAnswer() async {
    // get coin if s/he knows the answer in the first try
    if (guestCount.value == 0) {
      if (gameMode == "Easy") {
        totalCoinCount.value += 2;
      } else if (gameMode == "Normal") {
        totalCoinCount.value += 5;
      } else if (gameMode == "Hard") {
        totalCoinCount.value += 10;
      } else if (gameMode == "Extreme") {
        totalCoinCount.value += 15;
      }
    }
    // get score
    totalScore.value += baseScore.value / pow(2, guestCount.value);
    // game over
    if (currentCorrectWordIndex.value + 1 >= questionCount) {
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
        3,
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

  void wrongAnswer() {
    guestCount.value++;
  }

  void getNextGame() async {
    guestCount.value = 0;

    if (currentCorrectWordIndex.value + 1 >= questionCount) {
      gameOver.value = true;
      await insertGameInfo();
    } else {
      currentCorrectWordIndex.value++;
      randomWords.value = _getRandomWords();
    }
  }

  List<Word> _getRandomWords() {
    switch (gameMode) {
      case "Easy":
        return _getRandomWordsWithCount(1);
      case "Normal":
        return _getRandomWordsWithCount(3);
      case "Hard":
        return _getRandomWordsWithCount(5);
      case "Extreme":
        return _getRandomWordsWithCount(8);
      default:
    }
    return List.empty();
  }

  List<Word> _getRandomWordsWithCount(int count) {
    List<Word> result = <Word>[];

    // add the correct word beforehand
    var correctWord = correctWordList.elementAt(currentCorrectWordIndex.value);
    result.add(correctWord);

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
}
