// import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jawhara/core/config/validators.dart';
import 'package:jawhara/model/products/product.dart';
import 'package:jawhara/viewModel/gift_details_view_model.dart';
import 'package:jawhara/viewModel/wishList_view_model.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:share/share.dart';

import '../../index.dart';

class GiftDetail extends StatefulWidget {
  Product product;

  GiftDetail({Key key, this.product}) : super(key: key);

  @override
  _GiftDetailState createState() => _GiftDetailState();
}

class _GiftDetailState extends State<GiftDetail> {
  @override
  Widget build(BuildContext context) {
    var top;
    double kHeight = MediaQuery.of(context).size.width / 2;
    double kHeight3 = MediaQuery.of(context).size.width / 3;
    // final wish = locator<WishListViewModel>();
    return Scaffold(
        body: ViewModelBuilder<GiftDetailsViewModel>.reactive(
      viewModelBuilder: () => GiftDetailsViewModel(),
      disposeViewModel: false,
      onModelReady: (model) => model.initScreen(context, widget.product),
      builder: (context, model, child) {
        // if (model.productDetails == null) return Center(child: Text(translate('empty_data')));
        final data = model.giftCardDetails;
        return CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              actions: [
                IconButton(
                    icon: Icon(Icons.share_outlined),
                    onPressed: () {
                      Share.share(Strings.MAIN_URL + '/en/' + data.urlKey + ".html", subject: data.name);
                    }),
              ],
              expandedHeight: 220.0,
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
                      background: FullScreenWidget(
                        child: Center(
                          child: Hero(
                            tag: "smallImage",
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: PinchZoomImage(
                                image: Image.network(
                                  Strings.Image_URL + widget.product.smallImage.toString(),
                                  errorBuilder: (context, error, stackTrace) => Image.asset(
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
                          visible: top < 110.0,
                          child: Container(
                            width: 200,
                            child: Text(widget.product.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontFamily: FontFamily.cairo, color: AppColors.primaryColor, fontSize: 14)),
                          )),
                    ),
                    Visibility(
                      visible: top > 110.0,
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
                                  splashColor: Colors.red, // inkwell color
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
                  ],
                );
              }),
            ),
            // body
            new SliverList(
                delegate: new SliverChildListDelegate([
              model.isBusy
                  ? Center(
                      child: ShapeLoading(),
                      heightFactor: 10,
                    )
                  : Wrap(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // information
                              Text(data.name.toString(), style: TextStyle(fontFamily: FontFamily.cairo, fontSize: 15)),

                              Divider(),

                              Text(
                                translate('price'),
                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              // price
                              Row(
                                children: [
                                  Text(
                                    double.parse(data.price ?? '0.0').toDouble().toString() + ' ' + SharedData.currency,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: FontFamily.cairo,
                                        decorationThickness: 4,
                                        color: AppColors.secondaryColor),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                                mainAxisAlignment: MainAxisAlignment.start,
                              ),
                              Divider(),
                              Text(
                                translate('SKU'),
                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              Text("${data.sku.toString()}", style: TextStyle(fontFamily: FontFamily.cairo, fontSize: 14)),
                              Divider(),
                              Form(
                                key: model.userForm,
                                child: Column(
                                  children: [
                                    // Amount
                                    SizedBox(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            color: Colors.white,
                                            border: Border.all(color: Colors.grey[400])),
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          // initialValue: model.data.name,

                                          onChanged: (value) => model.amount = value,
                                          validator: (String value) => Validators.validateForm(value),
                                          decoration: InputDecoration(
                                              hintText: translate('amount'), hintStyle: TextStyle(fontSize: 12),counterText: '${translate('min')} ${double.parse(model.giftCardDetails.openAmountMin).toDouble()  ?? '0'} ${SharedData.currency} - ${translate('max')}  ${double.parse(model.giftCardDetails.openAmountMax).toDouble() ?? '0'} ${SharedData.currency}', contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                                        ),
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        // Name
                                        SizedBox(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10.0),
                                                color: Colors.white,
                                                border: Border.all(color: Colors.grey[400])),
                                            child: TextFormField(
                                              keyboardType: TextInputType.name,
                                              // initialValue: model.data.name,
                                              onChanged: (value) => model.senderName = value,
                                              validator: (String value) => Validators.validateName(value),
                                              decoration: InputDecoration(
                                                  hintText: translate('sender_name'), hintStyle: TextStyle(fontSize: 12),contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                                            ),
                                          ),
                                          width: MediaQuery.of(context).size.width / 2.2,
                                        ),
                                        // Email
                                        SizedBox(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10.0),
                                                color: Colors.white,
                                                border: Border.all(color: Colors.grey[400])),
                                            child: TextFormField(
                                              keyboardType: TextInputType.emailAddress,
                                              // initialValue: model.data.email,
                                              onChanged: (value) => model.senderEmail = value,
                                              validator: (String value) => Validators.validateEmail(value),
                                              decoration: InputDecoration(
                                                  hintText: translate('sender_email'), hintStyle: TextStyle(fontSize: 12),
                                                  contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                                            ),
                                          ),
                                          width: MediaQuery.of(context).size.width / 2.2,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        // Name
                                        SizedBox(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10.0), border: Border.all(color: Colors.grey[400])),
                                            child: TextFormField(
                                              keyboardType: TextInputType.name,
                                              // initialValue: model.data.name,
                                              onChanged: (value) => model.recipientName = value,
                                              validator: (String value) => Validators.validateName(value),
                                              decoration: InputDecoration(
                                                  hintText: translate('recipient_name'), hintStyle: TextStyle(fontSize: 12),
                                                  contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                                            ),
                                          ),
                                          width: MediaQuery.of(context).size.width / 2.2,
                                        ),
                                        // Email
                                        SizedBox(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10.0), border: Border.all(color: Colors.grey[400])),
                                            child: TextFormField(
                                              keyboardType: TextInputType.emailAddress,
                                              // initialValue: model.data.email,
                                              onChanged: (value) => model.recipientEmail = value,
                                              validator: (String value) => Validators.validateEmail(value),
                                              decoration: InputDecoration(
                                                  hintText: translate('recipient_email'), hintStyle: TextStyle(fontSize: 12),
                                                  contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                                            ),
                                          ),
                                          width: MediaQuery.of(context).size.width / 2.2,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    // Message
                                    SizedBox(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0), border: Border.all(color: Colors.grey[400])),
                                        child: TextFormField(
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          // initialValue: model.data.name,
                                          onChanged: (value) => model.message = value,
                                          validator: (String value) => Validators.validateForm(value),
                                          decoration: InputDecoration(
                                              hintText: translate('message'), contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                                        ),
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
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
                                            onPressed: () => model.addToCart(context),
                                            elevation: 0,
                                            color: AppColors.mainTextColor,
                                          ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        border: Border.all(color: AppColors.mainTextColor),
                                      ),
                                      margin: EdgeInsets.symmetric(horizontal: 5),
                                      padding: EdgeInsets.symmetric(vertical: 5),
                                      child: GestureDetector(
                                        onTap: () => model.addQuantity(context),
                                        child: Icon(Icons.add),
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
                                        border: Border.all(color: AppColors.mainTextColor),
                                      ),
                                      margin: EdgeInsets.symmetric(horizontal: 5),
                                      padding: EdgeInsets.symmetric(vertical: 5),
                                      child: GestureDetector(
                                        onTap: () => model.subQuantity(),
                                        child: Icon(Icons.remove),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ])),
          ],
        );
      },
    ));
  }
}
