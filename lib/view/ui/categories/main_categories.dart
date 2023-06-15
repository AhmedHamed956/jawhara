import 'package:auto_size_text/auto_size_text.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/rendering.dart';
import 'package:jawhara/core/config/connectivity_service.dart';
import 'package:jawhara/view/widgets/not_internet.dart';
import 'package:jawhara/view/widgets/page_view_tabs.dart';
import 'package:jawhara/view/widgets/scorollable_list_tabview_widget/model/list_tab.dart';
import 'package:jawhara/view/widgets/scorollable_list_tabview_widget/model/scrollable_list_tab.dart';
import 'package:jawhara/view/widgets/scorollable_list_tabview_widget/scrollable_list_tabview.dart';
import 'package:provider/provider.dart';
import '../../index.dart';

class MainCategoriesPage extends StatefulWidget {
  @override
  _MainCategoriesPageState createState() => _MainCategoriesPageState();
}

class _MainCategoriesPageState extends State<MainCategoriesPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _searching = false;
  ScrollController controller = new ScrollController();
  String indexMain = '0';

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    var lang = localizationDelegate.currentLocale.languageCode;
    final connection = Provider.of<ConnectivityStatus>(context);

    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        // leading: IconButton(icon: Icon(IcoMoon.line_circle), onPressed: (){
        //   BotToast.showText(
        //     text: translate("soon"),
        //     borderRadius: BorderRadius.all(Radius.circular(10)),
        //     contentColor: Colors.green,
        //     contentPadding: EdgeInsets.all(10),
        //   );
        // }),
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
          IconButton(
              icon: Icon(IcoMoon.barcode),
              onPressed: () {
                BotToast.showText(
                  text: translate("soon"),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  contentColor: Colors.green,
                  contentPadding: EdgeInsets.all(10),
                );
              }),
          IconButton(
              icon: Icon(
                IcoMoon.notification,
                color: AppColors.secondaryColor,
              ),
              onPressed: () {
                BotToast.showText(
                  text: translate("soon"),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  contentColor: Colors.green,
                  contentPadding: EdgeInsets.all(10),
                );
              }),
        ],
      ),
      body: ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => locator<HomeViewModel>(),
        disposeViewModel: false,
        fireOnModelReadyOnce: true,
        onModelReady: (model) => model.initScreen(context),
        builder: (context, model, child) {
          if (connection == ConnectivityStatus.Offline) return NoInternetWidget(retryFunc: () => model.initScreen(context));
          if (model.isBusy) return Center(child: Text(translate('loading')));
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ScrollableListTabView(
              tabs: model.catArray.sublist(1).map((e) {
                return ScrollableListTab(
                    tab: ListTab(
                        label: Text(
                      e.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w700),
                    )),
                    body: (e.childrenData.isEmpty && (e.image == null || e.image.isEmpty))
                        ? null
                        : ListView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              // Banners
                              Container(margin: EdgeInsets.symmetric(horizontal: 4), child: Banners(e.image ?? '', isAsset: false)),
                              // Space
                              Padding(padding: EdgeInsets.all(5)),

                              if (e.childrenData.isEmpty)
                                SizedBox(
                                  height: MediaQuery.of(context).size.height / 2,
                                ),

                              ListView(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: e.childrenData
                                    .map((element) => Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Header Text
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 15, bottom: 5),
                                                  child: Text(
                                                    element.name,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w700,
                                                      color: const Color(0xff333333),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 15, bottom: 5),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        locator<HomeViewModel>().spiderFunction(
                                                            context, element.id, element.level.toString(), element.parentId.toString());
                                                      },
                                                      child: Wrap(
                                                        crossAxisAlignment: WrapCrossAlignment.center,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.only(top: 3),
                                                            child: Text(translate('more')),
                                                          ),
                                                          Icon(
                                                            Icons.arrow_forward_ios_rounded,
                                                            size: 13,
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                              ],
                                            ),
                                            Container(
                                              margin: EdgeInsets.symmetric(horizontal: 4),
                                              child: element.childrenData.isEmpty
                                                  ? Row(
                                                      children: [Text(translate('empty_data'))],
                                                    )
                                                  : GridView.builder(
                                                      physics: NeverScrollableScrollPhysics(),
                                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 3,
                                                          childAspectRatio: 0.75,
                                                          crossAxisSpacing: 4.0,
                                                          mainAxisSpacing: 4.0),
                                                      itemBuilder: (context, i) {
                                                        final data = element.childrenData[i + 1];
                                                        // if(i == 0) return Text('d');
                                                        return Visibility(
                                                          // visible: i != 0 ,
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              locator<HomeViewModel>().spiderFunction(
                                                                  context, data.id, data.level.toString(), data.parentId.toString());
                                                            },
                                                            child: Container(
                                                              child: GridTile(
                                                                child: Card(
                                                                  child: Column(
                                                                    children: [
                                                                      Image.network(
                                                                        data.thumbnail ?? '',
                                                                        fit: BoxFit.contain,
                                                                        height: 45,
                                                                        errorBuilder: (context, error, stackTrace) => Image.asset(
                                                                          'assets/images/placeholder.png',
                                                                          fit: BoxFit.cover,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height: 10,
                                                                      ),
                                                                      Container(
                                                                        height: 20,
                                                                        width: MediaQuery.of(context).size.width / 4,
                                                                        child: AutoSizeText(
                                                                          data.name,
                                                                          maxLines: 2,
                                                                          // maxFontSize: 12,
                                                                          minFontSize: 6,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          style: TextStyle(
                                                                            fontSize: 10,
                                                                            // color: const Color(0xff333333),
                                                                          ),
                                                                          textAlign: TextAlign.center,
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  elevation: 0,
                                                                  color: Colors.transparent,
                                                                  margin: EdgeInsets.only(bottom: 20),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      itemCount: element.childrenData.length - 1,
                                                      shrinkWrap: true,
                                                    ),
                                            ),
                                          ],
                                        ))
                                    .toList(),
                              )
                            ],
                          ));
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
