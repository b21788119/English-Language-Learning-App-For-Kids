import 'dart:math';

import 'package:first_app/app/core/utils/DataHelper.dart';
import 'package:first_app/app/data/models/content.dart';
import 'package:first_app/app/data/models/game_user.dart';
import 'package:first_app/app/data/models/user.dart';
import 'package:first_app/app/data/models/word.dart';
import 'package:get/get.dart';

class Game4Controller extends GetxController {
  late List<Content> avaliableContents;
  late Rx<Content> selectedContent;

  // all words coming from the chosen categories
  late List<Word> words;

  late String gameMode;

  // deneme
  RxMap<int, ExtendedWordGame4> wordMap = RxMap();

  final totalScore = 0.0.obs;
  final totalCoinCount = 0.obs;

  // it depends on the words count
  final baseScore = 0.0.obs;

  late DateTime startTime;

  // how many move happened
  final moveCount = 0.obs;
  //late int maxMoveCount;

  // check wheter if the game is ended
  // if current couple count is 8 then game is over
  final chosenWordCount = 8;
  final gameOver = false.obs;
  int currentCoupleCount = 0;

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
    totalScore.value = 0;
    totalCoinCount.value = 0;

    words.shuffle();

    final subWord = words.sublist(0, chosenWordCount);
    var imageWord = List.generate(
      subWord.length,
      (index) => ExtendedWordGame4(subWord.elementAt(index), true, 0, false),
    );
    var voiceWord = List.generate(
      subWord.length,
      (index) => ExtendedWordGame4(subWord.elementAt(index), false, 0, false),
    );

    imageWord.addAll(voiceWord);
    imageWord.shuffle();

    var index = 0;
    for (var extendedword in imageWord) {
      wordMap[index] = extendedword;
      extendedword.index = index;
      index++;
    }

    // fill base score according to game mode
    baseScore.value = words.length.toDouble() * 5;
    if (gameMode == "kolay") {
      //baseScore.value *= 2;
      //maxMoveCount = 20;
    } else if (gameMode == "normal") {
      //baseScore.value *= 5;
      //maxMoveCount = 15;
    } else if (gameMode == "zor") {
      //baseScore.value *= 10;
      //maxMoveCount = 10;
    } else if (gameMode == "extreme") {
      //baseScore.value *= 15;
      //maxMoveCount = 5;
    }
  }

  void choseContent() {
    Random random = Random();
    int index = random.nextInt(avaliableContents.length);
    var content = avaliableContents.elementAt(index);
    selectedContent = Rx(content);
  }

  // draggedWord sürüklenen hangisi ise
  // üstüne gelinen on dragged
  void handleDrag(ExtendedWordGame4 draggedWord, ExtendedWordGame4 onDragged) {
    if (!_checkTheSibling(draggedWord.index, onDragged.index)) {
      return;
    }
    if (draggedWord.word.wordID == onDragged.word.wordID &&
        draggedWord.isImage != onDragged.isImage) {
      _correctAnswer(draggedWord, onDragged);
    } else if (draggedWord.word.wordID != onDragged.word.wordID) {
      _changeWordPosition(draggedWord.index, onDragged.index);
    }
  }

  Future _correctAnswer(
    ExtendedWordGame4 draggedWord,
    ExtendedWordGame4 onDragged,
  ) async {
    // get some score from the correct drag
    totalScore.value += baseScore.value;
    totalCoinCount.value += 5;

    // prepare bools
    draggedWord.isImage = true;
    draggedWord.isCompleted = true;
    onDragged.isImage = true;
    onDragged.isCompleted = true;

    currentCoupleCount++;
    if (currentCoupleCount >= chosenWordCount) {
      gameOver.value = true;
      await insertGameInfo();
    }
    wordMap.refresh();
  }

  Future insertGameInfo() async {
    final elapsed = DateTime.now().difference(startTime);
    await DataHelper.instance.insert(
      "GameUser",
      GameUser(
        1,
        4,
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

  void _changeWordPosition(int indexFirst, int indexSecond) {
    final firstWord = wordMap[indexFirst];
    final secondWord = wordMap[indexSecond];
    if (firstWord == null || secondWord == null) {
      return;
    }
    // birinciyi ikinciye geçir
    wordMap[indexSecond] = firstWord;
    firstWord.index = indexSecond;

    // birincinin yerine ikinciyi geçir
    wordMap[indexFirst] = secondWord;
    secondWord.index = indexFirst;

    wordMap.refresh();
    moveCount.value++;
  }

  bool _checkTheSibling(int a, int b) {
    final diff = (a - b).abs();
    if (diff == 1 || diff == 4) {
      return true;
    }
    return false;
  }
}

class ExtendedWordGame4 {
  Word word;
  bool isImage;
  int index;
  bool isCompleted;

  ExtendedWordGame4(this.word, this.isImage, this.index, this.isCompleted);
}
