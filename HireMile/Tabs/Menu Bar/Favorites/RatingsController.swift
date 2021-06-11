//
//  RatingsController.swift
//  HireMile
//
//  Created by JJ Zapata on 1/27/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Foundation

class RatingsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var allRatings = [ReviewStructure]()
    
    var finalRating : Int? {
        didSet {
            self.titleLabel.text = String(Float(finalRating ?? 0))
            setStars(withValue: finalRating ?? 0)
        }
    }
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "0.0"
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 60, weight: UIFont.Weight.heavy)
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let star1 : UIButton = {
        let imageView = UIButton(type: .system)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setImage(UIImage(named: "icons8-star-100"), for: .normal)
        return imageView
    }()
    
    let star2 : UIButton = {
        let imageView = UIButton(type: .system)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setImage(UIImage(named: "icons8-star-100"), for: .normal)
        return imageView
    }()
    
    let star3 : UIButton = {
        let imageView = UIButton(type: .system)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setImage(UIImage(named: "icons8-star-100"), for: .normal)
        return imageView
    }()
    
    let star4 : UIButton = {
        let imageView = UIButton(type: .system)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setImage(UIImage(named: "icons8-star-100"), for: .normal)
        return imageView
    }()
    
    let star5 : UIButton = {
        let imageView = UIButton(type: .system)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setImage(UIImage(named: "icons8-star-100"), for: .normal)
        return imageView
    }()
    
    let descLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        // constants
        self.view.addSubview(self.titleLabel)
        self.titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        self.titleLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.titleLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        view.addSubview(star3)
        star3.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10).isActive = true
        star3.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        star3.widthAnchor.constraint(equalToConstant: 35).isActive = true
        star3.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        view.addSubview(star2)
        star2.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10).isActive = true
        star2.rightAnchor.constraint(equalTo: self.star3.leftAnchor, constant: -5).isActive = true
        star2.widthAnchor.constraint(equalToConstant: 35).isActive = true
        star2.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        view.addSubview(star1)
        star1.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10).isActive = true
        star1.rightAnchor.constraint(equalTo: self.star2.leftAnchor, constant: -5).isActive = true
        star1.widthAnchor.constraint(equalToConstant: 35).isActive = true
        star1.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        view.addSubview(star4)
        star4.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10).isActive = true
        star4.leftAnchor.constraint(equalTo: self.star3.rightAnchor, constant: 5).isActive = true
        star4.widthAnchor.constraint(equalToConstant: 35).isActive = true
        star4.heightAnchor.constraint(equalToConstant: 35).isActive = true
        

        view.addSubview(star5)
        star5.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10).isActive = true
        star5.leftAnchor.constraint(equalTo: self.star4.rightAnchor, constant: 5).isActive = true
        star5.widthAnchor.constraint(equalToConstant: 35).isActive = true
        star5.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        self.view.addSubview(self.descLabel)
        self.descLabel.topAnchor.constraint(equalTo: self.star5.bottomAnchor, constant: 5).isActive = true
        self.descLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.descLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.descLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.topAnchor.constraint(equalTo: self.descLabel.bottomAnchor, constant: 32).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 10).isActive = true
        tableView.register(MyJobsCompletedgCell.self, forCellReuseIdentifier: "myRatingsCompletedCellID")

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = "Reviews"
        self.navigationController?.navigationBar.tintColor = UIColor.mainBlue
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.descLabel.text = "Based on \(self.allRatings.count) reviews"
        return self.allRatings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myRatingsCompletedCellID", for: indexPath) as! MyJobsCompletedgCell
        
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
                cell.dateLabel.isHidden = true
            } else {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                cell.dateLabel.text = "\(formatter.string(from: Date(timeIntervalSince1970: Double(timestamp))))"
                cell.dateLabel.isHidden = false
            }
        } else {
            cell.dateLabel.isHidden = true
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
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let uid = self.allRatings[indexPath.row].userUid {
            if let profileVC = CommonUtils.getStoryboardVC(StoryBoard.Profile.rawValue, vcIdetifier: UserProfileViewController.className) as? UserProfileViewController {
                profileVC.userUID = uid
                self.navigationController?.pushViewController(profileVC,  animated: true)
            }
        }
    }
    
    func setStars(withValue value: Int) {
        switch value {
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
            print("setting 4")
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
            print("nil")
        }
    }

}
