import 'package:jawhara/core/api/common.dart';
import 'package:jawhara/model/categories/categories_model.dart';
import 'package:jawhara/model/home/home.dart';
import 'package:jawhara/model/products/products.dart';
import 'package:jawhara/model/products/product.dart' as p;
import '../view/index.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel();

  CommonApi _api = CommonApi();
  Categories categories = Categories();
  Products products;
  Home home;
  HomeDatum sliderData,
      categoryButtonData,
      categoryBannerData,
      categoryBotSlider,
      categorySquareData,
      categoryCircleData,
      categoryTopData,
      categoryBottomData;
  int currentIndex = 0;

  List<CategoriesChildrenDatum> _catArray;

  List<CategoriesChildrenDatum> get catArray => _catArray;

  // TabController tabController;

  // init Categories data
  initScreen(context, {t, bool withHome = true}) async {
    categories = Categories();
    print('### Init ${this.runtimeType} ###');
    setBusy(true);
    final r = await _api.getCategoriesData(context);
    categories = r;
    _catArray = r.childrenData;
    // print(_catArray[0].toJson());
    // _catArray.removeAt(0);
    // Add <Home Tab> to another tabs
    CategoriesChildrenDatum _d = CategoriesChildrenDatum();
    categories.childrenData.insert(0, _d.copyWith(id: 0, name: 'home', childrenData: [], image: null));

    setBusy(false);
    // Call home screen
    await initHomeScreen(context);
  }

  // init Home data
  initHomeScreen(context) async {
    print('### Init home ${this.runtimeType} ###');
    setBusy(true);
    final r = await _api.getHomeData(context);
    home = r;
    sliderData = home.data.firstWhere((element) => element.blockType == 'home_slider', orElse: () => null);
    categoryButtonData = home.data.firstWhere((element) => element.blockType == 'category_buttons', orElse: () => null);
    categoryBannerData = home.data.firstWhere((element) => element.blockType == 'category_slider', orElse: () => null);
    categoryBotSlider = home.data.firstWhere((element) => element.blockType == 'category_bot_slider', orElse: () => null);
    categorySquareData = home.data.firstWhere((element) => element.blockType == 'category_square', orElse: () => null);
    categoryCircleData = home.data.firstWhere((element) => element.blockType == 'category_circle', orElse: () => null);
    categoryTopData = home.data.firstWhere((element) => element.blockType == 'category_product_top', orElse: () => null);
    categoryBottomData = home.data.firstWhere((element) => element.blockType == 'category_product_bottom', orElse: () => null);
    // print('categoryBannerData > ${categoryBannerData.toJson()}');
    setBusy(false);
  }

  pushToProducts(context, CategoriesChildrenDatum element, int indexForChildrenCategory) {
    final check = element.childrenData.firstWhere((element) => element.childrenData.isNotEmpty, orElse: () => null);
    if (check != null) {
      print('indexForChildrenCategory => $indexForChildrenCategory');
      return Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: CategoriesPage(
            element.childrenData,
            index: indexForChildrenCategory,
          ),
        ),
      );
    } else {
      print('eleel');
      return Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: ProductsPage(
            element.childrenData,
            index: indexForChildrenCategory,
          ),
        ),
      );
    }
  }

  spiderFunction(
    context,
    int id,
    String level,
    String parentId,
  ) {
    print('id -> $id');
    print('level -> $level');
    print('parentId -> $parentId');
    if (id == 0 && level == '0' && parentId == '0') {
      return handleTabSelection(0);
    }
    categories.childrenData.forEach((element) {
      // Level 2
      if ((element.level?.toString() ?? null) == level) {
        if (element.id == id) {
          final indexForCategory = categories.childrenData.indexWhere((e) => e.id == id);
          handleTabSelection(indexForCategory);
        }
      }
      // Level 3 & 4
      else {
        element.childrenData.forEach((element) {
          // Level 3
          if (element.level.toString() == level) {
            if (element.id == id) {
              pushToProducts(context, element, 0);
            }
          } else {
            // Level 4
            if (element.id.toString() == parentId) {
              final indexForChildrenCategory = element.childrenData.indexWhere((e) => e.id == id);
              print(indexForChildrenCategory);
              print('leve 4');
              if (indexForChildrenCategory >= 0) {
                pushToProducts(context, element, indexForChildrenCategory);
              }
            }
          }
        });
      }
    });
  }

  handleTabSelection(index) {
    print('handleTabSelection $index');
    tabController.animateTo(index);
    tabController.index = index;
    notifyListeners();
  }

  // Check if product expire or not
  bool checkExpire(p.Product p) {
    bool specialExpire = p.specialFromDate != null ? !p.specialFromDate.isAfter(DateTime.now()) : false;
    return specialExpire;
    // return false;
  }

  // Check if product have sale
  String initSale(p.Product p) {
    if (checkExpire(p)) {
      var sale = ((double.parse(p.price) - double.parse(p.specialPrice)) / double.parse(p.price)) * 100;
      // print(sale);
      return sale.toStringAsFixed(0);
    } else {
      return '';
    }
  }
}
