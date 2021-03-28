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
import ScrollableSegmentedControl

protocol MyTableViewCellDelegate {
    func didTapEditButton(withIndex: Int)
    func didTapDeleteButton(withIndex: Int)
}

class MyProfile: UIViewController, UITableViewDelegate, UITableViewDataSource, MyTableViewCellDelegate, MyTableViewCellDelegate2 {
    
    
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
    var followers = [UserStructure]()
    var favorites = [String]()
    var allRatings = [ReviewStructure]()
    
    let filterLauncher = DeleteLauncher()
    
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.black
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
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
    
    let profileName : UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 1
        return label
    }()
    
    let username : UILabel = {
        let label = UILabel()
        label.text = "@username"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 1
        return label
    }()
    
    let star1 : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "icons8-star-100")
        imageView.tintColor = UIColor.mainBlue
        return imageView
    }()
    
    let star2 : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "icons8-star-100")
        imageView.tintColor = UIColor.mainBlue
        return imageView
    }()
    
    let star3 : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "icons8-star-100")
        imageView.tintColor = UIColor.mainBlue
        return imageView
    }()
    
    let star4 : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "icons8-star-100")
        imageView.tintColor = UIColor.mainBlue
        return imageView
    }()
    
    let star5 : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "icons8-star-100")
        imageView.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
        return imageView
    }()
    
    let ratingLabel : UILabel = {
        let label = UILabel()
        label.text = "(No reviews)"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 1
        return label
    }()
    
    let segmentedControl : ScrollableSegmentedControl = {
        let segmentedControl = ScrollableSegmentedControl()
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.insertSegment(withTitle: "Services", at: 0)
        segmentedControl.insertSegment(withTitle: "Reviews", at: 1)
        segmentedControl.insertSegment(withTitle: "Followers", at: 2)
        segmentedControl.insertSegment(withTitle: "Info", at: 3)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.layer.masksToBounds = true
        segmentedControl.backgroundColor = UIColor.white
        segmentedControl.tintColor = UIColor.black
        segmentedControl.underlineSelected = true
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor(red: 185/255, green: 185/255, blue: 185/255, alpha: 1)], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        return segmentedControl
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
        label.text = "My Skills"
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
    
    let followersButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(followersButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let noServiceImage : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.image = UIImage(named: "not-service")
        return imageView
    }()
    
    let noServiceLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
