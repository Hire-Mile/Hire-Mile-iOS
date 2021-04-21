//
//  ChangePassword.swift
//  HireMile
//
//  Created by JJ Zapata on 11/20/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ChangePassword: UIViewController, UITextFieldDelegate {

    let currentPassword : MainTextField = {
        let textfield = MainTextField(placeholderString: "Current Password")
        return textfield
    }()
    
    let newPassword : MainTextField = {
        let textfield = MainTextField(placeholderString: "New Password")
        return textfield
    }()
    
    let confirmNewPassword : MainTextField = {
        let textfield = MainTextField(placeholderString: "Confirm New Password")
        return textfield
    }()

    let updatePasswordButton : MainButton = {
        let button = MainButton(title: "Update Password")
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
        self.view.addSubview(newPassword)
        self.view.addSubview(confirmNewPassword)
        self.view.addSubview(updatePasswordButton)
    }

    func addConstraints() {
        self.currentPassword.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        self.currentPassword.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 25).isActive = true
        self.currentPassword.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -25).isActive = true
        self.currentPassword.heightAnchor.constraint(equalToConstant: 45).isActive = true

        self.newPassword.topAnchor.constraint(equalTo: self.currentPassword.bottomAnchor, constant: 25).isActive = true
        self.newPassword.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 25).isActive = true
        self.newPassword.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -25).isActive = true
        self.newPassword.heightAnchor.constraint(equalToConstant: 45).isActive = true

        self.confirmNewPassword.topAnchor.constraint(equalTo: self.newPassword.bottomAnchor, constant: 20).isActive = true
        self.confirmNewPassword.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 25).isActive = true
        self.confirmNewPassword.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -25).isActive = true
        self.confirmNewPassword.heightAnchor.constraint(equalToConstant: 45).isActive = true

        self.updatePasswordButton.topAnchor.constraint(equalTo: self.confirmNewPassword.bottomAnchor, constant: 30).isActive = true
        self.updatePasswordButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 25).isActive = true
        self.updatePasswordButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -25).isActive = true
        self.updatePasswordButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }

    func basicSetup() {
        self.view.backgroundColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        title = "Change Password"
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
        

        self.currentPassword.delegate = self
        self.newPassword.delegate = self
        self.confirmNewPassword.delegate = self
    }

    @objc func updatePressed() {
        if self.newPassword.text == "" || self.currentPassword.text == "" || self.confirmNewPassword.text == "" {
            let alert = UIAlertController(title: "Error", message: "Please input in all textfields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            Auth.auth().currentUser!.updatePassword(to: self.newPassword.text!) { (error) in
                if error == nil {
                    let alert = UIAlertController(title: "Success!", message: "Your password has been changed", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
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
