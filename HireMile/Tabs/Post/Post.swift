//
//  Post.swift
//  HireMile
//
//  Created by JJ Zapata on 11/16/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import MBProgressHUD

class Post: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var isCurrentlyEditing = false
    
    let imagePicker = UIImagePickerController()
    let pickeringView = UIPickerView()
    let pickerData = ["Development / Design", "Repairs / Cleaning", "Teaching / Tutoring", "Writing", "Sales & Marketing", "SEO", "Public Relations", "Translation", "Other"]

    let backButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.imageView?.tintColor = UIColor.black
        button.tintColor = UIColor.black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(exitTapped), for: .touchUpInside)
        return button
    }()

    let backgroundImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "hireMilePostBackDrop")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        // image will have hiremile logo, and add button instead of add new service, which will have a title, description, price, when paid, and category.
    }()
    
    let changePhotoButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.white
        button.setTitle("Change Cover Photo", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
        return button
    }()
    
    let titleYourListing : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Title Your Listing"
        tf.tintColor = UIColor.mainBlue
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        tf.textColor = UIColor.black
        tf.textAlignment = NSTextAlignment.left
        return tf
    }()
    
    let describeYourListing : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Describe Your Listing"
        tf.tintColor = UIColor.mainBlue
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        tf.textColor = UIColor.black
        tf.textAlignment = NSTextAlignment.left
        return tf
    }()
    
    let segmentedControl : UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.insertSegment(withTitle: "Total", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Hourly", at: 1, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.layer.cornerRadius = 20
        segmentedControl.layer.borderColor = UIColor(red: 241/255, green: 239/255, blue: 239/255, alpha: 1).cgColor
        segmentedControl.layer.borderWidth = 2
        segmentedControl.layer.masksToBounds = true
        segmentedControl.backgroundColor = UIColor.mainBlue
        segmentedControl.setBackgroundImage(UIImage(named: "whiteback"), for: .normal, barMetrics: .default)
        segmentedControl.setBackgroundImage(UIImage(named: "mainBlue"), for: .selected, barMetrics: .default)
        segmentedControl.tintColor = UIColor.mainBlue
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1)], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    let priceYourListing : UITextField = {
        let tf = UITextField()
        tf.placeholder = "$0.00"
        tf.tintColor = UIColor.mainBlue
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        tf.textColor = UIColor.black
        tf.keyboardType = UIKeyboardType.decimalPad
        tf.textAlignment = NSTextAlignment.center
        return tf
    }()
    
    let pickCategory : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Category"
        tf.tintColor = UIColor.mainBlue
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        tf.textColor = UIColor.black
        tf.textAlignment = NSTextAlignment.center
        return tf
    }()
    
    let applyButton : UIButton = {
        let button = UIButton()
        button.setTitle("POST", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.mainBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(handlePost), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        self.view.addSubview(self.backgroundImage)
        self.backgroundImage.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.backgroundImage.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.backgroundImage.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.backgroundImage.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        self.view.addSubview(backButton)
        self.backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.backButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true

        self.view.addSubview(self.changePhotoButton)
        self.changePhotoButton.topAnchor.constraint(equalTo: self.backgroundImage.bottomAnchor, constant:  -60).isActive = true
        self.changePhotoButton.widthAnchor.constraint(equalToConstant: 225).isActive = true
        self.changePhotoButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.changePhotoButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

        self.view.addSubview(self.titleYourListing)
        self.titleYourListing.delegate = self
        self.titleYourListing.topAnchor.constraint(equalTo: self.backgroundImage.bottomAnchor, constant: 10).isActive = true
        self.titleYourListing.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.titleYourListing.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.titleYourListing.heightAnchor.constraint(equalToConstant: 35).isActive = true

        self.view.addSubview(self.describeYourListing)
        self.describeYourListing.delegate = self
        self.describeYourListing.topAnchor.constraint(equalTo: self.titleYourListing.bottomAnchor, constant: 10).isActive = true
        self.describeYourListing.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.describeYourListing.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.describeYourListing.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        self.view.addSubview(segmentedControl)
        self.segmentedControl.topAnchor.constraint(equalTo: self.describeYourListing.bottomAnchor, constant: 25).isActive = true
        self.segmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.segmentedControl.widthAnchor.constraint(equalToConstant: 250).isActive = true
        self.segmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(priceYourListing)
        self.priceYourListing.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor, constant: 10).isActive = true
        self.priceYourListing.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.priceYourListing.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.priceYourListing.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(pickCategory)
        self.pickeringView.delegate = self
        self.pickCategory.inputView = self.pickeringView
        self.pickCategory.topAnchor.constraint(equalTo: self.priceYourListing.bottomAnchor, constant: 10).isActive = true
        self.pickCategory.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.pickCategory.widthAnchor.constraint(equalToConstant: 150).isActive = true
        self.pickCategory.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(applyButton)
        self.applyButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.applyButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.applyButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        self.applyButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        // func here
        
        self.backgroundImage.image = GlobalVariables.postImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            self.backgroundImage.image = editedImage
            self.backgroundImage.contentMode = .scaleAspectFill
        } else if let originalImage = info[.originalImage] as? UIImage{
            self.backgroundImage.image = originalImage
            self.backgroundImage.contentMode = .scaleAspectFill
        }
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.frame.origin.y = 0
        self.isCurrentlyEditing = false
        return (true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.frame.origin.y = 0
        self.isCurrentlyEditing = false
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("hello")
        self.isCurrentlyEditing = true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickCategory.text = pickerData[row]
    }

    @objc func exitTapped() {
        let alert = UIAlertController(title: "Are you sure you want to cancel?", message: "Your current post will not be saved", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func addPhoto() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func segmentedControlValueChanged(_ semder: UISegmentedControl) {
        print("type changed")
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if self.isCurrentlyEditing == false {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height / 3.5
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func handlePost() {
        if self.titleYourListing.text! == "" || self.describeYourListing.text! == "" || self.priceYourListing.text! == "" || self.pickCategory.text! == "" {
            let alert = UIAlertController(title: "Error", message: "Please make sure that all fields are filled in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            // show loader
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            // image upload
            guard let imageData = backgroundImage.image?.jpegData(compressionQuality: 0.75) else { return }
            let storageRef = Storage.storage().reference()
            let storageProfileRef = storageRef.child("Jobs").child("\(Auth.auth().currentUser!.uid)").child("PostImage")
            let metadata = StorageMetadata()
            let key = Database.database().reference().child("Jobs").childByAutoId().key
            metadata.contentType = "image/jpg"
            storageProfileRef.putData(imageData, metadata: metadata) { (storageMetadata, putDataError) in
                if putDataError == nil && storageMetadata != nil {
                    storageProfileRef.downloadURL { (url, downloadUrlError) in
                        if let metalImageUrl = url?.absoluteString {
                            print(metalImageUrl)
                            // info upload
                            var typeOfPrice = ""
                            if self.segmentedControl.selectedSegmentIndex == 0 {
                                typeOfPrice = "Total"
                            } else {
                                typeOfPrice = "Hourly"
                            }
                            let infoToAdd : Dictionary<String, Any> = [
                                "category" : "\(self.pickCategory.text!)",
                                "description" : "\(self.describeYourListing.text!)",
                                "title" : "\(self.titleYourListing.text!)",
                                "postId" : "\(key!)",
                                "price" : Int(self.priceYourListing.text!),
                                "type-of-price" : "\(typeOfPrice)",
                                "author" : "\(Auth.auth().currentUser!.uid)",
                                "image" : "\(metalImageUrl)"
                            ]
                            let postFeed = ["\(key!)" : infoToAdd]
                            Database.database().reference().child("Jobs").updateChildValues(postFeed) { (addInfoError, result) in
                                if addInfoError == nil {
                                    Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("services").observeSingleEvent(of: .value) { (ratingNum) in
                                        let value = ratingNum.value as? NSNumber
                                        let newNumber = Int(value!)
                                        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("services").setValue(newNumber + 1)
                                    }
                                    switch self.pickCategory.text! {
                                    case "Development / Design":
                                        self.upload(childRef: "developmentdesign")
                                    case "Repairs / Cleaning":
                                        self.upload(childRef: "repairscleaning")
                                    case "Teaching / Tutoring":
                                        self.upload(childRef: "teachingtutoring")
                                    case "Writing":
                                        self.upload(childRef: "writing")
                                    case "SEO":
                                        self.upload(childRef: "seo")
                                    case "Public Relations":
                                        self.upload(childRef: "publicrelations")
                                    case "Translation":
                                        self.upload(childRef: "translation")
                                    case "Other":
                                        self.upload(childRef: "other")
                                    default:
                                        self.upload(childRef: "other")
                                    }
                                    // success alert
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                    let alert = UIAlertController(title: "Posted", message: "You post has been posted! Use your profile to see your job listings.", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                                        self.dismiss(animated: true, completion: nil)
                                    }))
                                    self.present(alert, animated: true, completion: nil)
                                } else {
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                    let alert = UIAlertController(title: "Error", message: addInfoError!.localizedDescription, preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
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
            
        }
    }
    
    func upload(childRef: String) {
        Database.database().reference().child("Information").child("home").child(childRef).child("trueOrFalse").setValue("true")
    }
    
}
