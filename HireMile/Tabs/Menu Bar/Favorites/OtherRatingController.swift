//
//  OtherRatingController.swift
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

class OtherRatingController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var running = [MyJobStructure]()
    var completed = [MyJobStructure]()
    var canceled = [MyJobStructure]()
    
    var allJobs = [MyJobStructure]()
    
    var finalRating : Int? {
        didSet {
            self.titleLabel.text = String(Float(finalRating ?? 0))
            setStars(withValue: finalRating ?? 0)
        }
    }
    
    var numberOfRatings : Int? {
        didSet {
            if let number = numberOfRatings {
                if number == 1 {
                    self.descLabel.text = "Based on \(number) review"
                } else {
                    self.descLabel.text = "Based on \(number) reviews"
                }
            }
        }
    }
    
    fileprivate func getJobs(withUid uid: String) {
        self.allJobs.removeAll()
        self.running.removeAll()
        self.completed.removeAll()
        self.canceled.removeAll()
        Database.database().reference().child("Users").child(uid).child("My_Jobs").observe(.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String: Any] {
                let job = MyJobStructure()
                job.authorUid = value["author-uid"] as? String ?? "AUTHOR ID"
                job.reasonOrDescripiotn = value["reason-or-description"] as? String ?? "REASON FALSE"
                job.jobKey = value["job-key"] as? String ?? "JOB KEY FALSE"
                job.rating = value["rating"] as? Int ?? 0
                job.ratingIsNil = value["is-rating-nil"] as? Bool ?? true
                job.type = value["job-status"] as? String ?? "TYPE FALSE"
                job.idThingy = value["job-id-for-me"] as? String ?? "ID FALSE"
                switch job.type! {
                case "running":
                    self.running.append(job)
                case "completed":
                    self.completed.append(job)
                case "cancelled":
                    self.canceled.append(job)
                default:
                    print(job.type!)
                }
            }
            self.tableView.reloadData()
        }
    }
    
    var userUid : String? {
        didSet {
            print("user id is \(userUid ?? "nil user")")
            getJobs(withUid: userUid ?? "")
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
        self.numberOfRatings = self.completed.count
        return self.completed.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myRatingsCompletedCellID", for: indexPath) as! MyJobsCompletedgCell
        
        Database.database().reference().child("Users").child(self.completed[indexPath.row].authorUid!).child("name").observe(.value) { (snapshot) in
            let nameString : String = (snapshot.value as? String)!
            cell.userNameLabel.text! = nameString
        }
        
        Database.database().reference().child("Users").child(self.completed[indexPath.row].authorUid!).child("profile-image").observe(.value) { (snapshot) in
            let profileImageString : String = (snapshot.value as? String)!
            if profileImageString == "not-yet-selected" {
                cell.profileImageView.image = UIImage(systemName: "person.circle.fill")
                cell.profileImageView.tintColor = UIColor.lightGray
                cell.profileImageView.contentMode = .scaleAspectFill
            } else {
                cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageString)
                cell.profileImageView.tintColor = UIColor.lightGray
                cell.profileImageView.contentMode = .scaleAspectFill
            }
        }
        
        if self.completed[indexPath.row].ratingIsNil! == false {
            if self.completed[indexPath.row].rating! == 100 {
                cell.star1.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                cell.star2.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                cell.star3.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                cell.star4.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                cell.star5.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
            } else {
                print("self.completed[indexPath.row].rating!")
                print(self.completed[indexPath.row].rating!)
                print("self.completed[indexPath.row].rating!")
                switch self.completed[indexPath.row].rating! {
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
        
        cell.reviewLabel.text! = self.completed[indexPath.row].reasonOrDescripiotn!
        
        Database.database().reference().child("Jobs").child(self.completed[indexPath.row].jobKey!).child("image").observe(.value) { (snapshot) in
            if let pictureString : String = (snapshot.value as? String) {
                cell.postImageView.loadImageUsingCacheWithUrlString(pictureString)
            }
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
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
