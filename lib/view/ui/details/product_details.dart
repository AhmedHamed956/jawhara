import 'package:badges/badges.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jawhara/core/config/validators.dart';
import 'package:jawhara/core/constants/dynamic_link.dart';
import 'package:jawhara/model/product%20details/CitiesDeliveryInfoModel.dart';
import 'package:jawhara/model/product%20details/product_details.dart';
import 'package:jawhara/model/products/product.dart';
import 'package:jawhara/view/ui/details/product_gallery.dart';
import 'package:jawhara/view/ui/details/widgets/bottom_nav_product_details.dart';
import 'package:jawhara/view/ui/details/widgets/header_product_details.dart';

import 'package:jawhara/viewModel/product_details_view_model.dart';
import 'package:jawhara/viewModel/wishList_view_model.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../../index.dart';

class ProductDetail extends StatefulWidget {
  final Product product;
  final bool fromProducts;

  ProductDetail({Key key, this.product, this.fromProducts = false}) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  bool _scrollingDown = false;
  ScrollController _scrollController = new ScrollController();
  int numberOfProductsToBuyTogether = 1;
  bool reachedTheEnd = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse && _scrollingDown == false) {
        setState(() {
          _scrollingDown = true;
        });
      }
      if (_scrollController.position.userScrollDirection == ScrollDirection.forward && _scrollingDown == true) {
        setState(() {
          _scrollingDown = false;
        });
      }

      if (_scrollController.position.pixels >= (_scrollController.position.maxScrollExtent - 10)) {
        setState(() {
          reachedTheEnd = true;
        });
      } else {
        setState(() {
          reachedTheEnd = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double kHeight = MediaQuery.of(context).size.width / 2;
    double kHeight3 = MediaQuery.of(context).size.width / 3;
    double kWidth3 = MediaQuery.of(context).size.width / 3 - 10;
    double kWidth2 = MediaQuery.of(context).size.width / 2 - 50;
    final connection = Provider.of<ConnectivityStatus>(context);

    return Scaffold(
        floatingActionButton: reachedTheEnd
            ? FloatingActionButton(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.arrow_upward,
                  color: Colors.grey,
                  size: 26,
                ),
                onPressed: () {
                  _scrollController.animateTo(
                    0.0,
                    curve: Curves.easeOut,
                    duration: const Duration(milliseconds: 500),
                  );
                })
            : Container(),
        bottomNavigationBar: BottomNavProductDetails(fromProducts: widget.fromProducts),
        appBar: AppBar(
          // leading: IconButton(
          //     icon: Icon(IcoMoon.line_circle),
          //     onPressed: () {
          //       BotToast.showText(
          //         text: translate("soon"),
          //         borderRadius: BorderRadius.all(Radius.circular(10)),
          //         contentColor: Colors.green,
          //         contentPadding: EdgeInsets.all(10),
          //       );
          //     }),
          title: SearchBar(
            isSearching: _scrollingDown,
          ),
          actions: [
            Visibility(
              visible: !_scrollingDown,
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
          // bottom: PreferredSize(
          //   child: Text(translate('freeShippingMoreThan299')),
          //   preferredSize: Size.fromHeight(20),
          // ),
        ),
        body: ViewModelBuilder<ProductDetailsViewModel>.reactive(
          viewModelBuilder: () => ProductDetailsViewModel(),
          disposeViewModel: false,
          onModelReady: (model) => model.initScreen(context, widget.product),
          builder: (context, model, child) {
            if (connection == ConnectivityStatus.Offline)
              return NoInternetWidget(retryFunc: () => model.initScreen(context, widget.product));

            final data = model.productDetails;
            _calculateNumOfProductsToBuyTogether(data);
            return CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                HeaderProductDetails(model: model, productDetails: data, product: widget.product),
                SliverList(
                    delegate: SliverChildListDelegate([
                  model.isBusy
                      ? Center(
                          child: ShapeLoading(),
                          heightFactor: 10,
                        )
                      : Wrap(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10),
                                  Divider(),
                                  // information
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(data.name.toString(), style: TextStyle(fontFamily: FontFamily.cairo, fontSize: 15)),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: AlignmentDirectional.centerEnd,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                (data.quantityAndStockStatus != null &&
                                                        data.quantityAndStockStatus.isInStock != null &&
                                                        data.quantityAndStockStatus.isInStock)
                                                    ? translate('available')
                                                    : translate('notAvailable'),
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: (data.quantityAndStockStatus != null &&
                                                            data.quantityAndStockStatus.isInStock != null &&
                                                            data.quantityAndStockStatus.isInStock)
                                                        ? Colors.green
                                                        : Colors.red,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Text("#${translate("SKU")}: ${data.sku.toString()}",
                                                  textDirection: TextDirection.ltr,
                                                  style: TextStyle(fontFamily: FontFamily.cairo, fontSize: 14)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // price
                                  Wrap(
                                    direction: Axis.horizontal,
                                    alignment: WrapAlignment.start,
                                    runAlignment: WrapAlignment.center,
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: [
                                      if (data != null &&
                                          data.price != null &&
                                          (!model.checkExpire(data) || data.price == data.specialPrice))
                                        Text(double.parse(data.price ?? '0.0').toDouble().toString() + ' ' + SharedData.currency,
                                            style: TextStyle(
                                                fontFamily: FontFamily.cairo,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14)),
                                      if (data != null && data.price != null && model.checkExpire(data) && data.price != data.specialPrice)
                                        Text(double.parse(data.specialPrice ?? '0.0').toDouble().toString() + ' ' + SharedData.currency,
                                            style: TextStyle(
                                                fontFamily: FontFamily.cairo,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14)),
                                      SizedBox(width: 10),
                                      if (data != null && data.price != null && model.checkExpire(data) && data.price != data.specialPrice)
                                        Text(double.parse(data.price ?? '0.0').toDouble().toString() + ' ' + SharedData.currency,
                                            style: TextStyle(
                                                fontFamily: FontFamily.cairo,
                                                decorationThickness: 2,
                                                decorationColor: AppColors.darkGreyColor,
                                                decoration: TextDecoration.lineThrough,
                                                fontSize: 12)),
                                      SizedBox(width: 10),
                                      Text('(${translate("priceIncludeVat")})',
                                          style: TextStyle(fontFamily: FontFamily.cairo, fontSize: 12)),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  if (data != null && data.price != null && model.checkExpire(data) && data.price != data.specialPrice)
                                    Text(
                                        '${translate("youSaved")} ${(double.tryParse(data.specialPrice ?? "0") - double.tryParse(data.price ?? "0")) * -1} ${translate("SAR")}',
                                        style: TextStyle(fontFamily: FontFamily.cairo, color: AppColors.redColor, fontSize: 12)),
                                  SizedBox(height: 10),
                                  // rating
                                  model.reviewLoad
                                      ? Center(
                                          child: ShapeLoading(),
                                        )
                                      : SmoothStarRating(
                                          allowHalfRating: false,
                                          starCount: 5,
                                          rating: model.reviews.ratings ?? 0,
                                          size: 20.0,
                                          isReadOnly: true,
                                          color: AppColors.rateColor,
                                          borderColor: AppColors.rateColor,
                                          spacing: 0.0),
                                  SizedBox(height: 10),
                                  // Select Color & Size
                                  Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    alignment: WrapAlignment.start,
                                    runAlignment: WrapAlignment.start,
                                    runSpacing: 10,
                                    spacing: 10,
                                    children: [
                                      Visibility(
                                        visible: model.color.isNotEmpty,
                                        child: Wrap(
                                          crossAxisAlignment: WrapCrossAlignment.center,
                                          alignment: WrapAlignment.start,
                                          runAlignment: WrapAlignment.start,
                                          children: [
                                            Text(
                                              translate('color') + ": ",
                                              style: TextStyle(fontFamily: FontFamily.tajawal, fontWeight: FontWeight.w500, fontSize: 15),
                                              textAlign: TextAlign.center,
                                            ),
                                            Wrap(
                                              children: model.color
                                                  .map((e) => GestureDetector(
                                                        onTap: () => e.isCheck == 1 ? null : model.switchImage(context, 'color', e),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: HexColor(e.swatchValue),
                                                              image: e.isCheck == 1
                                                                  ? DecorationImage(
                                                                      image: NetworkImage(
                                                                          'https://www.iconsdb.com/icons/preview/red/line-2-xxl.png'))
                                                                  : null,
                                                              border: model.cacheColor == null
                                                                  ? null
                                                                  : model.cacheColor.valueIndex == e.valueIndex
                                                                      ? Border.all(color: Colors.brown, width: 3)
                                                                      : Border.all(color: AppColors.darkGreyColor)),
                                                          margin: EdgeInsets.symmetric(horizontal: 2),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(12.0),
                                                          ),
                                                        ),
                                                      ))
                                                  .toList(),
                                            )
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        visible: model.size.isNotEmpty,
                                        child: Wrap(
                                          crossAxisAlignment: WrapCrossAlignment.center,
                                          alignment: WrapAlignment.start,
                                          runAlignment: WrapAlignment.start,
                                          children: [
                                            Text(
                                              translate('size') + ": ",
                                              style: TextStyle(fontFamily: FontFamily.tajawal, fontWeight: FontWeight.w500, fontSize: 15),
                                              textAlign: TextAlign.center,
                                            ),
                                            Wrap(
                                              children: model.size
                                                  .map((e) => GestureDetector(
                                                        onTap: () => e.isCheck == 1 ? null : model.switchImage(context, 'size', e),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            image: e.isCheck == 1
                                                                ? DecorationImage(
                                                                    image: NetworkImage(
                                                                        'https://www.iconsdb.com/icons/preview/red/line-2-xxl.png'))
                                                                : null,
                                                            border: model.cacheSize == null
                                                                ? Border.all(color: AppColors.darkGreyColor)
                                                                : model.cacheSize.valueIndex == e.valueIndex
                                                                    ? Border.all(color: Colors.brown, width: 3)
                                                                    : Border.all(color: AppColors.darkGreyColor),
                                                          ),
                                                          width: 35,
                                                          height: 30,
                                                          padding: EdgeInsets.only(top: 2),
                                                          child: Text(
                                                            e.swatchValue,
                                                            style: TextStyle(
                                                              fontFamily: FontFamily.cairo,
                                                              fontSize: 12,
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                      ))
                                                  .toList(),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Divider(),
                                  // Delivered to country
                                  if (!model.citiesLoad && model.citiesDeliveryInfoItems.isNotEmpty)
                                    InkWell(
                                      onTap: () {
                                        _showCitySelectionDialog(model);
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(translate('delivered_to') + ': ',
                                                  style: TextStyle(fontFamily: FontFamily.cairo, fontSize: 14)),
                                              Expanded(
                                                child: Text(model.selectedCity?.name ?? model.citiesDeliveryInfoItems[0].name,
                                                    style:
                                                        TextStyle(fontFamily: FontFamily.cairo, fontWeight: FontWeight.bold, fontSize: 14)),
                                              ),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                color: Colors.black,
                                                size: 14,
                                              )
                                            ],
                                          ),
                                          Text(model.selectedCity?.message ?? model.citiesDeliveryInfoItems[0].message,
                                              style: TextStyle(fontFamily: FontFamily.cairo, fontSize: 14)),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  // Add to cart
                                  Flex(
                                    direction: Axis.horizontal,
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: model.cartLoad == true
                                            ? Center(
                                                child: ShapeLoading(),
                                              )
                                            : RaisedButton(
                                                child: Text(
                                                  translate('add_to_cart'),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: FontFamily.cairo,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  model.alreadyTried = false;
                                                  model.addToCart(context);
                                                },
                                                elevation: 0,
                                                color: AppColors.mainTextColor,
                                              ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            border: Border.all(
                                                color: (double.parse(model.productDetails.stockItem.qty) > model.qty)
                                                    ? AppColors.mainTextColor
                                                    : Colors.grey),
                                          ),
                                          margin: EdgeInsets.symmetric(horizontal: 5),
                                          padding: EdgeInsets.symmetric(vertical: 5),
                                          child: GestureDetector(
                                            onTap: () => model.addQuantity(context),
                                            child: Icon(
                                              Icons.add,
                                              color: (double.parse(model.productDetails.stockItem.qty) > model.qty)
                                                  ? AppColors.mainTextColor
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            border: Border.all(color: AppColors.mainTextColor),
                                          ),
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.symmetric(horizontal: 1),
                                          // padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                          child: GestureDetector(
                                              child: Text(
                                            model.qty.toString(),
                                            style: TextStyle(fontSize: 18, fontFamily: FontFamily.cairo),
                                          )),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            border: Border.all(color: (model.qty != 1) ? AppColors.mainTextColor : Colors.grey),
                                          ),
                                          margin: EdgeInsets.symmetric(horizontal: 5),
                                          padding: EdgeInsets.symmetric(vertical: 5),
                                          child: GestureDetector(
                                            onTap: () => model.subQuantity(),
                                            child: Icon(
                                              Icons.remove,
                                              color: (model.qty != 1) ? AppColors.mainTextColor : Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Descriptions
                                  Container(
                                    child: ExpandablePanel(
                                        header: Text(
                                          translate('description'),
                                        ),
                                        theme: ExpandableThemeData(headerAlignment: ExpandablePanelHeaderAlignment.center),
                                        expanded: HtmlWidget(
                                          data.description.toString(),
                                        ),
                                        collapsed: Container()),
                                    decoration: BoxDecoration(border: Border.symmetric(horizontal: BorderSide(color: AppColors.greyColor))),
                                  ),
                                  // Specification
                                  if (data.customAttributes.specificiation != null)
                                    Container(
                                      child: ExpandablePanel(
                                        collapsed: Container(),
                                        header: Text(
                                          translate('specification'),
                                        ),
                                        theme: ExpandableThemeData(headerAlignment: ExpandablePanelHeaderAlignment.center),
                                        expanded: data.customAttributes.specificiation != null
                                            ? Row(
                                                children: [
                                                  Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: data.customAttributes.specificiation
                                                          .map((e) => Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(e.value.title ?? '',
                                                                      softWrap: true,
                                                                      style: TextStyle(
                                                                          fontFamily: FontFamily.cairo,
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.bold)),
                                                                  Text(e.value.label ?? '',
                                                                      softWrap: true,
                                                                      style: TextStyle(fontFamily: FontFamily.cairo, fontSize: 13)),
                                                                ],
                                                              ))
                                                          .toList()),
                                                ],
                                              )
                                            : Center(child: Text(translate('empty_data'))),
                                      ),
                                      decoration:
                                          BoxDecoration(border: Border.symmetric(horizontal: BorderSide(color: AppColors.greyColor))),
                                    ),
                                  // watchVideo
                                  if (data.watchVideoSection != null && data.watchVideoSection.isNotEmpty)
                                    Container(
                                      child: ExpandablePanel(
                                        collapsed: Container(),
                                        header: Text(
                                          translate("watchVideo"),
                                        ),
                                        theme: ExpandableThemeData(headerAlignment: ExpandablePanelHeaderAlignment.center),
                                        expanded: data.watchVideoSection != null && data.watchVideoSection.isNotEmpty
                                            ? Html(
                                                data: """${data.watchVideoSection}""",
                                                shrinkWrap: true,
                                              )
                                            : Center(child: Text(translate('empty_data'))),
                                      ),
                                      decoration:
                                          BoxDecoration(border: Border.symmetric(horizontal: BorderSide(color: AppColors.greyColor))),
                                    ),
                                  // sizeGuideSection
                                  if (data.sizeGuideSection != null && data.sizeGuideSection.isNotEmpty)
                                    Container(
                                      child: ExpandablePanel(
                                        collapsed: Container(),
                                        header: Text(
                                          translate("sizeGuide"),
                                        ),
                                        theme: ExpandableThemeData(headerAlignment: ExpandablePanelHeaderAlignment.center),
                                        expanded: data.sizeGuideSection != null && data.sizeGuideSection.isNotEmpty
                                            ? Html(
                                                data:
                                                    """${data.sizeGuideSection.replaceAll("{{media url=&quot;", "https://jawhara.online/media/").replaceAll("&quot;}}", "")}""")
                                            : Center(child: Text(translate('empty_data'))),
                                      ),
                                      decoration:
                                          BoxDecoration(border: Border.symmetric(horizontal: BorderSide(color: AppColors.greyColor))),
                                    ),
                                  // reviews
                                  Container(
                                    child: ExpandablePanel(
                                      collapsed: Container(),
                                      header: Text(
                                        translate('comment_review') + ' ( ${model.reviews?.data?.length?.toString() ?? '0'} )',
                                      ),
                                      theme: ExpandableThemeData(headerAlignment: ExpandablePanelHeaderAlignment.center),
                                      expanded: Column(
                                        children: [
                                          (model.reviews == null || model.reviews.data == null || model.reviews.data.isEmpty)
                                              ? Center(child: Text(translate('empty_data')))
                                              : Column(
                                                  children: model.reviewLoad
                                                      ? <Widget>[
                                                          Center(
                                                            child: ShapeLoading(),
                                                          )
                                                        ]
                                                      : model.reviews.data
                                                          .map((e) => (int.parse(e.reviewStatus) == 1 && e.rate != null)
                                                              ? ListTile(
                                                                  title: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Row(
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(e.nickname,
                                                                              softWrap: true,
                                                                              style: TextStyle(fontFamily: FontFamily.cairo, fontSize: 14)),
                                                                          SizedBox(width: 10),
                                                                          SmoothStarRating(
                                                                              allowHalfRating: false,
                                                                              starCount: 5,
                                                                              rating: double.parse(e.rate),
                                                                              size: 15.0,
                                                                              isReadOnly: true,
                                                                              color: AppColors.rateColor,
                                                                              borderColor: AppColors.rateColor,
                                                                              spacing: 0.0),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(e.title,
                                                                              softWrap: true,
                                                                              style: TextStyle(fontFamily: FontFamily.cairo, fontSize: 12)),
                                                                          Text(formatDate(e.createdAt.toUtc(), [dd, '/', mm, '/', yyyy]),
                                                                              style: TextStyle(fontFamily: FontFamily.cairo, fontSize: 12)),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  subtitle: Text(e.detail,
                                                                      softWrap: true,
                                                                      style: TextStyle(fontFamily: FontFamily.cairo, fontSize: 12)),
                                                                )
                                                              : Container())
                                                          .toList(),
                                                ),
                                          Form(
                                            key: model.commentForm,
                                            child: Column(
                                              children: [
                                                // Name
                                                title('rating'),
                                                Row(
                                                  children: [
                                                    Directionality(
                                                      textDirection: TextDirection.ltr,
                                                      child: SmoothStarRating(
                                                          allowHalfRating: false,
                                                          starCount: 5,
                                                          // rating: model.reviews.ratings ?? 0,
                                                          size: 20.0,
                                                          onRated: (rating) => model.updateCommentRating(rating),
                                                          color: AppColors.rateColor,
                                                          borderColor: AppColors.rateColor,
                                                          spacing: 0.0),
                                                    ),
                                                  ],
                                                ),
                                                // Name
                                                title('nick_name'),
                                                SizedBox(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10.0),
                                                        color: Colors.white,
                                                        border: Border.all(color: Colors.grey[400])),
                                                    padding: EdgeInsets.all(10),
                                                    child: TextFormField(
                                                      keyboardType: TextInputType.name,
                                                      onChanged: (value) => model.updateCommentNickname(value),
                                                      validator: (String value) => Validators.validateForm(value),
                                                      decoration: InputDecoration(
                                                          hintText: '',
                                                          hintStyle: TextStyle(fontSize: 12),
                                                          isDense: true,
                                                          contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                                                    ),
                                                  ),
                                                  width: MediaQuery.of(context).size.width,
                                                ),
                                                SizedBox(height: 10),
                                                // Email
                                                title('title_comment'),
                                                SizedBox(
                                                  child: Container(
                                                    padding: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10.0),
                                                        color: Colors.white,
                                                        border: Border.all(color: Colors.grey[400])),
                                                    child: TextFormField(
                                                      keyboardType: TextInputType.text,
                                                      // initialValue: model.data.email,
                                                      onChanged: (value) => model.updateCommentTitle(value),
                                                      validator: (String value) => Validators.validateForm(value),
                                                      decoration: InputDecoration(
                                                          hintText: '',
                                                          isDense: true,
                                                          hintStyle: TextStyle(fontSize: 12),
                                                          contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                                                    ),
                                                  ),
                                                  width: MediaQuery.of(context).size.width,
                                                ),
                                                SizedBox(height: 10),
                                                // Message
                                                title('review'),
                                                SizedBox(
                                                  child: Container(
                                                    padding: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10.0),
                                                        color: Colors.white,
                                                        border: Border.all(color: Colors.grey[400])),
                                                    child: TextFormField(
                                                      keyboardType: TextInputType.multiline,
                                                      maxLines: null,
                                                      onChanged: (value) => model.updateCommentDetail(value),
                                                      validator: (String value) => Validators.validateForm(value),
                                                      decoration: InputDecoration(
                                                          hintText: translate(''),
                                                          isDense: true,
                                                          hintStyle: TextStyle(fontSize: 12),
                                                          contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                                                    ),
                                                  ),
                                                  width: MediaQuery.of(context).size.width,
                                                ),

                                                SizedBox(height: 20),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () => model.submit(context),
                                                      child: Container(
                                                        width: MediaQuery.of(context).size.width / 2.5,
                                                        height: 30.0,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(1.0),
                                                          color: AppColors.mainTextColor,
                                                        ),
                                                        alignment: Alignment.center,
                                                        child: Text(
                                                          translate('send'),
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.white,
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    decoration: BoxDecoration(border: Border.symmetric(horizontal: BorderSide(color: AppColors.greyColor))),
                                  ),
                                ],
                              ),
                            ),
                            // Products buy together
                            (data.productLinks == null ||
                                    data.productLinks.isEmpty ||
                                    data.alwaysSoldWithProducts == null ||
                                    data.alwaysSoldWithProducts.isEmpty)
                                ? Text('')
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Padding(
                                      //   padding: const EdgeInsets.symmetric(
                                      //       vertical: 8.0),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        margin: EdgeInsets.all(15),
                                        color: Colors.grey.withAlpha(20),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (data.productLinks != null || data.alwaysSoldWithProducts != null)
                                              Text(
                                                translate('buy_together'),
                                                style: TextStyle(
                                                  fontFamily: FontFamily.cairo,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  color: AppColors.mainTextColor,
                                                ),
                                                // textAlign: TextAlign.center,
                                              ),
                                            if (data.productLinks != null || data.alwaysSoldWithProducts != null)
                                              SizedBox(
                                                height: 10,
                                              ),
                                            if (data.productLinks != null || data.alwaysSoldWithProducts != null)
                                              Container(
                                                width: MediaQuery.of(context).size.width,
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.rectangle,
                                                  border: Border.all(color: AppColors.darkGreyColor),
                                                  // borderRadius: BorderRadius.all(
                                                  //     Radius.circular(5)),
                                                ),
                                                child: Wrap(
                                                    children: data.alwaysSoldWithProducts != null && data.alwaysSoldWithProducts.isNotEmpty
                                                        ? data.alwaysSoldWithProducts
                                                            .map((e) => Container(
                                                                height: kHeight3,
                                                                width: kWidth2,
                                                                child: ProductScreen(
                                                                  direction: Axis.vertical,
                                                                  product: e,
                                                                  isBoughtWith: true,
                                                                  isSmall: true,
                                                                  onCheckBoxChange: () {
                                                                    _calculateNumOfProductsToBuyTogether(data);
                                                                    setState(() {});
                                                                  },
                                                                )))
                                                            .toList()
                                                        : data.productLinks == null
                                                            ? []
                                                            : data.productLinks
                                                                .map((e) => Visibility(
                                                                    visible: e.linkType == "upsell",
                                                                    replacement: Text(''),
                                                                    child: Container(
                                                                        height: kHeight3,
                                                                        width: kWidth2,
                                                                        child: ProductScreen(
                                                                          direction: Axis.vertical,
                                                                          product: e.data,
                                                                          isBoughtWith: true,
                                                                          onCheckBoxChange: () {
                                                                            _calculateNumOfProductsToBuyTogether(data);
                                                                            setState(() {});
                                                                          },
                                                                        ))))
                                                                .toList()),
                                              ),
                                            if (numberOfProductsToBuyTogether > 1)
                                              SizedBox(
                                                height: 5,
                                              ),
                                            if (numberOfProductsToBuyTogether > 1)
                                              model.buyTogether
                                                  ? Center(
                                                      child: ShapeLoading(),
                                                    )
                                                  : InkWell(
                                                      onTap: () {
                                                        List<ProductDetails> productsToAdd = [];
                                                        if (data.alwaysSoldWithProducts.isNotEmpty) {
                                                          for (int i = 0; i < data.alwaysSoldWithProducts.length; i++) {
                                                            if (data.alwaysSoldWithProducts[i].selected) {
                                                              productsToAdd.add(ProductDetails(sku: data.alwaysSoldWithProducts[i].sku));
                                                            }
                                                          }
                                                        } else {
                                                          for (int i = 0; i < data.productLinks.length; i++) {
                                                            if (data.productLinks[i].linkType == "upsell" &&
                                                                data.productLinks[i].data.selected) {
                                                              productsToAdd.add(ProductDetails(sku: data.productLinks[i].data.sku));
                                                            }
                                                          }
                                                        }
                                                        model.addBuyTogetherBundleToCart(context, productsToAdd);
                                                      },
                                                      child: Container(
                                                        width: MediaQuery.of(context).size.width,
                                                        padding: EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          shape: BoxShape.rectangle,
                                                          border: Border.all(color: AppColors.darkGreyColor),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                              "${translate("buy")} $numberOfProductsToBuyTogether ${translate("productTogether")}"),
                                                        ),
                                                      ),
                                                    )
                                          ],
                                        ),
                                      ),
                                      // ),
                                      // Products related
                                      if (data.productLinks != null)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                                          child: Text(
                                            translate('related'),
                                            style: TextStyle(
                                              fontFamily: FontFamily.cairo,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20,
                                              color: AppColors.mainTextColor,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      if (data.productLinks != null)
                                        Wrap(
                                            children: data.productLinks
                                                .map((e) => Visibility(
                                                    visible: e.linkType == "related",
                                                    replacement: Text(''),
                                                    child: Container(
                                                        height: kHeight,
                                                        width: kHeight,
                                                        child: ProductScreen(
                                                          direction: Axis.vertical,
                                                          product: e.data,
                                                          isRelative: true,
                                                        ))))
                                                .toList()),
                                    ],
                                  ),
                          ],
                        ),
                ])),
              ],
            );
          },
        ));
  }

  _calculateNumOfProductsToBuyTogether(data) {
    if (data != null && data.alwaysSoldWithProducts != null && data.alwaysSoldWithProducts.isNotEmpty) {
      numberOfProductsToBuyTogether = 1;
      for (int i = 0; i < data.alwaysSoldWithProducts.length; i++) {
        if (data.alwaysSoldWithProducts[i].selected) {
          // setState(() {
          numberOfProductsToBuyTogether++;
          // });
        }
      }
    } else if (data != null && data.productLinks != null) {
      numberOfProductsToBuyTogether = 1;
      for (int i = 0; i < data.productLinks.length; i++) {
        if (data.productLinks[i].linkType == "upsell" && data.productLinks[i].data.selected) {
          // setState(() {
          numberOfProductsToBuyTogether++;
          // });
        }
      }
    }
  }

  _showCitySelectionDialog(ProductDetailsViewModel model) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(translate('selectDeliveryCity')),
            content: SelectDeliveryCitDialogContent(model.citiesDeliveryInfoItems, model.selectedCity, (CityDeliveryInfoItem selectedCity) {
              model.setSelectedCity(selectedCity);
              Navigator.of(context).pop();
            }),
          );
        });
  }
}

