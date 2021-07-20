//
//  EditPostsVC.swift
//  HireMile
//
//  Created by mac on 15/06/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import MBProgressHUD
class EditPostsVC: UIViewController,UITextViewDelegate {
    
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
    
    var index = 0
    
    var hsaPicked = false

    var imagePost = ""
    var postImageDownlodUrl = ""
    var postTitle = ""
    var postDescription = ""
    var postPrice = 0
    var authorId = ""
    var postId = ""
    var type = ""
    var category = ""
    
    var coverPhotoCount  = 0
    
    let filterLauncher = EditPostLauncher()
   
    var arrayOfImages = [UIImage]()
    var arrayOfStrImages = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UISetUp()
    }
    
    // MARK: Page Function
    
    func UISetUp()  {
        self.txtTitle.delegate = self
        self.txtPrice.delegate = self
        self.txtDescription.delegate = self
        
        self.colCoverPhoto.register(UINib(nibName: "CoverPhotoCell", bundle: nil), forCellWithReuseIdentifier: "CoverPhotoCell")

        let flow = UICollectionViewFlowLayout()
        let vwWidth = (colCoverPhoto.frame.width-60)/4
        flow.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        flow.itemSize = CGSize(width: vwWidth, height: vwWidth)
        flow.minimumInteritemSpacing = 10
        flow.scrollDirection = .horizontal
        flow.minimumLineSpacing = 10
        colCoverPhoto?.setCollectionViewLayout(flow, animated: false)
        
        let array = postImageDownlodUrl.components(separatedBy: ",")
        arrayOfStrImages = array
            
        self.imgCoverPhoto.sd_setImage(with: URL(string: arrayOfStrImages[0]), completed: nil)
        
        self.coverPhotoCount = self.arrayOfStrImages.count
        self.lblPhotoCount.text = "\(self.colCoverPhoto!)/5"
        self.txtTitle.text = postTitle
        self.txtDescription.text = postDescription
        self.txtPrice.text = "$\(postPrice)" //String(postPrice)
        self.btnCategory.setTitle(self.category, for: .normal)
        
        colCoverPhoto.reloadData()
    }
    
    func uploadImages(userId: String, imagesArray : [UIImage], completionHandler: @escaping (Bool) -> ()){
        var i = 0
        var complet = 0
        for image in imagesArray{
            i = i + 1
            
            guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
            let storageRef = Storage.storage().reference()
            
            let metadata = StorageMetadata()
            let storageProfileRef = storageRef.child("Jobs").child("\(Auth.auth().currentUser!.uid)").child("\(postId)\(i).jpg")
            
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
                            MBProgressHUD.hide(for: self.view, animated: true)
                            let alert = UIAlertController(title: "Error", message: downloadUrlError!.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }else{
                    MBProgressHUD.hide(for: self.view, animated: true)
                    let alert = UIAlertController(title: "Error", message: putDataError!.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

    @objc func handlePost(back : Bool) {
        if self.txtTitle.text! == "" || self.txtDescription.text! == "" || self.txtPrice.text! == "" {
            let alert = UIAlertController(title: "Error", message: "Please make sure that all fields are filled in and a category is selected", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            // show loader
            MBProgressHUD.showAdded(to: self.view, animated: true)
            // image upload
            if arrayOfImages.count > 0 {
                uploadImages(userId: "us", imagesArray: arrayOfImages) { str in
                    print(str)
                    self.editData(back: back)
                }
            }else{
                self.editData(back: back)
            }
        }
    }
    
    func editData(back : Bool) {
        //   print(metalImageUrl)
        let stringRepresentation = self.arrayOfStrImages.joined(separator: ",")
        
        // info upload
        var typeOfPrice = ""
        typeOfPrice = "Total"
        
        let my_Price = self.txtPrice.text!.dropFirst()
        //Int(self.txtPrice.text!)
        let infoToAdd : Dictionary<String, Any> = [
            "description" : "\(self.txtDescription.text!)",
            "title" : "\(self.txtTitle.text!)",
            "postId" : "\(self.postId)",
            "price" : Int(my_Price)!,
            "type-of-price" : "\(typeOfPrice)",
            "author" : "\(Auth.auth().currentUser!.uid)",
            "image" : "\(stringRepresentation)",
            "category" : "\(self.btnCategory.currentTitle!)"
        ]
        let postFeed = ["\(self.postId)" : infoToAdd]
        Database.database().reference().child("Jobs").updateChildValues(postFeed) { (addInfoError, result) in
            if addInfoError == nil {
                Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("services").observeSingleEvent(of: .value) { (ratingNum) in
                    let value = ratingNum.value as? NSNumber
                    let newNumber = Int(value!)
                    Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("services").setValue(newNumber + 1)
                }
                switch self.btnCategory.currentTitle {
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
                //   self.postId = ""
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
    }
    
    func upload(childRef: String) {
        Database.database().reference().child("Information").child("home").child(childRef).child("trueOrFalse").setValue("true")
    }
    
    @objc func dismissPressed() {
        self.navigationController?.popViewController(animated: true)
    }

    func ViewBorder()  {
        VWDesc.layer.borderColor = UIColor(named: "LightGray")?.cgColor
        VWTlt.layer.borderColor = UIColor(named: "LightGray")?.cgColor
    }
    
    // MARK: Button Action
    
    @IBAction func btnBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnEditButton(_ sender: UIButton) {
        print("addCoverPhoto")
        ViewBorder()
    }
    
    @IBAction func btnDeleteButton(_ sender: UIButton) {
        print("addCoverPhoto")
        ViewBorder()
    }
    
    @IBAction func btnApplyEditButton(_ sender: UIButton) {
        ViewBorder()
        handlePost(back: true)
    }
    
    @IBAction func addCoverPhoto() {
        print("addCoverPhoto")
        ViewBorder()
        if self.arrayOfImages.count <= 4 && self.arrayOfStrImages.count <= 4 {
            let alertVC = ChooseYourSourceVC.init(nibName: "ChooseYourSourceVC", bundle: nil)
            alertVC.modalPresentationStyle = .custom
            alertVC.imgName = {(ifo,img) -> Void in
                self.imgCoverPhoto.image = img
                //self.arrayOfImages.append(img)
                MBProgressHUD.showAdded(to: self.view, animated: true)
                self.uploadImages(userId: "us", imagesArray: [img]) { _ in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.colCoverPhoto.reloadData()
                }
                self.colCoverPhoto.reloadData()
            }
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func brnCategoryButton(_ sender: UIButton) {
        ViewBorder()
        let alertVC = CategoryVC.init(nibName: "CategoryVC", bundle: nil)
        alertVC.modalPresentationStyle = .custom
        alertVC.CategoryData = {(categoryName,categoryImage) -> Void in
            self.btnCategory.setTitle(categoryName, for: .normal)
        }
        self.present(alertVC, animated: true, completion: nil)
    }
}

extension EditPostsVC: UICollectionViewDelegate, UICollectionViewDataSource  {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfStrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoverPhotoCell", for: indexPath) as! CoverPhotoCell
        cell.imgCoverPhoto.sd_setImage(with: URL(string: arrayOfStrImages[indexPath.item]), completed: nil)
      //  cell.imgCoverPhoto.image = UIImage(named: arrayOfStrImages[indexPath.item])
        self.lblPhotoCount.text = "\(self.arrayOfStrImages.count)/5"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
       
    }
    
    
}
extension EditPostsVC: UITextFieldDelegate  {
    
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
