//
//  AddCardVC.swift
//  HireMile
//
//  Created by mac on 11/07/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit
import Stripe
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Alamofire
import SwiftyJSON
import SafariServices

class AddCardVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var vwError1: UIView!
    @IBOutlet weak var lblError1: UILabel!
    @IBOutlet weak var lblError2: UILabel!
    @IBOutlet weak var imgCardNumber: UIImageView!
    @IBOutlet weak var imgCVV: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCardNumber: UITextField!
    @IBOutlet weak var txtExpiryDate: UITextField!
    @IBOutlet weak var txtCVV: UITextField!
    @IBOutlet weak var btnAddCard: UIButton!
    
    var arrToken = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtCardNumber.delegate = self
        txtExpiryDate.delegate = self
        txtCVV.delegate = self
        
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("Cards").observe(.value) { (usernameSnap) in
            print(usernameSnap)
            if let username = usernameSnap.value as? [[String:Any]] {
                self.arrToken = username
                print(self.arrToken)
            }
        }
        
//        let individual = STPConnectAccountIndividualParams()
//        individual.email = "jay@gmial.com"
//        let param = STPConnectAccountParams(individual: individual)
//
//        STPAPIClient.shared.createToken(withConnectAccount: param) { token, error in
//            let token = token?.tokenId ?? ""
//            debugPrint(token)
//            self.postRequest(token: token)
//        }
        
        guard let email = Auth.auth().currentUser?.email else {
           return
        }
        
//        let payment = STPPaymentIntentParams(clientSecret: "Bearer sk_test_T7azo8VosFz9hDdPCsnYK5mm")
//        payment.paymentMethodId = "tok_1JUAzvEA38NoxHvrY2NFzAjE"
//        payment.sourceId = "tok_1JUAzvEA38NoxHvrY2NFzAjE"
//        payment.receiptEmail = email
//        STPAPIClient.shared.confirmPaymentIntent(with: payment) { intent, error in
//            debugPrint(intent)
//            debugPrint(error.debugDescription)
//        }
        
        
        
        let parameters: [String: Any] = [
            "payment_method":"card_1JWgsJEA38NoxHvrHuB2Q6xR"

            ]
        let header = HTTPHeaders.init([HTTPHeader.init(name: "Content-Type", value: "application/x-www-form-urlencoded"),HTTPHeader.init(name: "Authorization", value: "Bearer sk_test_T7azo8VosFz9hDdPCsnYK5mm")])
        AF.request("https://api.stripe.com/v1/payment_intents/pi_3JWhcXEA38NoxHvr1W0Te7iN/confirm", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: header, interceptor: nil, requestModifier: nil).responseJSON { (response) in
            if let data = response.data {
                let json = JSON(data)
                let id = json["id"].stringValue
                
                debugPrint(json)
                var dict = [String:Any]()
                dict = ["id":id]
//                Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("Stripe").setValue(dict, withCompletionBlock: { (addInfoError, result) in
//                    if addInfoError == nil {
//
//                    }
//                })
            }
        }


//        let parameters: [String: Any] = [
//            "amount" : 1000,
//            "currency": "usd",
//            "payment_method_types":["card"],
//            "payment_method":"card_1JWgsJEA38NoxHvrHuB2Q6xR",
//            "receipt_email":email,
//            "customer": "cus_K8QpB3Z9MfTS55",
////            "confirm": true,
//            "transfer_data": ["destination":"acct_1JW2Fb2RV1M05Uqh"]
//            ]
//        let header = HTTPHeaders.init([HTTPHeader.init(name: "Content-Type", value: "application/x-www-form-urlencoded"),HTTPHeader.init(name: "Authorization", value: "Bearer sk_test_T7azo8VosFz9hDdPCsnYK5mm")])
//        AF.request("https://api.stripe.com/v1/payment_intents", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: header, interceptor: nil, requestModifier: nil).responseJSON { (response) in
//            if let data = response.data {
//                let json = JSON(data)
//                let id = json["id"].stringValue
//                //self.postRequest(token: id)
//                debugPrint(json)
//                var dict = [String:Any]()
//                dict = ["id":id]
////                Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("Stripe").setValue(dict, withCompletionBlock: { (addInfoError, result) in
////                    if addInfoError == nil {
////
////                    }
////                })
//            }
//        }
        //postRequest(token: "acct_1JUXzn2Svd26R0oa")
        
