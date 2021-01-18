//
//  ViewPostController.swift
//  HireMile
//
//  Created by JJ Zapata on 11/18/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import ZKCarousel
import FirebaseAuth
import FirebaseDatabase

class ViewPostController: UIViewController, UITextFieldDelegate {
    
    var postId = ""
    var authorId = ""
    
    let carousel : UIImageView = {
        let carousel = UIImageView()
        carousel.contentMode = .scaleAspectFill
        carousel.translatesAutoresizingMaskIntoConstraints = false
        return carousel
    }()
    
    let informationView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 40
        view.layer.cornerRadius = 15
        return view
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Job Title"
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    let descriptionLabel : UILabel = {
        let label = UILabel()
        label.text = "Job Description"
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    let priceLabel : UILabel = {
        let label = UILabel()
        label.text = "Price"
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    let profileImage : UIImageView = {
        let imageView = UIImageView()
//        imageView.image = UIImage(named: "woman-profile")
        imageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let textField : UITextField = {
        let tf = UITextField()
        tf.tintColor = UIColor.mainBlue
        tf.textColor = UIColor.black
        tf.backgroundColor = UIColor.white
        tf.borderStyle = .none
        tf.returnKeyType = .done
        tf.placeholder = "Say Something..."
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let seeAllButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.setTitle("SEND", for: .normal)
        button.addTarget(self, action: #selector(sendPressed), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let largeView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1).cgColor
        view.backgroundColor = UIColor.white
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Functions to throw
        self.addSubviews()
        self.addConstraints()
        
        let url = URL(string: GlobalVariables.postImageDownlodUrl)
        self.carousel.kf.setImage(with: url)
//        self.carousel.image! = GlobalVariables.imagePost.image!
        self.titleLabel.text = GlobalVariables.postTitle
        self.descriptionLabel.text = GlobalVariables.postDescription
        if GlobalVariables.type == "Hourly" {
            self.priceLabel.text = "$\(GlobalVariables.postPrice) / Hour"
        } else {
            self.priceLabel.text = "$\(GlobalVariables.postPrice)"
        }
        self.postId = GlobalVariables.postId
        
        Database.database().reference().child("Users").child(GlobalVariables.authorId).child("name").observe(.value) { (snapshot) in
            let name : String = (snapshot.value as? String)!
            self.navigationItem.title = name
        }
        
        print(GlobalVariables.authorId)
        self.authorId = GlobalVariables.authorId
        Database.database().reference().child("Users").child(GlobalVariables.authorId).child("profile-image").observe(.value) { (snapshot) in
            let profileImageUrl : String = (snapshot.value as? String)!
            if profileImageUrl == "not-yet-selected" {
                self.profileImage.image = UIImage(systemName: "person.circle.fill")
                self.profileImage.tintColor = UIColor.lightGray
                self.profileImage.contentMode = .scaleAspectFill
            } else {
                self.profileImage.loadImageUsingCacheWithUrlString(profileImageUrl)
            }
            GlobalVariables.postTitle = ""
            GlobalVariables.postDescription = ""
            GlobalVariables.postPrice = 0
            GlobalVariables.authorId = ""
            GlobalVariables.authorImageView = ""
            GlobalVariables.postId = ""
            GlobalVariables.userUID = ""
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Functions to throw
        self.basicSetup()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func addSubviews() {
        self.view.addSubview(self.carousel)
        self.view.addSubview(self.informationView)
        self.informationView.addSubview(self.titleLabel)
        self.informationView.addSubview(self.descriptionLabel)
        self.informationView.addSubview(self.priceLabel)
        self.informationView.addSubview(self.profileImage)
        self.view.addSubview(self.largeView)
        self.largeView.addSubview(self.seeAllButton)
        self.largeView.addSubview(self.textField)
    }
    
    func addConstraints() {
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        
        self.carousel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.carousel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.carousel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.carousel.heightAnchor.constraint(equalToConstant: self.view.frame.height / 3).isActive = true
        
        self.informationView.topAnchor.constraint(equalTo: self.carousel.bottomAnchor, constant: 20).isActive = true
        self.informationView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        self.informationView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        self.informationView.heightAnchor.constraint(equalToConstant: 125).isActive = true
        
        self.titleLabel.topAnchor.constraint(equalTo: self.informationView.topAnchor, constant: 15).isActive = true
        self.titleLabel.leftAnchor.constraint(equalTo: self.informationView.leftAnchor, constant: 15).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: self.informationView.rightAnchor, constant: -20).isActive = true
        self.titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.descriptionLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: -5).isActive = true
        self.descriptionLabel.leftAnchor.constraint(equalTo: self.informationView.leftAnchor, constant: 15).isActive = true
        self.descriptionLabel.rightAnchor.constraint(equalTo: self.informationView.rightAnchor, constant: -75).isActive = true
        self.descriptionLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.priceLabel.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: -15).isActive = true
        self.priceLabel.leftAnchor.constraint(equalTo: self.informationView.leftAnchor, constant: 15).isActive = true
        self.priceLabel.rightAnchor.constraint(equalTo: self.informationView.rightAnchor, constant: -15).isActive = true
        self.priceLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.profileImage.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: -15).isActive = true
        self.profileImage.rightAnchor.constraint(equalTo: self.informationView.rightAnchor, constant: -15).isActive = true
        self.profileImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.profileImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.largeView.topAnchor.constraint(equalTo: self.informationView.bottomAnchor, constant: 20).isActive = true
        self.largeView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.largeView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.largeView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.seeAllButton.rightAnchor.constraint(equalTo: self.largeView.rightAnchor).isActive = true
        self.seeAllButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.seeAllButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.seeAllButton.centerYAnchor.constraint(equalTo: self.largeView.centerYAnchor).isActive = true
        
        self.textField.topAnchor.constraint(equalTo: self.largeView.topAnchor).isActive = true
        self.textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.textField.leftAnchor.constraint(equalTo: self.largeView.leftAnchor, constant: 20).isActive = true
        self.textField.rightAnchor.constraint(equalTo: self.seeAllButton.leftAnchor, constant: -10).isActive = true
    }
    
    func basicSetup() {
        self.view.backgroundColor = UIColor.white
        
        self.textField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    func changeButtonStatus() {
        if self.textField.text != " " || self.textField.text != "  " || self.textField.text != "   " {
            self.seeAllButton.backgroundColor = UIColor.mainBlue
            self.seeAllButton.setTitleColor(UIColor.white, for: .normal)
        } else {
            self.seeAllButton.backgroundColor = UIColor(red: 242/255, green: 235/255, blue: 235/255, alpha: 1)
            self.seeAllButton.setTitleColor(UIColor(red: 131/255, green: 131/255, blue: 131/255, alpha: 1), for: .normal)
        }
    }
    
    @objc func keyboardUp(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = 0
            self.view.frame.origin.y -= 110
        }
    }
    
    @objc func keyboardDown(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = 0
        }
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        // send uid
        Database.database().reference().child("Jobs").child(postId).child("author").observe(.value) { (snapshot) in
            let profileUID : String = (snapshot.value as? String)!
            GlobalVariables.userUID = profileUID
            self.navigationController?.pushViewController(OtherProfile(), animated: true)
        }
        // following
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("began")
        if textField.text != "  Say Something..." {
            //
        } else {
            self.textField.text = "   "
        }
    }
    
    @objc func textFieldDidChange() {
        self.changeButtonStatus()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.frame.origin.y = 0
        return (true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.frame.origin.y = 0
        self.view.endEditing(true)
    }
    
    @objc func sendPressed() {
        if self.textField.text != " " || self.textField.text != "  " || self.textField.text != "   " || self.textField.text != nil || self.textField.text != "  Say Something..." || self.textField.text != "" {
            let ref = Database.database().reference().child("Messages")
            let childRef = ref.childByAutoId()
            let toId = authorId
            let fromId = Auth.auth().currentUser!.uid
            let timestamp = Int(Date().timeIntervalSince1970)
            let key = Database.database().reference().child("Users").child(toId).child("My_Jobs").childByAutoId().key
            let values = ["text": textField.text!, "toId": toId, "fromId": fromId, "timestamp": timestamp, "first-time" : true, "service-provider" : toId, "job-id" : self.postId, "job-ref-id" : key, "hasViewed" : false, "text-id" : childRef.key] as [String : Any]
            childRef.updateChildValues(values) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }
                
                guard let messageId = childRef.key else { return }
                
                let userMessagesRef = Database.database().reference().child("User-Messages").child(fromId).child(toId).child(messageId)
                userMessagesRef.setValue(1)
                
                let recipientUserMessagesRef = Database.database().reference().child("User-Messages").child(toId).child(fromId).child(messageId)
                recipientUserMessagesRef.setValue(1)
                
                
                Database.database().reference().child("Users").child(toId).child("fcmToken").observe(.value) { (snapshot) in
                    let token : String = (snapshot.value as? String)!
                    let sender = PushNotificationSender()
                    Database.database().reference().child("Users").child(fromId).child("name").observe(.value) { (snapshot) in
                        let name : String = (snapshot.value as? String)!
                        sender.sendPushNotification(to: token, title: "Chat Notification", body: "New message from \(name)")
                    }
                }
                
                self.textField.text = nil
                
                let alert = UIAlertController(title: "Message Sent", message: "Your messsage was sent successfully", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Please enter valid text", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

}
