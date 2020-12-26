//
//  EditProfile.swift
//  HireMile
//
//  Created by JJ Zapata on 11/20/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import MBProgressHUD

class EditProfile: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    var imageHasBeenChanged = false
    
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
        
        // image
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("profile-image").observe(.value) { (snapshot) in
            let profileImageString : String = (snapshot.value as? String)!
            if profileImageString == "not-yet-selected" {
                self.profileImageView.image = UIImage(systemName: "person.circle.fill")
                self.profileImageView.tintColor = UIColor.lightGray
                self.profileImageView.contentMode = .scaleAspectFill
            } else {
                self.profileImageView.loadImageUsingCacheWithUrlString(profileImageString)
                self.profileImageView.tintColor = UIColor.lightGray
                self.profileImageView.contentMode = .scaleAspectFill
            }
        }
        
        // name
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("name").observe(.value) { (snapshot) in
            let userName : String = (snapshot.value as? String)!
            self.currentPassword.text = userName
        }
        
        // zip code
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("zipcode").observe(.value) { (snapshot) in
            let zipcode = snapshot.value as? NSNumber
            let zipcodeInt = Int(zipcode!)
            if zipcodeInt == 0 {
                self.zipCode.text = ""
            } else {
                self.zipCode.text = String(zipcodeInt)
            }
        }
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
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        title = "Edit Profile"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        

        self.currentPassword.delegate = self
    }

    @objc func updatePressed() {
        if self.imageHasBeenChanged == true {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            guard let imageData = profileImageView.image?.jpegData(compressionQuality: 0.75) else { return }
            let storageRef = Storage.storage().reference()
            let storageProfileRef = storageRef.child("Profile").child("\(Auth.auth().currentUser!.uid)").child("ProfileImage")
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            storageProfileRef.putData(imageData, metadata: metadata) { (storageMetadata, putDataError) in
                if putDataError == nil && storageMetadata != nil {
                    storageProfileRef.downloadURL { (url, downloadUrlError) in
                        if let metalImageUrl = url?.absoluteString {
                            Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("profile-image").setValue(metalImageUrl, withCompletionBlock: { (addInfoError, result) in
                                if addInfoError == nil {
                                    if self.currentPassword.text != "" {
                                        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("name").setValue(self.currentPassword.text)
                                    }
                                    if self.zipCode.text != "" {
                                        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("zipcode").setValue(Int(self.zipCode.text!))
                                    }
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                    let alert = UIAlertController(title: "Success!", message: "Your information has been updated.", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
                                        self.navigationController?.popViewController(animated: true)
                                    }))
                                    self.present(alert, animated: true, completion: nil)
                                } else {
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                    let alert = UIAlertController(title: "Error", message: addInfoError!.localizedDescription, preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                }
                            })
                        } else {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            let alert = UIAlertController(title: "Error", message: downloadUrlError!.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                } else {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    let alert = UIAlertController(title: "Error", message: putDataError!.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else {
            if self.currentPassword.text != "" {
                Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("name").setValue(self.currentPassword.text)
            }
            if self.zipCode.text != "" {
                Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("zipcode").setValue(Int(self.zipCode.text!))
            }
            MBProgressHUD.hide(for: self.view, animated: true)
            let alert = UIAlertController(title: "Success!", message: "Your information has been updated.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
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
        self.imageHasBeenChanged = true
        dismiss(animated: true, completion: nil)
    }
}
