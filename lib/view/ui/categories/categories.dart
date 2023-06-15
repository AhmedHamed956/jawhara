import 'package:flutter/rendering.dart';

import '../../index.dart';

// ignore: must_be_immutable
class CategoriesPage extends StatefulWidget {
  List<CategoriesChildrenDatum> cat = List();
  int index;

  CategoriesPage(this.cat, {this.index = 0});

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _searching = false;
  ScrollController _scrollController = new ScrollController();
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse && _searching == false) {
        setState(() {
          _searching = true;
        });
      }
      if (_scrollController.position.userScrollDirection == ScrollDirection.forward && _searching == true) {
        setState(() {
          _searching = false;
        });
      }
    });
    _tabController = new TabController(vsync: this, length: this.widget.cat.length);
    _handleSelected();
  }
  void _handleSelected() {
    setState(() {
      _tabController.animateTo((_tabController.index + widget.index));
    });
  }
  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true; //Set to true

  @override
  Widget build(BuildContext context) {
    super.build(context); //You must add this
    return DefaultTabController(
      length: this.widget.cat.length,
      child: new Scaffold(
        key: scaffoldKey,
        appBar: new AppBar(
          title: SearchBar(
            isSearching: _searching,
          ),
          actions: [
            Visibility(
              visible: !_searching,
              child: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: AppColors.secondaryColor,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: SearchScreen(),
                      ),
                    );
                  }),
            ),
            IconButton(icon: Icon(IcoMoon.barcode), onPressed: ()=> null),
            IconButton(
                icon: Icon(
                  IcoMoon.notification,
                  color: AppColors.secondaryColor,
                ),
                onPressed: null),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: this.widget.cat.map((e) => Tab(text: e.name)).toList(),
            isScrollable: true,
            labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            labelColor: AppColors.mainTextColor,
            indicatorColor: AppColors.yellowColor,
            indicatorSize: TabBarIndicatorSize.label,
            labelPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: this.widget.cat.map((e) {
            return TabsCategories(e);
          }).toList(),
        ),
      ),
    );
  }
}
