import 'package:jawhara/core/api/common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../index.dart';

class TabsLayout extends StatefulWidget {
  final CategoriesChildrenDatum _cat;

  TabsLayout(this._cat);

  @override
  _TabsLayoutState createState() => _TabsLayoutState();
}

class _TabsLayoutState extends State<TabsLayout> {
  int get count => widget._cat.linkedProducts.length;

  // List<Product> list = [];
  bool reachedEnd = false;
  bool gettingData = false;
  var currentPage = 0;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void initState() {
    super.initState();
    if (count == 0) loadNextPage();
  }

  _onRefresh() async {
    currentPage = 0;
    reachedEnd = false;
    await loadNextPage();
    _refreshController.refreshCompleted();
  }

  loadNextPage() async {
    if (currentPage == 0 && widget._cat.linkedProducts.isNotEmpty) {
      if (widget._cat.linkedProducts.length % 12 != 0) {
        setState(() {
          reachedEnd = true;
        });
        _refreshController.loadComplete();
      } else {
        currentPage = widget._cat.linkedProducts.length ~/ 12;
      }
    }
    if (!reachedEnd) {
      currentPage++;
      setState(() {
        gettingData = true;
      });
      CommonApi()
          .getProductsData(context, widget._cat.id,
              page: currentPage, pageSize: 12)
          .then((productsResponse) {
        if (productsResponse.dataProducts.length < 12) {
          reachedEnd = true;
        }
        setState(() {
          widget._cat.linkedProducts.addAll(productsResponse.dataProducts);
          gettingData = false;
        });
        _refreshController.loadComplete();
      }).catchError((er) {
        _refreshController.loadComplete();
      });
    }else{
      _refreshController.loadComplete();
    }
  }

  // void load() {
  //   print("load");
  //   setState(() {
  //     for (int i = 0; i < 5; i++) {
  //       list.add(widget._cat.linkedProducts[index + i]);
  //     }
  //     index += 5;
  //     // print("data count = ${list.length}");
  //     // print("index count = ${index}");
  //   });
  // }

  // Future<bool> _loadMore() async {
  //   print("onLoadMore");
  //   await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
  //   load();
  //   return true;
  // }
  //
  // Future<void> _refresh() async {
  //   await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
  //   list.clear();
  //   index = 5;
  //   load();
  // }

  @override
  Widget build(BuildContext context) {
    double kWidth = (MediaQuery.of(context).size.width / 2) - 10;
    double kHeight = (MediaQuery.of(context).size.height / 2) - 40;
    return SmartRefresher(
      enablePullDown: false,
      enablePullUp: true,
      // header: WaterDropHeader(),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = reachedEnd
                ? Text(translate('no_more_data'))
                : Text(translate("watchMore"));
          } else if (mode == LoadStatus.loading) {
            body = ShapeLoading(
              color: Colors.black,
              size: 60,
            );
          } else if (mode == LoadStatus.failed) {
            body = Text(translate('failedToLoadRetry'));
          } else if (mode == LoadStatus.canLoading) {
            body = Text(translate("watchMore"));
          } else {
            body = Text(translate('no_more_data'));
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: _refreshController,
      // onRefresh: _onRefresh,
      onLoading: loadNextPage,
      child: ListView(children: [
        Banners(
          widget._cat.image ?? '',
          isAsset: false,
          datum: null,
        ),
        CategoriesCircle(widget._cat.childrenData),
        ListView.builder(
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemCount: count / 2 != count ~/ 2 ? count ~/ 2 + 1 : count ~/ 2,
          shrinkWrap: true,
          itemBuilder: (context, index) => Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Container(
                  height: kHeight,
                  width: kWidth,
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: ProductScreen(
                    direction: Axis.vertical,
                    product: widget._cat.linkedProducts[(index * 2)],
                  ),
                ),
                if ((index * 2) + 1 != count)
                  Container(
                    height: kHeight,
                    width: kWidth,
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: ProductScreen(
                      direction: Axis.vertical,
                      product: widget._cat.linkedProducts[(index * 2) + 1],
                    ),
                  ),
              ],
            ),
          ),
        ),
        // if (!reachedEnd)
        //   InkWell(
        //     onTap: () {
        //       loadNextPage();
        //     },
        //     child: Container(
        //       margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        //       color: Colors.white,
        //       width: MediaQuery.of(context).size.width,
        //       padding: const EdgeInsets.all(8.0),
        //       child: Center(
        //         child: Text(
        //             "${gettingData ? translate("loading") : translate("watchMore")} ..."),
        //       ),
        //     ),
        //   )
      ]),
    );
  }
}
