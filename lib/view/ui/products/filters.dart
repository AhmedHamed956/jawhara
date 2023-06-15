import 'package:hexcolor/hexcolor.dart';
import 'package:jawhara/viewModel/products_view_model.dart';

import '../../index.dart';

class Filters extends StatefulWidget {
  Filters({Key key}) : super(key: key);

  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductsViewModel>.reactive(
      viewModelBuilder: () => locator<ProductsViewModel>(),
      disposeViewModel: false,
      // onModelReady: (model) => model.initScreen(context, _cat.id),
      builder: (context, model, child) {
        print('values > ${model.values}');
        return Drawer(
          child: SafeArea(
              child: Scaffold(
            appBar: AppBar(
              title: Text(translate('filter')),
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
              backgroundColor: Colors.white,
            ),
            backgroundColor: Colors.white,
            body: Column(
              children: [
                Expanded(
                  child:
                      // model.isBusy ?Center(child:ShapeLoading()):
                      ListView(
                          padding: EdgeInsets.zero,
                          children: model.availableFilter == null
                              ? <Widget>[Center(heightFactor: 15, child: Text(translate('empty_data')))]
                              : model.availableFilter
                                  .map(
                                    (e) => Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: ExpandableNotifier(
                                          initialExpanded: true,
                                          child: ExpandablePanel(
                                            header: Text(
                                              e.filterName,
                                            ),
                                            theme: ExpandableThemeData(
                                              headerAlignment: ExpandablePanelHeaderAlignment.center,
                                            ),
                                            expanded: SizedBox(
                                              width: double.infinity,
                                              child: e.filterCode == 'price'
                                                  ? Column(
                                                      children: [
                                                        RangeSlider(
                                                          values: model.values,
                                                          min: e.filterRangeMin.toDouble(),
                                                          max: e.filterRangeMax.toDouble(),
                                                          activeColor: AppColors.secondaryColor,
                                                          inactiveColor: AppColors.greyColor,
                                                          onChanged: model.updatePrice,
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 15),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(model.values.start.floorToDouble().toString()),
                                                              Text(model.values.end.floorToDouble().toString()),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : Wrap(
                                                      direction: Axis.horizontal,
                                                      alignment: WrapAlignment.start,
                                                      crossAxisAlignment: WrapCrossAlignment.start,
                                                      runAlignment: WrapAlignment.start,
                                                      children: e.filterOptions.map((i) {
                                                        switch (e.filterCode) {
                                                          case 'price':
                                                            break;
                                                          case 'color':
                                                            {
                                                              return GestureDetector(
                                                                onTap: () => model.checkSelected(e, i)
                                                                    ? model.removeFromSelectedFilters(e, i)
                                                                    : model.addToSelectedFilters(field: e, value: i),
                                                                child: Chip(
                                                                  deleteIcon: CircleAvatar(
                                                                    backgroundColor:
                                                                        i.swatchValue.contains('#') ? HexColor(i.swatchValue) : null,
                                                                    backgroundImage: !i.swatchValue.contains('#')
                                                                        ? NetworkImage('https://i.stack.imgur.com/01XJ7.png')
                                                                        : null,
                                                                    radius: 8,
                                                                  ),
                                                                  onDeleted: () => null,
                                                                  label: Text(
                                                                    i.display,
                                                                    style: TextStyle(fontSize: 12),
                                                                  ),
                                                                  backgroundColor: AppColors.bgColor,
                                                                  shape: model.checkSelected(e, i)
                                                                      ? RoundedRectangleBorder(
                                                                          side: BorderSide(color: AppColors.primaryColor),
                                                                          borderRadius: BorderRadius.all(Radius.circular(100)))
                                                                      : null,
                                                                ),
                                                              );
                                                            }
                                                            break;
                                                          default:
                                                            {
                                                              return GestureDetector(
                                                                onTap: () => model.checkSelected(e, i)
                                                                    ? model.removeFromSelectedFilters(e, i)
                                                                    : model.addToSelectedFilters(field: e, value: i),
                                                                child: Chip(
                                                                  label: Text(
                                                                    i.display,
                                                                    style: TextStyle(fontSize: 12),
                                                                  ),
                                                                  shape: model.checkSelected(e, i)
                                                                      ? RoundedRectangleBorder(
                                                                          side: BorderSide(color: AppColors.primaryColor),
                                                                          borderRadius: BorderRadius.all(Radius.circular(100)))
                                                                      : null,
                                                                  backgroundColor: AppColors.bgColor,
                                                                ),
                                                              );
                                                            }
                                                            break;
                                                        }
                                                      }).toList()),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList()

                          // <Widget>[

                          //   Padding(
                          //     padding: const EdgeInsets.symmetric(horizontal: 10),
                          //     child: ExpandablePanel(
                          //         header: Text(
                          //           translate('color'),
                          //         ),
                          //         headerAlignment: ExpandablePanelHeaderAlignment.center,
                          //         expanded: SizedBox(
                          //           width: double.infinity,
                          //           child: Wrap(
                          //             direction: Axis.horizontal,
                          //             alignment: WrapAlignment.start,
                          //             crossAxisAlignment: WrapCrossAlignment.start,
                          //             runAlignment: WrapAlignment.start,
                          //             children: [
                          //               Chip(
                          //                 deleteIcon: CircleAvatar(
                          //                   backgroundColor: Colors.red,
                          //                   radius: 8,
                          //                 ),
                          //                 onDeleted: () => null,
                          //                 label: Text(
                          //                   'احمر',
                          //                   style: TextStyle(fontSize: 12),
                          //                 ),
                          //                 backgroundColor: AppColors.bgColor,
                          //               ),
                          //               Chip(
                          //                 deleteIcon: CircleAvatar(
                          //                   backgroundColor: Colors.red,
                          //                   radius: 8,
                          //                 ),
                          //                 onDeleted: () => null,
                          //                 label: Text(
                          //                   'احمر',
                          //                   style: TextStyle(fontSize: 12),
                          //                 ),
                          //                 backgroundColor: AppColors.bgColor,
                          //               ),
                          //               Chip(
                          //                 deleteIcon: CircleAvatar(
                          //                   backgroundColor: Colors.red,
                          //                   radius: 8,
                          //                 ),
                          //                 onDeleted: () => null,
                          //                 label: Text(
                          //                   'احمر',
                          //                   style: TextStyle(fontSize: 12),
                          //                 ),
                          //                 backgroundColor: AppColors.bgColor,
                          //               ),
                          //             ],
                          //           ),
                          //         )),
                          //   ),
                          // ],
                          ),
                  flex: 11,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(model.products.length.toString()),
                            Text(
                              translate('products'),
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      )),
                      Wrap(
                        children: [
                          IconButton(
                            onPressed: () => model.clearSelectedFilters(),
                            icon: Icon(
                              Icons.delete,
                              color: Colors.grey,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              model.reCallInit(context);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(primary: AppColors.primaryColor),
                            child: Text(
                              translate('accepted'),
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          SizedBox(width: 10)
                        ],
                      )
                    ],
                  ),
                  flex: 2,
                )
              ],
            ),
          )),
        );
      },
    );
  }
}
