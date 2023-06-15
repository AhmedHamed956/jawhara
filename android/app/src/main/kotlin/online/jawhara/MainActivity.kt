//package com.`is`.jawhara
//
//import io.flutter.embedding.android.FlutterActivity
//
//class MainActivity: FlutterActivity() {
//}

package online.jawhara

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.util.Log
import com.google.android.gms.common.GoogleApiAvailability
import com.huawei.hms.api.ConnectionResult
import com.huawei.hms.api.HuaweiApiAvailability
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
//    private val CHANNEL = "jawhara.channels/payment"
//    private lateinit var methodChannelResult: MethodChannel.Result;
    var concurrentContext = this@MainActivity.context

//    override
//    fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        GeneratedPluginRegistrant.registerWith(flutterEngine)
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
//            methodChannelResult = result;
//            if (call.method == "hyperPayPayment") {
//                val customerToken: String? = call.argument("customerToken");
//                val amount: String? = call.argument("amount");
//                val paymentType: String? = call.argument("paymentType");
//                val currency: String? = call.argument("currency");
//                val orderId: String? = call.argument("orderId");
//                val lang: String? = call.argument("lang");
//                val cardNumber: String? = call.argument("cardNumber");
//                val cardHolderName: String? = call.argument("cardHolderName");
//                val expirationDate: String? = call.argument("expirationDate");
//                val cvv: String? = call.argument("cvv");
//                val brand: String? = call.argument("brand");
//                val token: String? = call.argument("token");
//                val tokenized: Boolean? = call.argument("tokenized");
//                val saveCard: Boolean? = call.argument("saveCard");
////                print("amount :: " + amount + "currency :: " + currency + "paymentType :: " + paymentType + "orderId :: " + orderId + "lang :: " + lang);
////                paymentHandler.payment(this, amount, currency, paymentType, orderId);
//                val intent = Intent(this, CheckoutUIActivity::class.java)
//                intent.putExtra("customerToken", customerToken)
//                intent.putExtra("amount", amount)
//                intent.putExtra("currency", currency)
//                intent.putExtra("paymentType", paymentType)
//                intent.putExtra("orderId", orderId)
//                intent.putExtra("lang", lang)
//                if (tokenized != null && tokenized) {
//                    intent.putExtra("token", token)
//                    intent.putExtra("tokenized", true)
//                } else {
//                    intent.putExtra("tokenized", false)
//                    intent.putExtra("saveCard", saveCard)
//                }
//                intent.putExtra("cardNumber", cardNumber)
//                intent.putExtra("cardHolderName", cardHolderName)
//                intent.putExtra("expirationDate", expirationDate)
//                intent.putExtra("cvv", cvv)
//                intent.putExtra("brand", brand)
//                startActivityForResult(intent, 4)
//            } else if (call.method.equals("isHmsAvailable")) {
//                result.success(isHmsAvailable());
//            } else if (call.method.equals("isGmsAvailable")) {
//                result.success(isGmsAvailable());
//            } else {
//                result.notImplemented()
//            }
//        }
//    }
//
//    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent) {
//        if (requestCode == 4) {
//            when (resultCode) {
//                Activity.RESULT_OK -> {
//                    methodChannelResult.success(mapOf("success" to data.getBooleanExtra("success", false), "message" to data.getStringExtra("message"), "fromKey" to data.getBooleanExtra("fromKey", false), "registrationId" to data.getStringExtra("registrationId")))
//                }
//                Activity.RESULT_CANCELED -> {
//                    methodChannelResult.success(mapOf("success" to data.getBooleanExtra("success", false), "message" to data.getStringExtra("message"), "fromKey" to data.getBooleanExtra("fromKey", false)))
//                }
//
//            }
//        } else {
//            super.onActivityResult(requestCode, resultCode, data)
//        }
//    }

    private fun isHmsAvailable(): Boolean {
        var isAvailable = false
        val context: Context = concurrentContext
        if (null != context) {
            val result = HuaweiApiAvailability.getInstance().isHuaweiMobileServicesAvailable(context)
            isAvailable = ConnectionResult.SUCCESS == result
        }
        Log.i("MainActivity", "isHmsAvailable: $isAvailable")
        return isAvailable
    }

    private fun isGmsAvailable(): Boolean {
        var isAvailable = false
        val context: Context = concurrentContext
        if (null != context) {
            val result: Int = GoogleApiAvailability.getInstance().isGooglePlayServicesAvailable(context)
            isAvailable = com.google.android.gms.common.ConnectionResult.SUCCESS === result
        }
        Log.i("MainActivity", "isGmsAvailable: $isAvailable")
        return isAvailable
    }
}
