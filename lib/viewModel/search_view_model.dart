import 'package:jawhara/core/api/common.dart';
import 'package:jawhara/model/search/search_item.dart';
import 'package:jawhara/model/search/search_product_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../view/index.dart';

class SearchViewModel extends BaseViewModel {
  CommonApi _api = CommonApi();
  List<SearchProdItem> items;
  List<SuggestItem> suggestItems;
  List<RelatedSearchItem> relatedSearchItems;

  List<String> recentSearch;

  SearchViewModel() {
    getRecentSearch();
  }

  // search item data
  searchItem(context, String text) async {
    print('### Init ${this.runtimeType} ###');
    if (text != '' || text.length != 0) {
      setBusy(true);
      final r = await _api.getSearchItem(context, text);
      if (r != null && r.items != null && r.items.isNotEmpty) {
        print(r.totalCount);
        suggestItems = r.suggestItems;
        relatedSearchItems = r.relatedSearchItems;
        final result = await _api.getSearchProductItem(
            context, r.items.length > 15 ? r.items.sublist(0, 15) : r.items);
        if (result != null) {
          items = result.items;
          saveSearch(text);
          print(result.totalCount);
        }
      } else {
        items = [];
        if(r != null && r.suggestItems != null && r.suggestItems.isNotEmpty){
          suggestItems = r.suggestItems;
        }else{
          suggestItems = [];
        }
        if(r != null && r.relatedSearchItems != null && r.relatedSearchItems.isNotEmpty){
          relatedSearchItems = r.relatedSearchItems;
        }else{
          relatedSearchItems = [];
        }
      }
      setBusy(false);
    }
  }

  initScreen() {
    items = null;
    getRecentSearch();
    notifyListeners();
  }

  Future<List<String>> getRecentSearch() async {
    print('getFromCache');
    SharedPreferences _pref = await SharedPreferences.getInstance();
    recentSearch = _pref.getStringList("searchWords")?.reversed?.toList();
    notifyListeners();
    return recentSearch;
  }

  saveSearch(String searchWord) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    List<String> recentSearch = _pref.get("searchWords") ?? [];
    if (!recentSearch.contains(searchWord)) recentSearch.add(searchWord);
    _pref.setStringList("searchWords", recentSearch);
    getRecentSearch();
  }

  clearSearchHistory() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.remove("searchWords");
    recentSearch = null;
    notifyListeners();
  }
}
