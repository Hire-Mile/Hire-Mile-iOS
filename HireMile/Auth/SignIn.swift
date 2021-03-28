//
//  ViewController.swift
//  HireMile
//
//  Created by JJ Zapata on 11/15/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import Foundation
import FirebaseAuth
import LocalAuthentication
import AuthenticationServices
import FirebaseDatabase
import MBProgressHUD
import CryptoKit

class SignIn: UIViewController, ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate, UITextFieldDelegate {
    
    var currentNonce: String?
    
    let context = LAContext()
    
    var error: NSError?
    
    let welcomeLabel : UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Welcome to", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.black])
        attributedText.append(NSAttributedString(string: "\nHiremile", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 40   )]))
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        attributedText.addAttributes([NSAttributedString.Key.paragraphStyle: style], range: NSMakeRange(0, attributedText.length))
        label.attributedText = attributedText
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailTextField : UITextField = {
        let textfield = UITextField()
        textfield.tintColor = UIColor.mainBlue
        textfield.placeholder = "Enter your email"
        textfield.borderStyle = .roundedRect
        textfield.autocapitalizationType = .none
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
        textfield.autocapitalizationType = .none
        textfield.layer.cornerRadius = 15
        textfield.textColor = UIColor.black
        textfield.keyboardType = .default
        textfield.isSecureTextEntry = true
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    let forgotPasswordButton : UIButton = {
        let button = UIButton()
        button.setTitle("Forgot Password?", for: .normal)
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(forgotPasswordPressed), for: .touchUpInside)
        return button
    }()
    
    let loginButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.mainBlue
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 22.5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
        return button
    }()
    
    let appleButton : ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.cornerRadius = 22.5
        button.addTarget(self, action: #selector(applePressed), for: .touchUpInside)
        return button
    }()
    
    let signUpButton : UIButton = {
        let button = UIButton(type: .system)
        let title = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSMutableAttributedString.Key.foregroundColor: UIColor.darkGray])
        title.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.mainBlue]))
        button.setAttributedTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(signUpPressed), for: .touchUpInside)
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
            // biometrics stuff
            if UserDefaults.standard.bool(forKey: "biometrics") {
                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                        let reason = "Please Identify Yourself!"

                        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                            [unowned self] success, authenticationError in

                            DispatchQueue.main.async {
                                if success {
                                    let sb = UIStoryboard(name: "TabStoryboard", bundle: nil)
                                    let vc: UIViewController = sb.instantiateViewController(withIdentifier: "TabbControllerID") as! TabBarController
                                    UIApplication.shared.keyWindow?.rootViewController = vc
                                } else {
                                    let ac = UIAlertController(title: "Authentication failed", message: "Sorry!", preferredStyle: .alert)
                                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                                    present(ac, animated: true)
                                }
                            }
                        }
                    } else {
                        let ac = UIAlertController(title: "Biometrics not available", message: "Your device is not configured for Touch ID.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        present(ac, animated: true)
                    }
            } else {
                let sb = UIStoryboard(name: "TabStoryboard", bundle: nil)
                let vc: UIViewController = sb.instantiateViewController(withIdentifier: "TabbControllerID") as! TabBarController
                UIApplication.shared.keyWindow?.rootViewController = vc
            }
        }
    }
    
    func addSubviews() {
        self.view.addSubview(welcomeLabel)
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(forgotPasswordButton)
        self.view.addSubview(loginButton)
        self.view.addSubview(appleButton)
        self.view.addSubview(signUpButton)
    }
    
    func addConstraints() {
        self.welcomeLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
        self.welcomeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.welcomeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 20).isActive = true
        self.welcomeLabel.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        self.emailTextField.topAnchor.constraint(equalTo: self.welcomeLabel.bottomAnchor, constant: 25).isActive = true
        self.emailTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.emailTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.emailTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.passwordTextField.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 20).isActive = true
        self.passwordTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.passwordTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.passwordTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.forgotPasswordButton.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 5).isActive = true
        self.forgotPasswordButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.forgotPasswordButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
        self.forgotPasswordButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.loginButton.topAnchor.constraint(equalTo: self.forgotPasswordButton.bottomAnchor, constant: 20).isActive = true
        self.loginButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.loginButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.loginButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.appleButton.topAnchor.constraint(equalTo: self.loginButton.bottomAnchor, constant: 20).isActive = true
        self.appleButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.appleButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.appleButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.signUpButton.topAnchor.constraint(equalTo: self.appleButton.bottomAnchor, constant: 30).isActive = true
        self.signUpButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.signUpButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.signUpButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    func checkUserAgainstDatabase(completion: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { return }
        currentUser.getIDTokenForcingRefresh(true) { (idToken, error) in
            if let error = error {
                completion(false, error as NSError?)
                print(error.localizedDescription)
            } else {
                completion(true, nil)
            }
        }
    }
    
    @objc func forgotPasswordPressed() {
        let controller = ForgotPassword()
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func loginPressed() {
        if self.emailTextField.text! == "" || self.passwordTextField.text! == "" {
            print("cannot go ")
        } else {
            self.signInWith(email: self.emailTextField.text!, password: self.passwordTextField.text!)
        }
    }
    
    @objc func applePressed() {
        signUpWithApple()
    }
    
    @objc func signUpPressed() {
        let controller = SignUp()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
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
    
    func signInWith(email: String?, password: String?) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Auth.auth().signIn(withEmail: email!, password: password!) { authResult, error in
            if error == nil {
                MBProgressHUD.hide(for: self.view, animated: true)
//                let controller = TabBarController()
//                controller.modalPresentationStyle = .fullScreen
//                self.present(controller, animated: true, completion: nil)
                
                let sb = UIStoryboard(name: "TabStoryboard", bundle: nil)
                let vc: UIViewController = sb.instantiateViewController(withIdentifier: "TabbControllerID") as! TabBarController
                UIApplication.shared.keyWindow?.rootViewController = vc
            } else {
                MBProgressHUD.hide(for: self.view, animated: true)
                let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func signUpWithApple() {
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
//                let controller = TabBarController()
//                controller.modalPresentationStyle = .fullScreen
//                self.present(controller, animated: true, completion: nil)
                
                let sb = UIStoryboard(name: "TabStoryboard", bundle: nil)
                let vc: UIViewController = sb.instantiateViewController(withIdentifier: "TabbControllerID") as! TabBarController
                UIApplication.shared.keyWindow?.rootViewController = vc
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

