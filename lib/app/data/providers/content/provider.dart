import 'package:first_app/app/core/utils/DataHelper.dart';
import 'package:first_app/app/data/models/content.dart';

class ContentProvider {
  Future<List<Content>> readContents() async {
    final List<Map<String, dynamic>> contentMaps =
        await DataHelper.instance.getAll("Content");
    List<Content> contents = List.generate(contentMaps.length, (i) {
      return Content.fromJson(contentMaps[i]);
    });
    return contents;
  }

  void writeContents(List<Content> contents) {
    List<Map<String, dynamic>> maps = [];

    contents.forEach((element) {
      maps.add(element.toJson());
    });
    DataHelper.instance.insertAll("Content", maps);
  }

  void updateContent(Content content) {
    DataHelper.instance.update("Content", content);
  }
}