//        let bankAccount = STPBankAccountParams()
//        bankAccount.accountHolderName = "jaydeep"
//        bankAccount.accountHolderType = .individual
//        bankAccount.accountNumber = "000999999991"
//        bankAccount.country = "US"
//        bankAccount.currency = "USD"
//        bankAccount.routingNumber = "110000000"
//        STPAPIClient.shared.createToken(withBankAccount: bankAccount) { token, error in
//            debugPrint(token)
//            guard let tokenid = token?.tokenId else {
//                return
//            }
//            debugPrint(tokenid)
//            let parameters: [String: Any] = [
//                        "source" : tokenid
//                        ]
//            let header = HTTPHeaders.init([HTTPHeader.init(name: "Content-Type", value: "application/x-www-form-urlencoded"),HTTPHeader.init(name: "Authorization", value: "Bearer sk_test_T7azo8VosFz9hDdPCsnYK5mm")])
//            AF.request("https://api.stripe.com/v1/customers/cus_K8QpB3Z9MfTS55/sources", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: header, interceptor: nil, requestModifier: nil).responseJSON { (response) in
//                if let data = response.data {
//                    let json = JSON(data)
//                    debugPrint(json)
//                    let token = json["id"].stringValue
//
//                }
//            }
//        }
        
//        let parameters: [String: Any] = [
//            "amounts" : [32,45]
//            ]
//        let header = HTTPHeaders.init([HTTPHeader.init(name: "Content-Type", value: "application/x-www-form-urlencoded"),HTTPHeader.init(name: "Authorization", value: "Bearer sk_test_T7azo8VosFz9hDdPCsnYK5mm")])
//        AF.request("https://api.stripe.com/v1/customers/cus_K8QpB3Z9MfTS55/sources/ba_1JUASZEA38NoxHvrFncKrASC/verify", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: header, interceptor: nil, requestModifier: nil).responseJSON { (response) in
//            if let data = response.data {
//                let json = JSON(data)
//                debugPrint(json)
//                let token = json["id"].stringValue
//
//            }
//        }
        
//            let parameters: [String: Any] = [
//                "amount" : 2000,
//                "currency":"usd",
//                "source":"tok_1JUAzvEA38NoxHvrY2NFzAjE",
//                "description": "testing charge",
//                "customer": "cus_K8QpB3Z9MfTS55"
//                ]
//            let header = HTTPHeaders.init([HTTPHeader.init(name: "Content-Type", value: "application/x-www-form-urlencoded"),HTTPHeader.init(name: "Authorization", value: "Bearer sk_test_T7azo8VosFz9hDdPCsnYK5mm")])
//            AF.request("https://api.stripe.com/v1/charges", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: header, interceptor: nil, requestModifier: nil).responseJSON { (response) in
//                if let data = response.data {
//                    let json = JSON(data)
//                    debugPrint(json)
//
//
//                }
//            }
        
