import 'package:jawhara/model/home/home.dart';

import '../index.dart';

class CategoriesButton extends StatelessWidget {
  final List<DatumDatum> data;

  CategoriesButton({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: ListView(
        shrinkWrap: true,
        children: this
            .data
            .map(
              (e) => GestureDetector(
                onTap: () => locator<HomeViewModel>().spiderFunction(context, int.parse(e.id), e.level, e.parentId),
                child: Card(
                  child: Container(
                    width: 150,
                    child: Column(
                      children: [
                        Container(
                          child: Image.network(e.image,fit: BoxFit.cover,),
                          height: 100,
                          width: double.infinity,
                        ),
                        SizedBox(height: 5),
                        Text(e.name, style: TextStyle(color: Color(0xff333333), fontSize: 12), textAlign: TextAlign.center,),
                      ],
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 5),
                  ),
                ),
              ),
            )
            .toList(),
        scrollDirection: Axis.horizontal,
      ),
      width: MediaQuery.of(context).size.width,
      height: 150,
      margin: EdgeInsets.symmetric(vertical: 10),
    );
  }
}
