//
//  MyProfile.swift
//  HireMile
//
//  Created by JJ Zapata on 12/1/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

protocol MyTableViewCellDelegate {
    func didTapEditButton(withIndex: Int)
    func didTapDeleteButton(withIndex: Int)
}

class MyProfile: UIViewController, UITableViewDelegate, UITableViewDataSource, MyTableViewCellDelegate {
    
    var indexPathrow = 0
    var indexTappeedd = 0
    var allJobs = [JobStructure]()
    var myJobs = [JobStructure]()
    var finalRating = 0
    var ratingNumber = 0
    var findingRating = true
    var hires = 0
    var totalusers = [UserStructure]()
    var iamfollowedby = 0
    var finalNumber = 0
    
    let filterLauncher = DeleteLauncher()
    
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.black
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let profileName : UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.numberOfLines = 1
        return label
    }()
    
    let star1 : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = UIColor.mainBlue
        return imageView
    }()
    
    let star2 : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = UIColor.mainBlue
        return imageView
    }()
    
    let star3 : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = UIColor.mainBlue
        return imageView
    }()
    
    let star4 : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = UIColor.mainBlue
        return imageView
    }()
    
    let star5 : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
        return imageView
    }()
    
    let seperaterView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let toolBarView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let secondImportantView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let thirdImportantView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let fourthImportantView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let secondTitleLabel : UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.black
        return label
    }()
    
    let secondDescLabel : UILabel = {
        let label = UILabel()
        label.text = "Services"
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let thirdTitleLabel : UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.black
        return label
    }()
    
    let thirdDescLabel : UILabel = {
        let label = UILabel()
        label.text = "Reviews"
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let fourthTitleLabel : UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.black
        return label
    }()
    
    let fourthDescLabel : UILabel = {
        let label = UILabel()
        label.text = "Followers"
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let seperaterView2 : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let myServices : UILabel = {
        let label = UILabel()
        label.text = "My Services"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 1
        return label
    }()
    
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
        return tableView
    }()
    
    let mainView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.backgroundColor = .white
        return view
    }()
    
    let backButtonView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 21
        view.backgroundColor = .white
        return view
    }()
    
    let backButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        button.backgroundColor = .clear
        return button
    }()
    
    let backButtonImage : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.tintColor = UIColor.black
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "chevron.backward")
        return imageView
    }()
    
    let editButtonView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 21
        view.backgroundColor = .white
        return view
    }()
    
    let editButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editPressed), for: .touchUpInside)
        button.backgroundColor = .clear
        return button
    }()
    
    let editButtonImage : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.tintColor = UIColor.black
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "pencil")
        return imageView
    }()
    
    let shareButtonView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 21
        view.backgroundColor = .white
        return view
    }()
    
    let shareButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(uploadPressed), for: .touchUpInside)
        button.backgroundColor = .clear
        return button
    }()
    
    let shareButtonImage : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.tintColor = UIColor.black
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "square.and.arrow.up")
        return imageView
    }()
    
    let bottomBar1 : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.mainBlue
        return view
    }()
    
    let bottomBar2 : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.mainBlue
        return view
    }()
    
    let bottomBar3 : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.mainBlue
        return view
    }()
    
    let ratingsButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(ratingsButtonPressed), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        profileImageView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        view.backgroundColor = UIColor.white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileCell.self, forCellReuseIdentifier: "profileCell")
        
        view.addSubview(mainView)
        mainView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        mainView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        mainView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        mainView.topAnchor.constraint(equalTo: self.profileImageView.bottomAnchor, constant: -30).isActive = true
        
        view.addSubview(backButtonView)
        backButtonView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        backButtonView.heightAnchor.constraint(equalToConstant: 42).isActive = true
        backButtonView.widthAnchor.constraint(equalToConstant: 42).isActive = true
        backButtonView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        
        backButtonView.addSubview(backButtonImage)
        backButtonImage.centerXAnchor.constraint(equalTo: self.backButtonView.centerXAnchor).isActive = true
        backButtonImage.centerYAnchor.constraint(equalTo: self.backButtonView.centerYAnchor).isActive = true
        backButtonImage.widthAnchor.constraint(equalToConstant: 25).isActive = true
        backButtonImage.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        backButtonView.addSubview(backButton)
        backButton.topAnchor.constraint(equalTo: backButtonView.topAnchor).isActive = true
        backButton.leftAnchor.constraint(equalTo: backButtonView.leftAnchor).isActive = true
        backButton.rightAnchor.constraint(equalTo: backButtonView.rightAnchor).isActive = true
        backButton.bottomAnchor.constraint(equalTo: backButtonView.bottomAnchor).isActive = true
        
        mainView.addSubview(profileName)
        profileName.topAnchor.constraint(equalTo: self.mainView.topAnchor, constant: 32).isActive = true
        profileName.leftAnchor.constraint(equalTo: self.mainView.leftAnchor, constant: 32).isActive = true
        profileName.rightAnchor.constraint(equalTo: self.mainView.rightAnchor, constant: 32).isActive = true
        profileName.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(editButtonView)
        editButtonView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        editButtonView.heightAnchor.constraint(equalToConstant: 42).isActive = true
        editButtonView.widthAnchor.constraint(equalToConstant: 42).isActive = true
        editButtonView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        
        editButtonView.addSubview(editButtonImage)
        editButtonImage.centerXAnchor.constraint(equalTo: self.editButtonView.centerXAnchor).isActive = true
        editButtonImage.centerYAnchor.constraint(equalTo: self.editButtonView.centerYAnchor).isActive = true
        editButtonImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        editButtonImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        editButtonView.addSubview(editButton)
        editButton.topAnchor.constraint(equalTo: editButtonView.topAnchor).isActive = true
        editButton.leftAnchor.constraint(equalTo: editButtonView.leftAnchor).isActive = true
        editButton.rightAnchor.constraint(equalTo: editButtonView.rightAnchor).isActive = true
        editButton.bottomAnchor.constraint(equalTo: editButtonView.bottomAnchor).isActive = true
        
        view.addSubview(shareButtonView)
        shareButtonView.rightAnchor.constraint(equalTo: self.editButtonView.leftAnchor, constant: -16).isActive = true
        shareButtonView.heightAnchor.constraint(equalToConstant: 42).isActive = true
        shareButtonView.widthAnchor.constraint(equalToConstant: 42).isActive = true
        shareButtonView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        
        shareButtonView.addSubview(shareButtonImage)
        shareButtonImage.centerXAnchor.constraint(equalTo: self.shareButtonView.centerXAnchor).isActive = true
        shareButtonImage.centerYAnchor.constraint(equalTo: self.shareButtonView.centerYAnchor).isActive = true
        shareButtonImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        shareButtonImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        shareButtonView.addSubview(shareButton)
        shareButton.topAnchor.constraint(equalTo: shareButtonView.topAnchor).isActive = true
        shareButton.leftAnchor.constraint(equalTo: shareButtonView.leftAnchor).isActive = true
        shareButton.rightAnchor.constraint(equalTo: shareButtonView.rightAnchor).isActive = true
        shareButton.bottomAnchor.constraint(equalTo: shareButtonView.bottomAnchor).isActive = true
        
        mainView.addSubview(seperaterView)
        seperaterView.topAnchor.constraint(equalTo: self.profileName.bottomAnchor, constant: 15).isActive = true
        seperaterView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        seperaterView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        seperaterView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        mainView.addSubview(toolBarView)
        toolBarView.topAnchor.constraint(equalTo: self.seperaterView.bottomAnchor).isActive = true
        toolBarView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        toolBarView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        toolBarView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        toolBarView.addSubview(secondImportantView)
        secondImportantView.topAnchor.constraint(equalTo: toolBarView.topAnchor).isActive = true
        secondImportantView.leftAnchor.constraint(equalTo: toolBarView.leftAnchor).isActive = true
        secondImportantView.bottomAnchor.constraint(equalTo: toolBarView.bottomAnchor).isActive = true
        secondImportantView.widthAnchor.constraint(equalToConstant: view.frame.width / 3).isActive = true
        
        secondImportantView.addSubview(secondTitleLabel)
        secondTitleLabel.topAnchor.constraint(equalTo: secondImportantView.topAnchor).isActive = true
        secondTitleLabel.leftAnchor.constraint(equalTo: secondImportantView.leftAnchor).isActive = true
        secondTitleLabel.rightAnchor.constraint(equalTo: secondImportantView.rightAnchor).isActive = true
        secondTitleLabel.bottomAnchor.constraint(equalTo: secondImportantView.bottomAnchor, constant: -15).isActive = true
        
        secondImportantView.addSubview(secondDescLabel)
        secondDescLabel.topAnchor.constraint(equalTo: secondImportantView.topAnchor, constant: 25).isActive = true
        secondDescLabel.leftAnchor.constraint(equalTo: secondImportantView.leftAnchor).isActive = true
        secondDescLabel.rightAnchor.constraint(equalTo: secondImportantView.rightAnchor).isActive = true
        secondDescLabel.bottomAnchor.constraint(equalTo: secondImportantView.bottomAnchor).isActive = true
        
