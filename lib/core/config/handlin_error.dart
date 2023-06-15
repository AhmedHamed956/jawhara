import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
// import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:jawhara/core/config/shared_data.dart';
import 'package:jawhara/core/constants/colors.dart';

class HandlingError {
  HandlingError._();

  static final HandlingError handle = HandlingError._();

  ///// Helpers Functions ////////
  void debugApi({
    String fileName = "Api.dart",
    @required String methodName,
    @required int statusCode,
    @required response,
    @required data,
    @required url,
  }) {
    debugPrint(
      "-------- 🟢 --------\n"
      "FileName: $fileName\n"
      "Method: $methodName\n"
      "${url != null ? 'URL: $url\n' : ''}"
      "${data != null ? 'Sent with data: $data\n' : ''}"
      "Returned with statusCode: $statusCode\n"
      "${response != null ? 'Returned with Response: $response\n' : ''}"
      "-------------------",
      wrapWidth: 600,
    );
  }

  bool isValidResponse(int statusCode, {String status}) {
    return statusCode >= 200;
  }

  showError({context, String error, DioError dioError}) {
    if (dioError != null)
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response?.statusCode ?? "UNKNOWN"}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "Error message: ${dioError.response.requestOptions.path}\n"
        "-------------------",
        wrapWidth: 600,
      );
    BotToast.closeAllLoading();
    return
      // SharedData.debugMode == true
      //   ? showModalBottomSheet(
      //       context: context,
      //       builder: (builder) {
      //         return ListView(
      //           children: <Widget>[
      //             Container(
      //               child: HtmlWidget(
      //                 error == 'CATCH'
      //                     ? dioError.type.index == 5
      //                         ? """<h1>INTERNET CONNECTION</h1>"""
      //                         : """${dioError.response.data}"""
      //                     : dioError.type.index == 3
      //                         ? """${dioError.response}"""
      //                         : """$error""",
      //                 hyperlinkColor: Theme.of(context).primaryColor,
      //               ),
      //               padding: EdgeInsets.all(40.0),
      //             )
      //           ],
      //         );
      //       })
      //   :
    alertFlush(
            context: context,
            color: AppColors.redColor,
            icon: Icons.error,
            value: error == 'CATCH'
                ? dioError.type.index == 5
                    ? translate('internet_connection')
                    : dioError.type.index == 3
                        ? """${dioError.response.statusCode == 400 || dioError.response.statusCode == 401 || dioError.response.statusCode == 404 ? dioError.response.data['message'] : dioError.message}"""
                        : dioError.message.toString()
                : error,
          );
  }

  alertFlush({value, icon, context, color, seconds = 2}) {
    bool inDebugMode = true;
    // assert(inDebugMode = true);
    if (inDebugMode)
      return BotToast.showText(
        text: value,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        contentColor: color,
        contentPadding: EdgeInsets.all(8),
        duration: Duration(seconds: seconds)
      );
  }
}
