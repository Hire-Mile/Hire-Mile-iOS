//
//  OtherProfile.swift
//  HireMile
//
//  Created by JJ Zapata on 11/23/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class OtherProfile: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var allJobs = [JobStructure]()
    var myJobs = [JobStructure]()
    var favorites = [UserStructure]()
    var userUid = GlobalVariables.userUID
    var isFollowing : Bool?
    var finalRating = 0
    var ratingNumber = 0
    var findingRating = true
    var hires = 0
    var iamfollowedby = 0
    var totalusers = [UserStructure]()
    var finalNumber = 0
    
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
        label.font = UIFont.boldSystemFont(ofSize: 20)
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
    
    let statusButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.mainBlue
        button.setTitle("Follow", for: .normal)
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(followingPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return button
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
        
        self.updateFollowingButton(isFollowing: false)
        
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
                
                if job.authorName ==  GlobalVariables.userUID {
                    print("my name")
                    self.myJobs.append(job)
                }
            }
            self.secondTitleLabel.text = String(self.myJobs.count)
            self.tableView.reloadData()
        }
        
        view.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        profileImageView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 270).isActive = true
        
        view.backgroundColor = UIColor.white
        
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
        profileName.rightAnchor.constraint(equalTo: self.mainView.rightAnchor, constant: -160).isActive = true
        profileName.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        mainView.addSubview(statusButton)
        statusButton.rightAnchor.constraint(equalTo: self.mainView.rightAnchor, constant: -32).isActive = true
        statusButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        statusButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        statusButton.centerYAnchor.constraint(equalTo: self.profileName.centerYAnchor).isActive = true
        
        view.addSubview(shareButtonView)
        shareButtonView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
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
        tableView.topAnchor.constraint(equalTo: self.myServices.bottomAnchor, constant: 10).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 10).isActive = true
        
        thirdImportantView.addSubview(ratingsButton)
        self.ratingsButton.topAnchor.constraint(equalTo: thirdImportantView.topAnchor).isActive = true
        self.ratingsButton.bottomAnchor.constraint(equalTo: thirdImportantView.bottomAnchor).isActive = true
        self.ratingsButton.leftAnchor.constraint(equalTo: thirdImportantView.leftAnchor).isActive = true
        self.ratingsButton.rightAnchor.constraint(equalTo: thirdImportantView.rightAnchor).isActive = true
        
        view.backgroundColor = UIColor.white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(OtherProfileCell.self, forCellReuseIdentifier: "profileCell")
        
        // image
        let uid = GlobalVariables.userUID
        Database.database().reference().child("Users").child(GlobalVariables.userUID).child("profile-image").observe(.value) { (snapshot) in
            let urlImage : String = (snapshot.value as? String)!
            if urlImage == "not-yet-selected" {
                self.profileImageView.image = UIImage(systemName: "person.circle.fill")
                self.profileImageView.tintColor = UIColor.lightGray
                self.profileImageView.contentMode = .scaleAspectFill
            } else {
                self.profileImageView.loadImageUsingCacheWithUrlString(urlImage)
            }
            // name
            Database.database().reference().child("Users").child(uid).child("name").observe(.value) { (snapshot) in
                let name : String = (snapshot.value as? String)!
                self.profileName.text = "\(name)"
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
                        
                        if job.authorName == uid {
                            self.myJobs.append(job)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
        
        self.getAllFollowers()
        
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

        // Do any additional setup after loading the view.
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
                        if favorite.uid == GlobalVariables.userUID {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // get array
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("favorites").observe(.childAdded) { (listOfuserFavorite) in
            if let value = listOfuserFavorite.value as? [String : Any] {
                let user = UserStructure()
                user.uid = value["uid"] as? String ?? "Error"
                if user.uid! == GlobalVariables.userUID {
                    self.updateFollowingButton(isFollowing: true)
                    return
                }
            }
        }
    }
    
    func updateFollowingButton(isFollowing: Bool) {
        switch isFollowing {
        case true:
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.statusButton.backgroundColor = UIColor.mainBlue
                self.statusButton.setTitle("Following", for: .normal)
                self.statusButton.setTitleColor(UIColor.white, for: .normal)
                self.isFollowing = true
            } completion: { (completion) in
                print("updated button")
            }
        case false:
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.statusButton.backgroundColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 0.35)
                self.statusButton.setTitle("Follow", for: .normal)
                self.statusButton.setTitleColor(UIColor.mainBlue, for: .normal)
                self.isFollowing = false
            } completion: { (completion) in
                print("updated button")
            }
        default:
            print("following user error")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myJobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! OtherProfileCell
        cell.postImageView.loadImageUsingCacheWithUrlString(self.myJobs[indexPath.row].imagePost!)
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
        GlobalVariables.postImage2.loadImageUsingCacheWithUrlString(self.myJobs[indexPath.row].imagePost!)
        GlobalVariables.postImageDownlodUrl = self.myJobs[indexPath.row].imagePost!
        GlobalVariables.postTitle = self.myJobs[indexPath.row].titleOfPost!
        GlobalVariables.postDescription = self.myJobs[indexPath.row].descriptionOfPost!
        GlobalVariables.postPrice = self.myJobs[indexPath.row].price!
        GlobalVariables.authorId = self.myJobs[indexPath.row].authorName!
        GlobalVariables.postId = self.myJobs[indexPath.row].postId!
        GlobalVariables.type = self.myJobs[indexPath.row].typeOfPrice!
        self.navigationController?.pushViewController(ViewPostController(), animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    @objc func followingPressed() {
        if self.isFollowing == true {
            Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("favorites").child(GlobalVariables.userUID).removeValue()
            self.updateFollowingButton(isFollowing: false)
        } else {
            self.updateFollowingButton(isFollowing: true)
            let userInformation : Dictionary<String, Any> = [
                "uid" : "\(GlobalVariables.userUID)"
            ]
            let postFeed = ["\(GlobalVariables.userUID)" : userInformation]
            Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("favorites").updateChildValues(postFeed)
            Database.database().reference().child("Users").child(self.userUid).child("fcmToken").observe(.value) { (snapshot) in
                let token : String = (snapshot.value as? String)!
                let sender = PushNotificationSender()
                Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("name").observe(.value) { (snapshot) in
                    let userName : String = (snapshot.value as? String)!
                    sender.sendPushNotification(to: token, title: "Congrats! 🎉", body: "\(userName) started following you!")
                }
            }
        }
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func ratingsButtonPressed() {
        if self.ratingNumber != 0 {
            let controller = OtherRatingController()
            controller.finalRating = self.finalNumber
            controller.userUid = GlobalVariables.userUID
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

}

class OtherProfileCell: UITableViewCell {
    
    var postId = ""
    
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
