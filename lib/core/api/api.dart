import 'package:dio/dio.dart';
import 'package:jawhara/core/config/handlin_error.dart';
import 'package:jawhara/core/config/shared_data.dart';
import 'package:jawhara/core/constants/strings.dart';

class Api {
  final HandlingError handle = HandlingError.handle;
  Dio dio = new Dio();

  getCurrentMainApi({lang}) {
    String _lang = lang != null ? lang : SharedData.lang;
    if (_lang == "en") {
      return Strings.MAIN_API_URL_EN;
    } else {
      return Strings.MAIN_API_URL_AR;
    }
  }

  Future<Map<String, String>> getStoreId() async {
    String _lang = SharedData.lang;
    if (_lang == "en") {
      return <String, String>{Strings.STORE_ID: '2'};
    } else {
      return <String, String>{Strings.STORE_ID: '1'};
    }
  }

  Future<Map<String, String>> getHeaders() async {
    print('Bearer ${Strings.ADMIN_TOKEN}');
    return <String, String>{
      'Authorization': 'Bearer ${Strings.ADMIN_TOKEN}',
      // 'Content-Type': 'application/json'
      // 'Accept-Language': SharedData.lang
    };
  }

  Future<Map<String, String>> getHeaderUser(token) async {
    print({
      'Authorization': 'Bearer $token',
    });
    return <String, String>{
      'Authorization': 'Bearer $token',
    };
  }
}
