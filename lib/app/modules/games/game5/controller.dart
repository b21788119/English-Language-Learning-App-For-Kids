import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:first_app/app/core/utils/DataHelper.dart';
import 'package:first_app/app/data/models/content.dart';
import 'package:first_app/app/data/models/game_user.dart';
import 'package:first_app/app/data/models/user.dart';
import 'package:first_app/app/data/models/word.dart';
import 'package:first_app/app/widgets/file_operations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameWord {
  String name;
  String pictureSrc;
  String audioSrc;
  bool isCorrect;
  bool isNew;

  GameWord(
    this.name,
    this.pictureSrc,
    this.audioSrc,
    this.isCorrect,
    this.isNew,
  );
}

class Game5Controller extends GetxController {
  late List<Content> avaliableContents;
  late Rx<Content> selectedContent;

  // all words coming from the chosen categories
  late List<Word> words;
  late String gameMode;
  late Rx<List<GameWord>> gameWords = Rx<List<GameWord>>([]);
  final wordIndex = 0.obs;
  AudioPlayer general_audio_player = AudioPlayer();
  AudioPlayer choice_audio_player = AudioPlayer();
  AudioPlayer listen_audio_player = AudioPlayer();
  late Rx<MaterialAccentColor> wrongButton;
  final is_wrong_clickable = false.obs;
  late Rx<MaterialAccentColor> correctButton;
  final is_correct_clickable = false.obs;
  final is_next_clickable = false.obs;
  final is_restart_clickable = false.obs;
  late IconButton playButton;
  late IconButton correctIcon;
  late IconButton wrongIcon;
  final totalCoinCount = 0.obs;
  final totalScore = 0.0.obs;

  Rx<IconButton> currentButton =
      IconButton(onPressed: () {}, icon: Icon(Icons.add)).obs;
  final gameOver = false.obs;

  late DateTime startTime;

  @override
  void onInit() {
    super.onInit();
    words = Get.arguments[0] as List<Word>;
    gameMode = Get.arguments[1] as String;
    avaliableContents = Get.arguments[2] as List<Content>;

    wrongButton = Colors.deepPurpleAccent.obs;
    correctButton = createColor(Colors.blue).obs;
    correctIcon = IconButton(
      splashRadius: 50.0,
      splashColor: Colors.green,
      color: Colors.lightGreen,
      iconSize: 50,
      icon: Icon(Icons.check),
      onPressed: () {},
    );
    wrongIcon = IconButton(
      splashRadius: 50.0,
      splashColor: Colors.green,
      color: Colors.red,
      iconSize: 50,
      icon: Icon(Icons.close),
      onPressed: () {},
    );
    playButton = IconButton(
      splashRadius: 50.0,
      splashColor: Colors.green,
      color: Colors.lightGreen,
      iconSize: 50,
      icon: Icon(Icons.play_circle),
      onPressed: () {
        listenCurrentWord();
      },
    );
    currentButton.value = playButton;
    generateWords();
    choseContent();
    startTime = DateTime.now();
    listenCurrentWord();
    //startGame();
  }

  void listenCurrentWord() async {
    if (wordIndex.value < gameWords.value.length) {
      var curWord = gameWords.value[wordIndex.value];
      var src = getAudioSource(curWord.isNew, curWord.audioSrc);
      if (src == null) return;

      await listen_audio_player.play(src, volume: 10);
      listenAudioPlayer(listen_audio_player);
    }
  }

  void listenAudioPlayer(AudioPlayer player) async {
    StreamSubscription<void>? audioPlayerCompletionListener;
    audioPlayerCompletionListener =
        await player.onPlayerComplete.listen((event) {
      is_correct_clickable.value = true;
      is_wrong_clickable.value = true;
      is_restart_clickable.value = true;
    });
  }

  void listenChoiceAudioPlayer(AudioPlayer player) async {
    StreamSubscription<void>? audioPlayerCompletionListener;
    audioPlayerCompletionListener =
        await player.onPlayerComplete.listen((event) {
      is_next_clickable.value = true;
    });
  }

  void generateWords() {
    Random random = Random();
    int number_of_correct_words = random.nextInt(8) + 1;
    int number_of_incorrect_words = 10 - number_of_correct_words;
    words.shuffle();
    List<Word> sublist =
        words.getRange(0, 10 + number_of_incorrect_words).toList();
    int index = 10;
    for (int i = 0; i < 10; i++) {
      if (i < number_of_correct_words) {
        gameWords.value.add(GameWord(
          sublist[i].name,
          sublist[i].pictureSrc,
          sublist[i].audioSrc,
          true,
          sublist[i].isNew,
        ));
      } else {
        gameWords.value.add(GameWord(
          sublist[i].name,
          sublist[i].pictureSrc,
          sublist[index].audioSrc,
          false,
          sublist[i].isNew,
        ));
        index++;
      }
    }
    gameWords.value.shuffle();
    gameWords.value.forEach((element) {
      print("element:${element.name}  isCorrect:${element.isCorrect}");
    });
  }

  Future<void> handleUserSelect(bool choice, Function callback) async {
    is_wrong_clickable.value = false;
    is_correct_clickable.value = false;
    String audioPath = "";

    if (gameWords.value[wordIndex.value].isCorrect == choice) {
      if (choice == true) {
        correctButton.value = createColor(Colors.lightGreen);
      } else {
        wrongButton.value = createColor(Colors.lightGreen);
      }
      currentButton.value = correctIcon;
      currentButton.refresh();
      totalScore.value += 1000;
      totalScore.refresh();
      audioPath = "audios/game_5/correct.mp3";
    } else {
      if (choice == true) {
        correctButton.value = Colors.redAccent;
        correctButton.refresh();
      } else {
        wrongButton.value = Colors.redAccent;
        wrongButton.refresh();
      }
      currentButton.value = wrongIcon;
      currentButton.refresh();
      totalScore.value += 500;
      totalScore.refresh();
      audioPath = "audios/game_5/wrong.mp3";
    }
    await choice_audio_player.play(AssetSource(audioPath), volume: 3);
    listenChoiceAudioPlayer(choice_audio_player);
    controlGameStatus();
    totalCoinCount.value = totalScore.value ~/ 200;
    totalCoinCount.refresh();
  }

  MaterialAccentColor createColor(MaterialColor color) {
    return MaterialAccentColor(
      color.value,
      <int, Color>{
        100: color[100]!, // Replace with the desired swatch value
        400: color[400]!,
        200: color[200]!,
        700: color[700]!,
      },
    );
  }

  void controlGameStatus() {
    if (wordIndex.value == gameWords.value.length - 1) {
      gameOver.value = true;
    }
  }

  void getNextGame() async {
    wordIndex.value++;
    correctButton.value = createColor(Colors.blue);
    wrongButton.value = Colors.deepPurpleAccent;
    currentButton.value = playButton;
    is_next_clickable.value = false;
    listenCurrentWord();
  }

  void startGame() async {
    generateWords();
    choseContent();
    totalScore.value = 0;
    totalCoinCount.value = 0;
    gameOver.value = false;
    wordIndex.value = 0;
    startTime = DateTime.now();
    listenCurrentWord();

    // Fill below
  }

  void choseContent() {
    Random random = Random();
    int index = random.nextInt(avaliableContents.length);
    var content = avaliableContents.elementAt(index);
    selectedContent = Rx(content);
  }

  Future insertGameInfo() async {
    final elapsed = DateTime.now().difference(startTime);
    await DataHelper.instance.insert(
      "GameUser",
      GameUser(
        1,
        5,
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
}
