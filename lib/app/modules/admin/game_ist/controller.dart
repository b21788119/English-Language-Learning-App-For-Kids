import 'package:first_app/app/data/models/game.dart';
import 'package:first_app/app/data/models/game_user.dart';
import 'package:first_app/app/data/services/game/game_repository.dart';
import 'package:get/get.dart';

class GameStatController extends GetxController {
  GameRepository gameRepository;
  GameStatController({
    required this.gameRepository,
  });

  final games = <Game>[].obs;
  final gameStats = <GameUser>[].obs;
  final chosenGameInedx = 0.obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    List<Game> data = await gameRepository.readGames();
    games.assignAll(data);
  }

  Future chooseGame(int gameID) async {
    List<GameUser> data = await gameRepository.readGameStats(gameID);
    gameStats.assignAll(data);
    chosenGameInedx.value =
        games.indexWhere((element) => element.gameID == gameID);
  }
}
