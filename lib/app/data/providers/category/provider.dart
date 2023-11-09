import 'package:first_app/app/core/utils/DataHelper.dart';
import 'package:first_app/app/data/models/category.dart';

class CategoryProvider {
  Future<List<Category>> readCategories() async {
    final List<Map<String, dynamic>> categoryMaps =
        await DataHelper.instance.getAllNotDeleted("Category");
    final List<Map<String, dynamic>> wordMaps =
        await DataHelper.instance.getAllNotDeleted("Word");
    List<Category> categories = List.generate(categoryMaps.length, (i) {
      return Category.fromJson(categoryMaps[i]);
    });
    return categories;
  }

  void writeCategories(List<Category> categories) {
    List<Map<String, dynamic>> maps = [];

    categories.forEach((element) {
      maps.add(element.toJson());
    });
    DataHelper.instance.insertAll("Category", maps);
  }
}
