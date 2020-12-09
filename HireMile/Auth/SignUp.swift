//
//  SignUp.swift
//  HireMile
//
//  Created by JJ Zapata on 11/16/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import Foundation
import FirebaseAuth
import AuthenticationServices
import FirebaseDatabase
import MBProgressHUD
import CryptoKit

class SignUp: UIViewController, ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate, UITextFieldDelegate {
    
    var currentNonce: String?
    var largeName = ""
    
    let welcomeLabel : UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Create an", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.black])
        attributedText.append(NSAttributedString(string: "\nAccount", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 40   )]))
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        attributedText.addAttributes([NSAttributedString.Key.paragraphStyle: style], range: NSMakeRange(0, attributedText.length))
        label.attributedText = attributedText
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField : UITextField = {
        let textfield = UITextField()
        textfield.tintColor = UIColor.mainBlue
        textfield.placeholder = "Enter your name"
        textfield.borderStyle = .roundedRect
        textfield.layer.cornerRadius = 15
        textfield.textColor = UIColor.black
        textfield.keyboardType = .emailAddress
        textfield.isSecureTextEntry = false
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    let emailTextField : UITextField = {
        let textfield = UITextField()
        textfield.tintColor = UIColor.mainBlue
        textfield.placeholder = "Enter your email"
        textfield.borderStyle = .roundedRect
        textfield.layer.cornerRadius = 15
        textfield.textColor = UIColor.black
        textfield.keyboardType = .emailAddress
        textfield.isSecureTextEntry = false
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    let passwordTextField : UITextField = {
        let textfield = UITextField()
        textfield.tintColor = UIColor.mainBlue
        textfield.placeholder = "Enter your password"
        textfield.borderStyle = .roundedRect
        textfield.layer.cornerRadius = 15
        textfield.textColor = UIColor.black
        textfield.keyboardType = .default
        textfield.isSecureTextEntry = true
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    let signUpButton : UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.mainBlue
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 22.5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(signUpPressed), for: .touchUpInside)
        return button
    }()
    
    let appleButton : ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .signUp, style: .black)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.cornerRadius = 22.5
        button.addTarget(self, action: #selector(applePressed), for: .touchUpInside)
        return button
    }()
    
    let signInButton : UIButton = {
        let button = UIButton(type: .system)
        let title = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSMutableAttributedString.Key.foregroundColor: UIColor.darkGray])
        title.append(NSAttributedString(string: "Login", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.mainBlue]))
        button.setAttributedTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
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
        self.autoSignIn()
    }
    
    func autoSignIn() {
        if Auth.auth().currentUser != nil {
            print(Auth.auth().currentUser!.uid)
            let controller = TabBarController()
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: false, completion: nil)
        }
    }
    
    func addSubviews() {
        self.view.addSubview(welcomeLabel)
        self.view.addSubview(nameTextField)
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(signUpButton)
        self.view.addSubview(appleButton)
        self.view.addSubview(signInButton)
    }
    
    func addConstraints() {
        self.welcomeLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
        self.welcomeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.welcomeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 20).isActive = true
        self.welcomeLabel.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        self.nameTextField.topAnchor.constraint(equalTo: self.welcomeLabel.bottomAnchor, constant: 25).isActive = true
        self.nameTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.nameTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.nameTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.emailTextField.topAnchor.constraint(equalTo: self.nameTextField.bottomAnchor, constant: 25).isActive = true
        self.emailTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.emailTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.emailTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true

        self.passwordTextField.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 20).isActive = true
        self.passwordTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.passwordTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.passwordTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true

        self.signUpButton.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 30).isActive = true
        self.signUpButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.signUpButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.signUpButton.heightAnchor.constraint(equalToConstant: 45).isActive = true

        self.appleButton.topAnchor.constraint(equalTo: self.signUpButton.bottomAnchor, constant: 20).isActive = true
        self.appleButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.appleButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.appleButton.heightAnchor.constraint(equalToConstant: 45).isActive = true

        self.signInButton.topAnchor.constraint(equalTo: self.appleButton.bottomAnchor, constant: 30).isActive = true
        self.signInButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.signInButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.signInButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
    }
    
    @objc func loginPressed() {
        let controller = SignIn()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func applePressed() {
        signUpWithApple()
    }
    
    @objc func signUpPressed() {
        if self.nameTextField.text! == "" || self.emailTextField.text! == "" || self.passwordTextField.text! == "" {
            print("cannot go ")
        } else {
            self.signUpWith(name: self.nameTextField.text!, email: self.emailTextField.text!, password: self.passwordTextField.text!)
        }
    }
    
    func basicSetup() {
        self.view.backgroundColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return (true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func signUpWith(name: String?, email: String?, password: String?) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Auth.auth().createUser(withEmail: email!, password: password!) { result, error in
            if error == nil {
                let infoToAdd : Dictionary<String, Any> = [
                                                            "name" : "\(name!)",
                                                            "email" : "\(email!)",
                                                            "password" : "\(password!)",
                                                            "profile-image" : "not-yet-selected",
                                                            "rating" : 100,
                                                            "zipcode" : 0,
                                                            "services" : 0
                                                        ]
                Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).updateChildValues(infoToAdd)
                MBProgressHUD.hide(for: self.view, animated: true)
                let controller = TabBarController()
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
            } else {
                MBProgressHUD.hide(for: self.view, animated: true)
                let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func signUpWithApple() {
        let alertController = UIAlertController(title: "We need your name!", message: "How should we refer to you?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "Next", style: .default) { (action: UIAlertAction) -> Void in
            let usersName = alertController.textFields![0].text!
            self.largeName = usersName
            alertController.dismiss(animated: true, completion: nil)
            let nonce = self.randomNonceString()
            self.currentNonce = nonce
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            request.nonce = self.sha256(nonce)
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
        alertController.addTextField { (textField : UITextField) in
            textField.placeholder = "Name"
            textField.delegate = self
        }
        alertController.addAction(cancel)
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
    }

    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        return hashString
    }

    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                MBProgressHUD.hide(for: self.view, animated: true)
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                MBProgressHUD.hide(for: self.view, animated: true)
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                MBProgressHUD.hide(for: self.view, animated: true)
                return
            }
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            print("Up To Firebase Now")
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    return
                }
                print("Fine")
                let infoToAdd : Dictionary<String, Any> = [
                                                            "name" : "\(self.largeName)",
                                                            "email" : "\(Auth.auth().currentUser!.email!)",
                                                            "profile-image" : "not-yet-selected",
                                                            "rating" : 100,
                                                            "zipcode" : 0,
                                                            "services" : 0
                                                          ]
                Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).updateChildValues(infoToAdd)
                MBProgressHUD.hide(for: self.view, animated: true)
                let controller = TabBarController()
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple errored: \(error)")
        let errror = error.localizedDescription
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        print("Sign in with Apple errored: \(errror)")
    }

}
