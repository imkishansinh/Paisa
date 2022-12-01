import 'package:flutter_paisa/src/domain/category/repository/category_repository.dart';

class DeleteCategoryUseCase {
  final CategoryRepository categoryRepository;

  DeleteCategoryUseCase({required this.categoryRepository});

  Future<void> execute(int key) => categoryRepository.deleteCategory(key);
}
