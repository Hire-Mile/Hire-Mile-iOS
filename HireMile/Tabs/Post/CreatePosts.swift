//
//  CreatePosts.swift
//  HireMile
//
//  Created by mac on 19/06/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import MBProgressHUD
import CoreLocation

class CreatePosts: UIViewController ,UITextViewDelegate,CLLocationManagerDelegate{

    @IBOutlet weak var imgCoverPhoto: UIImageView!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var btnCategory: UIButton!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var btnApplyEdit: UIButton!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var colCoverPhoto: UICollectionView!
    @IBOutlet weak var VWTlt: UIView!
    @IBOutlet weak var VWDesc: UIView!
    @IBOutlet weak var lblPhotoCount: UILabel!
    
    var arrayOfImages = [UIImage]()
    var arrayOfStrImages = [String]()
    
    let postSourceLauncher = PostSourceLauncher()
    let filterLauncher = PostLauncher()
    let maxTitle : Int = 20
    let maxDesc : Int = 40
    let locationManager = CLLocationManager()
    var myLocation : CLLocationCoordinate2D?
    var image : UIImage?
    var titleOfPost : String?
    var categoryname = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UISetUp()
        // Do any additional setup after loading the view.
    }
    
    func UISetUp()  {
        setupLocationManager()
        self.colCoverPhoto.register(UINib(nibName: "CoverPhotoCell", bundle: nil), forCellWithReuseIdentifier: "CoverPhotoCell")

        let flow = UICollectionViewFlowLayout()
        let vwWidth = (colCoverPhoto.frame.width-60)/4
        flow.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        flow.itemSize = CGSize(width: vwWidth, height: vwWidth)
        flow.minimumInteritemSpacing = 10
        flow.scrollDirection = .horizontal
        flow.minimumLineSpacing = 10
        colCoverPhoto?.setCollectionViewLayout(flow, animated: false)
        
        self.txtTitle.delegate = self
        self.txtPrice.delegate = self
        self.txtDescription.delegate = self
        
        self.txtTitle.addTarget(self, action: #selector(self.titleChanged), for: UIControl.Event.editingChanged)
        
        self.txtDescription.delegate = self
       // self.txtDescription.addTarget(self, action: #selector(self.descrpitionChanged), for: UIControl.Event.editingChanged)
        
        self.categoryname = "\(self.btnCategory.currentTitle!)"
        
    }
    
    @objc func titleChanged() {
        if let text = self.txtTitle.text?.lowercased() {
          /*  self.wordCountTitle.text = "\(self.maxTitle - text.count) letters left"
            if text.count > self.maxTitle {
                self.wordCountTitle.textColor = UIColor.red
            } else {
                self.wordCountTitle.textColor = UIColor.lightGray
            }*/
        }
    }
    
    @objc func descrpitionChanged() {
        if let text = self.txtDescription.text?.lowercased() {
          /*  self.wordCountDescription.text = "\(self.maxDesc - text.count) letters left"
            if text.count > self.maxDesc {
                self.wordCountDescription.textColor = UIColor.red
            } else {
                self.wordCountDescription.textColor = UIColor.lightGray
            }*/
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    @objc func exitTapped() {
        let alert = UIAlertController(title: "Are you sure you want to cancel?", message: "Your current post will not be saved", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    @objc func dismissPressed() {
        Post.homeRemove = true
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func continueWith(image: UIImage, title: String, category: String, description: String, price: Int) {
        // show loader
        MBProgressHUD.showAdded(to: self.view, animated: true)
        // image upload
        uploadImages(userId: "us", imagesArray: arrayOfImages) { str in
            print(str)
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
                                let stringRepresentation = self.arrayOfStrImages.joined(separator: ",")
                                var typeOfPrice = ""
                                typeOfPrice = "Total"
                                let infoToAdd : Dictionary<String, Any> = [
                                    "category" : "\(category)",
                                    "description" : "\(description)",
                                    "title" : "\(title)",
                                    "postId" : "\(key!)",
                                    "price" : Int(price),
                                    "type-of-price" : "\(typeOfPrice)",
                                    "lat" : Float(location.latitude),
                                    "time" : Int(Date().timeIntervalSince1970),
                                    "long" : Float(location.longitude),
                                    "author" : "\(Auth.auth().currentUser!.uid)",
                                    "image" : "\(stringRepresentation)"
                                ]
                                let postFeed = ["\(key!)" : infoToAdd]
                                Database.database().reference().child("Jobs").updateChildValues(postFeed) { (addInfoError, result) in
                                    if addInfoError == nil {
                                        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("services").observeSingleEvent(of: .value) { (ratingNum) in
                                            let value = ratingNum.value as? NSNumber
                                            let newNumber = Int(value!)
                                            Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("services").setValue(newNumber + 1)
                                        }
                                        switch self.categoryname {
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
                                        
                                        self.txtTitle.resignFirstResponder()
                                        self.txtDescription.resignFirstResponder()
                                        self.txtPrice.resignFirstResponder()
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
    }
    
    func upload(childRef: String) {
        Database.database().reference().child("Information").child("home").child(childRef).child("trueOrFalse").setValue("true")
    }
    
    
    func uploadImages(userId: String, imagesArray : [UIImage], completionHandler: @escaping (Bool) -> ()){
        var i = 0
        var complet = 0
        for image in imagesArray{
            i = i + 1
            
            guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
            let storageRef = Storage.storage().reference()
            
            let metadata = StorageMetadata()
            let key = Database.database().reference().child("Jobs").childByAutoId().key
            let storageProfileRef = storageRef.child("Jobs").child("\(Auth.auth().currentUser!.uid)").child(key!)
            
            metadata.contentType = "image/jpg"
            
            // Upload image to firebase
            storageProfileRef.putData(imageData, metadata: metadata) { (storageMetadata, putDataError) in
                if putDataError == nil && storageMetadata != nil {
                storageProfileRef.downloadURL { (url, downloadUrlError) in
                    if let metalImageUrl = url?.absoluteString {
                        print(metalImageUrl)
                        self.arrayOfStrImages.append("\(metalImageUrl)")
                        complet = complet + 1
                        if complet == imagesArray.count {
                            completionHandler(true)
                            self.colCoverPhoto.reloadData()
                        }
                    }else {
                        self.AlertView(Tlt: "Error", Msg: downloadUrlError!.localizedDescription)
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                }
                }else{
                    self.AlertView(Tlt: "Error", Msg: putDataError!.localizedDescription)
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
        }
    }
    
    @objc func loginPressed() {
        if imgCoverPhoto.image != nil {
            if txtTitle.text! != "" {
                if self.categoryname != "Select Here" {
                    if txtDescription.text! != "" {
                        let my_Price = self.txtPrice.text!.dropFirst()
                        if my_Price != "" {
                            self.continueWith(image: self.imgCoverPhoto.image!, title: self.txtTitle.text!, category: self.categoryname, description: self.txtDescription.text!, price: Int(my_Price)!)
                        } else {
                            AlertView(Tlt: "Error", Msg: "Please set a price")
                        }
                    } else {
                        AlertView(Tlt: "Error", Msg: "Please set a description")
                    }
                } else {
                    AlertView(Tlt: "Error", Msg: "Please select a category")
                }
            } else {
                AlertView(Tlt: "Error", Msg: "Please go back and set title")
            }
        } else {
            AlertView(Tlt: "Error", Msg: "Please go back and attach an image")
        }
    }
    
    func ViewBorder()  {
        VWDesc.layer.borderColor = UIColor(named: "LightGray")?.cgColor
        VWTlt.layer.borderColor = UIColor(named: "LightGray")?.cgColor
    }
    
    func AlertView(Tlt : String, Msg : String)  {
        let alert = UIAlertController(title: Tlt, message: Msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Button Action
    
    @IBAction func btnBackButton(_ sender: UIButton) {
        exitTapped()
    }
 
    
    @IBAction func btnDeleteButton(_ sender: UIButton) {
        print("addCoverPhoto")
        ViewBorder()
    }
    
    @IBAction func btnApplyEditButton(_ sender: UIButton) {
     //   handlePost()
        ViewBorder()
        loginPressed()
    }
    
    @IBAction func addCoverPhoto() {
        print("addCoverPhoto")
        ViewBorder()
        if self.arrayOfImages.count <= 4 {
            let alertVC = ChooseYourSourceVC.init(nibName: "ChooseYourSourceVC", bundle: nil)
            alertVC.modalPresentationStyle = .custom
            alertVC.imgName = {(img) -> Void in
                self.imgCoverPhoto.image = img
                self.arrayOfImages.append(img)
                self.colCoverPhoto.reloadData()
            }
            self.present(alertVC, animated: true, completion: nil)
        }else{
            AlertView(Tlt: "Cover Photos", Msg: "You have selected maximum five images")
        }
    }
    
    @IBAction func brnCategoryButton(_ sender: UIButton) {
        ViewBorder()
        let alertVC = CategoryVC.init(nibName: "CategoryVC", bundle: nil)
        alertVC.modalPresentationStyle = .custom
        alertVC.CategoryData = {(categoryName,categoryImage) -> Void in
            self.btnCategory.setTitle(categoryName, for: .normal)
            self.categoryname = categoryName
        }
        self.present(alertVC, animated: true, completion: nil)
        
    }
}

extension CreatePosts: UICollectionViewDelegate, UICollectionViewDataSource  {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoverPhotoCell", for: indexPath) as! CoverPhotoCell
        cell.imgCoverPhoto.image = arrayOfImages[indexPath.item]
        self.lblPhotoCount.text = "\(self.arrayOfImages.count)/5"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
       
    }
    
    
}
extension CreatePosts: UITextFieldDelegate  {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView == txtDescription {
            VWDesc.layer.borderColor = UIColor.black.cgColor
            VWTlt.layer.borderColor = UIColor(named: "LightGray")?.cgColor
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtTitle {
            VWDesc.layer.borderColor = UIColor(named: "LightGray")?.cgColor
            VWTlt.layer.borderColor = UIColor.black.cgColor
        }else{
            ViewBorder()
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.isFirstResponder {
            
            guard let stringRange = Range(range, in: textField.text!) else { return false }
            let updatedText = textField.text!.replacingCharacters(in: stringRange, with: string)
            
            // print(range.location,updatedText.count)
            // restrict special char in test field  ✔  ✔  ✓  ✔  ✓
            if (textField == self.txtPrice){
                if updatedText.count == 0 {
                    return false
                }
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtDescription {
            textField.resignFirstResponder()
        }
        return (true)
    }
}
