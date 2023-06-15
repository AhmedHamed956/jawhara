import 'package:cached_network_image/cached_network_image.dart';
import 'package:jawhara/model/home/home.dart';

import '../index.dart';

class SliderBanner extends StatelessWidget {
  final List<DatumDatum> data;

  SliderBanner({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CarouselSlider(
        options: CarouselOptions(
            viewportFraction: 1.0,
            height: 180,
            autoPlay: data.length > 1,
            enableInfiniteScroll: data.length > 1,
            enlargeCenterPage: false),
        items: data
            .map((item) => GestureDetector(
                  onTap: () => locator<HomeViewModel>().spiderFunction(
                      context, int.parse(item.id), item.level, item.parentId),
                  child: Container(
                    child: CachedNetworkImage(
                      imageUrl: item.image,
                      fit: BoxFit.fill,
                    ),
                    width: MediaQuery.of(context).size.width,
                  ),
                ))
            .toList(),
      ),
      width: MediaQuery.of(context).size.width,
    );
  }
}
