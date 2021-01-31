//
//  FeedbackController.swift
//  HireMile
//
//  Created by JJ Zapata on 1/4/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import MBProgressHUD
import FirebaseDatabase

class FeedbackController: UIViewController, UITextFieldDelegate {
    
    let profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = UIColor.black
        return label
    }()
    
    let rateLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.black
        return label
    }()
    
    let star1 : UIButton = {
        let imageView = UIButton(type: .system)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setImage(UIImage(named: "icons8-star-100"), for: .normal)
        imageView.addTarget(self, action: #selector(star1Pressed), for: .touchUpInside)
        imageView.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
        return imageView
    }()
    
    let star2 : UIButton = {
        let imageView = UIButton(type: .system)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setImage(UIImage(named: "icons8-star-100"), for: .normal)
        imageView.addTarget(self, action: #selector(star2Pressed), for: .touchUpInside)
        imageView.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
        return imageView
    }()
    
    let star3 : UIButton = {
        let imageView = UIButton(type: .system)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setImage(UIImage(named: "icons8-star-100"), for: .normal)
        imageView.addTarget(self, action: #selector(star3Pressed), for: .touchUpInside)
        imageView.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
        return imageView
    }()
    
    let star4 : UIButton = {
        let imageView = UIButton(type: .system)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setImage(UIImage(named: "icons8-star-100"), for: .normal)
        imageView.addTarget(self, action: #selector(star4Pressed), for: .touchUpInside)
        imageView.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
        return imageView
    }()
    
    let star5 : UIButton = {
        let imageView = UIButton(type: .system)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setImage(UIImage(named: "icons8-star-100"), for: .normal)
        imageView.addTarget(self, action: #selector(star5Pressed), for: .touchUpInside)
        imageView.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
        return imageView
    }()
    
    let tf : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Leave a comment here"
        tf.tintColor = UIColor.mainBlue
        tf.textColor = UIColor.black
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let bottomBar : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    let applyButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SEND FEEDBACK", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.mainBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 25
        return button
    }()
    
    var rating = 0
    var numberToUpload = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("HELOOO")
        print(GlobalVariables.jobRefId)
        print("HELOOO")
        
        view.backgroundColor = UIColor.white
        
        self.view.addSubview(profileImageView)
        Database.database().reference().child("Users").child(GlobalVariables.chatPartnerId).child("profile-image").observe(.value) { (snapshot) in
            let profileImageString : String = (snapshot.value as? String)!
            if profileImageString == "not-yet-selected" {
                self.profileImageView.image = UIImage(systemName: "person.circle.fill")
                self.profileImageView.tintColor = UIColor.lightGray
                self.profileImageView.contentMode = .scaleAspectFill
            } else {
                self.profileImageView.loadImageUsingCacheWithUrlString(profileImageString)
                self.profileImageView.tintColor = UIColor.lightGray
                self.profileImageView.contentMode = .scaleAspectFill
            }
        }
        self.profileImageView.layer.cornerRadius = 55
        self.profileImageView.layer.masksToBounds = true
        self.profileImageView.widthAnchor.constraint(equalToConstant: 110).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        self.profileImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        self.profileImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.view.addSubview(titleLabel)
        Database.database().reference().child("Users").child(GlobalVariables.chatPartnerId).child("name").observe(.value) { (snapshot) in
            let name : String = (snapshot.value as? String)!
            self.titleLabel.text = name
        }
        self.titleLabel.textAlignment = .center
        self.titleLabel.topAnchor.constraint(equalTo: self.profileImageView.bottomAnchor, constant: 0).isActive = true
        self.titleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.titleLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.view.addSubview(rateLabel)
        self.rateLabel.text = "Rate Me"
        self.rateLabel.textAlignment = .center
        self.rateLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 20).isActive = true
        self.rateLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.rateLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.rateLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        view.addSubview(star3)
        star3.topAnchor.constraint(equalTo: self.rateLabel.bottomAnchor, constant: 5).isActive = true
        star3.centerXAnchor.constraint(equalTo: self.rateLabel.centerXAnchor).isActive = true
        star3.widthAnchor.constraint(equalToConstant: 50).isActive = true
        star3.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(star2)
        star2.topAnchor.constraint(equalTo: self.rateLabel.bottomAnchor, constant: 5).isActive = true
        star2.rightAnchor.constraint(equalTo: self.star3.leftAnchor, constant: -5).isActive = true
        star2.widthAnchor.constraint(equalToConstant: 50).isActive = true
        star2.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(star1)
        star1.topAnchor.constraint(equalTo: self.rateLabel.bottomAnchor, constant: 5).isActive = true
        star1.rightAnchor.constraint(equalTo: self.star2.leftAnchor, constant: -5).isActive = true
        star1.widthAnchor.constraint(equalToConstant: 50).isActive = true
        star1.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(star4)
        star4.topAnchor.constraint(equalTo: self.rateLabel.bottomAnchor, constant: 5).isActive = true
        star4.leftAnchor.constraint(equalTo: self.star3.rightAnchor, constant: 5).isActive = true
        star4.widthAnchor.constraint(equalToConstant: 50).isActive = true
        star4.heightAnchor.constraint(equalToConstant: 50).isActive = true

        view.addSubview(star5)
        star5.topAnchor.constraint(equalTo: self.rateLabel.bottomAnchor, constant: 5).isActive = true
        star5.leftAnchor.constraint(equalTo: self.star4.rightAnchor, constant: 5).isActive = true
        star5.widthAnchor.constraint(equalToConstant: 50).isActive = true
        star5.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(tf)
        self.tf.topAnchor.constraint(equalTo: self.star3.bottomAnchor, constant: 20).isActive = true
        self.tf.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 40).isActive = true
        self.tf.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -40).isActive = true
        self.tf.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.tf.becomeFirstResponder()
        self.tf.delegate = self
        
        view.addSubview(bottomBar)
        self.bottomBar.topAnchor.constraint(equalTo: self.tf.bottomAnchor).isActive = true
        self.bottomBar.leftAnchor.constraint(equalTo: self.tf.leftAnchor).isActive = true
        self.bottomBar.rightAnchor.constraint(equalTo: self.tf.rightAnchor).isActive = true
        self.bottomBar.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(applyButton)
        self.applyButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.applyButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.applyButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        self.applyButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.applyButton.addTarget(self, action: #selector(applyButtonpressed), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Give Feedback"
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .bottom, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    @objc func star5Pressed() {
        self.star1.tintColor = UIColor.mainBlue
        self.star2.tintColor = UIColor.mainBlue
        self.star3.tintColor = UIColor.mainBlue
        self.star4.tintColor = UIColor.mainBlue
        self.star5.tintColor = UIColor.mainBlue
        self.rating = 5
    }
    
    @objc func star4Pressed() {
        self.star1.tintColor = UIColor.mainBlue
        self.star2.tintColor = UIColor.mainBlue
        self.star3.tintColor = UIColor.mainBlue
        self.star4.tintColor = UIColor.mainBlue
        self.star5.tintColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        self.rating = 4
    }
    
    @objc func star3Pressed() {
        self.star1.tintColor = UIColor.mainBlue
        self.star2.tintColor = UIColor.mainBlue
        self.star3.tintColor = UIColor.mainBlue
        self.star4.tintColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        self.star5.tintColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        self.rating = 3
    }
    
    @objc func star2Pressed() {
        self.star1.tintColor = UIColor.mainBlue
        self.star2.tintColor = UIColor.mainBlue
        self.star3.tintColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        self.star4.tintColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        self.star5.tintColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        self.rating = 2
    }
    
    @objc func star1Pressed() {
        self.star1.tintColor = UIColor.mainBlue
        self.star2.tintColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        self.star3.tintColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        self.star4.tintColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        self.star5.tintColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        self.rating = 1
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return (true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func applyButtonpressed() {
        if self.tf.text == "" || self.rating == 0 {
            let alert = UIAlertController(title: "Error", message: "Please leave a comment and review", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("name").observe(.value) { (snapshot) in
                let name : String = (snapshot.value as? String)!
                Database.database().reference().child("Users").child(GlobalVariables.chatPartnerId).child("fcmToken").observe(.value) { (snapshot) in
                    if let token : String = (snapshot.value as? String) {
                        let sender = PushNotificationSender()
                        sender.sendPushNotification(to: token, title: "\(name) gave you feedback!", body: "Open 'My Reviews' on the menu bar to see")
                        self.addAnotherReview() 
                    } else {
                        self.addAnotherReview()
                    }
                }
            }
        }
    }
    
    func addAnotherReview() {
        Database.database().reference().child("Users").child(GlobalVariables.chatPartnerId).child("number-of-ratings").observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? NSNumber {
                let newNumber = Float(value)
                self.numberToUpload = Int(newNumber) + 1
                self.nextAction()
            }
        })
    }
    
    func nextAction() {
        Database.database().reference().child("Users").child(GlobalVariables.chatPartnerId).child("number-of-ratings").setValue(numberToUpload)
        self.addReview()
    }
    
    func addReview() {
        let values = [
            "user-id" : Auth.auth().currentUser!.uid,
            "rating-number" : rating,
            "post-id" : GlobalVariables.jobId,
            "description" : self.tf.text!,
        ] as [String : Any]
        let key = Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("ratings").childByAutoId().key
        let postFeed = ["\(key!)" : values]
        Database.database().reference().child("Users").child(GlobalVariables.chatPartnerId).child("ratings").updateChildValues(postFeed) { (uploadError, ref) in
            print("finished adding review")
            GlobalVariables.isDeleting = false
            GlobalVariables.indexToDelete = 0
            let alert = UIAlertController(title: "Success", message: "Thanks for your feedback!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                print("ok")
            }))
            GlobalVariables.finishedFeedback = true
            
            // add to running
            Database.database().reference().child("Users").child(GlobalVariables.chatPartnerId).child("My_Jobs").child(GlobalVariables.jobRefId).child("job-status").setValue("completed")
            Database.database().reference().child("Users").child(GlobalVariables.chatPartnerId).child("My_Jobs").child(GlobalVariables.jobRefId).child("reason-or-description").setValue(self.tf.text!)
            Database.database().reference().child("Users").child(GlobalVariables.chatPartnerId).child("My_Jobs").child(GlobalVariables.jobRefId).child("rating").setValue(self.rating)
            Database.database().reference().child("Users").child(GlobalVariables.chatPartnerId).child("My_Jobs").child(GlobalVariables.jobRefId).child("is-rating-nil").setValue(false)
            
            MBProgressHUD.hide(for: self.view, animated: true)
            let sb = UIStoryboard(name: "TabStoryboard", bundle: nil)
            let vc: UIViewController = sb.instantiateViewController(withIdentifier: "TabbControllerID") as! TabBarController
            UIApplication.shared.keyWindow?.rootViewController = vc
        }
    }

}
