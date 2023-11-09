import 'package:first_app/app/data/models/content.dart';
import 'package:first_app/app/data/providers/content/provider.dart';

class ContentRepository {
  ContentProvider contentProvider;

  ContentRepository({
    required this.contentProvider,
  });

  Future<List<Content>> readContents() async {
    List<Content> contents = await contentProvider.readContents();
    return contents;
  }

  void writeContents(List<Content> contents) =>
      contentProvider.writeContents(contents);

  void updateContent(Content content) => contentProvider.updateContent(content);
}
