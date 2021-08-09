//
//  RattingVC.swift
//  HireMile
//
//  Created by mac on 11/07/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit
import Cosmos
import MBProgressHUD
import FirebaseDatabase
import FirebaseAuth
class RattingVC: UIViewController {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRattig: UILabel!
    @IBOutlet weak var txtDescryption: UITextView!
    @IBOutlet weak var ratingView: CosmosView!
    
    var ongoingJob:OngoingJobs!
    var userOther : UserChat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        // Do any additional setup after loading the view.
    }
    
    func initUI() {
        lblName.text = userOther.name
        txtDescryption.placeholder = "Say Somenthing about Henry Service?"
    }
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func btnSubmitClick(_ sender: UIButton) {
        guard let chatPartnerId = self.userOther.id else {
            return
        }
        if self.txtDescryption.text == "" || self.ratingView.rating == 0 {
            let alert = UIAlertController(title: "Error", message: "Please leave a comment and review", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            Database.database().reference().child("Users").child(self.userOther.id ?? "").child("fcmToken").observeSingleEvent(of:.value) { (snapshot) in
                if let token : String = (snapshot.value as? String) {
                    let sender = PushNotificationSender()
                    sender.sendPushNotification(to: token, title: "\(self.userOther.name ?? "") gave you feedback!", body: "Open 'My Reviews' on the menu bar to see", page: true, senderId: Auth.auth().currentUser!.uid, recipient: chatPartnerId)
                    self.addReview()
                } else {
                    self.addReview()
                }
            }
        }
    }
 
    
    func addReview() {
        let timestamp = Int(Date().timeIntervalSince1970)
        guard let chatPartnerId = self.userOther.id , let currentUid = Auth.auth().currentUser?.uid else {
            return
        }
        let values = [
            "user-id":currentUid ,
            "rating-number" : ratingView.rating,
            "post-id" : self.ongoingJob.jobId,
            "timestamp" : timestamp,
            "description" : self.txtDescryption.text!,
            "price": "\(self.ongoingJob.price)"
        ] as [String : Any]
        let key = Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("ratings").childByAutoId().key
        let postFeed = ["\(key!)" : values]
        
        let jobsReference = Database.database().reference().child("Ongoing-Jobs")
        jobsReference.child(self.ongoingJob.key).child("rating").child(currentUid).updateChildValues(["rating":ratingView.rating,"review": self.txtDescryption.text!])
        
        Database.database().reference().child("Users").child(chatPartnerId).child("ratings").updateChildValues(postFeed) { (uploadError, ref) in
            print("finished adding review")
            GlobalVariables.isDeleting = false
            GlobalVariables.indexToDelete = 0
            let alert = UIAlertController(title: "Success", message: "Thanks for your feedback!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                print("ok")
            }))
           
            // REMOVE CHAT
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            let sb = UIStoryboard(name: "TabStoryboard", bundle: nil)
            let vc: UIViewController = sb.instantiateViewController(withIdentifier: "TabbControllerID") as! TabBarController
            UIApplication.shared.keyWindow?.rootViewController = vc
            
//            Database.database().reference().child("User-Messages").child(uid).child(chatPartnerId).removeValue { (error, ref) in
//                Database.database().reference().child("User-Messages").child(chatPartnerId).child(uid).removeValue { (error, ref) in
//                    MBProgressHUD.hide(for: self.view, animated: true)
//                    let sb = UIStoryboard(name: "TabStoryboard", bundle: nil)
//                    let vc: UIViewController = sb.instantiateViewController(withIdentifier: "TabbControllerID") as! TabBarController
//                    UIApplication.shared.keyWindow?.rootViewController = vc
//                }
//            }
        }
    }
    
}
