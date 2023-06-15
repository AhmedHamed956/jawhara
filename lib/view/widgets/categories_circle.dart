import 'package:cached_network_image/cached_network_image.dart';
import 'package:jawhara/model/home/home.dart';

import '../index.dart';

// ignore: must_be_immutable
class CategoriesCircle extends StatelessWidget {
  List<CategoriesChildrenDatum> _cat = List();
  final List<DatumDatum> data;

  CategoriesCircle(this._cat, {this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _cat == null
          ? Wrap(
              children: this.data.isEmpty
                  ? [
                      Center(
                          heightFactor: 10,
                          child: Text(translate('empty_data')))
                    ]
                  : this.data.map(
                      (e) {
                        return GestureDetector(
                          onTap: () => locator<HomeViewModel>().spiderFunction(
                              context, int.parse(e.id), e.level, e.parentId),
                          child: Container(
                            height: 120,
                            width: MediaQuery.of(context).size.width / 3,
                            child: GridTile(
                              child: Card(
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl:
                                    e.image ?? '',
                                    fit: BoxFit.cover,
                                    errorWidget: (context, error, stackTrace) =>
                                        Image.asset(
                                      'assets/images/placeholder.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                elevation: 0,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: Colors.transparent,
                                shape: RoundedRectangleBorder(),
                                margin: EdgeInsets.only(bottom: 20,right: 10,left: 10,top: 5),
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
                        );
                      },
                    ).toList(),
              runAlignment: WrapAlignment.center,
            )
          : Wrap(
              children:
                  this._cat.map(
                (e) {
                  return GestureDetector(
                    onTap: () {
                      final check = e.childrenData.firstWhere((element) => element.childrenData.isNotEmpty, orElse: () => null);
                      print('check > $check');
                      if (check != null) {
                        return Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: CategoriesPage(e.childrenData),
                          ),
                        );
                      }else
                      {
                        return Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: ProductsPage(e.childrenData),
                          ),
                        );
                      }
                    },
                    child: Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width / 3,
                      child: GridTile(
                        child: new Card(
                          child: CachedNetworkImage(
                            imageUrl:
                            e.thumbnail ?? '',
                            fit: BoxFit.cover,
                            errorWidget: (context, error, stackTrace) =>
                                Image.asset(
                              'assets/images/placeholder.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                          elevation: 0,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(),
                          margin: EdgeInsets.only(bottom: 20,right: 10,left: 10,top: 5),
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
                  );
                },
              ).toList(),
              runAlignment: WrapAlignment.center,
            ),
      margin: EdgeInsets.only(bottom: 15),
      color: AppColors.bgColor,
    );
  }
}
