//
//  ViewGalleryItemController.swift
//  HireMile
//
//  Created by JJ Zapata on 5/10/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase

class ViewGalleryItemController: UIViewController {
    
    var url : String? {
        didSet {
            if let url = url {
                imageView.loadImage(from: URL(string: url)!)
            }
        }
    }
    
    var author : String? {
        didSet {
            if let author = author {
                if author == Auth.auth().currentUser!.uid {
                    addRemoveButton()
                }
            }
        }
    }
    
    var id : String?
    
    private let imageView : CustomImageView = {
        let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    private let removeButton : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitle("Remove Photo", for: UIControl.State.normal)
        button.setTitleColor(UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(removeButtonTapped), for: UIControl.Event.touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = view.frame.size.width
        let wantedWidth = width - 50
        let wantedHeight = wantedWidth
        
        view.backgroundColor = UIColor(red: 21/255, green: 21/255, blue: 23/255, alpha: 1)
        
        view.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: wantedWidth).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: wantedHeight).isActive = true

        // Do any additional setup after loading the view.
    }
    
    private func addRemoveButton() {
        view.addSubview(removeButton)
        removeButton.widthAnchor.constraint(equalToConstant: 203).isActive = true
        removeButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        removeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        removeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
    }
    
    @objc func removeButtonTapped() {
        let alert = UIAlertController(title: "Remove?", message: "Are you sure you would like to delete this photo?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (action) in
            Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("gallery").child(self.id!).removeValue()
            self.dismiss(animated: true) {
                self.dismiss(animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "No, Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}
