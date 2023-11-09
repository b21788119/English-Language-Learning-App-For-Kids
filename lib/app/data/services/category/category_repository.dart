import 'package:first_app/app/data/models/word.dart';
import 'package:first_app/app/data/models/category.dart';
import 'package:first_app/app/data/providers/category/provider.dart';
import 'package:first_app/app/data/providers/word/provider.dart';

class CategoryRepository {
  CategoryProvider categoryProvider;
  WordProvider wordProvider;

  CategoryRepository({
    required this.categoryProvider,
    required this.wordProvider,
  });

  Future<List<Category>> readCategories() async {
    List<Category> categories = await categoryProvider.readCategories();
    List<Word> allWords = await wordProvider.readWords();
    categories.forEach((element) {
      List<Word> categoryWords = [];
      int categoryID = element.ID;
      allWords.forEach((element) {
        element.moduleID == categoryID ? categoryWords.add(element) : {};
      });
      element.words = categoryWords;
    });
    return categories;
  }

  void writeCategories(List<Category> categories) =>
      categoryProvider.writeCategories(categories);
}
