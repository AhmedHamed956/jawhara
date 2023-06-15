import 'package:cached_network_image/cached_network_image.dart';
import 'package:jawhara/model/cart/cart.dart';
import 'package:jawhara/model/products/product.dart';
import 'package:jawhara/viewModel/cart_view_model.dart';
import 'package:provider/provider.dart';

import '../index.dart';

// ignore: must_be_immutable
class ProductListScreen extends ViewModelBuilderWidget<HomeViewModel> {
  Axis direction;
  bool isSub;
  Item item;
  bool isCounter;

  ProductListScreen(
      {this.direction, this.isSub = false, this.item, this.isCounter = true});

  @override
  bool get reactive => true;

  @override
  bool get disposeViewModel => false;

  @override
  Widget builder(BuildContext context, HomeViewModel model, Widget child) {
    final _cart = locator<CartViewModel>();

    return this.direction == Axis.horizontal
        ? Container(
            child: Flex(
              direction: Axis.vertical,
              children: [
                // Image Header
                Expanded(
                  child: Container(
                    // color: AppColors.bgColor,
                    child: Stack(
                      children: [
                        Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: CachedNetworkImage(
                              imageUrl: this
                                  .item
                                  .extensionAttributes
                                  .imageUrl
                                  .toString(),
                              fit: BoxFit.contain,
                              errorWidget: (context, error, stackTrace) =>
                                  Image.asset(
                                'assets/images/placeholder.png',
                                fit: BoxFit.cover,
                              ),
                            )),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 2),
                  ),
                  flex: 4,
                ),
                // Text Footer
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Text(
                          this.item.extensionAttributes.itemName.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: const Color(0xff1d1f22),
                          ),
                          textAlign: TextAlign.start,
                        ),
                        Row(
                          children: [
                            Text(
                              ((this.item.extensionAttributes.priceIncludingTax) ?? this.item.price).toString() +
                                  ' ' +
                                  SharedData.currency,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: FontFamily.cairo,
                                  decorationThickness: 4,
                                  color: AppColors.secondaryColor),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              this.item.qty.toString() + ' X ',
                              textDirection: SharedData.lang == 'en'
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: FontFamily.cairo,
                                  decorationThickness: 4,
                                  color: AppColors.secondaryColor),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        Text(
                          _cart.subTotal(this.item) + ' ' + SharedData.currency,
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: FontFamily.cairo,
                              decorationThickness: 4,
                              color: AppColors.fourthColor),
                          textAlign: TextAlign.start,
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),
                  flex: 2,
                )
              ],
            ),
          )
        : Container(
            child: Column(
              children: [
                ListTile(
                  leading: Stack(
                    children: [
                      Container(
                          child: Image.network(
                        this.item.extensionAttributes?.imageUrl.toString() ??
                            Strings.Image_URL,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                          'assets/images/placeholder.png',
                          fit: BoxFit.cover,
                        ),
                      )),
                    ],
                  ),
                  title: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Text(
                          this.item.extensionAttributes.itemName.toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: const Color(0xff1d1f22),
                          ),
                          textAlign: TextAlign.start,
                        ),
                        this.item.extensionAttributes?.configurableOptions !=
                                null
                            ? Column(
                                children: this
                                    .item
                                    .extensionAttributes
                                    .configurableOptions
                                    .map((e) => Row(
                                          children: [
                                            Text(
                                              e.optionName,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: FontFamily.cairo,
                                                  color:
                                                      AppColors.secondaryColor),
                                              textAlign: TextAlign.start,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              e.optionLabel,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: FontFamily.cairo,
                                                  decorationThickness: 4,
                                                  color:
                                                      AppColors.secondaryColor),
                                              textAlign: TextAlign.start,
                                            )
                                          ],
                                        ))
                                    .toList(),
                              )
                            : Container(),
                        Row(
                          children: [
                            Text(
                              ((this.item.extensionAttributes.priceIncludingTax) ?? this.item.price).toString() +
                                  ' ' +
                                  SharedData.currency,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: FontFamily.cairo,
                                  decorationThickness: 4,
                                  color: AppColors.secondaryColor),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              this.item.qty.toString() + ' X ',
                              textDirection: SharedData.lang == 'en'
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: FontFamily.cairo,
                                  decorationThickness: 4,
                                  color: AppColors.secondaryColor),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        Text(
                          _cart.subTotal(this.item) + ' ' + SharedData.currency,
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: FontFamily.cairo,
                              decorationThickness: 4,
                              color: AppColors.fourthColor),
                          textAlign: TextAlign.start,
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),
                  trailing: Container(
                    width: 130,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                            child: Flex(
                              direction: Axis.horizontal,
                              children: [
                                GestureDetector(
                                  onTap: (item.extensionAttributes.isInStock !=
                                              null &&
                                          !item.extensionAttributes.isInStock)
                                      ? null
                                      : () => locator<CartViewModel>()
                                          .addQty(context, this.item),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        border: Border.all(
                                            color: (item.extensionAttributes
                                                            .isInStock !=
                                                        null &&
                                                    !item.extensionAttributes
                                                        .isInStock)
                                                ? Color(0xffd3d3d3)
                                                : AppColors.secondaryColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(3))),
                                    width: 20,
                                    height: 30,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.symmetric(horizontal: 1),
                                    // padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                    child: Icon(
                                      Icons.add,
                                      size: 15,
                                      color:
                                          (item.extensionAttributes.isInStock !=
                                                      null &&
                                                  !item.extensionAttributes
                                                      .isInStock)
                                              ? Color(0xffd3d3d3)
                                              : Colors.black,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                          color: AppColors.secondaryColor),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(3))),
                                  width: 20,
                                  height: 30,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(horizontal: 1),
                                  // padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                  child: GestureDetector(
                                      onTap: () => null,
                                      child: Text(
                                        this.item.qty.toString(),
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: FontFamily.cairo),
                                      )),
                                ),
                                GestureDetector(
                                  onTap: (item.extensionAttributes.isInStock !=
                                              null &&
                                          !item.extensionAttributes.isInStock)
                                      ? null
                                      : () => locator<CartViewModel>()
                                          .subtractQty(context, this.item),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        border: Border.all(
                                            color: (item.extensionAttributes
                                                            .isInStock !=
                                                        null &&
                                                    !item.extensionAttributes
                                                        .isInStock)
                                                ? Color(0xffd3d3d3)
                                                : AppColors.secondaryColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(3))),
                                    width: 20,
                                    height: 30,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.symmetric(horizontal: 1),
                                    // padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                    child: Icon(
                                      Icons.remove,
                                      size: 15,
                                      color:
                                          (item.extensionAttributes.isInStock !=
                                                      null &&
                                                  !item.extensionAttributes
                                                      .isInStock)
                                              ? Color(0xffd3d3d3)
                                              : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            visible: isCounter),
                        IconButton(
                          icon: Icon(Icons.delete_outline),
                          onPressed: () => locator<CartViewModel>()
                              .removeItem(context, this.item),
                        )
                      ],
                    ),
                  ),
                ),
                if (item.extensionAttributes.isInStock != null &&
                    !item.extensionAttributes.isInStock)
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: Color(0xfffae5e5),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          Icons.highlight_remove_sharp,
                          color: Colors.red,
                          size: 15,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            translate('outOfStock'),
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: FontFamily.cairo,
                                decorationThickness: 4,
                                color: Colors.red),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) =>
      locator<HomeViewModel>();
}
