import 'package:cached_network_image/cached_network_image.dart';
import 'package:jawhara/model/home/home.dart';
import '../index.dart';

// ignore: must_be_immutable
class CategoriesSquare extends StatelessWidget {
  final List<DatumDatum> data;
  int fraction;
  double height;

  CategoriesSquare({this.fraction = 3, this.height = 130, this.data});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: this
          .data
          .map(
            (e) => GestureDetector(
              onTap: () => locator<HomeViewModel>().spiderFunction(context, int.parse(e.id), e.level, e.parentId),
              child: Container(
                height: this.height,
                width: MediaQuery.of(context).size.width / this.fraction,
                child: Column(
                  children: [
                    Card(
                      child: CachedNetworkImage(
                        imageUrl: e.image,height: 65,
                        // placeholder: (context, url) =>
                        //     Image.network('https://www.sgpthorncliffe.com/wp-content/uploads/2016/08/jk-placeholder-image.jpg',height: 65),
                      ),
                      elevation: 0,
                      color: Colors.transparent,
                    ),
                    Text(
                      e.name,
                      style: TextStyle(
                        fontSize: 12,
                        // color: const Color(0xff333333),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
      runAlignment: WrapAlignment.center,
    );
  }
}
