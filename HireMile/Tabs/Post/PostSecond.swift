//
//  PostSecond.swift
//  HireMile
//
//  Created by JJ Zapata on 4/15/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import MBProgressHUD
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class PostSecond: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate, UITextViewDelegate {
    
    let pickerController = UIImagePickerController()
    
    let postSourceLauncher = PostSourceLauncher()
    
    let filterLauncher = PostLauncher()
    
    let maxTitle : Int = 20
    
    let maxDesc : Int = 40
    
    let topView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor.white
        return scrollView
    }()
    
    let view1 : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(r: 230, g: 230, b: 230)
        view.layer.cornerRadius = 3
        return view
    }()
    
    let view2 : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.mainBlue
        view.layer.cornerRadius = 3
        return view
    }()
    
    let backButton : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Cancel", for: UIControl.State.normal)
        button.setTitleColor(UIColor.mainBlue, for: UIControl.State.normal)
        button.titleLabel!.font = UIFont.boldSystemFont(ofSize: 16)
        button.imageView?.tintColor = UIColor.black
        button.tintColor = UIColor.black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(exitTapped), for: .touchUpInside)
        return button
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.darkGray
        label.text = "Category"
        return label
    }()
    
    let titleLabel12 : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.black
        label.text = "Select Here"
        return label
    }()
    
    let titleLabel2 : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.darkGray
        label.text = "Description"
        return label
    }()
    
    let titleLabel3 : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.black
        label.text = "Price"
        return label
    }()
    
    let titleLabelView : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.black
        label.text = "Details"
        return label
    }()
    
    let title1 : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor(r: 230, g: 230, b: 230)
        label.text = "1. Photos"
        return label
    }()
    
    let title2 : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.mainBlue
        label.text = "2. Details"
        return label
    }()
    
    let emailTextField : UITextField = {
        let textfield = UITextField()
        textfield.tintColor = UIColor.mainBlue
        textfield.placeholder = "Write here"
        textfield.borderStyle = .roundedRect
        textfield.layer.cornerRadius = 15
        textfield.textColor = UIColor.black
        textfield.keyboardType = .default
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    let button : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addPhoto), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let myCategoryLabel : UILabel = {
        let label = UILabel()
        label.text = "Select Category"
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let loginButton : MainButton = {
        let button = MainButton(title: "Post")
        button.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
        return button
    }()
    
    let categoryImage : UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(addCategory), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let downImage : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.white
        imageView.image = UIImage(systemName: "arrowtriangle.down.fill")
        imageView.tintColor = UIColor.darkGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let describeYourListing : UITextView = {
        let tf = UITextView()
        tf.text = "Write Here.."
        tf.textColor = UIColor.lightGray
        tf.tintColor = UIColor.mainBlue
        tf.translatesAutoresizingMaskIntoConstraints = false
//        tf.borderStyle = .roundedRect
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 8
        tf.font = UIFont.systemFont(ofSize: 17)
        tf.layer.borderColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1).cgColor
        tf.textColor = UIColor.black
        tf.textAlignment = NSTextAlignment.left
        return tf
    }()
    
    let priceYourListing : UITextField = {
        let tf = UITextField()
        tf.placeholder = "$0.00"
        tf.tintColor = UIColor.mainBlue
        tf.font = UIFont.boldSystemFont(ofSize: 30)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .none
        tf.textColor = UIColor.black
        tf.keyboardType = UIKeyboardType.decimalPad
        tf.textAlignment = NSTextAlignment.left
        return tf
    }()
    
    let wordCountTitle : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = NSTextAlignment.right
        label.numberOfLines = 3
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "20 letters left"
        return label
    }()
    
    let wordCountDescription : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = NSTextAlignment.right
        label.numberOfLines = 3
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "40 letters left"
        return label
    }()
    
    let middleView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var image : UIImage?
    
    var titleOfPost : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Post Service"
        
        view.backgroundColor = UIColor.white
        
        setupLocationManager()
        
        self.describeYourListing.delegate = self
        
