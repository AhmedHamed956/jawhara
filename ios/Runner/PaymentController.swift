import UIKit
import SafariServices

class PaymentViewController: UIViewController , SFSafariViewControllerDelegate{
    var result : ((_ data: Dictionary<String, Any>) -> Void)?

    var provider: OPPPaymentProvider?
    var transaction: OPPTransaction?
    var safariVC: SFSafariViewController?
    
    var customerToken: String?
    var amount: String?
    var paymentType: String?
    var currency: String?
    var orderId: String?
    var token: String?
    var lang: String?
    var cardNumber: String?
    var cardHolderName: String?
    var expirationDate: String?
    var cvv: String?
    var brand: String?
    var tokenized: Bool?
    var saveCard: Bool?
    var closedByUser: Bool = true
    
    func setResult(_ resultParam : ((_ data: Dictionary<String, Any>)
-> Void)?){
        result = resultParam
    }
    
//    @IBOutlet weak var loader: UIActivityIndicatorView!
    // MARK: - Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.provider = OPPPaymentProvider.init(mode: .live)
        showActivityIndicatory()
        pay()
    }
    
    func pay(){
        Request.requestCheckoutID(amount: amount!, currency: currency!, paymentType: paymentType!, orderId: orderId!, token: customerToken!) { (checkoutID) in
            DispatchQueue.main.async {
                guard let checkoutID = checkoutID else {
//                    Utils.showResult(presenter: self, success: false, message: "Checkout ID is empty")
                    return
                }
                
                guard let transaction = self.createTransaction(checkoutID: checkoutID) else {
//                    self.processingView.stopAnimating()
                    return
                }
                
                self.provider!.submitTransaction(transaction, completionHandler: { (transaction, error) in
                    DispatchQueue.main.async {
//                        self.processingView.stopAnimating()
                        self.handleTransactionSubmission(transaction: transaction, error: error)
                    }
                })
            }
        }
    }
    
    // MARK: - Payment helpers
    
    func createTransaction(checkoutID: String) -> OPPTransaction? {
        do {
            if(tokenized != nil && tokenized! == true){
                let params = try OPPTokenPaymentParams.init(checkoutID: checkoutID, tokenID: token!, paymentBrand: brand!)
                params.shopperResultURL = Config.urlScheme + "://payment"
                return OPPTransaction.init(paymentParams: params)
            }else{
                let expiryYear : String = "20" +  expirationDate!.components(separatedBy: "/")[1]
                let params = try OPPCardPaymentParams.init(checkoutID: checkoutID, paymentBrand: brand!, holder: cardHolderName, number: cardNumber!, expiryMonth: expirationDate!.components(separatedBy: "/")[0], expiryYear: expiryYear, cvv: cvv!)
                params.isTokenizationEnabled = saveCard ?? false
            params.shopperResultURL = Config.urlScheme + "://payment"
            return OPPTransaction.init(paymentParams: params)
            }
        } catch let error as NSError {
//            Utils.showResult(presenter: self, success: false, message: error.localizedDescription)
            print(error.localizedDescription)
            return nil
        }
    }
    
    func handleTransactionSubmission(transaction: OPPTransaction?, error: Error?) {
        guard let transaction = transaction else {
            print(error!.localizedDescription)
//            Utils.showResult(presenter: self, success: false, message: error?.localizedDescription)
            return
        }
        
        self.transaction = transaction
        if transaction.type == .synchronous {
            // If a transaction is synchronous, just request the payment status
            self.requestPaymentStatus()
        } else if transaction.type == .asynchronous {
            // If a transaction is asynchronous, you should open transaction.redirectUrl in a browser
            // Subscribe to notifications to request the payment status when a shopper comes back to the app
            closedByUser = false
            NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveAsynchronousPaymentCallback), name: Notification.Name(rawValue: Config.asyncPaymentCompletedNotificationKey), object: nil)
            self.presenterURL(url: self.transaction!.redirectURL!)
        } else {
//            Utils.showResult(presenter: self, success: false, message: "Invalid transaction")
        }
    }
    
    func presenterURL(url: URL) {
        self.safariVC = SFSafariViewController(url: url)
        self.safariVC?.delegate = self;
        self.present(safariVC!, animated: true, completion: nil)
    }
    
    func requestPaymentStatus() {
        // You can either hard-code resourcePath or request checkout info to get the value from the server
        // * Hard-coding: "/v1/checkouts/" + checkoutID + "/payment"
        // * Requesting checkout info:
        
        guard let checkoutID = self.transaction?.paymentParams.checkoutID else {
//            Utils.showResult(presenter: self, success: false, message: "Checkout ID is invalid")
            return
        }
        self.transaction = nil
        
        self.provider!.requestCheckoutInfo(withCheckoutID: checkoutID) { (checkoutInfo, error) in
            DispatchQueue.main.async {
                guard let resourcePath = checkoutInfo?.resourcePath else {
                    self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                    self.result!(["success": false, "message": "errorWhilePayment", "fromKey": true])
//                    Utils.showResult(presenter: self, success: false, message: "Checkout info is empty or doesn't contain resource path")
                    return
                }
                
                Request.requestPaymentStatus(resourcePath: checkoutID, orderId: self.orderId!, token: self.customerToken!) { (result) in
                    DispatchQueue.main.async {
                        self.closedByUser = false
                        self.navigationController?.popViewController(animated: true)
                        self.dismiss(animated: true, completion: nil)
                        var resultMap: Dictionary<String, Any>
//                        if(result["success"]! as! Bool){
                            resultMap = result
                        var cameWithMessage: Bool = false
                        if(result["message"] as? String != nil){
                            cameWithMessage = true
                        }
                        resultMap["message"] = cameWithMessage ? result["message"] : (result["success"] as! Bool) ? "": "errorWhilePayment"
                        resultMap["fromKey"] = !cameWithMessage
//                        }else{
//                            resultMap = ["success": false, "message": "errorWhilePayment", "fromKey": true]
//                        }
                        self.result!(resultMap)
//                        self.processingView.stopAnimating()
//                        let message = success ? "Your payment was successful" : "Your payment was not successful"
//                        Utils.showResult(presenter: self, success: success, message: message)
                    }
                }
            }
        }
    }
    
    // MARK: - Async payment callback
    
    @objc func didReceiveAsynchronousPaymentCallback() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: Config.asyncPaymentCompletedNotificationKey), object: nil)
        self.safariVC?.dismiss(animated: true, completion: {
            DispatchQueue.main.async {
                self.closedByUser = true
                self.requestPaymentStatus()
            }
        })
    }
    
    // MARK: - Safari Delegate
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true) {
            DispatchQueue.main.async {
                self.requestPaymentStatus()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    func showActivityIndicatory() {
            DispatchQueue.main.async {
                self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 80, height: 80) //or whatever size you would like
                self.activityIndicator.center = CGPoint(x: self.view.bounds.size.width / 2, y: self.view.bounds.height / 2)
                self.activityIndicator.startAnimating()
                self.view.addSubview(self.activityIndicator)
            }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        do {
//            sleep(4)
//        }
//        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "mainOne")
//        self.view.window?.rootViewController = initialViewControlleripad
//        self.view.window?.makeKeyAndVisible()
//        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
//        self.presentingViewController?.dismiss(animated: true, completion: nil)
//        navigationController?.popViewController(animated: true)
//        dismiss(animated: true, completion: nil)
//        result!(["success": false, "message": "Hello from other side"])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if(closedByUser){
            result!(["success": false, "message": "paymentCanceled", "fromKey": true])
        }
    }
}