//        secondImportantView.addSubview(bottomBar1)
//        bottomBar1.bottomAnchor.constraint(equalTo: secondImportantView.bottomAnchor).isActive = true
//        bottomBar1.leftAnchor.constraint(equalTo: secondImportantView.leftAnchor, constant: 20).isActive = true
//        bottomBar1.rightAnchor.constraint(equalTo: secondImportantView.rightAnchor, constant: -20).isActive = true
//        bottomBar1.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        toolBarView.addSubview(thirdImportantView)
        thirdImportantView.topAnchor.constraint(equalTo: toolBarView.topAnchor).isActive = true
        thirdImportantView.leftAnchor.constraint(equalTo: secondImportantView.rightAnchor).isActive = true
        thirdImportantView.bottomAnchor.constraint(equalTo: toolBarView.bottomAnchor).isActive = true
        thirdImportantView.widthAnchor.constraint(equalToConstant: view.frame.width / 3).isActive = true
        
        thirdImportantView.addSubview(thirdTitleLabel)
        thirdTitleLabel.topAnchor.constraint(equalTo: thirdImportantView.topAnchor).isActive = true
        thirdTitleLabel.leftAnchor.constraint(equalTo: thirdImportantView.leftAnchor).isActive = true
        thirdTitleLabel.rightAnchor.constraint(equalTo: thirdImportantView.rightAnchor).isActive = true
        thirdTitleLabel.bottomAnchor.constraint(equalTo: thirdImportantView.bottomAnchor, constant: -15).isActive = true
        
        thirdImportantView.addSubview(thirdDescLabel)
        thirdDescLabel.topAnchor.constraint(equalTo: thirdImportantView.topAnchor, constant: 25).isActive = true
        thirdDescLabel.leftAnchor.constraint(equalTo: thirdImportantView.leftAnchor).isActive = true
        thirdDescLabel.rightAnchor.constraint(equalTo: thirdImportantView.rightAnchor).isActive = true
        thirdDescLabel.bottomAnchor.constraint(equalTo: thirdImportantView.bottomAnchor).isActive = true
        
