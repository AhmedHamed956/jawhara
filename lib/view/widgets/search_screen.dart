import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jawhara/model/products/product.dart';
import 'package:jawhara/view/ui/details/gift_details.dart';
import 'package:jawhara/viewModel/search_view_model.dart';
import 'package:jawhara/viewModel/wishList_view_model.dart';
import 'package:provider/provider.dart';

import '../index.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen();

  @override
  _SearchScreenState createState() => new _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _searchQuery;
  bool _isSearching = true;
  String searchQuery = "Search query";
  bool gridview = true;

  @override
  void initState() {
    super.initState();
    _searchQuery = TextEditingController();
  }

  void _startSearch() {
    print("open search box");
    ModalRoute.of(context).addLocalHistoryEntry(new LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    print("close search box");
    setState(() {
      _searchQuery.clear();
      updateSearchQuery("Search query");
    });
  }

  Widget _buildTitle(BuildContext context) {
    var horizontalTitleAlignment = Platform.isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    return new InkWell(
      onTap: () => scaffoldKey.currentState.openDrawer(),
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: horizontalTitleAlignment,
          children: <Widget>[
            const Text('Seach box'),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return new TextField(
      controller: _searchQuery,
      autofocus: true,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: translate("searchNow"),
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.grey),
      ),
      style: const TextStyle(color: Colors.black, fontSize: 16.0),
      onSubmitted: (value) => locator<SearchViewModel>().searchItem(context, value),
    );
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
    print("search query " + newQuery);
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        new IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQuery == null || _searchQuery.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      new IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    double kHeight = MediaQuery.of(context).size.height / 2;
    double kWidth = MediaQuery.of(context).size.width / 2;
    final connection = Provider.of<ConnectivityStatus>(context);

    return ViewModelBuilder<SearchViewModel>.reactive(
      viewModelBuilder: () => locator<SearchViewModel>(),
      disposeViewModel: false,
      onModelReady: (model) => model.initScreen(),
      builder: (context, model, child) {
        // if (model.isBusy) return Center(child: Text(translate('loading')));
        // if (model.cart.items == null) return Center(child: Text(translate('empty_data')));
        // if (model.cart.items.isEmpty) return Center(child: Text(translate('empty_data')));

        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            leading: _isSearching ? const BackButton() : null,
            title: _isSearching ? _buildSearchField() : _buildTitle(context),
            actions: _buildActions(),
          ),
          body: connection == ConnectivityStatus.Offline
              ? NoInternetWidget(retryFunc: () => model.initScreen())
              : ListView(
                  children: [
                    if (model.recentSearch != null && model.recentSearch.isNotEmpty)
                      Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Text(translate("searchHistory")),
                              Expanded(
                                child: Container(),
                              ),
                              IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.trashAlt,
                                    size: 14,
                                  ),
                                  onPressed: () {
                                    model.clearSearchHistory();
                                  })
                            ],
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            margin: EdgeInsets.only(bottom: 10),
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              spacing: 8,
                              children: (model.recentSearch.length > 8 ? model.recentSearch.sublist(0, 8) : model.recentSearch).map((item) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      _searchQuery = TextEditingController(text: item);
                                    });
                                    locator<SearchViewModel>().searchItem(context, item);
                                  },
                                  child: Chip(
                                    label: Text(item),
                                    deleteIcon: Icon(
                                      Icons.search,
                                      size: 14,
                                    ),
                                    backgroundColor: Colors.grey.withOpacity(0.3),
                                    onDeleted: () => null,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    //Suggested items
                    (!model.isBusy && model.suggestItems != null && model.suggestItems.isNotEmpty)
                        ? Container(
                            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                            margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
                            width: MediaQuery.of(context).size.width,
                            color: (model.items == null || model.items.isEmpty) ? Color(0xfffdf0d5) : Color(0xfff4f4f4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (model.items == null || model.items.isEmpty)
                                  Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.warning,
                                          color: Color(0xffc07600),
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          translate('yourSearchReturnedNoResult'),
                                        ),
                                      ],
                                    ),
                                  ),
                                Text(
                                  translate('didYouMean'),
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: (model.items == null || model.items.isEmpty) ? Color(0xff6f4400) : Color(0xff777777)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                                  child: Wrap(
                                    alignment: WrapAlignment.start,
                                    crossAxisAlignment: WrapCrossAlignment.start,
                                    spacing: 8,
                                    children: model.suggestItems.map((item) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            _searchQuery = TextEditingController(text: item.queryText);
                                          });
                                          locator<SearchViewModel>().searchItem(context, item.queryText);
                                        },
                                        child: Text(
                                          item.queryText,
                                          style: TextStyle(
                                              decoration: TextDecoration.underline,
                                              color: (model.items == null || model.items.isEmpty) ? Color(0xff0088cc) : null),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),

                    //Related items
                    (!model.isBusy && model.relatedSearchItems != null && model.relatedSearchItems.isNotEmpty)
                        ? Container(
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
                            color: Color(0xfff4f4f4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  translate('relatedSearchTerms'),
                                  style: TextStyle(fontSize: 12, color: Color(0xff777777), fontWeight: FontWeight.w700),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: model.relatedSearchItems.map((item) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            _searchQuery = TextEditingController(text: item.queryText);
                                          });
                                          locator<SearchViewModel>().searchItem(context, item.queryText);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: 5),
                                          child: Text(
                                            item.queryText,
                                            style:
                                                TextStyle(color: (model.items == null || model.items.isEmpty) ? Color(0xff0088cc) : null),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    model.isBusy
                        ? Container(height: MediaQuery.of(context).size.height / 2, child: Center(child: Text(translate('loading'))))
                        : model.items == null
                            ? Container()
                            : model.items.isEmpty
                                ? Container()
                                : Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Column(
                                      children: [
                                        Align(
                                            alignment: AlignmentDirectional.centerEnd,
                                            child: Container(
                                              margin: EdgeInsetsDirectional.only(end: 10),
                                              child: IconButton(
                                                icon: Icon(gridview ? Icons.list : Icons.grid_view),
                                                onPressed: () {
                                                  setState(() {
                                                    gridview = !gridview;
                                                  });
                                                },
                                              ),
                                            )),
                                        gridview
                                            ? ListView(
                                                shrinkWrap: true,
                                                physics: NeverScrollableScrollPhysics(),
                                                children: [
                                                  Wrap(
                                                      runSpacing: 4,
                                                      spacing: 4,
                                                      alignment: WrapAlignment.start,
                                                      children: model.items
                                                          .map((e) => Container(
                                                              height: kHeight,
                                                              width: kWidth - 5,
                                                              alignment: Alignment.center,
                                                              color: Colors.white,
                                                              child: ProductScreen(
                                                                direction: Axis.vertical,
                                                                product: e.toProduct(),
                                                              )))
                                                          .toList()),
                                                ],
                                              )
                                            : ListView(
                                                shrinkWrap: true,
                                                physics: NeverScrollableScrollPhysics(),
                                                children: model.items
                                                    .map((e) => Column(
                                                          children: [
                                                            ListTile(
                                                              leading: Stack(
                                                                children: [
                                                                  Container(
                                                                      child: Hero(
                                                                    tag: e.sku,
                                                                    child: Image.network(
                                                                      Strings.MAIN_URL +
                                                                              Strings.MEDIA_PRODUCT +
                                                                              e.mediaGalleryEntries[0].file ??
                                                                          Strings.Image_URL,
                                                                      fit: BoxFit.contain,
                                                                      errorBuilder: (context, error, stackTrace) => Image.asset(
                                                                        'assets/images/placeholder.png',
                                                                        fit: BoxFit.cover,
                                                                      ),
                                                                    ),
                                                                  )),
                                                                ],
                                                              ),
                                                              title: Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      e.name.toString(),
                                                                      maxLines: 2,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      style: TextStyle(
                                                                        fontSize: 12,
                                                                        color: const Color(0xff1d1f22),
                                                                      ),
                                                                      textAlign: TextAlign.start,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                          double.parse(e.price.toString()).toStringAsFixed(2) +
                                                                              ' ' +
                                                                              SharedData.currency,
                                                                          style: TextStyle(
                                                                              fontSize: 12,
                                                                              fontFamily: FontFamily.cairo,
                                                                              decorationThickness: 4,
                                                                              color: AppColors.secondaryColor),
                                                                          textAlign: TextAlign.start,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                ),
                                                              ),
                                                              trailing: ViewModelBuilder<WishListViewModel>.reactive(
                                                                viewModelBuilder: () => locator<WishListViewModel>(),
                                                                disposeViewModel: false,
                                                                builder: (context, model, child) => ClipOval(
                                                                  child: Material(
                                                                    color: Colors.white, // button color
                                                                    child: InkWell(
                                                                      child: SizedBox(
                                                                          width: 25,
                                                                          height: 25,
                                                                          child: model.checkAvailable(e.id.toString())
                                                                              ? Icon(
                                                                                  Icons.favorite_rounded,
                                                                                  color: Colors.redAccent,
                                                                                )
                                                                              : Icon(Icons.favorite_outline_rounded)),
                                                                      onTap: () {
                                                                        model.checkAvailable(e.id.toString())
                                                                            ? model.removeProductWishItem(context, e.id.toString())
                                                                            : model.addItem(context, e.id.toString());
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              onTap: () => Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) => e.typeId == 'giftcard'
                                                                        ? GiftDetail(
                                                                            product: Product(
                                                                            name: e.name,
                                                                            price: e.price.toString(),
                                                                            smallImage: e.mediaGalleryEntries[0].file,
                                                                            thumbnail: e.mediaGalleryEntries[0].file,
                                                                            entityId: e.id.toString(),
                                                                            sku: e.sku,
                                                                          ))
                                                                        : ProductDetail(
                                                                            product: Product(
                                                                            name: e.name,
                                                                            price: e.price.toString(),
                                                                            smallImage: e.mediaGalleryEntries[0].file,
                                                                            thumbnail: e.mediaGalleryEntries[0].file,
                                                                            entityId: e.id.toString(),
                                                                            sku: e.sku,
                                                                          )),
                                                                  )),
                                                            ),
                                                            Divider(
                                                              endIndent: 60,
                                                              indent: 20,
                                                            )
                                                          ],
                                                        ))
                                                    .toList(),
                                              ),
                                      ],
                                    ),
                                  ),
                  ],
                ),
        );
      },
    );
  }
}
