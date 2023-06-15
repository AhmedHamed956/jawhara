import 'package:cached_network_image/cached_network_image.dart';
import 'package:jawhara/model/home/home.dart';

import '../index.dart';

class Banners extends StatelessWidget {
  final String img;
  final bool isAsset; //check if image is assets or Network
  final DatumDatum datum;

  Banners(this.img, {this.isAsset = true, this.datum});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 120,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: isAsset
          ? Image.asset(
              img,
              fit: BoxFit.fill,
            )
          : GestureDetector(
              onTap: () => datum == null
                  ? null
                  : locator<HomeViewModel>().spiderFunction(context, int.parse(datum.id), datum.level, datum.parentId),
              child: CachedNetworkImage(
                imageUrl:
                img,
                fit: BoxFit.contain,
                errorWidget: (context, error, stackTrace) => Image.asset(
                  'assets/images/placeholder_banner.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
    );
  }
}
