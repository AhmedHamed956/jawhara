import 'package:flutter/material.dart';
import 'package:jawhara/model/products/products.dart';

class SelectedFilterItem{
  AvailableFilter field;
  List<FilterOption> values;
  RangeValues rangeValue;
  bool price;

  SelectedFilterItem({this.field, this.values, this.rangeValue, this.price = false});
}