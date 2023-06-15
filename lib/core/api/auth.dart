import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jawhara/core/config/shared_data.dart';
import 'package:jawhara/core/constants/colors.dart';
import 'package:jawhara/core/constants/strings.dart';
import 'package:jawhara/model/data/data_form_model.dart';
import 'package:jawhara/model/user.dart';
import 'package:jawhara/view/index.dart';
import 'package:jawhara/viewModel/auth_view_model.dart';
import 'package:provider/provider.dart';
import 'api.dart';

class AuthApi extends Api {
  Future<String> login(context, {String email, String password}) async {
    var data = {
      Strings.USERNAME: email,
      Strings.PASSWORD: password,
    };
    print(
      getCurrentMainApi() + Strings.LOGIN,
    );
    try {
      // Dio Request
      var response = await dio.post(getCurrentMainApi() + Strings.LOGIN, data: data, options: Options(headers: await getHeaders()));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: decoded,
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return response.data;
      } else {
        // Failed
        print(decoded['message']);
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response.statusCode}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "Error response data: ${dioError.response.data}\n"
        "-------------------",
        wrapWidth: 600,
      );
      print(dioError);

      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<User> getUserInfo(context, {String token}) async {
    try {
      // Dio Request
      var response = await dio.get(getCurrentMainApi() + Strings.CUSTOMER_ME, options: Options(headers: await getHeaderUser(token)));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: decoded,
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context,
        //     icon: Icons.done_all,
        //     color: AppColors.greenColor,
        //     value: response.statusCode.toString());
        return User.fromJson(response.data);
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response.statusCode}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<User> signUp(context, {DataForm dataForm}) async {
    var data = dataForm.gender != null
        ? {
            "customer": {
              Strings.EMAIL: dataForm.email,
              Strings.FIRSTNAME: dataForm.firstName,
              Strings.LASTNAME: dataForm.lastName,
              Strings.GENDER: int.tryParse(dataForm.gender),
              // Strings.IS_SUBSCRIBED: dataForm.isSubscribed,
              ...await getStoreId(),
            },
            Strings.PASSWORD: dataForm.password,
          }
        : {
            "customer": {
              Strings.EMAIL: dataForm.email,
              Strings.FIRSTNAME: dataForm.firstName,
              Strings.LASTNAME: dataForm.lastName,
              // Strings.IS_SUBSCRIBED: dataForm.isSubscribed,
              ...await getStoreId(),
            },
            Strings.PASSWORD: dataForm.password,
          };
    print('[data] = $data');
    try {
      // Dio Request
      var response = await dio.post(getCurrentMainApi() + Strings.CUSTOMERS, data: data);

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: decoded,
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return User.fromJson(response.data);
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response.statusCode}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<String> loginGoogle(context, {String token}) async {
    var data = {
      Strings.TOKEN: token,
      Strings.TYPE: 'google',
    };
    print('[data] => $data');
    try {
      // Dio Request
      var response =
          await dio.post(getCurrentMainApi() + Strings.SOCIAL_LOGIN, data: data, options: Options(headers: await getHeaderUser(token)));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: decoded,
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context,
        //     icon: Icons.done_all,
        //     color: AppColors.greenColor,
        //     value: response.statusCode.toString());
        return response.data;
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response.statusCode}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<String> loginFacebook(context, {String token}) async {
    var data = {
      Strings.TOKEN: token,
      Strings.TYPE: 'facebook',
    };
    print('[data] => $data');
    try {
      // Dio Request
      var response =
          await dio.post(getCurrentMainApi() + Strings.SOCIAL_LOGIN, data: data, options: Options(headers: await getHeaderUser(token)));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: decoded,
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context,
        //     icon: Icons.done_all,
        //     color: AppColors.greenColor,
        //     value: response.statusCode.toString());
        return response.data;
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response.statusCode}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<dynamic> loginApple(context, {String token}) async {
    var data = {
      Strings.TOKEN: token,
      Strings.TYPE: 'apple',
    };
    print('[data] => $data');
    print('[URL] => ${getCurrentMainApi() + Strings.SOCIAL_LOGIN}');
    try {
      // Dio Request
      var response =
          await dio.post(getCurrentMainApi() + Strings.SOCIAL_LOGIN, data: data, options: Options(headers: await getHeaderUser(token)));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: decoded,
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context,
        //     icon: Icons.done_all,
        //     color: AppColors.greenColor,
        //     value: response.statusCode.toString());
        return response.data;
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response.statusCode}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<bool> forgetPasswordData(context, {String email}) async {
    var data = {Strings.EMAIL: email, Strings.TEMPLATE: "email_reset"};
    print('[URL] => ${getCurrentMainApi() + Strings.CUSTOMER_PASSWORD}');
    print('[data] => $data');
    try {
      // Dio Request
      var response =
          await dio.put(getCurrentMainApi() + Strings.CUSTOMER_PASSWORD, data: data, options: Options(headers: await getHeaders()));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: decoded,
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context,
        //     icon: Icons.done_all,
        //     color: AppColors.greenColor,
        //     value: response.statusCode.toString());
        return true;
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response.statusCode}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "Error data: ${dioError.response.data}\n"
        "-------------------",
        wrapWidth: 600,
      );
      if (dioError.response.data['message'] == 'No such entity with %fieldName = %fieldValue, %field2Name = %field2Value') {
        handle.showError(context: context, error: translate('mail_not_found'));
      } else
        handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<bool> changePasswordData(context, {DataForm dataForm}) async {
    var data = {Strings.EMAIL: dataForm.email, Strings.RESET_TOKEN: dataForm.verifyCode, Strings.NEW_PASSWORD: dataForm.password};
    print('[data] => $data');
    try {
      // Dio Request
      var response =
          await dio.post(getCurrentMainApi() + Strings.CUSTOMER_RESET_PASSWORD, data: data, options: Options(headers: await getHeaders()));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: decoded,
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context,
        //     icon: Icons.done_all,
        //     color: AppColors.greenColor,
        //     value: response.statusCode.toString());
        return true;
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response.statusCode}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
    }
  }

  Future<String> addGuestCartToLoginUser(context) async {
    final _auth = Provider.of<AuthViewModel>(context, listen: false);
    var url;
    url = getCurrentMainApi() + Strings.GUEST_CART + '${SharedData.cartId}';
    print(url);
    // var data = ;
    // print(data);

    try {
      // Dio Request
      var response = await dio.put(url,
          data: {
            "customerId": _auth.currentUser.id,
            ...await getStoreId(),
          },
          options: Options(
            headers: await getHeaderUser(Strings.USER_TOKEN),
          ));

      // Decoding Response.
      var decoded = response.data;

      // Debugging API response
      handle.debugApi(
        methodName: "${this.runtimeType}",
        statusCode: response.statusCode,
        response: decoded,
        data: '',
        url: response.realUri.path,
      );
      if (handle.isValidResponse(response.statusCode)) {
        // Success
        // handle.alertFlush(
        //     context: context, icon: Icons.done_all, color: AppColors.greenColor, value: response.statusCode.toString());
        return response.data.toString();
      } else {
        // Failed
        handle.showError(context: context, error: decoded['message']);
        return null;
      }
    } on DioError catch (dioError) {
      // if(dioError.error.toString().contains("404")){ //no cart so create one
      //
      // }else {
      debugPrint(
        "-------- 🔴 --------\n"
        "Error: $dioError\n"
        "Error error: ${dioError.error}\n"
        "Error response: ${dioError.response.data}\n"
        "Error type: ${dioError.type.index}\n"
        "Error message: ${dioError.message}\n"
        "-------------------",
        wrapWidth: 600,
      );
      handle.showError(context: context, error: 'CATCH', dioError: dioError);
      return null;
      // }
    }
  }
}