class SelectDeliveryCitDialogContent extends StatefulWidget {
  final onTap;
  final List<CityDeliveryInfoItem> citiesDeliveryInfoItems;
  final CityDeliveryInfoItem selectedCity;

  SelectDeliveryCitDialogContent(this.citiesDeliveryInfoItems, this.selectedCity, this.onTap);

  @override
  _SelectDeliveryCitDialogContentState createState() => _SelectDeliveryCitDialogContentState();
}

class _SelectDeliveryCitDialogContentState extends State<SelectDeliveryCitDialogContent> {
  TextEditingController searchTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 200.0, // Change as per your requirement
      child: Column(
        children: [
          TextField(
            controller: searchTextEditingController,
            decoration: InputDecoration(
                hintText: translate('searchForCity'),
                border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor)),
                contentPadding: EdgeInsets.all(8.0),
                prefixIcon: Icon(Icons.search)),
            onChanged: (text) {
              setState(() {});
            },
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.citiesDeliveryInfoItems.length,
              itemBuilder: (BuildContext context, int index) {
                if (searchTextEditingController.text.isEmpty ||
                    widget.citiesDeliveryInfoItems[index].name.contains(searchTextEditingController.text))
                  return ListTile(
                    onTap: () {
                      widget.onTap(widget.citiesDeliveryInfoItems[index]);
                    },
                    title: Text(widget.citiesDeliveryInfoItems[index].name),
                    trailing: ((widget.selectedCity == null && index == 0) ||
                            (widget.selectedCity != null && widget.selectedCity.id == widget.citiesDeliveryInfoItems[index].id))
                        ? Icon(
                            Icons.check,
                            color: Colors.green,
                          )
                        : null,
                  );
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget title(element) {
  return Row(children: [
    Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(
          translate(element) + '*',
          style: TextStyle(fontSize: 14),
        ))
  ]);
}
