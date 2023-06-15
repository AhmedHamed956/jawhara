import 'package:jawhara/view/index.dart';

class SharedData {
  SharedData._();
  static String currency = "ر.س";
  static String lang;
  static bool dev = true;
  //Debug Mode
  static bool debugMode = true;
  static String quoteId;
  static String cartId;

}
String checkResponseData(value){
  print('value > $value');
  if(value == 'Product that you are trying to add is not available.'){
    return translate('product_not_available');
  }else if(value == 'The requested qty is not available'){
    return translate('notAvailable');
  }else{
    return value;
  }
}