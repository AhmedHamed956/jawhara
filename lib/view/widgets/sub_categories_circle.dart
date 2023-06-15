

import 'package:cached_network_image/cached_network_image.dart';

import '../index.dart';

// ignore: must_be_immutable
class SubCategoriesCircle extends StatelessWidget {
  List<CategoriesChildrenDatum> _cat = List();
  SubCategoriesCircle(this._cat);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children:  this._cat.isEmpty
            ? [Center(heightFactor: 10, child: Text(translate('empty_data')))]
            : this._cat
            .map(
              (e) => GestureDetector(
                onTap: ()=> Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: ProductsPage(e.childrenData),
                  ),
                ),
                child: Container(
                  height: 115,
                  width: MediaQuery.of(context).size.width / 4,
                  child: GridTile(
                    child: CachedNetworkImage(
                      imageUrl:
                      e.image ?? '',
                      fit: BoxFit.contain,
                      errorWidget: (context, error, stackTrace) => Image.asset(
                        'assets/images/placeholder.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    footer: Text(
                      e.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        // color: const Color(0xff333333),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
        runAlignment: WrapAlignment.center,
      ),
      margin: EdgeInsets.only(bottom: 15),
      color: AppColors.bgColor,
    );
  }
}
