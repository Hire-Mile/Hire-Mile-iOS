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
import CoreLocation

class Post: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate {

    var index = 0
    
    let maxTitle : Int = 20
    
    let maxDesc : Int = 40
    
    var hsaPicked = false

    let filterLauncher = PostLauncher()
    
    let imagePicker = UIImagePickerController()
    
    let imageArray = ["autodetail-blue", "barber-blue", "Carpentry-blue", "cleaning-blue", "furniture-blue", "hairsaloon-blue", "nails-blue", "phone-blue", "towing-blue", "other-blue"]
    
    let titles = ["Auto", "Barber", "Carpentry", "Cleaning", "Moving", "Salon", "Beauty", "Technology", "Towing", "Other"]
    
    let locationManager = CLLocationManager()
    
    var myLocation : CLLocationCoordinate2D?
    
    let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor.white
        return scrollView
    }()

    let backButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.imageView?.tintColor = UIColor.black
        button.tintColor = UIColor.black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        button.backgroundColor = UIColor.white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
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
        tf.placeholder = "Title Your Service (Max. 20 Characters)"
        tf.tintColor = UIColor.mainBlue
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .none
        tf.textColor = UIColor.black
        tf.textAlignment = NSTextAlignment.left
        return tf
    }()
    
    let describeYourListing : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Describe Your Service (Max. 40 Characters)"
        tf.tintColor = UIColor.mainBlue
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .none
        tf.textColor = UIColor.black
        tf.textAlignment = NSTextAlignment.left
        return tf
    }()
    
    let categorizeYourListing : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Select Category"
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
    
    let myCategoryLabel : UILabel = {
        let label = UILabel()
        label.text = "Select Category"
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = NSTextAlignment.center
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
    
    let bottomBorder4 : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        return view
    }()
    
    let wordCountTitle : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = NSTextAlignment.left
        label.numberOfLines = 3
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "20 letters left"
        return label
    }()
    
    let wordCountDescription : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = NSTextAlignment.left
        label.numberOfLines = 3
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "40 letters left"
        return label
    }()
    
    var categoryCollectionView : UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationServices()

        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(scrollView)
        
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: 850)
        
        self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true

        self.titleYourListing.addTarget(self, action: #selector(titleEnabled), for: .editingChanged)
        self.describeYourListing.addTarget(self, action: #selector(descriptionEnabled), for: .editingChanged)
        self.priceYourListing.addTarget(self, action: #selector(pricingEnabled), for: .editingChanged)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        self.scrollView.addSubview(self.backgroundImage)
        self.backgroundImage.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.backgroundImage.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.backgroundImage.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.backgroundImage.heightAnchor.constraint(equalToConstant: 350).isActive = true

        self.view.addSubview(backButton)
        self.backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        self.backButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 18).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.scrollView.addSubview(self.categorizeYourListing)
        self.categorizeYourListing.delegate = self
        self.categorizeYourListing.topAnchor.constraint(equalTo: self.backgroundImage.bottomAnchor, constant: 15).isActive = true
        self.categorizeYourListing.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 18).isActive = true
        self.categorizeYourListing.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -18).isActive = true
        self.categorizeYourListing.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.scrollView.addSubview(downArrow)
        self.downArrow.topAnchor.constraint(equalTo: self.categorizeYourListing.topAnchor).isActive = true
        self.downArrow.bottomAnchor.constraint(equalTo: self.categorizeYourListing.bottomAnchor).isActive = true
        self.downArrow.rightAnchor.constraint(equalTo: self.categorizeYourListing.rightAnchor).isActive = true
        self.downArrow.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.scrollView.addSubview(chooseCategoryVutton)
        self.chooseCategoryVutton.topAnchor.constraint(equalTo: self.categorizeYourListing.topAnchor).isActive = true
        self.chooseCategoryVutton.leftAnchor.constraint(equalTo: self.categorizeYourListing.leftAnchor).isActive = true
        self.chooseCategoryVutton.rightAnchor.constraint(equalTo: self.categorizeYourListing.rightAnchor).isActive = true
        self.chooseCategoryVutton.bottomAnchor.constraint(equalTo: self.categorizeYourListing.bottomAnchor).isActive = true
        
        self.scrollView.addSubview(self.bottomBorder4)
        self.bottomBorder4.topAnchor.constraint(equalTo: self.categorizeYourListing.bottomAnchor).isActive = true
        self.bottomBorder4.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 18).isActive = true
        self.bottomBorder4.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -18).isActive = true
        self.bottomBorder4.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        self.scrollView.addSubview(self.titleYourListing)
        self.titleYourListing.delegate = self
        self.titleYourListing.addTarget(self, action: #selector(self.titleChanged), for: UIControl.Event.editingChanged)
        self.titleYourListing.topAnchor.constraint(equalTo: self.bottomBorder4.bottomAnchor, constant: 18).isActive = true
        self.titleYourListing.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 18).isActive = true
        self.titleYourListing.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -18).isActive = true
        self.titleYourListing.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.scrollView.addSubview(self.bottomBorder)
        self.bottomBorder.topAnchor.constraint(equalTo: self.titleYourListing.bottomAnchor).isActive = true
        self.bottomBorder.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 18).isActive = true
        self.bottomBorder.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -18).isActive = true
        self.bottomBorder.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        self.scrollView.addSubview(self.wordCountTitle)
        self.wordCountTitle.topAnchor.constraint(equalTo: self.bottomBorder.bottomAnchor, constant: 5).isActive = true
        self.wordCountTitle.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.wordCountTitle.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.wordCountTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true

        self.scrollView.addSubview(self.describeYourListing)
        self.describeYourListing.delegate = self
        self.describeYourListing.addTarget(self, action: #selector(self.descrpitionChanged), for: UIControl.Event.editingChanged)
        self.describeYourListing.topAnchor.constraint(equalTo: self.bottomBorder.bottomAnchor, constant: 35).isActive = true
        self.describeYourListing.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 18).isActive = true
        self.describeYourListing.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -18).isActive = true
        self.describeYourListing.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.scrollView.addSubview(self.bottomBorder2)
        self.bottomBorder2.topAnchor.constraint(equalTo: self.describeYourListing.bottomAnchor).isActive = true
        self.bottomBorder2.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 18).isActive = true
        self.bottomBorder2.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -18).isActive = true
        self.bottomBorder2.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        self.scrollView.addSubview(self.wordCountDescription)
        self.wordCountDescription.topAnchor.constraint(equalTo: self.bottomBorder2.bottomAnchor, constant: 5).isActive = true
        self.wordCountDescription.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.wordCountDescription.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.wordCountDescription.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.scrollView.addSubview(moneyLabel)
        self.moneyLabel.topAnchor.constraint(equalTo: self.bottomBorder2.bottomAnchor, constant: 35).isActive = true
        self.moneyLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 18).isActive = true
        self.moneyLabel.widthAnchor.constraint(equalToConstant: 20).isActive = true
        self.moneyLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true

        self.scrollView.addSubview(priceYourListing)
        self.priceYourListing.delegate = self
        self.priceYourListing.topAnchor.constraint(equalTo: self.bottomBorder2.bottomAnchor, constant: 35).isActive = true
        self.priceYourListing.leftAnchor.constraint(equalTo: self.moneyLabel.rightAnchor).isActive = true
        self.priceYourListing.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -18).isActive = true
        self.priceYourListing.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.scrollView.addSubview(self.bottomBorder3)
        self.bottomBorder3.topAnchor.constraint(equalTo: self.priceYourListing.bottomAnchor).isActive = true
        self.bottomBorder3.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 18).isActive = true
        self.bottomBorder3.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -18).isActive = true
        self.bottomBorder3.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        self.scrollView.addSubview(applyButton)
        self.applyButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 18).isActive = true
        self.applyButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -18).isActive = true
        self.applyButton.topAnchor.constraint(equalTo: self.bottomBorder3.bottomAnchor, constant: 20).isActive = true
        self.applyButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        self.backgroundImage.image = GlobalVariables.postImage
    }
    
    @objc func titleChanged() {
        if let text = self.titleYourListing.text?.lowercased() {
            self.wordCountTitle.text = "\(self.maxTitle - text.count) letters left"
            if text.count > self.maxTitle {
                self.wordCountTitle.textColor = UIColor.red
            } else {
                self.wordCountTitle.textColor = UIColor.lightGray
            }
        }
    }
    
    @objc func descrpitionChanged() {
        if let text = self.describeYourListing.text?.lowercased() {
            self.wordCountDescription.text = "\(self.maxDesc - text.count) letters left"
            if text.count > self.maxDesc {
                self.wordCountDescription.textColor = UIColor.red
            } else {
                self.wordCountDescription.textColor = UIColor.lightGray
            }
        }
    }
    
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
        self.hsaPicked = true
        self.categorizeYourListing.text = self.titles[indexPath.row]
        self.dismissView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 115)
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
        self.titleYourListing.resignFirstResponder()
        self.describeYourListing.resignFirstResponder()
        self.priceYourListing.resignFirstResponder()
        if self.titleYourListing.text! == "" || self.describeYourListing.text! == "" || self.priceYourListing.text! == "" || self.categoryLabel.text == "+ Select Category" {
            let alert = UIAlertController(title: "Error", message: "Please make sure that all fields are filled in and a category is selected", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            if self.titleYourListing.text!.count > self.maxTitle {
                let alert = UIAlertController(title: "Error", message: "Please make sure that your title's character count is less than 20", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else if self.describeYourListing.text!.count > self.maxDesc {
                let alert = UIAlertController(title: "Error", message: "Please make sure that your description's character count is less than 40", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                // show loader
                MBProgressHUD.showAdded(to: self.view, animated: true)
                // image upload
                guard let imageData = backgroundImage.image?.jpegData(compressionQuality: 0.75) else { return }
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
                                        "category" : "\(self.categorizeYourListing.text!)",
                                        "description" : "\(self.describeYourListing.text!)",
                                        "title" : "\(self.titleYourListing.text!)",
                                        "postId" : "\(key!)",
                                        "price" : Int(self.priceYourListing.text!),
                                        "type-of-price" : "\(typeOfPrice)",
                                        "lat" : Float(location.latitude),
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
                                    // info upload
                                    var typeOfPrice = ""
                                        typeOfPrice = "Total"
                                    let infoToAdd : Dictionary<String, Any> = [
                                        "category" : "\(self.categorizeYourListing.text!)",
                                        "description" : "\(self.describeYourListing.text!)",
                                        "title" : "\(self.titleYourListing.text!)",
                                        "postId" : "\(key!)",
                                        "price" : Int(self.priceYourListing.text!),
                                        "type-of-price" : "\(typeOfPrice)",
                                        "lat" : Float(0),
                                        "time" : String(Int(Date().timeIntervalSince1970)),
                                        "long" : Float(0),
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
                                        } else {
                                            MBProgressHUD.hide(for: self.view, animated: true)
                                            let alert = UIAlertController(title: "Error", message: addInfoError!.localizedDescription, preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                                            self.present(alert, animated: true, completion: nil)
                                        }
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
    }

    func upload(childRef: String) {
        Database.database().reference().child("Information").child("home").child(childRef).child("trueOrFalse").setValue("true")
    }
    
    func getAllFollowers() {
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("name").observe(.value) { (snapshot) in
            if let name = snapshot.value as? String {
                Database.database().reference().child("Users").observe(.childAdded) { (snapshot) in
                    if let value = snapshot.value as? [String : Any] {
                        let user = UserStructure()
                        user.uid = value["uid"] as? String ?? "Error"
                        user.notification = value["fcmToken"] as? String
                        Database.database().reference().child("Users").child(snapshot.key).child("favorites").observe(.childAdded) { (favoritesSnap) in
                            if let _ = favoritesSnap.value as? [String : Any] {
                                let favorite = UserStructure()
                                favorite.uid = favoritesSnap.key
                                if favorite.uid == Auth.auth().currentUser!.uid {
                                    let sender = PushNotificationSender()
                                    sender.sendPushNotification(to: user.notification ?? "", title: "New Job Alert!", body: "\(name) Posted!", page: true, senderId: Auth.auth().currentUser!.uid, recipient: favorite.uid!)
                                }
                            }
                        }
                    }
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // success alert
            MBProgressHUD.hide(for: self.view, animated: true)
            self.filterLauncher.applyButton.addTarget(self, action: #selector(self.dismissPressed), for: .touchUpInside)
            self.filterLauncher.showFilter()
        }
    }

    @objc func dismissView() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.exit.alpha = 0
            self.myCategoryLabel.alpha = 0
            self.categoryCollectionView!.alpha = 0
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
        self.pickerView.layer.cornerRadius = 30
        self.pickerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.pickerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.pickerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.pickerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.pickerView.heightAnchor.constraint(equalToConstant: 500).isActive = true

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
        self.categoryCollectionView = UICollectionView(frame: CGRect(x: 40, y: 80, width: self.view.frame.width - 80, height: 400), collectionViewLayout: layou2)
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
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            let alert = UIAlertController(title: "Cannot find location", message: "Please go to Settings and allow location to view this screen!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            let alert = UIAlertController(title: "Cannot find location", message: "Your location is marked as 'restricted'", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            break
        }
    }

}
