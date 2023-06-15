import UIKit

//TODO: This class uses our test integration server; please adapt it to use your own backend API.
class Request: NSObject {
    
    // Test merchant server domain
    static let serverDomain = "https://jawhara.online"
    
    static func requestCheckoutID(amount: String, currency: String, paymentType: String,
                                  orderId: String, token: String, completion: @escaping (String?) -> Void) {
        let parameters: [String:String] = [
            "amount": String(format: "%.2f", Double(amount)!),
            "currency": currency,
            // Store notificationUrl on your server to change it any time without updating the app.
            "notificationUrl": serverDomain + "/notification",
            "order_id": orderId,
            "paymentType": paymentType,
            "testMode": "INTERNAL"
        ]
//        var parametersString = ""
//        for (key, value) in parameters {
//            parametersString += key + "=" + value + "&"
//        }
//        parametersString.remove(at: parametersString.index(before: parametersString.endIndex))
        
        let url = serverDomain + "/rest/V1/api/checkout/preparecheckout"
        print("url >", url)
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        print("request >",request)
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if let error = error {
                    // Handle HTTP request error
                print(error)
                } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let checkoutID = json["id"] as? String
                completion(checkoutID)
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    static func requestPaymentStatus(resourcePath: String, orderId: String, token: String, completion: @escaping ([String: Any]) -> Void) {
        let parameters: [String:String] = [
            "id": resourcePath,
            "order_id": orderId
        ]
        let url = serverDomain + "/rest/V1/api/checkout/paymentStatus"
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let transactionStatus = json["paymentResult"] as? String
                let message = json["message"] as? String
                let registrationId = json["registrationId"] as? String
                completion(["success": transactionStatus == "OK", "message": message ?? nil, "registrationId": registrationId ?? nil])
            } else {
                completion(["success": false])
            }
        }.resume()
    }
}