//        self.titleYourListing.addTarget(self, action: #selector(self.titleChanged), for: UIControl.Event.editingChanged)
//        self.describeYourListing.addTarget(self, action: #selector(self.descrpitionChanged), for: UIControl.Event.editingChanged)
        
        self.view.addSubview(backButton)
        self.backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        self.backButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 18).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.view.addSubview(titleLabelView)
        self.titleLabelView.topAnchor.constraint(equalTo: backButton.topAnchor, constant: 10).isActive = true
        self.titleLabelView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.titleLabelView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        self.titleLabelView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.view.addSubview(scrollView)
        self.scrollView.contentSize = CGSize(width: (self.view.frame.width / 2) - 60, height: 1000)
        self.scrollView.topAnchor.constraint(equalTo: titleLabelView.bottomAnchor, constant: 12).isActive = true
        self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        
        self.scrollView.addSubview(view1)
        self.view1.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        self.view1.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -15).isActive = true
        self.view1.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.view1.heightAnchor.constraint(equalToConstant: 6).isActive = true

        self.scrollView.addSubview(view2)
        self.view2.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        self.view2.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 15).isActive = true
        self.view2.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.view2.heightAnchor.constraint(equalToConstant: 6).isActive = true

        self.scrollView.addSubview(title1)
        self.title1.topAnchor.constraint(equalTo: view1.bottomAnchor, constant: 5).isActive = true
        self.title1.leftAnchor.constraint(equalTo: view1.leftAnchor).isActive = true
        self.title1.rightAnchor.constraint(equalTo: view1.rightAnchor).isActive = true
        self.title1.heightAnchor.constraint(equalToConstant: 20).isActive = true

        self.scrollView.addSubview(title2)
        self.title2.topAnchor.constraint(equalTo: view2.bottomAnchor, constant: 5).isActive = true
        self.title2.leftAnchor.constraint(equalTo: view2.leftAnchor).isActive = true
        self.title2.rightAnchor.constraint(equalTo: view2.rightAnchor).isActive = true
        self.title2.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.scrollView.addSubview(titleLabel)
        self.titleLabel.topAnchor.constraint(equalTo: self.title1.bottomAnchor, constant: 35).isActive = true
        self.titleLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        self.titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.scrollView.addSubview(titleLabel12)
        self.titleLabel12.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 5).isActive = true
        self.titleLabel12.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        self.titleLabel12.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        self.titleLabel12.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(categoryImage)
        self.categoryImage.topAnchor.constraint(equalTo: self.titleLabel.topAnchor).isActive = true
        self.categoryImage.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor).isActive = true
        self.categoryImage.rightAnchor.constraint(equalTo: self.titleLabel.rightAnchor).isActive = true
        self.categoryImage.bottomAnchor.constraint(equalTo: self.titleLabel12.bottomAnchor).isActive = true
        
        self.view.addSubview(titleLabel2)
        self.titleLabel2.topAnchor.constraint(equalTo: self.titleLabel12.bottomAnchor, constant: 55).isActive = true
        self.titleLabel2.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        self.titleLabel2.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        self.titleLabel2.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(describeYourListing)
        self.describeYourListing.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor).isActive = true
        self.describeYourListing.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor).isActive = true
        self.describeYourListing.topAnchor.constraint(equalTo: self.titleLabel2.bottomAnchor, constant: 12).isActive = true
        self.describeYourListing.heightAnchor.constraint(equalToConstant: 100).isActive = true

        self.view.addSubview(self.wordCountDescription)
        self.wordCountDescription.topAnchor.constraint(equalTo: self.describeYourListing.bottomAnchor, constant: 5).isActive = true
        self.wordCountDescription.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor).isActive = true
        self.wordCountDescription.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor).isActive = true
        self.wordCountDescription.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        self.titleLabel12.addSubview(downImage)
        self.downImage.topAnchor.constraint(equalTo: titleLabel12.topAnchor).isActive = true
        self.downImage.widthAnchor.constraint(equalToConstant: 15).isActive = true
        self.downImage.heightAnchor.constraint(equalToConstant: 15).isActive = true
        self.downImage.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor).isActive = true
        
        self.view.addSubview(titleLabel3)
        self.titleLabel3.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor).isActive = true
        self.titleLabel3.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor).isActive = true
        self.titleLabel3.topAnchor.constraint(equalTo: self.wordCountDescription.bottomAnchor, constant: 12).isActive = true
        self.titleLabel3.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(titleYourListing)
        self.titleYourListing.delegate = self
        titleYourListing.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: UIControl.Event.touchDown)
        self.titleYourListing.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor).isActive = true
        self.titleYourListing.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor).isActive = true
        self.titleYourListing.topAnchor.constraint(equalTo: self.titleLabel3.bottomAnchor, constant: 12).isActive = true
        self.titleYourListing.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.scrollView.addSubview(loginButton)
        self.loginButton.topAnchor.constraint(equalTo: self.titleYourListing.bottomAnchor, constant: 24).isActive = true
        self.loginButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.loginButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.loginButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        self.loginButton.setTitleColor(UIColor.white, for: .normal)
        self.loginButton.backgroundColor = UIColor.mainBlue
        
        self.view.addSubview(middleView)
        self.middleView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        self.middleView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        self.middleView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        self.middleView.bottomAnchor.constraint(equalTo: self.titleLabel2.topAnchor, constant: -25).isActive = true
        
        self.view.addSubview(topView)
        self.topView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.topView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.topView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.topView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.view.sendSubviewToBack(topView)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = true
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
        presentPhotoPopup()
    }
    
    @objc func titleChanged() {
        if let text = self.titleYourListing.text?.lowercased() {
            self.wordCountTitle.text = "\(self.maxTitle - text.count) characters left"
            if text.count > self.maxTitle {
                self.wordCountTitle.textColor = UIColor.red
            } else {
                self.wordCountTitle.textColor = UIColor.lightGray
            }
        }
    }
    
    @objc func descrpitionChanged() {
        if let text = self.describeYourListing.text?.lowercased() {
            self.wordCountDescription.text = "\(self.maxDesc - text.count) characters left"
            if text.count > self.maxDesc {
                self.wordCountDescription.textColor = UIColor.red
            } else {
                self.wordCountDescription.textColor = UIColor.lightGray
            }
        }
    }
    
    let locationManager = CLLocationManager()
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func continueWith(image: UIImage, title: String, category: String, description: String, price: Float) {
        // show loader
        MBProgressHUD.showAdded(to: self.view, animated: true)
        // image upload
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let storageRef = Storage.storage().reference()
        let metadata = StorageMetadata()
        let key = Database.database().reference().child("Jobs").childByAutoId().key
        let storageProfileRef = storageRef.child("Jobs").child("\(Auth.auth().currentUser!.uid)").child(key!)
        metadata.contentType = "image/jpg"
        storageProfileRef.putData(imageData, metadata: metadata) { (storageMetadata, putDataError) in
            if putDataError == nil && storageMetadata != nil {
                storageProfileRef.downloadURL { (url, downloadUrlError) in
                    if let metalImageUrl = url?.absoluteString {
                        if let location = self.locationManager.location?.coordinate {
                            // info upload
                            var typeOfPrice = ""
                                typeOfPrice = "Total"
                            let infoToAdd : Dictionary<String, Any> = [
                                "category" : "\(category)",
                                "description" : "\(description)",
                                "title" : "\(title)",
                                "postId" : "\(key!)",
                                "price" : price,
                                "type-of-price" : "\(typeOfPrice)",
                                "lat" : Float(location.latitude),
                                "time" : Int(Date().timeIntervalSince1970),
                                "long" : Float(location.longitude),
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
                                    switch self.myCategoryLabel.text! {
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
                                    self.titleYourListing.resignFirstResponder()
                                    self.describeYourListing.resignFirstResponder()
                                    self.priceYourListing.resignFirstResponder()
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
                            let alert = UIAlertController(title: "Error", message: "Please Allow Location Services", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
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
    
    func upload(childRef: String) {
        Database.database().reference().child("Information").child("home").child(childRef).child("trueOrFalse").setValue("true")
    }
    
    @objc func loginPressed() {
        if let image = image {
            if let title = titleOfPost {
                if let category = titleLabel12.text, titleLabel12.text! != "Select Here" {
                    if let desc = describeYourListing.text {
                        if let price = titleYourListing.text {
                            let secondPrice = Float(price)!
                            print(secondPrice)
                            print(category)
                            self.continueWith(image: image, title: title, category: category, description: desc, price: secondPrice)
                        } else {
                            let alert = UIAlertController(title: "Error", message: "Please set a price", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                            present(alert, animated: true, completion: nil)
                        }
                    } else {
                        let alert = UIAlertController(title: "Error", message: "Please set a description", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                        present(alert, animated: true, completion: nil)
                    }
                } else {
                    let alert = UIAlertController(title: "Error", message: "Please select a category", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                    present(alert, animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "Error", message: "Please go back and set title", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                }))
                present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Please go back and attach an image", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == describeYourListing {
            textField.resignFirstResponder()
        }
        return (true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = CGPoint(x: 0, y: 0)
        scrollView.setContentOffset(point, animated: true)
        self.view.endEditing(true)
    }
    
    private func presentPhotoPopup() {
        self.postSourceLauncher.showFilter()
//        self.filterLauncher.completeJob.addTarget(self, action: #selector(self.completeJobButton), for: .touchUpInside)
//        self.filterLauncher.stopJob.addTarget(self, action: #selector(self.stopJobButton), for: .touchUpInside)
    }
    
    @objc func dismissPressed() {
        Post.homeRemove = true
        dismiss(animated: true, completion: nil)
    }
    
    let blackView : UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return view
    }()

    let pickerView : UIView = {
        let pickerView = UIView()
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
    
    let titleYourListing : MainTextField = {
        let tf = MainTextField(placeholderString: "$0.00")
        tf.keyboardType = .decimalPad
        tf.font = UIFont.boldSystemFont(ofSize: 30)
        tf.textAlignment = NSTextAlignment.center
        return tf
    }()
    
    var categoryCollectionView : UICollectionView?
    
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
        self.pickerView.layer.cornerRadius = 30
        self.pickerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.pickerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.pickerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.pickerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.pickerView.heightAnchor.constraint(equalToConstant: 600).isActive = true

        self.view.addSubview(exit)
        self.exit.topAnchor.constraint(equalTo: self.pickerView.topAnchor, constant: 30).isActive = true
        self.exit.rightAnchor.constraint(equalTo: self.pickerView.rightAnchor, constant: -30).isActive = true
        self.exit.widthAnchor.constraint(equalToConstant: 20).isActive = true
        self.exit.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.pickerView.addSubview(self.myCategoryLabel)
        self.myCategoryLabel.topAnchor.constraint(equalTo: self.pickerView.topAnchor, constant: 30).isActive = true
        self.myCategoryLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.myCategoryLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.myCategoryLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        let layou2: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layou2.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layou2.scrollDirection = .vertical
        self.categoryCollectionView = UICollectionView(frame: CGRect(x: 20, y: 80, width: self.view.frame.width - 40, height: 500), collectionViewLayout: layou2)
        self.categoryCollectionView!.alwaysBounceVertical = true
        self.categoryCollectionView!.alwaysBounceHorizontal = false
        self.categoryCollectionView!.dataSource = self
        self.categoryCollectionView!.backgroundColor = UIColor.white
        self.categoryCollectionView!.showsHorizontalScrollIndicator = false
        self.categoryCollectionView!.showsVerticalScrollIndicator = false
        self.categoryCollectionView!.delegate = self
        self.categoryCollectionView!.register(PostCategoryCell.self, forCellWithReuseIdentifier: "postCategoryId")
        self.pickerView.addSubview(self.categoryCollectionView!)

        UIView.animate(withDuration: 0.5) {
            self.pickerView.alpha = 1
            self.exit.alpha = 1
            self.myCategoryLabel.alpha = 1
            self.categoryCollectionView!.alpha = 1
            self.blackView.alpha = 0.3
        }
    }
    
    @objc func dismissView() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.exit.alpha = 0
            self.myCategoryLabel.alpha = 0
            self.categoryCollectionView!.alpha = 0
            self.pickerView.alpha = 0
        }
    }
    
    let imageArray = ["auto-sq", "scissor-sq", "carperter-sq", "clean-sq", "moving-sq", "hair-sq", "NAIL", "phone-sq", "towing-sq", "other-sq"]
    
    let titles = ["Auto", "Barber", "Carpentry", "Cleaning", "Moving", "Salon", "Beauty", "Technology", "Towing", "Other"]
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCategoryId", for: indexPath) as! PostCategoryCell
        cell.title.text = self.titles[indexPath.row]
        cell.imageView.image = UIImage(named: self.imageArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.titleLabel12.text = self.titles[indexPath.row]
        self.dismissView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 115)
    }
    
    @objc func addCategory() {
        let point = CGPoint(x: 0, y: 0)
        scrollView.setContentOffset(point, animated: true)
        self.showView()
    }
    
    // MARK: - UITextView Delegate Functions
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Write Here.." {
            textView.text = ""
            textView.font = UIFont.systemFont(ofSize: 17)
            textView.textColor = UIColor.black
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == titleYourListing {
            let point = CGPoint(x: 0, y: scrollView.contentSize.height - 850)
            scrollView.setContentOffset(point, animated: true)
        }
    }

}
