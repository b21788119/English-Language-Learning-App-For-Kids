import 'dart:math';

import 'package:first_app/app/core/utils/DataHelper.dart';
import 'package:first_app/app/data/models/content.dart';
import 'package:first_app/app/data/models/game_user.dart';
import 'package:first_app/app/data/models/user.dart';
import 'package:first_app/app/data/models/word.dart';
import 'package:get/get.dart';

class Game2Controller extends GetxController {
  var availableContents = <Content>[];
  Rx<Content> selectedContent =
      Rx(Content(-1, "hiç", "assets/images/apple.png", true, true, 50, 3));

  // all words coming from the chosen categories
  late List<Word> words;

  // this will store 10 game correct word
  late List<Word> missingWordList;
  final currentMissingWordIndex = 0.obs;

  late String gameMode;

  // randomWords chosen words for the game from words list
  Rx<List<Word>> randomWords = Rx<List<Word>>([]);
  Rx<List<Word>> randomWordsWithotMissing = Rx<List<Word>>([]);

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
  void onInit() async {
    super.onInit();

    // get arguments
    words = Get.arguments[0] as List<Word>;
    gameMode = Get.arguments[1] as String;
    availableContents = Get.arguments[2] as List<Content>;

    startGame();
  }

  void startGame() {
    choseContent();

    startTime = DateTime.now();
    gameOver.value = false;
    guestCount.value = 0;
    totalScore.value = 0;
    totalCoinCount.value = 0;
    currentMissingWordIndex.value = 0;

    words.shuffle();

    // create questions getting missing words
    missingWordList = words.sublist(0, questionCount);

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
    if (availableContents.isEmpty) {
      return;
    }
    Random random = Random();
    int index = random.nextInt(availableContents.length);
    var content = availableContents.elementAt(index);
    selectedContent = Rx(content);
  }

  Word getMissingWord() {
    return missingWordList.elementAt(currentMissingWordIndex.value);
  }

  Future correctAnswer() async {
    // get coin if s/he knows the answer in the first try
    if (guestCount.value == 0) {
      if (gameMode == "Easy") {
        totalCoinCount.value += 5;
      } else if (gameMode == "Normal") {
        totalCoinCount.value += 5;
      } else if (gameMode == "Hard") {
        totalCoinCount.value += 10;
      } else if (gameMode == "Extreme") {
        totalCoinCount.value += 10;
      }
    }
    // get score
    totalScore.value += baseScore.value / pow(2, guestCount.value);

    // game over
    if (currentMissingWordIndex.value + 1 >= questionCount) {
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
        2,
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

    if (currentMissingWordIndex.value + 1 >= questionCount) {
      gameOver.value = true;
      await insertGameInfo();
    } else {
      currentMissingWordIndex.value++;
      randomWords.value = _getRandomWords();
    }
  }

  List<Word> _getRandomWords() {
    switch (gameMode) {
      case "Easy":
        return _getRandomWordsWithCount(2);
      case "Normal":
        return _getRandomWordsWithCount(2);
      case "Hard":
        return _getRandomWordsWithCount(3);
      case "Extreme":
        return _getRandomWordsWithCount(3);
      default:
    }
    return List.empty();
  }

  List<Word> _getRandomWordsWithCount(int count) {
    List<Word> result = <Word>[];

    // add the correct word beforehand
    var correctWord = missingWordList.elementAt(currentMissingWordIndex.value);
    Random random = Random();

    for (int i = 0; i < count; i++) {
      int index = random.nextInt(words.length);
      var word = words.elementAt(index);

      // aynısı eklendiyse tekrar gir for'a
      if (result.contains(word) || word.wordID == correctWord.wordID) {
        i--;
      } else {
        result.add(word);
      }
    }
    randomWordsWithotMissing.value = [...result];

    result.add(correctWord);
    result.shuffle();

    return result;
  }
}
