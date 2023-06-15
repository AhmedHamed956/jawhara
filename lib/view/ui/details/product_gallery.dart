import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jawhara/core/constants/strings.dart';
import 'package:jawhara/model/product%20details/product_details.dart';
import 'package:jawhara/view/index.dart';
import 'package:jawhara/view/ui/details/widgets/youtube_view.dart';
import 'package:jawhara/view/widgets/image_gallery.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_metadata/youtube.dart';

class ProductGallery extends StatefulWidget {
  final ProductDetails product;
  final Function onSelect;

  ProductGallery({this.product, this.onSelect});

  @override
  _ProductGalleryState createState() => _ProductGalleryState();
}

class _ProductGalleryState extends State<ProductGallery> {
  int _current = 0;
  YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

  void _onShowGallery(BuildContext context, [int index = 0]) {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return ImageGallery(images: widget.product.galleryImages, index: index);
        });
  }

  void _handleImageTap(BuildContext context, {int index = 0, bool fullScreen = false}) {
    if (widget.onSelect != null && !fullScreen) {
      widget.onSelect(widget.product.galleryImages[index], false);
      return;
    }
    _onShowGallery(context, index);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return Container(
          child: Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                    viewportFraction: 1.0,
                    height: 240,
                    autoPlay: widget.product.galleryImages.length > 2,
                    enlargeCenterPage: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }),
                items: widget.product.galleryImages.map((item) {
                  return item.contains('https://youtu.be')
                      ? FutureBuilder<MetaDataModel>(
                          builder: (context, snapshot) {
                            return InkWell(
                              onTap: () async {
                                return Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.fade,
                                    child: YoutubeView(snapshot.data.url),
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    child: snapshot.data == null
                                        ? ShapeLoadingR()
                                        : CachedNetworkImage(imageUrl: snapshot.data.thumbnailUrl, fit: BoxFit.fitHeight),
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                  Center(child: Icon(Icons.play_circle, size: 45, color: Colors.white))
                                ],
                              ),
                            );
                          },
                          future: YoutubeMetaData.getData(item),
                        )
                      : InkWell(
                          onTap: () => _handleImageTap(context, index: _current),
                          child: Container(
                            child: CachedNetworkImage(imageUrl: Strings.Image_URL + item, fit: BoxFit.fitHeight),
                            width: MediaQuery.of(context).size.width,
                          ),
                        );
                }).toList(),
              ),
              if (widget.product.galleryImages.length > 2)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.product.galleryImages.map((url) {
                    int index = widget.product.galleryImages.indexOf(url);
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == index ? Color.fromRGBO(0, 0, 0, 0.9) : Color.fromRGBO(0, 0, 0, 0.4),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
          width: MediaQuery.of(context).size.width,
        );
        //   Container(
        //   width: MediaQuery.of(context).size.width,
        //   child: SingleChildScrollView(
        //     scrollDirection: Axis.horizontal,
        //     child: Row(
        //       children: [
        //         for (var i = 0; i < product.galleryImages.length; i++)
        //           GestureDetector(
        //             onDoubleTap: () =>
        //                 _handleImageTap(context, index: i, fullScreen: true),
        //             onLongPress: () =>
        //                 _handleImageTap(context, index: i, fullScreen: true),
        //             onTap: () => _handleImageTap(context, index: i),
        //             child: Container(
        //                 padding: const EdgeInsets.only(left: 4.0, right: 8),
        //                 margin:
        //                     const EdgeInsets.only(left: 2, top: 4, right: 4),
        //                 child: ExtendedImage.network(
        //                   Strings.Image_URL + product.galleryImages[i],
        //                   width: dimension,
        //                   height: dimension * 0.9,
        //                   fit: BoxFit.contain,
        //                   cache: true,
        //                   enableLoadState: false,
        //                   loadStateChanged: (ExtendedImageState state) {
        //                     Widget widget;
        //                     switch (state.extendedImageLoadState) {
        //                       case LoadState.loading:
        //                         widget = const SizedBox();
        //                         break;
        //                       case LoadState.completed:
        //                         widget = ExtendedRawImage(
        //                           image: state.extendedImageInfo?.image,
        //                           width: dimension,
        //                           height: dimension * 0.9,
        //                           fit: BoxFit.contain,
        //                         );
        //                         break;
        //                       case LoadState.failed:
        //                         widget = ExtendedImage.asset(
        //                           'assets/images/placeholder.png',
        //                           fit: BoxFit.cover,
        //                         );
        //                         break;
        //                     }
        //                     return widget;
        //                   },
        //                 )
        //                 // Tools.image(
        //                 //                 url: product.images[i],
        //                 //                 height: dimension * 0.9,
        //                 //                 width: dimension,
        //                 //                 isResize: true,
        //                 //                 fit: BoxFit.contain,
        //                 //               ),
        //                 ),
        //           )
        //       ],
        //     ),
        //   ),
        // );
      },
    );
  }
}
