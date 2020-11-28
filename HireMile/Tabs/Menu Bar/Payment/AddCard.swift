
//
//  AddCard.swift
//  HireMile
//
//  Created by JJ Zapata on 11/28/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit

class AddCard: UIViewController, UITextFieldDelegate {
    
    let titleView : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.text = "Add Your Details"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cardNumber : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Card Number"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.tintColor = UIColor.mainBlue
        tf.keyboardType = .decimalPad
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let cardHolderName : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Card Holder Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.tintColor = UIColor.mainBlue
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let expiryDate : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Exp. Date"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.tintColor = UIColor.mainBlue
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let cvv : UITextField = {
        let tf = UITextField()
        tf.placeholder = "CVV"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.tintColor = UIColor.mainBlue
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let loginButton : UIButton = {
        let button = UIButton()
        button.setTitle("Add Card", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.mainBlue
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 22.5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addCard), for: .touchUpInside)
        return button
    }()
     
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        // Functions to throw
        self.basicSetup()
    }
    
    func basicSetup() {
        self.view.backgroundColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.topItem?.title = "Add"
        self.navigationController?.navigationBar.tintColor = UIColor.mainBlue
        
        self.view.addSubview(titleView)
        self.titleView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        self.titleView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        self.titleView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        self.titleView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(cardNumber)
        self.cardNumber.delegate = self
        self.cardNumber.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 30).isActive = true
        self.cardNumber.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        self.cardNumber.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        self.cardNumber.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.view.addSubview(cardHolderName)
        self.cardHolderName.delegate = self
        self.cardHolderName.topAnchor.constraint(equalTo: self.cardNumber.bottomAnchor, constant: 16).isActive = true
        self.cardHolderName.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        self.cardHolderName.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        self.cardHolderName.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.view.addSubview(expiryDate)
        self.expiryDate.delegate = self
        self.expiryDate.topAnchor.constraint(equalTo: self.cardHolderName.bottomAnchor, constant: 16).isActive = true
        self.expiryDate.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        self.expiryDate.widthAnchor.constraint(equalToConstant: (self.view.frame.width - 48) / 2).isActive = true
        self.expiryDate.heightAnchor.constraint(equalToConstant: 45).isActive = true
        self.expiryDate.setInputViewDatePicker(target: self, selector: #selector(doneTapped))
        
        self.view.addSubview(cvv)
        self.cvv.delegate = self
        self.cvv.topAnchor.constraint(equalTo: self.cardHolderName.bottomAnchor, constant: 16).isActive = true
        self.cvv.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        self.cvv.widthAnchor.constraint(equalToConstant: (self.view.frame.width - 48) / 2).isActive = true
        self.cvv.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.view.addSubview(loginButton)
        self.loginButton.topAnchor.constraint(equalTo: self.cvv.bottomAnchor, constant: 30).isActive = true
        self.loginButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        self.loginButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        self.loginButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return (true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func doneTapped() {
        if let datePicker = self.expiryDate.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            self.expiryDate.text = dateFormatter.string(from: datePicker.date)
        }
        self.expiryDate.resignFirstResponder()
    }
    
    @objc func addCard() {
        let alert = UIAlertController(title: "Card Successfully Added", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }

}
