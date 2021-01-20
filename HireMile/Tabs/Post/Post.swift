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

    var index = 0
    var hsaPicked = false

    let filterLauncher = PostLauncher()
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

    let changeCategory : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 22.5
        return view
    }()

    let downArrow : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = UIColor.lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let titleYourListing : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Title Your Listing"
        tf.tintColor = UIColor.mainBlue
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .none
        tf.textColor = UIColor.black
        tf.textAlignment = NSTextAlignment.left
        return tf
    }()

    let describeYourListing : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Describe Your Listing"
        tf.tintColor = UIColor.mainBlue
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .none
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

    let moneyLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$"
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.black
        return label
    }()

    let priceYourListing : UITextField = {
        let tf = UITextField()
        tf.placeholder = "0.00"
        tf.tintColor = UIColor.mainBlue
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .none
        tf.textColor = UIColor.black
        tf.keyboardType = UIKeyboardType.decimalPad
        tf.textAlignment = NSTextAlignment.left
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

    let categoryLabel : UILabel = {
        let label = UILabel()
        label.text = "Select Category"
        label.textColor = UIColor.lightGray
        label.textAlignment = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let chooseCategoryVutton : UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(addCategory), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let blackView : UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return view
    }()

    let pickerView : UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = UIColor.white
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()

    let exit : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = UIColor.black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        button.alpha = 0
        return button
    }()

    let bottomBorder : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        return view
    }()

    let bottomBorder2 : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        return view
    }()

    let bottomBorder3 : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white

        self.titleYourListing.addTarget(self, action: #selector(titleEnabled), for: .editingChanged)
        self.describeYourListing.addTarget(self, action: #selector(descriptionEnabled), for: .editingChanged)
        self.priceYourListing.addTarget(self, action: #selector(pricingEnabled), for: .editingChanged)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        self.view.addSubview(self.backgroundImage)
        self.backgroundImage.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.backgroundImage.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.backgroundImage.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.backgroundImage.heightAnchor.constraint(equalToConstant: 400).isActive = true

        self.view.addSubview(backButton)
        self.backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.backButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true

        self.view.addSubview(self.changeCategory)
        self.changeCategory.topAnchor.constraint(equalTo: self.backgroundImage.bottomAnchor, constant:  -60).isActive = true
        self.changeCategory.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        self.changeCategory.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        self.changeCategory.heightAnchor.constraint(equalToConstant: 45).isActive = true

        self.view.addSubview(self.titleYourListing)
        self.titleYourListing.delegate = self
        self.titleYourListing.topAnchor.constraint(equalTo: self.backgroundImage.bottomAnchor, constant: 20).isActive = true
        self.titleYourListing.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        self.titleYourListing.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        self.titleYourListing.heightAnchor.constraint(equalToConstant: 40).isActive = true

        self.view.addSubview(self.describeYourListing)
        self.describeYourListing.delegate = self
        self.describeYourListing.topAnchor.constraint(equalTo: self.titleYourListing.bottomAnchor, constant: 25).isActive = true
        self.describeYourListing.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        self.describeYourListing.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        self.describeYourListing.heightAnchor.constraint(equalToConstant: 40).isActive = true

        self.view.addSubview(moneyLabel)
        self.moneyLabel.topAnchor.constraint(equalTo: self.describeYourListing.bottomAnchor, constant: 25).isActive = true
        self.moneyLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        self.moneyLabel.widthAnchor.constraint(equalToConstant: 20).isActive = true
        self.moneyLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true

        self.view.addSubview(priceYourListing)
        self.priceYourListing.topAnchor.constraint(equalTo: self.describeYourListing.bottomAnchor, constant: 25).isActive = true
        self.priceYourListing.leftAnchor.constraint(equalTo: self.moneyLabel.rightAnchor).isActive = true
        self.priceYourListing.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        self.priceYourListing.heightAnchor.constraint(equalToConstant: 60).isActive = true

        self.view.addSubview(self.bottomBorder3)
        self.bottomBorder3.topAnchor.constraint(equalTo: self.priceYourListing.bottomAnchor).isActive = true
        self.bottomBorder3.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        self.bottomBorder3.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        self.bottomBorder3.heightAnchor.constraint(equalToConstant: 3).isActive = true

        self.view.addSubview(self.bottomBorder)
        self.bottomBorder.topAnchor.constraint(equalTo: self.titleYourListing.bottomAnchor).isActive = true
        self.bottomBorder.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        self.bottomBorder.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        self.bottomBorder.heightAnchor.constraint(equalToConstant: 3).isActive = true

        self.view.addSubview(self.bottomBorder2)
        self.bottomBorder2.topAnchor.constraint(equalTo: self.describeYourListing.bottomAnchor).isActive = true
        self.bottomBorder2.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        self.bottomBorder2.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        self.bottomBorder2.heightAnchor.constraint(equalToConstant: 3).isActive = true

        self.view.addSubview(applyButton)
        self.applyButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.applyButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.applyButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        self.applyButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        self.changeCategory.addSubview(categoryLabel)
        self.categoryLabel.topAnchor.constraint(equalTo: self.changeCategory.topAnchor, constant: -2.5).isActive = true
        self.categoryLabel.leftAnchor.constraint(equalTo: self.changeCategory.leftAnchor, constant: 15).isActive = true
        self.categoryLabel.rightAnchor.constraint(equalTo: self.changeCategory.rightAnchor, constant: -15).isActive = true
        self.categoryLabel.bottomAnchor.constraint(equalTo: self.changeCategory.bottomAnchor).isActive = true

        self.changeCategory.addSubview(downArrow)
        self.downArrow.topAnchor.constraint(equalTo: self.changeCategory.topAnchor).isActive = true
        self.downArrow.bottomAnchor.constraint(equalTo: self.changeCategory.bottomAnchor).isActive = true
        self.downArrow.rightAnchor.constraint(equalTo: self.changeCategory.rightAnchor, constant: -15).isActive = true
        self.downArrow.widthAnchor.constraint(equalToConstant: 50).isActive = true

        self.changeCategory.addSubview(chooseCategoryVutton)
        self.chooseCategoryVutton.topAnchor.constraint(equalTo: self.changeCategory.topAnchor).isActive = true
        self.chooseCategoryVutton.leftAnchor.constraint(equalTo: self.changeCategory.leftAnchor).isActive = true
        self.chooseCategoryVutton.rightAnchor.constraint(equalTo: self.changeCategory.rightAnchor).isActive = true
        self.chooseCategoryVutton.bottomAnchor.constraint(equalTo: self.changeCategory.bottomAnchor).isActive = true

        self.pickerView.delegate = self
        self.pickerView.dataSource = self

        self.backgroundImage.image = GlobalVariables.postImage
    }

    @objc func addCategory() {
        self.showView()
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
        return (true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.frame.origin.y = 0
        self.view.endEditing(true)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.priceYourListing {
            self.pricingEnabled()
        } else if textField == self.describeYourListing {
            self.descriptionEnabled()
        } else {
            self.titleEnabled()
        }
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
        self.hsaPicked = true
        self.categoryLabel.text = pickerData[row]
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
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height / 2.5
                }
            }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    @objc func handlePost() {
        if self.titleYourListing.text! == "" || self.describeYourListing.text! == "" || self.priceYourListing.text! == "" || self.categoryLabel.text == "+ Select Category" {
//            let alert = UIAlertController(title: "Error", message: "Please make sure that all fields are filled in and a category is selected", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
            self.filterLauncher.showFilter()
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
                                typeOfPrice = "Total"
                            let infoToAdd : Dictionary<String, Any> = [
                                "category" : "\(self.categoryLabel.text!)",
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
                                    self.filterLauncher.applyButton.addTarget(self, action: #selector(self.dismissPressed), for: .touchUpInside)
                                    self.filterLauncher.showFilter()
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

    @objc func dismissView() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.exit.alpha = 0
            self.pickerView.alpha = 0
            self.seeIfhasPicked()
        }
    }

    func showView() {
        self.view.addSubview(blackView)
        self.blackView.backgroundColor = UIColor.black
        self.blackView.alpha = 0
        self.blackView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.blackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.blackView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.blackView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true

        self.view.addSubview(pickerView)
        self.pickerView.alpha = 0
        self.pickerView.layer.cornerRadius = 15
        self.pickerView.widthAnchor.constraint(equalToConstant: 275).isActive = true
        self.pickerView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        self.pickerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.pickerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true

        self.view.addSubview(exit)
        self.exit.topAnchor.constraint(equalTo: self.pickerView.topAnchor, constant: 10).isActive = true
        self.exit.rightAnchor.constraint(equalTo: self.pickerView.rightAnchor, constant: -10).isActive = true
        self.exit.widthAnchor.constraint(equalToConstant: 20).isActive = true
        self.exit.heightAnchor.constraint(equalToConstant: 20).isActive = true

        UIView.animate(withDuration: 0.5) {
            self.pickerView.alpha = 1
            self.exit.alpha = 1
            self.blackView.alpha = 0.3
        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView()
        let label = UILabel()
        label.text = self.pickerData[row]
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = NSTextAlignment.left

        view.addSubview(label)
        label.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        label.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        return view
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }

    func seeIfhasPicked() {
        if self.hsaPicked {
            self.categoryLabel.textColor = UIColor.black
            self.downArrow.isHidden = true
        } else {
            self.categoryLabel.textColor = UIColor.lightGray
            self.downArrow.isHidden = false
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.bottomBorder3.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        self.bottomBorder2.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        self.bottomBorder.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
    }

    @objc func titleEnabled() {
        self.bottomBorder3.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        self.bottomBorder2.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        self.bottomBorder.backgroundColor = UIColor.mainBlue
    }

    @objc func descriptionEnabled() {
        self.bottomBorder3.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        self.bottomBorder2.backgroundColor = UIColor.mainBlue
        self.bottomBorder.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
    }

    @objc func pricingEnabled() {
        self.bottomBorder3.backgroundColor = UIColor.mainBlue
        self.bottomBorder2.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        self.bottomBorder.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
    }
    
    @objc func dismissPressed() {
        self.dismiss(animated: true, completion: nil)
    }

}
