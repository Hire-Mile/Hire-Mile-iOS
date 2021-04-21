//
//  WelcomeScreen.swift
//  HireMile
//
//  Created by JJ Zapata on 4/5/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit
import Foundation
import LocalAuthentication
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class WelcomeScreen: UIViewController {
    
    // MARK: - Variables
    
    let context = LAContext()
    
    var error: NSError?
    
    // MARK: - Constants
    
    let signUpButton : MainButton = {
        let button = MainButton(title: "Create Account")
        button.addTarget(self, action: #selector(signUpButtonPressed), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let signInButton : MainSecondaryButton = {
        let button = MainSecondaryButton(title: "Sign In")
        button.addTarget(self, action: #selector(signInButtonPressed), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let text : UILabel = {
        let label = UILabel()
        let title = NSMutableAttributedString(string: "By continuing, you are agreeing to our", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)])
        let description = NSAttributedString(string: " Terms of Service & Privacy Policy", attributes: [NSAttributedString.Key.foregroundColor : UIColor.mainBlue, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        title.append(description)
        label.attributedText = title
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 100
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Hiremile"
        label.font = UIFont.boldSystemFont(ofSize: 60)
        label.textColor = UIColor.mainBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    // MARK: - Overriden Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        autoSignIn()
        
        constraints()
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        constraints()
    }
    
    func constraints() {
        
        view.addSubview(text)
        text.heightAnchor.constraint(equalToConstant: 50).isActive = true
        text.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        text.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        text.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -155).isActive = true
        
        view.addSubview(signInButton)
        signInButton.bottomAnchor.constraint(equalTo: text.topAnchor, constant: -60).isActive = true
        signInButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        signInButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        view.addSubview(signUpButton)
        signUpButton.bottomAnchor.constraint(equalTo: signInButton.topAnchor, constant: -15).isActive = true
        signUpButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        signUpButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: signUpButton.topAnchor).isActive = true
    }
    
    // MARK: - Objective-C Functions
    
    @objc func signInButtonPressed() {
        presentViewController(SignInController())
    }
    
    @objc func signUpButtonPressed() {
        presentViewController(SignUp())
    }
    
    // MARK: - Helper Functions
    
    func presentViewController(_ viewController: UIViewController) {
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
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

}
