import 'package:flutter/cupertino.dart';
import 'package:jawhara/view/widgets/flutter_shimmer.dart';
import 'package:jawhara/viewModel/products_view_model.dart';
import 'package:provider/provider.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';
import '../../index.dart';

// ignore: must_be_immutable
class TabsProducts extends StatelessWidget {
  CategoriesChildrenDatum _cat = CategoriesChildrenDatum();

  TabsProducts(this._cat);

  @override
  Widget build(BuildContext context) {
    double kHeight = MediaQuery.of(context).size.height / 2;
    double kWidth = MediaQuery.of(context).size.width / 2;
    final connection = Provider.of<ConnectivityStatus>(context);
    print('_cat > ${_cat.name}');
    print('_cat > ${_cat.id}');
    return ViewModelBuilder<ProductsViewModel>.reactive(
      viewModelBuilder: () => locator<ProductsViewModel>(),
      disposeViewModel: false,
      onModelReady: (model) => model.initScreen(context, id: _cat.id, pageInit: 1),
      builder: (context, model, child) {
        if (connection == ConnectivityStatus.Offline) return NoInternetWidget(retryFunc: () => null);
        if (model.isBusy && model.page == 1)
          return ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemBuilder: (context, builder) => VideoShimmer(
              margin: EdgeInsets.all(0),
            ),
            itemCount: 10,
          );
        if (model.products.isEmpty) return Center(child: Text(translate('empty_data')));
        return RefreshLoadmore(
          onRefresh: () => model.initScreen(context, id: _cat.id, isLoadMore: false),
          onLoadmore: () => model.reCallInit(context, loadMore: true),
          noMoreWidget: Text(model.isLastPage ? model.noMoreDataMessage : ""),
          isLastPage: model.isLastPage,
          child: model.products.isNotEmpty
              ? Wrap(
                  runSpacing: 4,
                  spacing: 4,
                  alignment: WrapAlignment.start,
                  children: model.products
                      .map((e) => Container(
                          height: kHeight,
                          width: kWidth - 5,
                          alignment: Alignment.center,
                          color: Colors.white,
                          child: ProductScreen(
                            direction: Axis.vertical,
                            product: e,
                            fromProducts: true,
                          )))
                      .toList())
              : Center(
                  child: Text('empty'),
                ),
        );
      },
    );
  }
}
