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
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
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
        
        /*if txtCardNumber.text!.count == 19 && txtCVV.text!.count == 3 && txtExpiryDate.text!.count == 5 {
            
            let exdate = txtExpiryDate.text!
            let m = String(exdate.prefix(2))
            let y = String(exdate.suffix(2))
            
            let stripCard =
            stripCard.cvc = txtCVV.text!
            stripCard.expYear = UInt(y)!
            stripCard.expMonth = UInt(m)!
            stripCard.number = txtCardNumber.text! //"4242424242424242"
            stripCard.name = txtName.text!
            
            STPAPIClient.shared.createToken(with: stripCard, completion: { (token, error) -> Void in
                if error != nil {
                    self.alertMSG(title: "Error", Message: error!.localizedDescription)
                    return
                }
                var t = "\(String(describing: token!))"
                t = t.replacingOccurrences(of: " (test mode)", with: "", options: NSString.CompareOptions.literal, range: nil)
                print("token =",t)
                print("\(token!.card!.description)")
                
                var dict = [String:Any]()
                dict = ["token":t,"brand":"\(token!.card!.brand)","hashValue":"\(token!.card!.brand.hashValue)","rawValue":"\(token!.card!.brand.rawValue)","tokenId":"\(token!.tokenId)","created":"\(token!.created!)","country":"\(token!.card!.country!)","expMonth":"\(token!.card!.expMonth)","expYear":"\(token!.card!.expYear)","last4":"\(token!.card!.last4!)","client_ip":"\(token!.card!.cardId!)","name":"\(token!.card!.name!)","selectrow":"no"]
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
            })
        }*/
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
