//
//  ChatLogController.swift
//  HireMile
//
//  Created by JJ Zapata on 12/26/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ChatLogController: UICollectionViewController, UITextFieldDelegate {
    
    let inputTextField : UITextField = {
        let inputTextField = UITextField()
        inputTextField.placeholder = "Write here"
        inputTextField.textColor = UIColor.black
        inputTextField.borderStyle = .none
        inputTextField.layer.cornerRadius = 20
        inputTextField.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        inputTextField.tintColor = UIColor.mainBlue
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        return inputTextField
    }()
    
    let inputTextView : UIView = {
        let inputTextView = UIView()
        inputTextView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        inputTextView.layer.cornerRadius = 20
        inputTextView.translatesAutoresizingMaskIntoConstraints = false
        return inputTextView
    }()
    
    let attachmentButton : UIButton = {
        let attachmentButton = UIButton(type: .system)
        attachmentButton.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        attachmentButton.setImage(UIImage(systemName: "camera"), for: .normal)
        attachmentButton.tintColor = UIColor.darkGray
        attachmentButton.layer.cornerRadius = 20
        attachmentButton.translatesAutoresizingMaskIntoConstraints = false
        return attachmentButton
    }()
    
    let sendButton : UIButton = {
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("SEND", for: .normal)
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        sendButton.setTitleColor(UIColor.white, for: .normal)
        sendButton.backgroundColor = UIColor.mainBlue
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        sendButton.layer.cornerRadius = 20
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        return sendButton
    }()
    
    let secondContainer : UIView = {
        let secondContainer = UIView()
        secondContainer.backgroundColor = UIColor.white
        secondContainer.translatesAutoresizingMaskIntoConstraints = false
        return secondContainer
    }()
    
    let containerView : UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.addBottomShadow()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Chat Log Controller"
        
        collectionView.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
        
        self.setupInputComponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func setupInputComponents() {
        view.addSubview(containerView)
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        view.addSubview(secondContainer)
        secondContainer.topAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        secondContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        secondContainer.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        secondContainer.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        
        containerView.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.addSubview(attachmentButton)
        attachmentButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        attachmentButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        attachmentButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        attachmentButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.addSubview(inputTextView)
        inputTextView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextView.leftAnchor.constraint(equalTo: attachmentButton.rightAnchor, constant: 10).isActive = true
        inputTextView.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -10).isActive = true
        inputTextView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        inputTextView.addSubview(inputTextField)
        inputTextField.delegate = self
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.leftAnchor.constraint(equalTo: inputTextView.leftAnchor, constant: 10).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: inputTextView.rightAnchor, constant: -10).isActive = true
        inputTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    @objc func handleSend() {
        let ref = Database.database().reference().child("Messages")
        let childRef = ref.childByAutoId()
        let values = ["text" : inputTextField.text!, "name" : "Jorge Zapata"]
        childRef.updateChildValues(values)
    }

}
