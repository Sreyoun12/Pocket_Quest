import '../model/category.dart';

class CategoryService {
  final List<Category> categories = [];

  //add category
  void addCategory({
    required int categoryId,
    required String categoryName,
  }) {
    Category? category = _findCategoryOrNull(categoryId);
    if (category != null) {
      throw Exception("Category $categoryId already exists");
    }
    if (categoryName.trim().isEmpty) {
      throw Exception("Category name cannot be empty");
    }
    categories.add(
      Category(id: categoryId, name: categoryName),
    );
  }

  //remove category
  void removeCategory({required int categoryId}) {
    Category? category = _findCategoryOrNull(categoryId);
    if (category == null) {
      throw Exception("Category $categoryId not found");
    }
    categories.remove(category);
  }

  //update category
  void updateCategory({
    required int categoryId,
    required String newCategoryName,
  }) {
    Category? category = _findCategoryOrNull(categoryId);
    if (category == null) {
      throw Exception("Category $categoryId not found");
    }
    if (newCategoryName.trim().isEmpty) {
      throw Exception("Category name cannot be empty");
    }
    category.name = newCategoryName;
  }

  //view all categories
  List<Category> viewAllCategories() {
    return categories;
  }

  //helper method - Find category
  Category? _findCategoryOrNull(int categoryId) {
    for (Category c in categories) {
      if (c.id == categoryId) {
        return c;
      }
    }
    return null;
  }
}