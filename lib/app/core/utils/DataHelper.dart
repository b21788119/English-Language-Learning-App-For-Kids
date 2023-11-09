import 'package:first_app/app/core/values/queries.dart';
import 'package:first_app/app/data/models/content.dart';
import 'package:first_app/app/data/models/game_user.dart';
import 'package:first_app/app/data/models/pronunciation.dart';
import 'package:first_app/app/data/models/user.dart';
import 'package:first_app/app/data/models/category.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../data/models/word.dart';

class DataHelper {
  static final DataHelper instance = DataHelper._init();
  static Database? _database;

  DataHelper._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    String dbPath = await getDatabasesPath();
    String myDbPath = join(dbPath, "database.db");
    print(myDbPath);
    return await openDatabase(myDbPath,
        singleInstance: true, version: 1, onCreate: _onCreate);
  }

  static void _onCreate(Database db, int version) async {
    print("on create first time");
    db.execute(categoryTable);
    db.execute(wordTable);
    db.execute(gameTable);
    db.execute(userTable);
    db.execute(GameUserTable);
    db.execute(pronunciationTable);
    db.execute(contentTable);
    wordTableRows.forEach((element) {
      db.execute(element);
    });
    categoryTableRows.forEach((element) {
      db.execute(element);
    });
    gameTableRows.forEach((element) {
      db.execute(element);
    });
    userTableRows.forEach((element) {
      db.execute(element);
    });
    contentTableRows.forEach((element) {
      db.execute(element);
    });
  }

  Future<int> delete(String table, Object object) async {
    try {
      final db = await instance.database;
      int result = -1;

      switch (object.runtimeType.toString()) {
        case "Word":
          Word newWord = object as Word;
          result = await db.delete(
            table,
            where: 'wordID = ?',
            whereArgs: [newWord.wordID],
          );
          break;
        case "Category":
          Category newCategory = object as Category;
          result = await db.delete(
            table,
            where: 'ID = ?',
            whereArgs: [newCategory.ID],
          );
          break;
        default:
      }
      return result;
    } catch (e) {
      return -1;
    }
  }

  Future<int> insert(String table, Object object) async {
    final db = await instance.database;
    int result = -1;

    switch (object.runtimeType.toString()) {
      case "Word":
        Word newWord = object as Word;
        result = await db.insert(table, newWord.toJson());
        break;
      case "Category":
        Category newCategory = object as Category;
        result = await db.insert(table, newCategory.toJson());
        break;
      case "GameUser":
        GameUser newGameUser = object as GameUser;
        result = await db.insert(table, newGameUser.toJson());
        break;
      case "Pronunciation":
        Pronunciation newPronounce = object as Pronunciation;
        result = await db.insert(table, newPronounce.toJson());
        break;
      default:
    }
    return result;
  }

  Future<int> update(String table, Object object) async {
    final db = await instance.database;
    int result = -1;

    switch (object.runtimeType.toString()) {
      case "User":
        User newUser = object as User;
        result = await db.update(
          table,
          newUser.toJson(),
          where: '${newUser.userID} = ?',
          whereArgs: [newUser.userID],
        );
        break;
      case "Category":
        Category category = object as Category;
        result = await db.update(
          table,
          category.toJson(),
          where: 'ID = ?',
          whereArgs: [category.ID],
        );
        break;
      case "Word":
        Word word = object as Word;
        result = await db.update(
          table,
          word.toJson(),
          where: 'wordID = ?',
          whereArgs: [word.wordID],
        );
        break;
      case "Content":
        Content content = object as Content;
        result = await db.update(
          table,
          content.toJson(),
          where: 'ID = ?',
          whereArgs: [content.id],
        );
        break;
      default:
    }
    return result;
  }

  Future<List<Map<String, dynamic>>> getAllNotDeleted(String table) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query(table, where: "IsDeleted = 0");
    return maps;
  }

  Future<List<Map<String, dynamic>>> getAllWithFilter(
      String table, String where) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table, where: where);
    return maps;
  }

  Future<List<Map<String, dynamic>>> getAll(String table) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    return maps;
  }

  Future<void> insertAll(String table, List<Map<String, dynamic>> maps) async {
    try {
      final db = await instance.database;
      maps.forEach((element) async {
        await db.insert(table, element);
      });
    } catch (e, s) {
      print(e);
    }
  }
}

/*
if(table == "Word")
      {
        final List<Map<String, dynamic>> maps = await _database!.query('Word');
        List<Word> words = List.generate(maps.length, (i) {
          return Word.fromJson(maps[i]);
        });
        return words;
      }
      else if(table == "Category")
      {
        final List<Map<String, dynamic>> maps = await _database!.query('Category');
        List<Category> words = List.generate(maps.length, (i) {
          return Cate.fromJson(maps[i]);
        });
        return words;

      }

*/