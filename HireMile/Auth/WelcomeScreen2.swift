//
//  WelcomeScreen.swift
//  HireMile
//
//  Created by JJ Zapata on 4/5/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit
import LocalAuthentication
import Firebase
import FirebaseAuth
import FirebaseDatabase

class WelcomeScreen2: UIViewController {
    
    // MARK: - Variables
    
    let context = LAContext()
    
    var error: NSError?
    
    // MARK: - Constants
    
    let headerImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "on-foto")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        return imageView
    }()
    
    let signInButton : UIButton = {
        let button = UIButton(type: .system)
        let prompt1 = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)])
        let prompt2 = NSAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.foregroundColor : UIColor.mainBlue, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)])
        prompt1.append(prompt2)
        button.backgroundColor = UIColor.clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(prompt1, for: .normal)
        button.addTarget(self, action: #selector(signInButtonPressed), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let signUpButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.mainBlue
        button.setTitle("Create Account", for: .normal)
        button.titleLabel!.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(signUpButtonPressed), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let text : UILabel = {
        let label = UILabel()
        let title = NSMutableAttributedString(string: "Earn Money", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 24)])
        let description = NSAttributedString(string: "\n\nSearch among the best workers near your neighborhood for any task or project that you need performed quickly and efficiently.", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)])
        title.append(description)
        label.attributedText = title
        label.numberOfLines = 100
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
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
        view.addSubview(headerImage)
        headerImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerImage.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        headerImage.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        headerImage.heightAnchor.constraint(equalToConstant: 548).isActive = true
        
        view.addSubview(signInButton)
        signInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        signInButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        signInButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(signUpButton)
        signUpButton.bottomAnchor.constraint(equalTo: signInButton.topAnchor, constant: -15).isActive = true
        signUpButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        signUpButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(text)
        text.topAnchor.constraint(equalTo: headerImage.bottomAnchor).isActive = true
        text.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        text.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        text.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -30).isActive = true
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
