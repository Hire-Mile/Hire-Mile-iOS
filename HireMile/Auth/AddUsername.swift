//
//  AddUsername.swift
//  HireMile
//
//  Created by JJ Zapata on 3/4/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD

class AddUsername: UIViewController, UITextFieldDelegate {
    
    var imageHasBeenChanged = false
    
    var imageView : UIImage? {
        didSet {
            self.profileImage.image = imageView
        }
    }
    
    var isTaken = false
    var wordLimit = false
    
    var takenUsernames = [String]()
    
    let profileImage : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.white
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "upload-illus")
        imageView.clipsToBounds = true
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.layer.cornerRadius = 75
        return imageView
    }()
    
    let currentPassword : UITextField = {
        let textfield = UITextField()
        textfield.tintColor = UIColor.mainBlue
        textfield.placeholder = "Enter a username"
        textfield.autocapitalizationType = .none
        textfield.borderStyle = .roundedRect
        textfield.layer.cornerRadius = 15
        textfield.textColor = UIColor.black
        textfield.isSecureTextEntry = false
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    let label : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = NSTextAlignment.left
        label.numberOfLines = 3
        label.textColor = UIColor.red
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Error message here"
        return label
    }()
    
    let button : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.setTitleColor(UIColor(red: 213/255, green: 213/255, blue: 213/255, alpha: 1), for: .normal)
        button.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(nextPressed), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let buttonView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let backButtonView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 21
        view.backgroundColor = .white
        return view
    }()
    
    let backButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        button.backgroundColor = .clear
        return button
    }()
    
    let backButtonImage : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.tintColor = UIColor.black
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "chevron.backward")
        return imageView
    }()
    
    @objc func backButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.title = "Choose A Username"
        
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.profileImage)
        self.profileImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        self.profileImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        self.profileImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.profileImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -200).isActive = true
        
        self.view.addSubview(self.currentPassword)
        self.currentPassword.delegate = self
        self.currentPassword.addTarget(self, action: #selector(self.textChanged), for: UIControl.Event.editingChanged)
        self.currentPassword.topAnchor.constraint(equalTo: self.profileImage.bottomAnchor, constant: 30).isActive = true
        self.currentPassword.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.currentPassword.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.currentPassword.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.view.addSubview(self.label)
        self.label.isHidden = true
        self.label.topAnchor.constraint(equalTo: self.currentPassword.bottomAnchor, constant: 5).isActive = true
        self.label.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.label.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.label.heightAnchor.constraint(equalToConstant: 20).isActive = true

        self.button.isEnabled = false
        self.view.addSubview(self.button)
        self.button.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.button.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        
        view.addSubview(backButtonView)
        backButtonView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        backButtonView.heightAnchor.constraint(equalToConstant: 42).isActive = true
        backButtonView.widthAnchor.constraint(equalToConstant: 42).isActive = true
        backButtonView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        
        backButtonView.addSubview(backButtonImage)
        backButtonImage.centerXAnchor.constraint(equalTo: self.backButtonView.centerXAnchor).isActive = true
        backButtonImage.centerYAnchor.constraint(equalTo: self.backButtonView.centerYAnchor).isActive = true
        backButtonImage.widthAnchor.constraint(equalToConstant: 25).isActive = true
        backButtonImage.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        backButtonView.addSubview(backButton)
        backButton.topAnchor.constraint(equalTo: backButtonView.topAnchor).isActive = true
        backButton.leftAnchor.constraint(equalTo: backButtonView.leftAnchor).isActive = true
        backButton.rightAnchor.constraint(equalTo: backButtonView.rightAnchor).isActive = true
        backButton.bottomAnchor.constraint(equalTo: backButtonView.bottomAnchor).isActive = true
        
        self.findCurrents()

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return (true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func nextPressed() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("username").setValue(self.currentPassword.text)
        self.successCompletion()
    }
    
    func findCurrents() {
        Database.database().reference().child("Users").observe(.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                let username : String?
                username = value["username"] as? String
                if let username = username {
                    self.takenUsernames.append(username)
                }
            }
        }
    }
    
    @objc func textChanged() {
        if let text = self.currentPassword.text?.lowercased() {
            if text.count < 7 || text == "" || text == " " {
                isTaken = false
                wordLimit = true
                self.updateButton()
            } else {
                isTaken = false
                wordLimit = false
                self.label.isHidden = true
                self.updateButton()
                self.checkForOpen()
            }
        }
    }
    
    func checkForOpen() {
        if let text = self.currentPassword.text?.lowercased() {
            for username in self.takenUsernames {
                if username.lowercased() == text {
                    print("taken")
                    isTaken = true
                    self.checkAvailability()
                } else {
                    isTaken = false
                    self.checkAvailability()
                }
            }
        }
    }
    
    @objc func updateButton() {
        if self.wordLimit {
            self.showErrorView(withText: "Username requires of 8 characters")
        } else {
            self.removeError()
        }
    }
    
    @objc func checkAvailability() {
        if self.isTaken {
            self.showErrorView(withText: "Username is already taken")
        } else {
            self.removeError()
        }
    }
    
    func removeError() {
        self.label.isHidden = true
        
        // button enable
        self.button.isEnabled = true
        self.button.backgroundColor = UIColor.mainBlue
        self.button.setTitleColor(UIColor.white, for: .normal)
        
        self.wordLimit = false
//        self.isTaken = false
    }
    
    func showErrorView(withText text: String) {
        self.label.isHidden = false
        self.label.text = text
        
        // button disable
        self.button.isEnabled = false
        self.button.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
        self.button.setTitleColor(UIColor(red: 213/255, green: 213/255, blue: 213/255, alpha: 1), for: .normal)
    }
    
    func successCompletion() {
        MBProgressHUD.hide(for: self.view, animated: true)
        let controller = AllowLocation()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }

}
