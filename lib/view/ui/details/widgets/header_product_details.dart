import 'package:badges/badges.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
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

import 'package:jawhara/viewModel/product_details_view_model.dart';
import 'package:jawhara/viewModel/wishList_view_model.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../../../index.dart';

class HeaderProductDetails extends StatefulWidget {
  ProductDetailsViewModel model;
  ProductDetails productDetails;
  Product product;

  HeaderProductDetails({Key key, this.model, this.productDetails, this.product}) : super(key: key);

  @override
  _HeaderProductDetailsState createState() => _HeaderProductDetailsState();
}

class _HeaderProductDetailsState extends State<HeaderProductDetails> {
  @override
  Widget build(BuildContext context) {
    var top;
    final data = widget.productDetails;
    final model = widget.model;
    return SliverAppBar(
      actions: [
        IconButton(
            icon: Icon(Icons.share_outlined),
            onPressed: () async {
              DynamicLinkService dynamicLinkService = DynamicLinkService();
              ShortDynamicLink generatedUri =
                  await dynamicLinkService.generateFirebaseDynamicLinkForProductDetails(SharedData.lang, data.entityId, shortLink: true);
              Share.share(generatedUri.shortUrl.toString());
            }),
      ],
      leading: Container(),
      expandedHeight: 280.0,
      floating: true,
      pinned: true,
      snap: true,
      elevation: 0,
      backgroundColor: Colors.white,
      flexibleSpace: LayoutBuilder(builder: (context, constraints) {
        top = constraints.biggest.height;

        return Stack(
          children: [
            FlexibleSpaceBar(
              centerTitle: true,
              background: data != null && data.galleryImages != null && data.galleryImages.isNotEmpty
                  ? ProductGallery(product: data)
                  : FullScreenWidget(
                      child: Center(
                        child: Hero(
                          tag: "smallImage",
                          child: ClipRRect(
                            child: PinchZoomImage(
                              image: CachedNetworkImage(
                                imageUrl: model.selectOption != null
                                    ? model.selectOption.swatchImage
                                    : Strings.Image_URL + widget.product.smallImage.toString(),
                                width: 270,
                                height: 270,
                                // maxHeightDiskCache: 270,
                                // maxWidthDiskCache: 270,
                                errorWidget: (context, error, stackTrace) => Image.asset(
                                  'assets/images/placeholder.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
                            ),
                          ),
                        ),
                      ),
                    ),
              title: Visibility(
                  visible: top < 280.0,
                  child: Container(
                    width: 200,
                    child: Text((widget.product?.name) ?? (model.productDetails?.name) ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontFamily: FontFamily.cairo, color: AppColors.primaryColor, fontSize: 14)),
                  )),
            ),
            if (data != null)
              Visibility(
                visible: top > 200.0,
                child: ViewModelBuilder<WishListViewModel>.reactive(
                  viewModelBuilder: () => locator<WishListViewModel>(),
                  disposeViewModel: false,
                  builder: (context, model, child) => Positioned(
                      bottom: 5,
                      left: 10,
                      child: ClipOval(
                        child: Material(
                          color: Colors.white, // button color
                          child: InkWell(
                            splashColor: Colors.red,
                            // inkwell color
                            child: SizedBox(
                                width: 25,
                                height: 25,
                                child: model.checkAvailable(widget.product.entityId)
                                    ? Icon(
                                        Icons.favorite_rounded,
                                        color: Colors.redAccent,
                                      )
                                    : Icon(
                                        Icons.favorite_outline_rounded,
                                        color: Colors.grey[500],
                                      )),
                            onTap: () {
                              model.checkAvailable(widget.product.entityId)
                                  ? model.removeProductWishItem(context, widget.product.entityId)
                                  : model.addItem(context, widget.product.entityId);
                            },
                          ),
                        ),
                      )),
                ),
              ),
            if (data != null && model.checkExpire(data) && double.tryParse(model.initSale(data)) != 0)
              Visibility(
                visible: top > 200.0,
                child: Positioned(
                    bottom: 15,
                    right: 15,
                    child: ClipOval(
                      child: Material(
                        color: AppColors.redColor, // button color
                        shape: CircleBorder(),
                        child: InkWell(
                          splashColor: Colors.red, // inkwell color
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              '${model.initSale(data)} %',
                              style: TextStyle(fontFamily: FontFamily.cairo, fontWeight: FontWeight.bold, color: Colors.white),
                              textDirection: TextDirection.ltr,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                    )),
              ),
          ],
        );
      }),
    );
  }
}
