import 'package:jawhara/core/api/common.dart';
import 'package:jawhara/model/products/product.dart';
import 'package:jawhara/model/products/products.dart';
import 'package:jawhara/model/products/selected_filter.dart';
import '../view/index.dart';

class ProductsViewModel extends BaseViewModel {
  ProductsViewModel();

  CommonApi _api = CommonApi();
  List<Product> products = List();
  List<AvailableFilter> availableFilter;
  List<SelectedFilter> selectedFilters;
  RangeValues values;
  int cacheCategoryId;
  List<AvailableFilter> cacheFilter = List();
  Products _products = Products();
  bool isLastPage = false;
  String noMoreDataMessage;
  int page = 1;
  List<SelectedFilterItem> selectedFiltersItems = [];

  // init Categories data
  initScreen(context, {int id, bool isLoadMore = false, pageInit = 1, firstTime = true}) async {
    if (id != null) cacheCategoryId = id;
    if (firstTime) selectedFiltersItems = [];
    print('### Init ${this.runtimeType} ###');
    setBusy(true);
    if (!isLoadMore) page = pageInit;
    final r = await _api.getProductsData(context, cacheCategoryId, filterItems: selectedFiltersItems, page: page);
    if (r != null) {
      print('before > ${products.length}');

      if (isLoadMore) {
        r.dataProducts.forEach((newElement) {
          products.add(newElement);
        });
      } else {
        products = r.dataProducts;
        page = 2;
      }

      // selectedFilters = r.selectedFilters;
      if (r.availablefilter != null) {
        availableFilter = r.availablefilter;
        double _from;
        double _to;
        r.selectedFilters.forEach((element) {
          element.filters.forEach((e) {
            if (e.conditionType == 'from') {
              _from = double.parse(e.value);
            }
            if (e.conditionType == 'to') {
              _to = double.parse(e.value);
            }
          });
        });
        availableFilter.forEach((e) {
          if (e.filterCode == 'price') {
            values =
                RangeValues((_from ?? double.tryParse(e.filterRangeMin.toString())), (_to ?? double.tryParse(e.filterRangeMax.toString())));
          }
        });
      }
      print('[Product count > ${products.length}]');

      // print(page);
      print(products.length);
      if (r.dataProducts.isEmpty || r.dataProducts.length % 10 != 0) {
        isLastPage = true;
        noMoreDataMessage = translate('no_more_data');
      } else {
        noMoreDataMessage = translate('loading');
      }

      if (isLoadMore) page++;

      notifyListeners();
    }
    setBusy(false);
  }

  reCallInit(context, {loadMore = false}) async {
    await Future.delayed(Duration(seconds: 1), () {
      initScreen(context, firstTime: false, isLoadMore: loadMore);
    });
  }

  clearSelectedFilters() {
    selectedFiltersItems = [];
    notifyListeners();
  }

  checkSelected(AvailableFilter field, FilterOption value) {
    try {
      final check = selectedFiltersItems.firstWhere(
          (SelectedFilterItem element) =>
              element.values.firstWhere((FilterOption e) => e.value == value.value, orElse: () => null) != null &&
              element.field?.filterName == field.filterName,
          orElse: () => null);
      if (check != null) {
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      return false;
    }
  }

  updatePrice(RangeValues v) {
    values = v;
    bool found = false;
    for (SelectedFilterItem sfi in selectedFiltersItems) {
      if (sfi.price) {
        sfi.rangeValue = v;
        found = true;
        break;
      }
    }
    if (!found) {
      selectedFiltersItems.add(SelectedFilterItem(price: true, rangeValue: v, field: AvailableFilter(filterCode: "price")));
    }
    notifyListeners();
  }

  addToSelectedFilters({AvailableFilter field, FilterOption value, RangeValues rangeValue, bool price = false}) {
    bool found = false;
    for (SelectedFilterItem sfi in selectedFiltersItems) {
      if (sfi.field.filterName == field.filterName) {
        sfi.values.add(value);
        found = true;
        break;
      }
    }
    if (!found) {
      selectedFiltersItems.add(SelectedFilterItem(field: field, values: [value], rangeValue: rangeValue, price: price));
    }
    notifyListeners();
  }

  removeFromSelectedFilters(AvailableFilter field, FilterOption value) {
    for (SelectedFilterItem sfi in selectedFiltersItems) {
      if (sfi.field.filterName == field.filterName) {
        for (FilterOption fo in sfi.values) {
          if (fo.value == value.value) {
            sfi.values.remove(fo);
            if (sfi.values.isEmpty) {
              selectedFiltersItems.remove(sfi);
            }
            break;
          }
        }
        break;
      }
    }
    notifyListeners();
  }
}
