//
//  ChooseYourSourceVC.swift
//  HireMile
//
//  Created by mac on 17/06/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit

class ChooseYourSourceVC: UIViewController {

    @IBOutlet weak var containerView: UIView!
    let imagePicker = UIImagePickerController()
    
    var imgName : ((_ imgName : UIImage)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        // Do any additional setup after loading the view.
    }

    @IBAction func btnClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnTapped_UploadImage(_ sender: Any) {
        self.uploadPhoto()
    }
    
    @IBAction func btnTapped_TakePicture(_ sender: Any) {
        self.uploadPhotoTakePhoto()
    }
   

}

extension ChooseYourSourceVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       var img = UIImage()
        if let editedImage = info[.editedImage] as? UIImage {
            //self.imgCoverPhoto.image = editedImage
            img = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage{
            //self.imgCoverPhoto.image = originalImage
            img = originalImage
        }
        // self.imageHasBeenChanged = true
        dismiss(animated: true, completion: nil)
        
        if (imgName != nil){
            imgName!(img)
            self.dismiss(animated: false, completion: nil)
        }
    }
    
  
    func uploadPhoto() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func uploadPhotoTakePhoto() {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
}