//        let parameters: [String: Any] = [
//            :
//            ]
//        let header = HTTPHeaders.init([HTTPHeader.init(name: "Content-Type", value: "application/x-www-form-urlencoded"),HTTPHeader.init(name: "Authorization", value: "Bearer sk_test_T7azo8VosFz9hDdPCsnYK5mm")])
//        AF.request("https://api.stripe.com/v1/charges/ch_3JUB1kEA38NoxHvr0FqUK2ce/capture", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: header, interceptor: nil, requestModifier: nil).responseJSON { (response) in
//            if let data = response.data {
//                let json = JSON(data)
//                debugPrint(json)
//
//
//            }
//        }
//
//        let parameters: [String: Any] = [
//            "amount":1000,
//            "currency":"usd",
//            "destination":"ba_1JUASZEA38NoxHvrFncKrASC"
//            ]
//        let header = HTTPHeaders.init([HTTPHeader.init(name: "Content-Type", value: "application/x-www-form-urlencoded"),HTTPHeader.init(name: "Authorization", value: "Bearer sk_test_T7azo8VosFz9hDdPCsnYK5mm")])
//        AF.request("https://api.stripe.com/v1/payouts", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: header, interceptor: nil, requestModifier: nil).responseJSON { (response) in
//            if let data = response.data {
//                let json = JSON(data)
//                debugPrint(json)
//
//
//            }
//        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func postRequest(token:String) {
        let parameters: [String: Any] = [
                "account" : token,
                "refresh_url" : "https://example.com/reauth",
                "return_url" : "https://example.com/return",
                "type": "account_onboarding"
            ]
        let header = HTTPHeaders.init([HTTPHeader.init(name: "Content-Type", value: "application/x-www-form-urlencoded"),HTTPHeader.init(name: "Authorization", value: "Bearer sk_test_T7azo8VosFz9hDdPCsnYK5mm")])//
        AF.request("https://api.stripe.com/v1/account_links", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: header, interceptor: nil, requestModifier: nil).responseJSON { (response) in
            if let data = response.data {
                let json = JSON(data)
                debugPrint(json)
                let url = json["url"].stringValue
                let svc = SFSafariViewController(url: URL(string: url)!)
                self.present(svc, animated: true, completion: nil)
            }
        }
    }
    // MARK: Button Action
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddCardClick(_ sender: UIButton) {
        vwError1.isHidden = true
        lblError2.isHidden = true
        self.createToken()
    }
    
    // MARK:-  Call API 
    
    func createToken() {
        
        if txtCardNumber.text!.count == 19 && txtCVV.text!.count == 3 && txtExpiryDate.text!.count == 5 {
            
            let exdate = txtExpiryDate.text!
            let m = String(exdate.prefix(2))
            let y = String(exdate.suffix(2))
            
            let stripCard = STPCardParams()
            stripCard.cvc = txtCVV.text!
            stripCard.expYear = UInt(y)!
            stripCard.expMonth = UInt(m)!
            stripCard.number = txtCardNumber.text! //"4242424242424242"
            stripCard.name = txtName.text!
            
            STPAPIClient.shared.createToken(withCard: stripCard) { token, error in
                if error != nil {
                    self.alertMSG(title: "Error", Message: error!.localizedDescription)
                    return
                }
                var t = "\(String(describing: token!))"
                t = t.replacingOccurrences(of: " (test mode)", with: "", options: NSString.CompareOptions.literal, range: nil)
                print("token =",t)
                print("\(token!.card!.description)")
                
                var dict = [String:Any]()
                dict = ["token":t,"brand":"\(token!.card!.brand)","hashValue":"\(token!.card!.brand.hashValue)","rawValue":"\(token!.card!.brand.rawValue)","tokenId":"\(token!.tokenId)","created":"\(token!.created!)","country":"\(token!.card!.country!)","expMonth":"\(token!.card!.expMonth)","expYear":"\(token!.card!.expYear)","last4":"\(token!.card!.last4)","client_ip":"\(token!.card!.cardId!)","name":"\(token!.card!.name!)","selectrow":"no"]
                print(dict)
                
                self.arrToken.append(dict)
                
                Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("Cards").setValue(self.arrToken, withCompletionBlock: { (addInfoError, result) in
                    if addInfoError == nil {
                        print("successfully")
                        self.alertMSG(title: "Add Card", Message: "Your card add successfully!")
                    }else{
                        self.alertMSG(title: "Error", Message: addInfoError!.localizedDescription)
                    }
                })
            }
        }
        
    }
    

    func alertMSG(title:String,Message:String)  {
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK:-  TextField Delegate 
           
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // only allow numerical characters
            guard string.compactMap({ Int(String($0)) }).count ==
                string.count else { return false }

            guard let stringRange = Range(range, in: textField.text!) else { return false }
            let updatedText = textField.text!.replacingCharacters(in: stringRange, with: string)
            
            let text = textField.text ?? ""
            if (textField == self.txtCardNumber){
                
                if string.count == 0 {
                    textField.text = String(text.dropLast()).chunkFormatted(withChunkSize: 4, withSeparator: " ")
                }else {
                    let newText = String((text + string)
                        .filter({ $0 != " " }).prefix(16))
                    textField.text = newText.chunkFormatted(withChunkSize: 4, withSeparator: " ")
                }
            }else if (textField == self.txtExpiryDate){
                if string.count == 0 {
                    textField.text = String(text.dropLast()).chunkFormatted(withChunkSize: 2, withSeparator: "/")
                }else {
                    let newText = String((text + string)
                        .filter({ $0 != " " }).prefix(5))
                    textField.text = newText.chunkFormatted(withChunkSize: 2, withSeparator: "/")
                }
            }else{
                if updatedText.count >= 4 {
                    return false
                }else{
                    return true
                }
            }
            return false
        }
}
