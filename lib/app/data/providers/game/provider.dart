import 'package:first_app/app/core/utils/DataHelper.dart';
import 'package:first_app/app/data/models/game.dart';
import 'package:first_app/app/data/models/game_user.dart';

class GameProvider {
  Future<List<Game>> readGames() async {
    final List<Map<String, dynamic>> gameMaps =
        await DataHelper.instance.getAll("Game");

    List<Game> games = List.generate(gameMaps.length, (i) {
      return Game.fromJson(gameMaps[i]);
    });
    return games;
  }

  Future<List<GameUser>> readGameStats(int gameID) async {
    final List<Map<String, dynamic>> gameMaps = await DataHelper.instance
        .getAllWithFilter("GameUser", "GameID = $gameID");

    List<GameUser> games = List.generate(gameMaps.length, (i) {
      return GameUser.fromJson(gameMaps[i]);
    });
    return games;
  }
}
