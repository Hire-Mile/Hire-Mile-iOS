//
//  FavoriteRemoveView.swift
//  HireMile
//
//  Created by JJ Zapata on 12/7/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class FavoriteRemoveView: NSObject {
    
    var uid = ""
    
    let height : CGFloat = 400
    
    let blackView = UIView()
    
    let filterView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 30
        return view
    }()
    
    let applyButton : UIButton = {
        let button = UIButton()
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.mainBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 25
        return button
    }()
    
    let discardButton : UIButton = {
        let button = UIButton()
        button.setTitle("No", for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.backgroundColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.darkGray.cgColor
        return button
    }()
    
    let filterTitle : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sure to unfollow?"
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 1
        return label
    }()
    
    let nameTitle : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Name"
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 32)
        label.numberOfLines = 1
        return label
    }()
    
    let profileImage : UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
//        iv.image = UIImage(named: "profilepic")
        iv.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 37.5
        iv.clipsToBounds = true
        return iv
    }()
    
    let exitButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.imageView?.tintColor = UIColor.black
        button.tintColor = UIColor.black
        return button
    }()
    
    override init() {
        super.init()
        
        // start working here :)
    }
    
    func doStuff() {
        
        self.applyButton.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        self.discardButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        self.exitButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
        filterView.addSubview(discardButton)
        self.discardButton.centerXAnchor.constraint(equalTo: self.filterView.centerXAnchor, constant: -75).isActive = true
        self.discardButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.discardButton.bottomAnchor.constraint(equalTo: self.filterView.bottomAnchor, constant: -85).isActive = true
        self.discardButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        filterView.addSubview(applyButton)
        self.applyButton.centerXAnchor.constraint(equalTo: self.filterView.centerXAnchor, constant: 75).isActive = true
        self.applyButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.applyButton.bottomAnchor.constraint(equalTo: self.filterView.bottomAnchor, constant: -85).isActive = true
        self.applyButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        filterView.addSubview(filterTitle)
        self.filterTitle.leftAnchor.constraint(equalTo: self.filterView.leftAnchor, constant: 30).isActive = true
        self.filterTitle.rightAnchor.constraint(equalTo: self.filterView.rightAnchor, constant: -30).isActive = true
        self.filterTitle.topAnchor.constraint(equalTo: self.filterView.topAnchor, constant: 30).isActive = true
        self.filterTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        filterView.addSubview(profileImage)
        self.profileImage.centerXAnchor.constraint(equalTo: self.filterView.centerXAnchor).isActive = true
        self.profileImage.widthAnchor.constraint(equalToConstant: 75).isActive = true
        self.profileImage.topAnchor.constraint(equalTo: self.filterTitle.bottomAnchor, constant: 45  ).isActive = true
        self.profileImage.heightAnchor.constraint(equalToConstant: 75).isActive = true
        self.profileImage.tintColor = UIColor.lightGray
        self.profileImage.contentMode = .scaleAspectFill
        
        filterView.addSubview(nameTitle)
        self.nameTitle.leftAnchor.constraint(equalTo: self.filterView.leftAnchor, constant: 40).isActive = true
        self.nameTitle.rightAnchor.constraint(equalTo: self.filterView.rightAnchor, constant: -30).isActive = true
        self.nameTitle.topAnchor.constraint(equalTo: self.profileImage.bottomAnchor, constant: 5).isActive = true
        self.nameTitle.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        filterView.addSubview(exitButton)
        self.exitButton.rightAnchor.constraint(equalTo: self.filterView.rightAnchor, constant: -30).isActive = true
        self.exitButton.topAnchor.constraint(equalTo: self.filterView.topAnchor, constant: 30).isActive = true
        self.exitButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.exitButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func showFilter(withName name: String, withImage image: String, withUid uid: String, isImageNil imageBool: Bool) {
        if let window = UIApplication.shared.keyWindow {
            blackView.frame = window.frame
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.alpha = 0
            window.addSubview(blackView)
            window.addSubview(filterView)
            
            self.nameTitle.text! = name
            
            if imageBool == true {
                self.profileImage.image = UIImage(systemName: "person.circle.fill")
            } else {
                self.profileImage.loadImageUsingCacheWithUrlString(image)
            }
            
            self.uid = "\(uid)"
            
            let y = window.frame.height - height
            filterView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 400)
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.blackView.alpha = 1
                self.filterView.frame = CGRect(x: 0, y: y, width: self.filterView.frame.width, height: self.filterView.frame.height)
            }) { (completion) in
                print("showing view")
                self.doStuff()
            }
        }
    }
    
    @objc func handleDelete() {
        if uid == Auth.auth().currentUser!.uid {
            UIView.animate(withDuration: 0.5) {
                self.blackView.alpha = 0
                if let window = UIApplication.shared.keyWindow {
                    self.filterView.frame = CGRect(x: 0, y: window.frame.height, width: self.filterView.frame.width, height: self.filterView.frame.height)
                }
            }
        } else {
            Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("favorites").child(uid).removeValue()
            UIView.animate(withDuration: 0.5) {
                self.blackView.alpha = 0
                if let window = UIApplication.shared.keyWindow {
                    self.filterView.frame = CGRect(x: 0, y: window.frame.height, width: self.filterView.frame.width, height: self.filterView.frame.height)
                    GlobalVariables.removedSomon = true
                }
            }
        }
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.filterView.frame = CGRect(x: 0, y: window.frame.height, width: self.filterView.frame.width, height: self.filterView.frame.height)
            }
        }
    }
}
