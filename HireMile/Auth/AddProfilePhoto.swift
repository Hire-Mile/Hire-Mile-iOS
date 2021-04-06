//
//  AddProfilePhoto.swift
//  HireMile
//
//  Created by JJ Zapata on 2/9/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import MBProgressHUD
import FirebaseDatabase

class AddProfilePhoto: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    var imageHasBeenChanged = false
    
    let profileImage : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.white
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "upload-illus")
        imageView.clipsToBounds = true
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.layer.cornerRadius = 75
        return imageView
    }()
    
    let uploadPhotoButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Upload Photo", for: .normal)
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(uploadPhoto), for: .touchUpInside)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.mainBlue.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let label : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 3
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Please smile and let the community get to know you!"
        return label
    }()
    
    let chooseLibrary : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Choose from Library", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.mainBlue
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(uploadPhoto), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let takePhoto : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Take Photo", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(uploadPhotoTakePhoto), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let button : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.setTitleColor(UIColor(red: 213/255, green: 213/255, blue: 213/255, alpha: 1), for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(nextPressed), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let buttonView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.title = "Upload Image"
        
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.profileImage)
        self.profileImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        self.profileImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        self.profileImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.profileImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -170).isActive = true
        
        self.view.addSubview(self.label)
        self.label.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50).isActive = true
        self.label.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50).isActive = true
        self.label.heightAnchor.constraint(equalToConstant: 80).isActive = true
        self.label.topAnchor.constraint(equalTo: self.profileImage.bottomAnchor, constant: 15).isActive = true
        
        self.view.addSubview(self.chooseLibrary)
        self.chooseLibrary.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.chooseLibrary.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.chooseLibrary.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.chooseLibrary.topAnchor.constraint(equalTo: self.label.bottomAnchor, constant: 25).isActive = true
        
        self.view.addSubview(self.takePhoto)
        self.takePhoto.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.takePhoto.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.takePhoto.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.takePhoto.topAnchor.constraint(equalTo: self.chooseLibrary.bottomAnchor, constant: 15).isActive = true

        self.button.isEnabled = false
        self.view.addSubview(self.button)
        self.button.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.button.topAnchor.constraint(equalTo: self.takePhoto.bottomAnchor, constant: 25).isActive = true

        // Do any additional setup after loading the view.
    }
    
    @objc func uploadPhoto() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func uploadPhotoTakePhoto() {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func nextPressed() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        guard let imageData = profileImage.image?.jpegData(compressionQuality: 0.75) else { return }
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
                                self.successCompletion()
                            } else {
                                MBProgressHUD.hide(for: self.view, animated: true)
                                let alert = UIAlertController(title: "Error", message: addInfoError?.localizedDescription, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        })
                    } else {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        let alert = UIAlertController(title: "Error", message: "There was an error processing your request", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            } else {
                MBProgressHUD.hide(for: self.view, animated: true)
                let alert = UIAlertController(title: "Error", message: putDataError?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            self.profileImage.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage{
            self.profileImage.image = originalImage
        }
        self.imageHasBeenChanged = true
        self.updateButton()
        dismiss(animated: true, completion: nil)
    }
    
    func updateButton() {
        if self.imageHasBeenChanged == true {
            self.buttonEnabled()
        } else {
            self.buttonDiabled()
        }
    }
    
    func buttonEnabled() {
        self.button.isEnabled = true
        self.button.backgroundColor = UIColor.clear
        self.button.setTitleColor(UIColor.black, for: .normal)
    }
    
    func buttonDiabled() {
        self.button.isEnabled = false
        self.button.backgroundColor = UIColor.clear
        self.button.setTitleColor(UIColor(red: 213/255, green: 213/255, blue: 213/255, alpha: 1), for: .normal)
    }
    
    func successCompletion() {
        MBProgressHUD.hide(for: self.view, animated: true)
        let controller = AddUsername()
        controller.imageView = self.profileImage.image
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }

}