//        label.text = "No Services"
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.black
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        profileImageView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
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
        
        mainView.addSubview(profileName)
        profileName.topAnchor.constraint(equalTo: self.mainView.topAnchor, constant: 32).isActive = true
        profileName.leftAnchor.constraint(equalTo: self.mainView.leftAnchor, constant: 32).isActive = true
        profileName.rightAnchor.constraint(equalTo: self.mainView.rightAnchor, constant: -160).isActive = true
        profileName.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        mainView.addSubview(username)
        username.topAnchor.constraint(equalTo: self.profileName.bottomAnchor, constant: 6.7).isActive = true
        username.leftAnchor.constraint(equalTo: self.mainView.leftAnchor, constant: 32).isActive = true
        username.rightAnchor.constraint(equalTo: self.mainView.rightAnchor, constant: -160).isActive = true
        username.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        view.addSubview(star1)
        star1.topAnchor.constraint(equalTo: self.username.bottomAnchor, constant: 6).isActive = true
        star1.leftAnchor.constraint(equalTo: self.username.leftAnchor).isActive = true
        star1.widthAnchor.constraint(equalToConstant: 25).isActive = true
        star1.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        view.addSubview(star2)
        star2.topAnchor.constraint(equalTo: self.username.bottomAnchor, constant: 6).isActive = true
        star2.leftAnchor.constraint(equalTo: self.star1.rightAnchor, constant: 5).isActive = true
        star2.widthAnchor.constraint(equalToConstant: 25).isActive = true
        star2.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        view.addSubview(star3)
        star3.topAnchor.constraint(equalTo: self.username.bottomAnchor, constant: 6).isActive = true
        star3.leftAnchor.constraint(equalTo: self.star2.rightAnchor, constant: 5).isActive = true
        star3.widthAnchor.constraint(equalToConstant: 25).isActive = true
        star3.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        view.addSubview(star4)
        star4.topAnchor.constraint(equalTo: self.username.bottomAnchor, constant: 6).isActive = true
        star4.leftAnchor.constraint(equalTo: self.star3.rightAnchor, constant: 5).isActive = true
        star4.widthAnchor.constraint(equalToConstant: 25).isActive = true
        star4.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        view.addSubview(star5)
        star5.topAnchor.constraint(equalTo: self.username.bottomAnchor, constant: 6).isActive = true
        star5.leftAnchor.constraint(equalTo: self.star4.rightAnchor, constant: 5).isActive = true
        star5.widthAnchor.constraint(equalToConstant: 25).isActive = true
        star5.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        view.addSubview(ratingLabel)
        ratingLabel.topAnchor.constraint(equalTo: self.username.bottomAnchor, constant: 6).isActive = true
        ratingLabel.leftAnchor.constraint(equalTo: self.star5.rightAnchor, constant: 5).isActive = true
        ratingLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        ratingLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.view.addSubview(segmentedControl)
        self.segmentedControl.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 15).isActive = true
        self.segmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        self.segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        self.segmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        mainView.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor, constant: 10).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 10).isActive = true
        
        // profile image view
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("profile-image").observe(.value) { (snapshot) in
            if let profileImageString : String = (snapshot.value as? String) {
                if profileImageString == "not-yet-selected" {
                    self.profileImageView.tintColor = UIColor.lightGray
                    self.profileImageView.tintColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
                    self.profileImageView.contentMode = .scaleAspectFill
                } else {
                    self.profileImageView.loadImageUsingCacheWithUrlString(profileImageString)
                    self.profileImageView.tintColor = UIColor.lightGray
                    self.profileImageView.contentMode = .scaleAspectFill
                }
            } else {
                self.profileImageView.tintColor = UIColor.lightGray
                self.profileImageView.tintColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
                self.profileImageView.contentMode = .scaleAspectFill
            }
        }
        
        view.backgroundColor = UIColor.white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileCell2.self, forCellReuseIdentifier: "profileCell")
        tableView.register(MyJobsCompletedgCell.self, forCellReuseIdentifier: "otherProfileCell")
        tableView.register(FavoritesCell.self, forCellReuseIdentifier: "followres")
        
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.showsVerticalScrollIndicator = false
        
        // image
        let uid = Auth.auth().currentUser!.uid
        
        Database.database().reference().child("Users").child(uid).child("username").observe(.value) { (usernameSnap) in
            if let userame = usernameSnap.value as? String {
                self.username.text = "@\(userame)"
            }
        }
        
        Database.database().reference().child("Users").child(uid).child("profile-image").observe(.value) { (snapshot) in
            if let urlImage : String = (snapshot.value as? String) {
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
        }
        
        self.getAllFollowers()
        self.getAllRatings()
        
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
        navigationItem.backButtonTitle = " "
        
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
    
    @objc func segmentedControlValueChanged(_ semder: UISegmentedControl) {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5) {
                self.tableView.alpha = 1
            } completion: { (complete) in
                self.tableView.reloadData()
            }
        } else if segmentedControl.selectedSegmentIndex == 1 {
            UIView.animate(withDuration: 0.5) {
                self.tableView.alpha = 1
            } completion: { (complete) in
                self.tableView.reloadData()
            }
        } else if segmentedControl.selectedSegmentIndex == 2 {
            UIView.animate(withDuration: 0.5) {
                self.tableView.alpha = 1
            } completion: { (complete) in
                self.tableView.reloadData()
            }
        } else if segmentedControl.selectedSegmentIndex == 3 {
            let infoPage = InfoPage()
            infoPage.rating = finalRating ?? 0
            infoPage.followers = self.followers.count
            let user = UserStructure()
            user.uid = Auth.auth().currentUser!.uid
            infoPage.user = user
            self.present(infoPage, animated: true, completion: nil)
            self.segmentedControl.selectedSegmentIndex = 0
        } else {
            print("other")
        }
    }
    
    @objc func setFollowPeople() {
        print("followers:")
        self.fourthImportantView.addSubview(followersButton)
        self.followersButton.topAnchor.constraint(equalTo: self.fourthImportantView.topAnchor).isActive = true
        self.followersButton.leftAnchor.constraint(equalTo: self.fourthImportantView.leftAnchor).isActive = true
        self.followersButton.rightAnchor.constraint(equalTo: self.fourthImportantView.rightAnchor).isActive = true
        self.followersButton.bottomAnchor.constraint(equalTo: self.fourthImportantView.bottomAnchor).isActive = true
        self.fourthTitleLabel.text = "\(self.iamfollowedby)"
    }
    
    func getAllRatings() {
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("ratings").observe(.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                let job = ReviewStructure()
                job.ratingNumber = value["rating-number"] as? Int ?? 0
                job.userUid = value["user-id"] as? String ?? "Error"
                job.postId = value["post-id"] as? String ?? "Error"
                job.descriptionOfRating = value["description"] as? String ?? "Error"
                self.ratingNumber += 1
                self.finalRating += job.ratingNumber!
                self.allRatings.append(job)
            }
            
            print(self.ratingNumber)
            self.thirdTitleLabel.text = String(self.ratingNumber)
            print("updating rating label")
            
            let finalNumber = self.finalRating / self.ratingNumber
            self.finalNumber = finalNumber
            
            self.ratingLabel.text = "(\(String(finalNumber)))"
            
            switch finalNumber {
            case 0:
                self.star1.image = UIImage(named: "icons8-star-100")
                self.star2.image = UIImage(named: "icons8-star-100")
                self.star3.image = UIImage(named: "icons8-star-100")
                self.star4.image = UIImage(named: "icons8-star-100")
                self.star5.image = UIImage(named: "icons8-star-100")
            case 1:
                self.star1.image = UIImage(named: "icons8-star-200")
                self.star2.image = UIImage(named: "icons8-star-100")
                self.star3.image = UIImage(named: "icons8-star-100")
                self.star4.image = UIImage(named: "icons8-star-100")
                self.star5.image = UIImage(named: "icons8-star-100")
            case 2:
                self.star1.image = UIImage(named: "icons8-star-200")
                self.star2.image = UIImage(named: "icons8-star-200")
                self.star3.image = UIImage(named: "icons8-star-100")
                self.star4.image = UIImage(named: "icons8-star-100")
                self.star5.image = UIImage(named: "icons8-star-100")
            case 3:
                self.star1.image = UIImage(named: "icons8-star-200")
                self.star2.image = UIImage(named: "icons8-star-200")
                self.star3.image = UIImage(named: "icons8-star-200")
                self.star4.image = UIImage(named: "icons8-star-100")
                self.star5.image = UIImage(named: "icons8-star-100")
            case 4:
                self.star1.image = UIImage(named: "icons8-star-200")
                self.star2.image = UIImage(named: "icons8-star-200")
                self.star3.image = UIImage(named: "icons8-star-200")
                self.star4.image = UIImage(named: "icons8-star-200")
                self.star5.image = UIImage(named: "icons8-star-100")
            case 5:
                self.star1.image = UIImage(named: "icons8-star-200")
                self.star2.image = UIImage(named: "icons8-star-200")
                self.star3.image = UIImage(named: "icons8-star-200")
                self.star4.image = UIImage(named: "icons8-star-200")
                self.star5.image = UIImage(named: "icons8-star-200")
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
                    if let _ = favoritesSnap.value as? [String : Any] {
                        let favorite = UserStructure()
                        favorite.uid = favoritesSnap.key
                        print("\(snapshot.key) is following \(favorite.uid)")
                        if favorite.uid == Auth.auth().currentUser!.uid {
                            print("i am followed by \(snapshot.key)")
                            self.iamfollowedby += 1
                            let follower = UserStructure()
                            follower.uid = snapshot.key
                            self.followers.append(follower)
                        }
                    }
                }
            }
        }
        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.setFollowPeople), userInfo: nil, repeats: false)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            if self.myJobs.count == 0 {
                self.addEtraView()
            } else {
                self.removeEtraView()
            }
            return myJobs.count
        } else if self.segmentedControl.selectedSegmentIndex == 1 {
            return self.allRatings.count
        } else if self.segmentedControl.selectedSegmentIndex == 2 {
            return self.followers.count
        } else if self.segmentedControl.selectedSegmentIndex == 3 {
            if self.myJobs.count == 0 {
                self.addEtraView()
            } else {
                self.removeEtraView()
            }
            return myJobs.count
        } else {
            if self.myJobs.count == 0 {
                self.addEtraView()
            } else {
                self.removeEtraView()
            }
            return myJobs.count
        }
    }
    
    func addEtraView() {
        self.view.addSubview(self.noServiceImage)
        self.noServiceImage.topAnchor.constraint(equalTo: self.tableView.topAnchor, constant: 20).isActive = true
        self.noServiceImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.noServiceImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        self.noServiceImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.view.addSubview(self.noServiceLabel)
        self.noServiceLabel.topAnchor.constraint(equalTo: self.noServiceImage.bottomAnchor, constant: 10).isActive = true
        self.noServiceLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.noServiceLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.noServiceLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.noServiceImage.alpha = 1
        self.noServiceLabel.alpha = 1
    }
    
    func removeEtraView() {
        self.noServiceImage.alpha = 0
        self.noServiceLabel.alpha = 0
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)], context: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileCell2
            
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
                let rect = estimateFrameForText(text: String(self.myJobs[indexPath.row].price!)).width
                cell.priceNumber.widthAnchor.constraint(equalToConstant: rect + 30).isActive = true
            }
            
            return cell
        } else if self.segmentedControl.selectedSegmentIndex == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "otherProfileCell", for: indexPath) as! MyJobsCompletedgCell
            cell.backgroundColor = .white
            if let uid = self.allRatings[indexPath.row].userUid {
                Database.database().reference().child("Users").child(uid).child("name").observe(.value) { (snapshot) in
                    if let nameString : String = (snapshot.value as? String) {
                        cell.userNameLabel.text! = nameString
                    } else {
                        cell.userNameLabel.text! = "Unknown"
                    }
                }
                Database.database().reference().child("Users").child(uid).child("profile-image").observe(.value) { (snapshot) in
                    if let profileImageString : String = (snapshot.value as? String) {
                        if profileImageString == "not-yet-selected" {
                            cell.profileImageView.image = UIImage(systemName: "person.circle.fill")
                            cell.profileImageView.tintColor = UIColor.lightGray
                            cell.profileImageView.contentMode = .scaleAspectFill
                        } else {
                            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageString)
                            cell.profileImageView.tintColor = UIColor.lightGray
                            cell.profileImageView.contentMode = .scaleAspectFill
                        }
                    } else {
                        cell.profileImageView.image = UIImage(systemName: "person.circle.fill")
                        cell.profileImageView.tintColor = UIColor.lightGray
                        cell.profileImageView.contentMode = .scaleAspectFill
                    }
                }
            }
            
            if let timestamp = self.allRatings[indexPath.row].timestamp {
                if timestamp == 0 {
                    cell.date.isHidden = true
                } else {
                    let formatter = DateFormatter()
                    formatter.dateStyle = .medium
                    cell.date.text = "\(formatter.string(from: Date(timeIntervalSince1970: Double(timestamp))))"
                    cell.date.isHidden = false
                }
            } else {
                cell.date.isHidden = true
            }

            let num = 20

            if num == 20 {
                if let rating = self.allRatings[indexPath.row].ratingNumber {
                    if rating == 100 {
                        cell.star1.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                        cell.star2.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                        cell.star3.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                        cell.star4.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                        cell.star5.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                    } else {
                        switch rating {
                        case 0:
                            cell.star1.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                            cell.star2.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                            cell.star3.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                            cell.star4.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                            cell.star5.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                        case 1:
                            cell.star1.tintColor = UIColor.mainBlue
                            cell.star2.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                            cell.star3.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                            cell.star4.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                            cell.star5.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                        case 2:
                            cell.star1.tintColor = UIColor.mainBlue
                            cell.star2.tintColor = UIColor.mainBlue
                            cell.star3.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                            cell.star4.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                            cell.star5.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                        case 3:
                            cell.star1.tintColor = UIColor.mainBlue
                            cell.star2.tintColor = UIColor.mainBlue
                            cell.star3.tintColor = UIColor.mainBlue
                            cell.star4.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                            cell.star5.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                        case 4:
                            cell.star1.tintColor = UIColor.mainBlue
                            cell.star2.tintColor = UIColor.mainBlue
                            cell.star3.tintColor = UIColor.mainBlue
                            cell.star4.tintColor = UIColor.mainBlue
                            cell.star5.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                        case 5:
                            cell.star1.tintColor = UIColor.mainBlue
                            cell.star2.tintColor = UIColor.mainBlue
                            cell.star3.tintColor = UIColor.mainBlue
                            cell.star4.tintColor = UIColor.mainBlue
                            cell.star5.tintColor = UIColor.mainBlue
                        default:
                            print("hello")
                        }
                    }
                }
            }

            if let description = self.allRatings[indexPath.row].descriptionOfRating {
                cell.reviewLabel.text! = description
            }

            if let postId = self.allRatings[indexPath.row].postId {
                Database.database().reference().child("Jobs").child(postId).child("image").observe(.value) { (snapshot) in
                    if let pictureString : String = (snapshot.value as? String) {
                        cell.postImageView.loadImageUsingCacheWithUrlString(pictureString)
                    }
                }
            }
            
            return cell
        } else if self.segmentedControl.selectedSegmentIndex == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "followres", for: indexPath) as! FavoritesCell
            cell.profileImageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
            
            if let uid = self.followers[indexPath.row].uid {
                Database.database().reference().child("Users").child(uid).child("name").observe(.value) { (snapshot) in
                    if let snapshot : String = (snapshot.value as? String) {
                        cell.textLabel?.text = snapshot
//                        cell.delegate = self
                        cell.index = indexPath
                    }
                }
                
                Database.database().reference().child("Users").child(uid).child("profile-image").observe(.value) { (snapshot) in
                    let snapshot : String = (snapshot.value as? String)!
                    if snapshot == "not-yet-selected" {
                        cell.profileImageView.image = UIImage(systemName: "person.circle.fill")
                        cell.profileImageView.tintColor = UIColor.lightGray
                        cell.profileImageView.contentMode = .scaleAspectFill
                    } else {
                        cell.profileImageView.loadImageUsingCacheWithUrlString(snapshot)
                    }
                }
                
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                
                cell.favoriteButton.removeFromSuperview()
                
                if self.favorites.contains(uid) {
                    cell.favoriteButton.backgroundColor = .white
                    cell.favoriteButton.setTitle("Following", for: .normal)
                    cell.favoriteButton.setTitleColor(UIColor.black, for: .normal)
                } else {
                    cell.favoriteButton.backgroundColor = .mainBlue
                    cell.favoriteButton.setTitle("Follow", for: .normal)
                    cell.favoriteButton.setTitleColor(UIColor.white, for: .normal)
                }
            }
            return cell
        } else if self.segmentedControl.selectedSegmentIndex == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! OtherProfileCell
            cell.selectionStyle = .none
            if let imagePost = self.myJobs[indexPath.row].imagePost {
                cell.postImageView.loadImageUsingCacheWithUrlString(imagePost)
            }
            if let titleJob = self.myJobs[indexPath.row].titleOfPost {
                cell.titleJob.text = titleJob
            }
            if let postId = self.myJobs[indexPath.row].postId {
                cell.postId = postId
            }
            if let saleNumber = self.myJobs[indexPath.row].descriptionOfPost {
                cell.saleNumber.text = saleNumber
            }
            if let typeOfPrice = self.myJobs[indexPath.row].typeOfPrice {
                if self.myJobs[indexPath.row].typeOfPrice == "Hourly" {
                    cell.priceNumber.text = "$\(self.myJobs[indexPath.row].price!) / Hour"
                } else {
                    cell.priceNumber.text = "$\(self.myJobs[indexPath.row].price!)"
                }
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! OtherProfileCell
            cell.selectionStyle = .none
            if let imagePost = self.myJobs[indexPath.row].imagePost {
                cell.postImageView.loadImageUsingCacheWithUrlString(imagePost)
            }
            if let titleJob = self.myJobs[indexPath.row].titleOfPost {
                cell.titleJob.text = titleJob
            }
            if let postId = self.myJobs[indexPath.row].postId {
                cell.postId = postId
            }
            if let saleNumber = self.myJobs[indexPath.row].descriptionOfPost {
                cell.saleNumber.text = saleNumber
            }
            if let typeOfPrice = self.myJobs[indexPath.row].typeOfPrice {
                if self.myJobs[indexPath.row].typeOfPrice == "Hourly" {
                    cell.priceNumber.text = "$\(self.myJobs[indexPath.row].price!) / Hour"
                } else {
                    cell.priceNumber.text = "$\(self.myJobs[indexPath.row].price!)"
                }
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            GlobalVariables.postImage2.loadImageUsingCacheWithUrlString(self.myJobs[indexPath.row].imagePost!)
            GlobalVariables.postImageDownlodUrl = self.myJobs[indexPath.row].imagePost!
            GlobalVariables.postTitle = self.myJobs[indexPath.row].titleOfPost!
            GlobalVariables.postDescription = self.myJobs[indexPath.row].descriptionOfPost!
            GlobalVariables.postPrice = self.myJobs[indexPath.row].price!
            GlobalVariables.authorId = self.myJobs[indexPath.row].authorName!
            GlobalVariables.postId = self.myJobs[indexPath.row].postId!
            GlobalVariables.type = self.myJobs[indexPath.row].typeOfPrice!
            self.navigationController?.pushViewController(ViewPostController(), animated: true)
        } else if self.segmentedControl.selectedSegmentIndex == 1 {
            if let uid = self.allRatings[indexPath.row].userUid {
                GlobalVariables.userUID = uid
                self.navigationController?.pushViewController(OtherProfile(), animated: true)
            }
        } else if self.segmentedControl.selectedSegmentIndex == 2 {
            GlobalVariables.userUID = self.followers[indexPath.row].uid!
            self.navigationController?.pushViewController(OtherProfile(), animated: true)
        } else if self.segmentedControl.selectedSegmentIndex == 3 {
            print("info tap")
        } else {
            print("other")
        }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            return 175
        } else if self.segmentedControl.selectedSegmentIndex == 1 {
            return 135
        } else if self.segmentedControl.selectedSegmentIndex == 2 {
            return 80
        } else if self.segmentedControl.selectedSegmentIndex == 3 {
            return 150
        } else {
            return 150
        }
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
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func ratingsButtonPressed() {
        if self.ratingNumber != 0 {
            let controller = RatingsController()
            controller.allRatings = self.allRatings
//            controller.user = Auth.auth().currentUser!.uid
            controller.finalRating = self.finalNumber
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc func followersButtonPressed() {
        print("followed pressed")
        let controller = FollowersController()
        controller.followers = self.followers
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func postServicePressed() {
        GlobalVariables.isGoingToPost = true
        self.navigationController?.popViewController(animated: true)
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
