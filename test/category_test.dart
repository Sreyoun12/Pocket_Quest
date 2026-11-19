import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_quest/service/category_service.dart';

void main() {
  late CategoryService service;

  setUp(() {
    service = CategoryService();
  });

  group('Add Category', () {
    test('should add a category', () {
      service.addCategory(
        categoryId: 1,
        categoryName: 'Food',
      );

      expect(service.viewAllCategories().length, 1);
      expect(service.viewAllCategories().first.name, 'Food');
    });

    test('should not add a duplicate category ID', () {
      service.addCategory(
        categoryId: 1,
        categoryName: 'Food',
      );

      expect(
        () => service.addCategory(
          categoryId: 1,
          categoryName: 'Travel',
        ),
        throwsException,
      );
    });

    test('should not add an empty category name', () {
      expect(
        () => service.addCategory(
          categoryId: 1,
          categoryName: '',
        ),
        throwsException,
      );
    });

    test('should not add a category name with only spaces', () {
      expect(
        () => service.addCategory(
          categoryId: 1,
          categoryName: '   ',
        ),
        throwsException,
      );
    });
  });

  group('Update Category', () {
    test('should update a category name', () {
      service.addCategory(
        categoryId: 1,
        categoryName: 'Food',
      );

      service.updateCategory(
        categoryId: 1,
        newCategoryName: 'Restaurant',
      );

      expect(service.viewAllCategories().first.name, 'Restaurant');
    });

    test('should not update a category that does not exist', () {
      expect(
        () => service.updateCategory(
          categoryId: 99,
          newCategoryName: 'Travel',
        ),
        throwsException,
      );
    });

    test('should not update with an empty name', () {
      service.addCategory(
        categoryId: 1,
        categoryName: 'Food',
      );

      expect(
        () => service.updateCategory(
          categoryId: 1,
          newCategoryName: '',
        ),
        throwsException,
      );
    });
  });

  group('Remove Category', () {
    test('should remove a category', () {
      service.addCategory(
        categoryId: 1,
        categoryName: 'Food',
      );

      service.removeCategory(categoryId: 1);

      expect(service.viewAllCategories(), isEmpty);
    });

    test('should not remove a category that does not exist', () {
      expect(
        () => service.removeCategory(categoryId: 99),
        throwsException,
      );
    });
  });

  group('View Categories', () {
    test('should return all categories', () {
      service.addCategory(
        categoryId: 1,
        categoryName: 'Food',
      );

      service.addCategory(
        categoryId: 2,
        categoryName: 'Travel',
      );

      expect(service.viewAllCategories().length, 2);
    });

    test('should return an empty list when there are no categories', () {
      expect(service.viewAllCategories(), isEmpty);
    });
  });
}