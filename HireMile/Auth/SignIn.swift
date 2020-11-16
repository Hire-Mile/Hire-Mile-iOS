//
//  ViewController.swift
//  HireMile
//
//  Created by JJ Zapata on 11/15/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit
import AuthenticationServices

class SignIn: UIViewController {
    
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
        let button = UIButton()
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
    }
    
    @objc func forgotPasswordPressed() {
        navigationController?.pushViewController(ForgotPassword(), animated: true)
    }
    
    @objc func loginPressed() {
        print("login pressed")
        let controller = TabBarController()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func applePressed() {
        print("apple pressed")
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


}

