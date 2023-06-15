import UIKit
import Flutter
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var flutterResult: FlutterResult?
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let channelName = "jawhara.channels/payment"
    let rootViewController : FlutterViewController = window?.rootViewController as! FlutterViewController
    let methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: rootViewController as! FlutterBinaryMessenger)
        methodChannel.setMethodCallHandler {(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            self.flutterResult = result
            
            if (call.method == "hyperPayPayment") {
                guard let args = call.arguments else {
                  return
                }
                if let myArgs = args as? [String: Any],
                    let customerToken = myArgs["customerToken"] as? String?,
                    let amount = myArgs["amount"] as? String?,
                    let paymentType = myArgs["paymentType"] as? String?,
                    let currency = myArgs["currency"] as? String?,
                    let orderId = myArgs["orderId"] as? String?,
                    let lang = myArgs["lang"] as? String?,
                    let cardNumber = myArgs["cardNumber"] as? String?,
                    let cardHolderName = myArgs["cardHolderName"] as? String?,
                    let expirationDate = myArgs["expirationDate"] as? String?,
                    let cvv = myArgs["cvv"] as? String?,
                    let brand = myArgs["brand"] as? String?,
                    let token = myArgs["token"] as? String?,
                    let tokenized = myArgs["tokenized"] as? Bool?,
                    let saveCard = myArgs["saveCard"] as? Bool?{
                    
                    let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let initialViewControlleripad = mainStoryboardIpad.instantiateViewController(withIdentifier: "paymentVC") as? PaymentViewController
                    initialViewControlleripad!.setResult(self.resultFunc)
                    initialViewControlleripad?.customerToken = customerToken
                    initialViewControlleripad?.amount = amount
                    initialViewControlleripad?.currency = currency
                    initialViewControlleripad?.paymentType = paymentType
                    initialViewControlleripad?.orderId = orderId
                    initialViewControlleripad?.lang = lang
                    initialViewControlleripad?.cardNumber = cardNumber
                    initialViewControlleripad?.cardHolderName = cardHolderName
                    initialViewControlleripad?.expirationDate = expirationDate
                    initialViewControlleripad?.cvv = cvv
                    initialViewControlleripad?.brand = brand
                    initialViewControlleripad?.token = token
                    initialViewControlleripad?.tokenized = tokenized
                    initialViewControlleripad?.saveCard = saveCard
                    
                    let navigationController:UINavigationController! = UINavigationController(rootViewController:initialViewControlleripad!)
                      rootViewController.present(navigationController, animated:true, completion:nil)
                    
    //                rootViewController.presentedViewController?.pushViewController(initialViewControlleripad!, animated: true)
    //                self.window = UIWindow(frame: UIScreen.main.bounds)
    //                self.window?.rootViewController = initialViewControlleripad
    //                self.window?.makeKeyAndVisible()
                    
    //              result("Params received on iOS = \(amount), \(currency)")
    //                let storyboard : UIStoryboard? = UIStoryboard.init(name: "Main", bundle: nil);
    //                let window: UIWindow = ((UIApplication.shared.delegate?.window)!)!
    //                let storyBoard : UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
    //                let paymentVC = storyBoard.instantiateViewController(withIdentifier: "paymentVC") as? PaymentViewController
    //                paymentVC!.setResult(self.resultFunc)
    //                OperationQueue.main.addOperation {
    //                    self.pushViewController(paymentVC!, animated: true)
    //                }
    //                if let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController{
    //                    navController.pushViewController(paymentVC!, animated: true)
    //                }
    //OperationQueue.main.addOperation {
    //                let objVC: PaymentViewController? = storyboard!.instantiateViewController(withIdentifier: "paymentVC") as? PaymentViewController
    ////                let aObjNavi = UINavigationController(rootViewController: objVC!)
    ////                window.rootViewController = aObjNavi
    ////                let paymentViewController : PaymentViewController = PaymentViewController()
    //                objVC!.result = {() -> Void in result(["success": false, "message": "Error From IOS"])}
    ////                objVC.result!()
    //                self.present(objVC!, animated: true, completion: nil)
    ////                aObjNavi.pushViewController(paymentViewController, animated: true)
    //                }
                } else {
                  result(FlutterError(code: "-1", message: "iOS could not extract " +
                     "flutter arguments in method: (sendParams)", details: nil))
                }
                print("dfgdfgfdgfdgfdgdfg")
                
            }
        }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("dddd")
    }
    
//    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//
//       Messaging.messaging().apnsToken = deviceToken
//       super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
//     }
    
    func resultFunc(_ data: Dictionary<String, Any>){
        self.flutterResult!(data)
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        if Auth.auth().canHandle(url) {
//            return true
//        }
        // Make sure that URL scheme is identical to the registered one 
        if url.scheme?.localizedCaseInsensitiveCompare(Config.urlScheme) == .orderedSame {
            // Send notification to handle result in the view controller. 
            NotificationCenter.default.post(name: Notification.Name(rawValue: Config.asyncPaymentCompletedNotificationKey), object: nil);
            return true
        };
        return false
    }
    

}
