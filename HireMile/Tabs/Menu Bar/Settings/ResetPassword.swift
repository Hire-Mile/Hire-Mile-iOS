//
//  ResetPassword.swift
//  HireMile
//
//  Created by JJ Zapata on 11/20/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit
import FirebaseAuth

class ResetPassword: UIViewController {
    
    let bigView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 7
        view.layer.shadowOpacity = 0.05
        return view
    }()
    
    let buttonOfMail : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 235/255, green: 234/255, blue: 234/255, alpha: 1)
        button.clipsToBounds = true
        button.setImage(UIImage(systemName: "envelope"), for: .normal)
        button.tintColor = UIColor.black
        button.imageView?.tintColor = UIColor.black
        button.imageView?.image?.withTintColor(UIColor.black)
        button.layer.cornerRadius = 17.5
        return button
    }()
    
    let topLabel : UILabel = {
        let label = UILabel()
        label.text = "Via Email"
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let bottomLabel : UILabel = {
        let label = UILabel()
        label.text = "Send reset link to email address"
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let actionButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(sendResendLink), for: .touchUpInside)
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
        self.view.addSubview(self.bigView)
        self.view.addSubview(self.buttonOfMail)
        self.view.addSubview(self.topLabel)
        self.view.addSubview(self.bottomLabel)
        self.view.addSubview(self.actionButton)
    }

    func addConstraints() {
        self.bigView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        self.bigView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        self.bigView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        self.bigView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.buttonOfMail.centerYAnchor.constraint(equalTo: self.bigView.centerYAnchor).isActive = true
        self.buttonOfMail.leftAnchor.constraint(equalTo: self.bigView.leftAnchor, constant: 20).isActive = true
        self.buttonOfMail.widthAnchor.constraint(equalToConstant: 35).isActive = true
        self.buttonOfMail.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        self.topLabel.topAnchor.constraint(equalTo: bigView.topAnchor, constant: 10).isActive = true
        self.topLabel.leftAnchor.constraint(equalTo: self.buttonOfMail.rightAnchor, constant: 10).isActive = true
        self.topLabel.rightAnchor.constraint(equalTo: self.bigView.rightAnchor, constant: -10).isActive = true
        self.topLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        self.bottomLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor).isActive = true
        self.bottomLabel.leftAnchor.constraint(equalTo: self.buttonOfMail.rightAnchor, constant: 10).isActive = true
        self.bottomLabel.rightAnchor.constraint(equalTo: self.bigView.rightAnchor, constant: -10).isActive = true
        self.bottomLabel.bottomAnchor.constraint(equalTo: self.bigView.bottomAnchor, constant: -15).isActive = true
        
        self.actionButton.topAnchor.constraint(equalTo: self.bigView.topAnchor).isActive = true
        self.actionButton.leftAnchor.constraint(equalTo: self.bigView.leftAnchor).isActive = true
        self.actionButton.rightAnchor.constraint(equalTo: self.bigView.rightAnchor).isActive = true
        self.actionButton.bottomAnchor.constraint(equalTo: self.bigView.bottomAnchor).isActive = true
    }

    func basicSetup() {
        self.view.backgroundColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.mainBlue
        title = "Reset Password"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func sendResendLink() {
        Auth.auth().sendPasswordReset(withEmail: Auth.auth().currentUser!.email!) { (error) in
            if error == nil {
                let alert = UIAlertController(title: "Success!", message: "Password reset link has been sent to your registered email ", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Success!", message: error!.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        let alert = UIAlertController(title: "Success!", message: "Password reset link has been sent to your registered email ", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }

}
