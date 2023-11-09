import 'package:first_app/app/data/models/game.dart';
import 'package:first_app/app/data/models/game_user.dart';
import 'package:first_app/app/data/providers/game/provider.dart';

class GameRepository {
  GameProvider gameProvider;

  GameRepository({
    required this.gameProvider,
  });

  Future<List<Game>> readGames() async {
    List<Game> games = await gameProvider.readGames();
    return games;
  }

  Future<List<GameUser>> readGameStats(int gameID) async {
    List<GameUser> games = await gameProvider.readGameStats(gameID);
    return games;
  }
}
