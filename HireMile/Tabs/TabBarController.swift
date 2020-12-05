//
//  TabBarControllerMain.swift
//  HireMile
//
//  Created by JJ Zapata on 11/16/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    var passingImage : UIImage?
    
    var timer : Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerFunction), userInfo: nil, repeats: true)
        
        tabBar.tintColor = UIColor.mainBlue
        
        let middleButton = UIButton()
        middleButton.frame.size = CGSize(width: 70, height: 70)
        middleButton.backgroundColor = UIColor.mainBlue
        middleButton.setTitleColor(UIColor.white, for: .normal)
        middleButton.setImage(UIImage(named: "postButton"), for: .normal)
        middleButton.layer.cornerRadius = 35
        middleButton.layer.masksToBounds = true
        middleButton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 65)
        middleButton.addTarget(self, action: #selector(openPost), for: .touchUpInside)
        view.addSubview(middleButton)
        
        let homeController = UINavigationController(rootViewController: Home())
        homeController.tabBarItem.image = UIImage(systemName: "house")
        homeController.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        
        let addController = UINavigationController(rootViewController: Chat())
        
        let chatController = UINavigationController(rootViewController: Chat())
        chatController.tabBarItem.image = UIImage(systemName: "text.bubble")
        chatController.tabBarItem.selectedImage = UIImage(systemName: "text.bubble.fill")
        
        viewControllers = [homeController, addController, chatController]

        // Do any additional setup after loading the view.
    }
    
    @objc func openPost() {
        let alert = UIAlertController(title: "Choose Your Source", message: "Where should you get your cover photo from?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = true
            self.imagePicker.delegate = self
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            self.passingImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            self.passingImage = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func timerFunction() {
        if self.passingImage != nil {
            GlobalVariables.postImage = passingImage!
            let controller = Post()
            controller.modalPresentationStyle = .fullScreen
            timer?.invalidate()
            self.present(controller, animated: true, completion: nil)
        }
    }

}
