import '../models/category_model.dart';
import '../../l10n/app_localizations.dart';
import 'app_colors.dart';

class AppCategories {
  AppCategories._();

  static const List<CategoryModel> all = [
    CategoryModel(
      id: 'classic',
      iconPath: 'assets/images/categories/classic.svg',
      color: AppColors.categoryClassic,
      isFree: true,
    ),
    CategoryModel(
      id: 'party',
      iconPath: 'assets/images/categories/party.svg',
      color: AppColors.categoryParty,
      isFree: false,
    ),
    CategoryModel(
      id: 'girls',
      iconPath: 'assets/images/categories/girls.svg',
      color: AppColors.categoryGirls,
      isFree: false,
    ),
    CategoryModel(
      id: 'couples',
      iconPath: 'assets/images/categories/couples.svg',
      color: AppColors.categoryCouples,
      isFree: false,
    ),
    CategoryModel(
      id: 'hot',
      iconPath: 'assets/images/categories/hot.svg',
      color: AppColors.categoryHot,
      isFree: false,
    ),
    CategoryModel(
      id: 'guys',
      iconPath: 'assets/images/categories/guys.svg',
      color: AppColors.categoryGuys,
      isFree: false,
    ),
  ];

  static CategoryModel getById(String id) {
    return all.firstWhere((category) => category.id == id);
  }

  static String localizedName(AppLocalizations t, String id) {
    switch (id) {
      case 'classic':
        return t.category_classic_name;
      case 'party':
        return t.category_party_name;
      case 'girls':
        return t.category_girls_name;
      case 'couples':
        return t.category_couples_name;
      case 'hot':
        return t.category_hot_name;
      case 'guys':
        return t.category_guys_name;
      default:
        return t.category_classic_name;
    }
  }

  static String localizedDescription(AppLocalizations t, String id) {
    switch (id) {
      case 'classic':
        return t.category_classic_desc;
      case 'party':
        return t.category_party_desc;
      case 'girls':
        return t.category_girls_desc;
      case 'couples':
        return t.category_couples_desc;
      case 'hot':
        return t.category_hot_desc;
      case 'guys':
        return t.category_guys_desc;
      default:
        return t.category_classic_desc;
    }
  }

  static List<CategoryModel> getFreeCategories() {
    return all.where((category) => category.isFree).toList();
  }

  static List<CategoryModel> getPremiumCategories() {
    return all.where((category) => !category.isFree).toList();
  }
}
