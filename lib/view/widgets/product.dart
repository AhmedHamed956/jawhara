import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:jawhara/model/products/product.dart';
import 'package:jawhara/model/search/search_product_item.dart';
import 'package:jawhara/view/ui/details/gift_details.dart';
import 'package:jawhara/viewModel/wishList_view_model.dart';
import 'package:provider/provider.dart';

import '../index.dart';

// ignore: must_be_immutable
class ProductScreen extends ViewModelBuilderWidget<HomeViewModel> {
  Axis direction;
  bool isRelative;
  bool isBoughtWith;
  bool isSmall;
  Product product;
  Function onCheckBoxChange;
  bool fromProducts;

  ProductScreen(
      {this.direction,
      this.isRelative = false,
      this.isSmall = false,
      this.isBoughtWith = false,
      this.product,
      this.onCheckBoxChange,
      this.fromProducts = false});

  @override
  bool get reactive => true;

  @override
  bool get disposeViewModel => false;

  @override
  Widget builder(BuildContext context, HomeViewModel model, Widget child) {
    // final wish = locator<WishListViewModel>();
    // print(this.product.toJson());
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => this.product.typeId == 'giftcard'
                ? GiftDetail(product: this.product)
                : ProductDetail(
                    product: this.product,
                    fromProducts: fromProducts,
                  ),
          )),
      child: Container(
        child: Flex(
          direction: Axis.vertical,
          children: [
            // Image Header
            Expanded(
              child: Container(
                // color: AppColors.bgColor,
                child: Stack(
                  children: [
                    // SizedBox(
                    //   // height: 200,
                    //   child: Stack(
                    //     fit: StackFit.expand,
                    //     children: [
                    //       // CachedNetworkImage(
                    //       //   imageUrl: this.product.categoryListImageURL == null
                    //       //       ? Strings.Image_URL + this.product.smallImage
                    //       //       : this.product.categoryListImageURL,
                    //       //   fit: BoxFit.cover,
                    //       //   // placeholder: (context, url) => Image.asset('assets/garageui/bg_garage_view.png'),
                    //       // ),
                    //       ClipRRect(
                    //         child: Container(
                    //           decoration: BoxDecoration(
                    //             // color: Colors.red,
                    //             image: DecorationImage(
                    //               fit: BoxFit.contain,
                    //               image: CachedNetworkImageProvider(
                    //                 this.product.categoryListImageURL == null
                    //                     ? Strings.Image_URL + this.product.smallImage
                    //                     : this.product.categoryListImageURL,
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: Strings.Image_URL + this.product.smallImage,
                          fit: BoxFit.contain,
                          errorWidget: (context, error, stackTrace) => Image.asset(
                            'assets/images/placeholder.png',
                            fit: BoxFit.cover,
                          ),
                        )),
                    Visibility(
                      visible: model.checkExpire(this.product) && double.tryParse(model.initSale(this.product)) != 0,
                      child: Positioned(
                          bottom: isRelative || isBoughtWith ? null : 5,
                          top: isRelative || isBoughtWith ? 5 : null,
                          right: 10,
                          child: Container(
                            child: Text(
                              '${translate("discount")} ${model.initSale(this.product)} %',
                              style: TextStyle(color: Colors.white, fontFamily: FontFamily.cairo, fontSize: 10),
                            ),
                            color: AppColors.redColor,
                            padding: EdgeInsets.all(3),
                          )),
                    ),
                    if (isBoughtWith)
                      Positioned(
                          top: 0,
                          left: 0,
                          child: Checkbox(
                              value: this.product.selected,
                              onChanged: (val) {
                                this.product.selected = val;
                                onCheckBoxChange();
                              })),
                    if (!isBoughtWith)
                      ViewModelBuilder<WishListViewModel>.reactive(
                        viewModelBuilder: () => locator<WishListViewModel>(),
                        disposeViewModel: false,
                        builder: (context, model, child) => Positioned(
                            bottom: isRelative ? null : 5,
                            top: isRelative ? 5 : null,
                            left: 10,
                            child: ClipOval(
                              child: Material(
                                color: Colors.white, // button color
                                child: InkWell(
                                  splashColor: Colors.red, // inkwell color
                                  child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: model.checkAvailable(this.product.entityId)
                                          ? Icon(
                                              Icons.favorite_rounded,
                                              size: 20,
                                              color: Colors.redAccent,
                                            )
                                          : Icon(
                                              Icons.favorite_outline_rounded,
                                              size: 20,
                                              color: Colors.grey[500],
                                            )),
                                  onTap: () {
                                    model.checkAvailable(this.product.entityId)
                                        ? model.removeProductWishItem(context, this.product.entityId)
                                        : model.addItem(context, this.product.entityId);
                                  },
                                ),
                              ),
                            )),
                      ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 2),
              ),
              flex: isSmall ? 3 : 4,
            ),
            // Text Footer
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  children: [
                    Text(
                      this.product.name.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 11, color: const Color(0xff1d1f22), fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                    SmoothStarRating(
                        allowHalfRating: false,
                        starCount: 5,
                        rating: this.product.ratings?.averageratings == null ? 0 : this.product.ratings.averageratings.toDouble(),
                        size: 15.0,
                        isReadOnly: true,
                        color: AppColors.rateColor,
                        borderColor: AppColors.rateColor,
                        spacing: 0.0),
                    !model.checkExpire(this.product) || this.product.price == this.product.specialPrice
                        ? Text(
                            ((double.tryParse(this.product.price ?? '0.0')?.toString()) ?? (this.product.price ?? '0.0')) +
                                ' ' +
                                SharedData.currency,
                            style: TextStyle(
                                fontSize: 12, fontFamily: FontFamily.cairo, color: AppColors.redColor, fontWeight: FontWeight.w900),
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        : Flex(
                            direction: Axis.horizontal,
                            children: [
                              Expanded(
                                child: Text(
                                  double.parse(this.product.specialPrice ?? '0.0').toString() + ' ' + SharedData.currency,
                                  style: TextStyle(
                                      fontSize: isSmall ? 10 : 12,
                                      fontFamily: FontFamily.cairo,
                                      color: AppColors.redColor,
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  double.parse(this.product.price ?? '0.0').toDouble().toString() + ' ' + SharedData.currency,
                                  style: TextStyle(
                                      fontSize: isSmall ? 8 : 10,
                                      fontFamily: FontFamily.cairo,
                                      decoration: TextDecoration.lineThrough,
                                      decorationThickness: 2,
                                      color: AppColors.secondaryColor),
                                  textAlign: TextAlign.start,
                                ),
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.start,
                          )
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
              flex: isSmall ? 2 : 1,
            )
          ],
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => locator<HomeViewModel>();
}