//        thirdImportantView.addSubview(bottomBar2)
//        bottomBar2.bottomAnchor.constraint(equalTo: thirdImportantView.bottomAnchor).isActive = true
//        bottomBar2.leftAnchor.constraint(equalTo: thirdImportantView.leftAnchor, constant: 20).isActive = true
//        bottomBar2.rightAnchor.constraint(equalTo: thirdImportantView.rightAnchor, constant: -20).isActive = true
//        bottomBar2.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        toolBarView.addSubview(fourthImportantView)
        fourthImportantView.topAnchor.constraint(equalTo: toolBarView.topAnchor).isActive = true
        fourthImportantView.rightAnchor.constraint(equalTo: toolBarView.rightAnchor).isActive = true
        fourthImportantView.bottomAnchor.constraint(equalTo: toolBarView.bottomAnchor).isActive = true
        fourthImportantView.widthAnchor.constraint(equalToConstant: view.frame.width / 3).isActive = true

        fourthImportantView.addSubview(fourthTitleLabel)
        fourthTitleLabel.topAnchor.constraint(equalTo: fourthImportantView.topAnchor).isActive = true
        fourthTitleLabel.leftAnchor.constraint(equalTo: fourthImportantView.leftAnchor).isActive = true
        fourthTitleLabel.rightAnchor.constraint(equalTo: fourthImportantView.rightAnchor).isActive = true
        fourthTitleLabel.bottomAnchor.constraint(equalTo: fourthImportantView.bottomAnchor, constant: -15).isActive = true

        fourthImportantView.addSubview(fourthDescLabel)
        fourthDescLabel.topAnchor.constraint(equalTo: fourthImportantView.topAnchor, constant: 25).isActive = true
        fourthDescLabel.leftAnchor.constraint(equalTo: fourthImportantView.leftAnchor).isActive = true
        fourthDescLabel.rightAnchor.constraint(equalTo: fourthImportantView.rightAnchor).isActive = true
        fourthDescLabel.bottomAnchor.constraint(equalTo: fourthImportantView.bottomAnchor).isActive = true
        
