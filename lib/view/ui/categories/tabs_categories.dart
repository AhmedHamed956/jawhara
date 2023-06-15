
import '../../index.dart';

class TabsCategories extends StatelessWidget {
  CategoriesChildrenDatum _cat = CategoriesChildrenDatum();
  TabsCategories(this._cat);

  @override
  Widget build(BuildContext context) {
    double kHeight = MediaQuery.of(context).size.width / 3;
    return ListView(
      children: [
        // Categories
        SubCategoriesCircle(_cat.childrenData),

        // Product Widget
        Wrap(
            children: _cat.linkedProducts
                .map((e) => Container(
                height: kHeight,
                width: kHeight,
                child: ProductScreen(
                  direction: Axis.vertical,
                  product: e,
                )))
                .toList())
      ],
    );
  }
}
