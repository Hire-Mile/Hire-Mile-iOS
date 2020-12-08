//
//  EditProfile.swift
//  HireMile
//
//  Created by JJ Zapata on 11/20/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit

class EditProfile: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
//        imageView.image = UIImage(named: "onboarding3")
        imageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let changeImageButton : UIButton = {
        let button = UIButton()
        button.setTitle("Change Image", for: .normal)
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.backgroundColor = UIColor.clear
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(openImgePicker), for: .touchUpInside)
        return button
    }()

    let currentPassword : UITextField = {
        let textfield = UITextField()
        textfield.tintColor = UIColor.mainBlue
        textfield.placeholder = "Name"
        textfield.borderStyle = .roundedRect
        textfield.layer.cornerRadius = 15
        textfield.textColor = UIColor.black
        textfield.isSecureTextEntry = false
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()

    let zipCode : UITextField = {
        let textfield = UITextField()
        textfield.tintColor = UIColor.mainBlue
        textfield.placeholder = "Zip Code"
        textfield.borderStyle = .roundedRect
        textfield.layer.cornerRadius = 15
        textfield.textColor = UIColor.black
        textfield.isSecureTextEntry = false
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()

    let updatePasswordButton : UIButton = {
        let button = UIButton()
        button.setTitle("APPLY", for: .normal)
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
        self.view.addSubview(profileImageView)
        self.view.addSubview(changeImageButton)
        self.view.addSubview(currentPassword)
        self.view.addSubview(zipCode)
        self.view.addSubview(updatePasswordButton)
    }

    func addConstraints() {
        self.profileImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        self.profileImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.changeImageButton.topAnchor.constraint(equalTo: self.profileImageView.bottomAnchor, constant: 15).isActive = true
        self.changeImageButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.changeImageButton.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        self.changeImageButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.currentPassword.topAnchor.constraint(equalTo: self.changeImageButton.bottomAnchor, constant: 20).isActive = true
        self.currentPassword.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.currentPassword.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.currentPassword.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.zipCode.topAnchor.constraint(equalTo: self.currentPassword.bottomAnchor, constant: 10).isActive = true
        self.zipCode.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.zipCode.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.zipCode.heightAnchor.constraint(equalToConstant: 45).isActive = true

        self.updatePasswordButton.topAnchor.constraint(equalTo: self.zipCode.bottomAnchor, constant: 30).isActive = true
        self.updatePasswordButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.updatePasswordButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.updatePasswordButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }

    func basicSetup() {
        self.view.backgroundColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.mainBlue
        title = "Edit Profile"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        

        self.currentPassword.delegate = self
    }

    @objc func updatePressed() {
        // check for changes
        let alert = UIAlertController(title: "Success!", message: "Your information has been updated.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func openImgePicker() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return (true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            self.profileImageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage{
            self.profileImageView.image = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
}
