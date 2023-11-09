import 'package:first_app/app/core/utils/DataHelper.dart';
import 'package:first_app/app/data/services/category/category_repository.dart';
import 'package:first_app/app/widgets/file_operations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:first_app/app/data/models/category.dart';

class CategoryController extends GetxController {
  CategoryRepository categoryRepository;

  CategoryController({
    required this.categoryRepository,
  });

  final categories = <Category>[].obs;
  final fromKey = GlobalKey<FormState>();
  final editController = TextEditingController();
  final chipIndex = 0.obs;
  final deleting = false.obs;
  final selectedCategory = Rx<Category?>(null);

  final mapIndex = 0.obs;
  final mapList = <String>[];
  final categoryListForMap = <Category>[].obs;

  // adding new category store the data in here
  final selectedCategoryImageFilePath = Rx<String?>(null);

  @override
  void onInit() async {
    super.onInit();
    List<Category> data = await categoryRepository.readCategories();
    categories.assignAll(data);
    //ever(categories, (_) => categoryRepository.writeCategories(categories));

    // this is for Maps slider in the category Map
    for (var i = 0; i < categories.length / 12; i++) {
      mapList.add("Map ${i + 1}");
    }
    changeMap();
  }

  @override
  void onClose() {
    editController.dispose();
    super.onClose();
  }

  void changeMap() {
    categoryListForMap.value = categories.skip(12 * mapIndex.value).toList();
    categoryListForMap.value =
        categoryListForMap.where((p0) => p0.words.isNotEmpty).take(12).toList();
  }

  // yeni kategori ekleme
  Future<bool> insertCategory() async {
    final categoryName = editController.text;
    var nameCheck = categories.any(
      (element) => element.name.toLowerCase() == categoryName.toLowerCase(),
    );

    if (nameCheck) {
      return false;
    }

    var imagePath = await saveFilePermenantAndGetThePath(
        selectedCategoryImageFilePath.value,
        recordName: categoryName);
    if (imagePath == null) {
      return false;
    }

    Category category = Category.withoutSettings(categoryName, imagePath);

    final result = await DataHelper.instance.insert("Category", category);
    if (result == 0) {
      deleteFile(imagePath);
      return false;
    }
    categories.value = await categoryRepository.readCategories();
    return true;
  }

  // kategori sil
  Future<int> deleteCategory(Category category) async {
    category.isDeleted = true;
    final result = await DataHelper.instance.update("Category", category);
    if (result == 0) {
      return -1;
    }
    categories.remove(category);

    // delete the category image from the device
    if (category.isNew) {
      deleteFile(category.pictureSrc);

      // delete category words images and voice data
      for (var word in category.words) {
        //deleteImage(word.pictureSrc);
        //deleteVoice(word.audioSrc);
      }
    }
    return 1;
  }

  // sürükle bırak ile categori silerken kullanılır
  void changeDeleting(bool value) {
    deleting.value = value;
  }

  // kategori seçme işleminden sonra seçilenin tutulması
  void changeSelectedCategory(Category? category) {
    selectedCategory.value = category;
  }

  // yeni kelime ekleme önceden seçilmiş olan kategoriye
  bool addWord(String title) {
    return true;
  }

  // kategorilerin başlıklarını çekmek için
  List<String> getCategoryTitles() {
    List<String> result = [];
    for (Category category in categories) {
      result.add(category.name);
    }
    return result;
  }
}
