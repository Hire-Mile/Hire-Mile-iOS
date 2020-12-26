//
//  Email.swift
//  HireMile
//
//  Created by JJ Zapata on 11/20/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import MBProgressHUD

class Email: UIViewController, UITextFieldDelegate {

    let currentPassword : UITextField = {
        let textfield = UITextField()
        textfield.tintColor = UIColor.mainBlue
        textfield.placeholder = "New email"
        textfield.borderStyle = .roundedRect
        textfield.layer.cornerRadius = 15
        textfield.textColor = UIColor.black
        textfield.isSecureTextEntry = false
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()

    let updatePasswordButton : UIButton = {
        let button = UIButton()
        button.setTitle("Change Email", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.mainBlue
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 22.5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(updatePressed), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Functions to throw
        self.addSubviews()
        self.addConstraints()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Functions to throw
        self.basicSetup()
    }

    func addSubviews() {
        self.view.addSubview(currentPassword)
        self.view.addSubview(updatePasswordButton)
    }

    func addConstraints() {
        self.currentPassword.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        self.currentPassword.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.currentPassword.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.currentPassword.heightAnchor.constraint(equalToConstant: 45).isActive = true

        self.updatePasswordButton.topAnchor.constraint(equalTo: self.currentPassword.bottomAnchor, constant: 30).isActive = true
        self.updatePasswordButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.updatePasswordButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.updatePasswordButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }

    func basicSetup() {
        self.view.backgroundColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        title = "Change Email"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        

        self.currentPassword.delegate = self
    }

    @objc func updatePressed() {
        if self.currentPassword.text == "" {
            let alert = UIAlertController(title: "Error", message: "Please input in all textfields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            Auth.auth().currentUser!.updateEmail(to: self.currentPassword.text!) { (error) in
                if error != nil {
                    let errorAlert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(errorAlert, animated: true, completion: nil)
                } else {
                    Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("email").setValue(self.currentPassword.text!)
                    let alert = UIAlertController(title: "Success!", message: "Your email has been changed", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return (true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