//        fourthImportantView.addSubview(bottomBar3)
//        bottomBar3.bottomAnchor.constraint(equalTo: fourthImportantView.bottomAnchor).isActive = true
//        bottomBar3.leftAnchor.constraint(equalTo: fourthImportantView.leftAnchor, constant: 20).isActive = true
//        bottomBar3.rightAnchor.constraint(equalTo: fourthImportantView.rightAnchor, constant: -20).isActive = true
//        bottomBar3.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        mainView.addSubview(seperaterView2)
        seperaterView2.topAnchor.constraint(equalTo: self.toolBarView.bottomAnchor).isActive = true
        seperaterView2.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        seperaterView2.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        seperaterView2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        mainView.addSubview(myServices)
        myServices.topAnchor.constraint(equalTo: self.seperaterView2.bottomAnchor, constant: 25).isActive = true
        myServices.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32).isActive = true
        myServices.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        myServices.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        mainView.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: self.myServices.bottomAnchor, constant: 32).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 10).isActive = true
        
        thirdImportantView.addSubview(ratingsButton)
        self.ratingsButton.topAnchor.constraint(equalTo: thirdImportantView.topAnchor).isActive = true
        self.ratingsButton.bottomAnchor.constraint(equalTo: thirdImportantView.bottomAnchor).isActive = true
        self.ratingsButton.leftAnchor.constraint(equalTo: thirdImportantView.leftAnchor).isActive = true
        self.ratingsButton.rightAnchor.constraint(equalTo: thirdImportantView.rightAnchor).isActive = true
        
        // profile image view
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("profile-image").observe(.value) { (snapshot) in
            let profileImageString : String = (snapshot.value as? String)!
            if profileImageString == "not-yet-selected" {
                self.profileImageView.tintColor = UIColor.lightGray
                self.profileImageView.tintColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
                self.profileImageView.contentMode = .scaleAspectFill
            } else {
                self.profileImageView.loadImageUsingCacheWithUrlString(profileImageString)
                self.profileImageView.tintColor = UIColor.lightGray
                self.profileImageView.contentMode = .scaleAspectFill
            }
        }
        
        // name
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("name").observe(.value) { (snapshot) in
            let userName : String = (snapshot.value as? String)!
            self.profileName.text = userName
        }
        
        if self.findingRating == true {
            // find rating
            Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("number-of-ratings").observeSingleEvent(of: .value) { (ratingNum) in
                let value = ratingNum.value as? NSNumber
                let newNumber = Float(value!)
                if newNumber == 0 {
                    self.star1.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                    self.star2.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                    self.star3.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                    self.star4.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                    self.star5.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                } else {
                    self.getAllRatings()
                }
            }
        }
        
        self.getAllFollowers()
        
        self.allJobs.removeAll()
        self.myJobs.removeAll()
        Database.database().reference().child("Jobs").observe(.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                let job = JobStructure()
                job.authorName = value["author"] as? String ?? "Error"
                job.titleOfPost = value["title"] as? String ?? "Error"
                job.descriptionOfPost = value["description"] as? String ?? "Error"
                job.price = value["price"] as? Int ?? 0
                job.category = value["category"] as? String ?? "Error"
                job.imagePost = value["image"] as? String ?? "Error"
                job.typeOfPrice = value["type-of-price"] as? String ?? "Error"
                job.postId = value["postId"] as? String ?? "Error"
                
                if job.authorName ==  Auth.auth().currentUser!.uid {
                    print("my name")
                    self.myJobs.append(job)
                }
            }
            self.secondTitleLabel.text = String(self.myJobs.count)
            self.tableView.reloadData()
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationController?.navigationBar.tintColor = UIColor.black
//        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let btnProfile = UIButton(type: .system)
        btnProfile.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        btnProfile.setImage(UIImage(systemName: "pencil"), for: .normal)
        btnProfile.tintColor = UIColor.black
        btnProfile.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btnProfile.addTarget(self, action: #selector(self.editPressed), for: .touchUpInside)
        btnProfile.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
        btnProfile.layer.cornerRadius = 25
        btnProfile.layer.masksToBounds = true
        
        let share = UIButton(type: .system)
        
        share.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        share.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        share.tintColor = UIColor.black
        share.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        share.addTarget(self, action: #selector(self.uploadPressed), for: .touchUpInside)
        share.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
        share.layer.cornerRadius = 25
        share.layer.masksToBounds = true
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: btnProfile), UIBarButtonItem(customView: share)]
    }
    
    func getAllFollowers() {
        self.totalusers.removeAll()
        Database.database().reference().child("Users").observe(.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                let user = UserStructure()
                user.uid = value["uid"] as? String ?? "Error"
                print("hello user, \(snapshot.key)")
                Database.database().reference().child("Users").child(snapshot.key).child("favorites").observe(.childAdded) { (favoritesSnap) in
                    if let favorites = favoritesSnap.value as? [String : Any] {
                        let favorite = UserStructure()
                        favorite.uid = favoritesSnap.key
                        print("\(snapshot.key) is following \(favorite.uid)")
                        if favorite.uid == Auth.auth().currentUser!.uid {
                            print("i am followed by \(snapshot.key)")
                            self.iamfollowedby += 1
                        }
                    }
                }
            }
        }
        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.setFollowPeople), userInfo: nil, repeats: false)
    }
    
    @objc func setFollowPeople() {
        print("hi")
        self.fourthTitleLabel.text = "\(self.iamfollowedby)"
    }
    
    func getAllRatings() {
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("ratings").observe(.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                let job = ReviewStructure()
                job.ratingNumber = value["rating-number"] as? Int ?? 0
                self.ratingNumber += 1
                print("found rating")
                self.finalRating += job.ratingNumber!
            }
            
            print(self.ratingNumber)
            self.thirdTitleLabel.text = String(self.ratingNumber)
            print("updating rating label")
            
            let finalNumber = self.finalRating / self.ratingNumber
            self.finalNumber = finalNumber
            
            switch finalNumber {
            case 0:
                self.star1.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                self.star2.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                self.star3.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                self.star4.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                self.star5.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
            case 1:
                self.star1.tintColor = UIColor.mainBlue
                self.star2.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                self.star3.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                self.star4.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                self.star5.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
            case 2:
                self.star1.tintColor = UIColor.mainBlue
                self.star2.tintColor = UIColor.mainBlue
                self.star3.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                self.star4.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                self.star5.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
            case 3:
                self.star1.tintColor = UIColor.mainBlue
                self.star2.tintColor = UIColor.mainBlue
                self.star3.tintColor = UIColor.mainBlue
                self.star4.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                self.star5.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
            case 4:
                self.star1.tintColor = UIColor.mainBlue
                self.star2.tintColor = UIColor.mainBlue
                self.star3.tintColor = UIColor.mainBlue
                self.star4.tintColor = UIColor.mainBlue
                self.star5.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
            case 5:
                self.star1.tintColor = UIColor.mainBlue
                self.star2.tintColor = UIColor.mainBlue
                self.star3.tintColor = UIColor.mainBlue
                self.star4.tintColor = UIColor.mainBlue
                self.star5.tintColor = UIColor.mainBlue
            default:
                print("hello")
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.myServices.text = "My Services"
        return myJobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileCell
        
        cell.selectionStyle = .none
        cell.delegate = self
        cell.index = indexPath
        
        let url = URL(string: self.myJobs[indexPath.row].imagePost!)
        cell.postImageView.kf.setImage(with: url)
        
        cell.titleJob.text = self.myJobs[indexPath.row].titleOfPost!
        cell.postId = self.myJobs[indexPath.row].postId!
        cell.saleNumber.text = self.myJobs[indexPath.row].descriptionOfPost!
        if self.myJobs[indexPath.row].typeOfPrice == "Hourly" {
            cell.priceNumber.text = "$\(self.myJobs[indexPath.row].price!) / Hour"
        } else {
            cell.priceNumber.text = "$\(self.myJobs[indexPath.row].price!)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = URL(string: self.myJobs[indexPath.row].imagePost!)
        GlobalVariables.imagePost.kf.setImage(with: url)
        GlobalVariables.postImageDownlodUrl = self.myJobs[indexPath.row].imagePost!
        GlobalVariables.postTitle = self.myJobs[indexPath.row].titleOfPost!
        GlobalVariables.postDescription = self.myJobs[indexPath.row].descriptionOfPost!
        GlobalVariables.postPrice = self.myJobs[indexPath.row].price!
        GlobalVariables.authorId = self.myJobs[indexPath.row].authorName!
        GlobalVariables.postId = self.myJobs[indexPath.row].postId!
        GlobalVariables.categoryName = self.myJobs[indexPath.row].typeOfPrice!
        
        self.navigationController?.pushViewController(ViewPostController(), animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    
    @objc func uploadPressed() {
        let text = "Hire or get work on the fastest and easiest platform"
        let url : NSURL = NSURL(string: "https://www.hiremile.com")!
        let vc = UIActivityViewController(activityItems: [text, url], applicationActivities: [])
        if let popoverController = vc.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = self.view.bounds
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func deletePostPressed() {
        Database.database().reference().child("Jobs").child(self.myJobs[indexTappeedd].postId!).removeValue()
        self.filterLauncher.handleDismiss()
        self.viewWillAppear(true)
    }
    
    @objc func editPressed() {
        self.navigationController?.pushViewController(EditProfile(), animated: true)
    }
    
    func didTapEditButton(withIndex index: Int) {
        let url = URL(string: self.myJobs[index].imagePost!)
        GlobalVariables.imagePost.kf.setImage(with: url)
        GlobalVariables.postImageDownlodUrl = self.myJobs[indexPathrow].imagePost!
        GlobalVariables.postTitle = self.myJobs[indexPathrow].titleOfPost!
        GlobalVariables.postDescription = self.myJobs[indexPathrow].descriptionOfPost!
        GlobalVariables.postPrice = self.myJobs[indexPathrow].price!
        GlobalVariables.authorId = self.myJobs[indexPathrow].authorName!
        GlobalVariables.postId = self.myJobs[indexPathrow].postId!
        GlobalVariables.type = self.myJobs[indexPathrow].typeOfPrice!
        self.navigationController?.pushViewController(EditPost(), animated: true)
    }
    
    func didTapDeleteButton(withIndex index: Int) {
        print("hello, \(index)")
        self.indexTappeedd = index
        self.filterLauncher.stopJob.addTarget(self, action: #selector(self.deletePostPressed), for: .touchUpInside)
        self.filterLauncher.showFilter()
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func ratingsButtonPressed() {
        if self.ratingNumber != 0 {
            let controller = RatingsController()
            controller.finalRating = self.finalNumber
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

}

class ProfileCell: UITableViewCell {
    
    var delegate : MyTableViewCellDelegate?
    
    var postId = ""
    
    var index : IndexPath?
    
    let postImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let informationView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 10
        view.layer.cornerRadius = 15
        return view
    }()
    
    let titleJob : UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 1
        return label
    }()
    
    let saleNumber : UILabel = {
        let label = UILabel()
        label.text = "Sales"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 1
        return label
    }()
    
    let priceNumber : UILabel = {
        let label = UILabel()
        label.text = "Cost"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    let editButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.mainBlue.cgColor
        return button
    }()
    
    let deleteButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.mainBlue.cgColor
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        isUserInteractionEnabled = true
            
        addSubview(informationView)
        informationView.topAnchor.constraint(equalTo: self.topAnchor, constant: 25).isActive = true
        informationView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -25).isActive = true
        informationView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25).isActive = true
        informationView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25).isActive = true
        
        informationView.addSubview(postImageView)
        postImageView.topAnchor.constraint(equalTo: informationView.topAnchor, constant: -10).isActive = true
        postImageView.leftAnchor.constraint(equalTo: informationView.leftAnchor, constant: -10).isActive = true
        postImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        postImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        informationView.addSubview(priceNumber)
        priceNumber.topAnchor.constraint(equalTo: informationView.topAnchor, constant: 10).isActive = true
        priceNumber.rightAnchor.constraint(equalTo: informationView.rightAnchor, constant: -10).isActive = true
        priceNumber.heightAnchor.constraint(equalToConstant: 25).isActive = true
        priceNumber.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        informationView.addSubview(titleJob)
        titleJob.topAnchor.constraint(equalTo: self.topAnchor, constant: 40).isActive = true
        titleJob.rightAnchor.constraint(equalTo: priceNumber.leftAnchor).isActive = true
        titleJob.leftAnchor.constraint(equalTo: self.postImageView.rightAnchor, constant: 25).isActive = true
        titleJob.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        informationView.addSubview(saleNumber)
        saleNumber.topAnchor.constraint(equalTo: self.titleJob.bottomAnchor, constant: -5).isActive = true
        saleNumber.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -25).isActive = true
        saleNumber.leftAnchor.constraint(equalTo: self.postImageView.rightAnchor, constant: 25).isActive = true
        saleNumber.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        contentView.addSubview(editButton)
        editButton.layer.cornerRadius = 15
        editButton.layer.masksToBounds = true
        editButton.topAnchor.constraint(equalTo: saleNumber.bottomAnchor, constant: 7).isActive = true
        editButton.rightAnchor.constraint(equalTo: informationView.rightAnchor, constant: -15).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: 85).isActive = true

        contentView.addSubview(deleteButton)
        deleteButton.layer.cornerRadius = 15
        deleteButton.layer.masksToBounds = true
        deleteButton.topAnchor.constraint(equalTo: saleNumber.bottomAnchor, constant: 7).isActive = true
        deleteButton.rightAnchor.constraint(equalTo: editButton.leftAnchor, constant: -15).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 85).isActive = true
        
        editButton.addTarget(self, action: #selector(editPostPressed), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deletePostPressed), for: .touchUpInside)
    }
    
    @objc func editPostPressed() {
        delegate?.didTapEditButton(withIndex: (index?.row)!)
    }
    
    @objc func deletePostPressed() {
        delegate?.didTapDeleteButton(withIndex: (index?.row)!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
