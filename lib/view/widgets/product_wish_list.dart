import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jawhara/model/wishlist/wishlist.dart';
import 'package:jawhara/view/ui/details/gift_details.dart';
import 'package:jawhara/viewModel/cart_view_model.dart';
import 'package:jawhara/viewModel/wishList_view_model.dart';
import 'package:provider/provider.dart';
import '../index.dart';

// ignore: must_be_immutable
class ProductWishListScreen extends ViewModelBuilderWidget<WishListViewModel> {
  Axis direction;
  bool isSub;
  ItemWish item;
  bool isCounter;
  int index;

  ProductWishListScreen(
      {this.direction,
      this.isSub = false,
      this.item,
      this.isCounter = true,
      this.index});

  @override
  bool get reactive => true;

  @override
  bool get disposeViewModel => false;

  @override
  Widget builder(BuildContext context, WishListViewModel model, Widget child) {
    // final _cartModel = locator<CartViewModel>();
    //TODO: Fix exception here
    return Container(
      child: ListTile(
        leading: InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => this.item.product.typeId == 'giftcard'
                    ? GiftDetail(product: this.item.product)
                    : ProductDetail(product: this.item.product),
              )),
          child: Container(
              width: MediaQuery.of(context).size.width / 5,
              child: CachedNetworkImage(
                imageUrl: Strings.Image_URL +
                        this.item.product.thumbnail.toString() ??
                    Strings.Image_URL,
                fit: BoxFit.contain,
                errorWidget: (context, error, stackTrace) => Image.asset(
                  'assets/images/placeholder.png',
                  fit: BoxFit.cover,
                ),
              )),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            this.item.product.typeId == 'giftcard'
                                ? GiftDetail(product: this.item.product)
                                : ProductDetail(product: this.item.product),
                      )),
                  child: Column(
                    children: [
                      Text(
                        this.item.product.name.toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xff1d1f22),
                        ),
                        textAlign: TextAlign.start,
                      ),
                      !model.checkExpire(this.item.product) ||
                              this.item.product.price ==
                                  this.item.product.specialPrice
                          ? Text(
                              double.parse(this.item.product.price ?? '0.0')
                                      .toString() +
                                  ' ' +
                                  SharedData.currency,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: FontFamily.cairo,
                                  color: AppColors.redColor,
                                  fontWeight: FontWeight.w900),
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          : Container(
                              height: 40,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      double.parse(this
                                                      .item
                                                      .product
                                                      .specialPrice ??
                                                  '0.0')
                                              .toString() +
                                          ' ' +
                                          SharedData.currency,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: FontFamily.cairo,
                                          color: AppColors.redColor,
                                          fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      double.parse(this.item.product.price ??
                                                  '0.0')
                                              .toDouble()
                                              .toString() +
                                          ' ' +
                                          SharedData.currency,
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontFamily: FontFamily.cairo,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          decorationThickness: 2,
                                          color: AppColors.secondaryColor),
                                      textAlign: TextAlign.start,
                                    ),
                                  )
                                ],
                              ),
                            ),
                      // Text(
                      //   this.item.product.price == null
                      //       ? '0'
                      //       : double.parse(this.item.product.price.toString())
                      //               .toStringAsFixed(2) +
                      //           ' ' +
                      //           SharedData.currency,
                      //   style: TextStyle(
                      //       fontSize: 12,
                      //       fontFamily: FontFamily.cairo,
                      //       fontWeight: FontWeight.w700,
                      //       decorationThickness: 4,
                      //       color: AppColors.secondaryColor),
                      //   textAlign: TextAlign.start,
                      // ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ),
              ),
              Column(
                children: [
                  GestureDetector(
                    child: Icon(
                      FontAwesomeIcons.trashAlt,
                      color: AppColors.secondaryColor,
                    ),
                    onTap: () =>
                        model.removeItem(context, this.item.wishlistItemId),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(color: AppColors.darkGreyColor),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                        child: GestureDetector(
                          onTap: () => model.addQuantity(index),
                          child: Icon(
                            Icons.add,
                            size: 14,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(color: AppColors.darkGreyColor),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(vertical: 2),
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: GestureDetector(
                            child: Text(
                          item.qty.toString(),
                          style: TextStyle(
                              fontSize: 14, fontFamily: FontFamily.cairo),
                        )),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(color: AppColors.darkGreyColor),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                        child: GestureDetector(
                          onTap: () => model.subQuantity(index),
                          child: Icon(
                            Icons.remove,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                      decoration: BoxDecoration(
                        color: AppColors.mainTextColor,
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Text(
                        translate('add_to_cart2'),
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: FontFamily.cairo,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    onTap: () => model.addToCart(context, index),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  WishListViewModel viewModelBuilder(BuildContext context) =>
      locator<WishListViewModel>();
}
