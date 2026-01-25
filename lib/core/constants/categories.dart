import '../models/category_model.dart';
import 'app_colors.dart';

class AppCategories {
  AppCategories._();

  static const List<CategoryModel> all = [
    CategoryModel(
      id: 'classic',
      name: 'Classic Pack',
      description: 'The perfect starter to kick off any gathering!',
      iconPath: 'assets/images/categories/classic.svg',
      color: AppColors.categoryClassic,
      isFree: true,
    ),
    CategoryModel(
      id: 'party',
      name: 'Party Pack',
      description: 'Energize your celebration with exciting challenges!',
      iconPath: 'assets/images/categories/party.svg',
      color: AppColors.categoryParty,
      isFree: false,
    ),
    CategoryModel(
      id: 'girls',
      name: 'Girls 18+',
      description: 'Bold and daring questions for a girls night out!',
      iconPath: 'assets/images/categories/girls.svg',
      color: AppColors.categoryGirls,
      isFree: false,
    ),
    CategoryModel(
      id: 'couples',
      name: 'Couples Pack',
      description: 'Connect with your partner like never before!',
      iconPath: 'assets/images/categories/couples.svg',
      color: AppColors.categoryCouples,
      isFree: false,
    ),
    CategoryModel(
      id: 'hot',
      name: 'Hot Questions 18+',
      description: 'Turn up the heat with spicy questions!',
      iconPath: 'assets/images/categories/hot.svg',
      color: AppColors.categoryHot,
      isFree: false,
    ),
    CategoryModel(
      id: 'guys',
      name: 'Guys Pack',
      description: 'Epic challenges designed for the bros!',
      iconPath: 'assets/images/categories/guys.svg',
      color: AppColors.categoryGuys,
      isFree: false,
    ),
  ];

  static CategoryModel getById(String id) {
    return all.firstWhere((category) => category.id == id);
  }

  static List<CategoryModel> getFreeCategories() {
    return all.where((category) => category.isFree).toList();
  }

  static List<CategoryModel> getPremiumCategories() {
    return all.where((category) => !category.isFree).toList();
  }
}
