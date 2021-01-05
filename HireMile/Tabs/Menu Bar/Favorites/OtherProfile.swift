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
    
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.image = UIImage(named: "profilepic")
        imageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        imageView.layer.cornerRadius = 37.5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let profileName : UILabel = {
        let label = UILabel()
        label.text = "Jorge Zapata"
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
        view.backgroundColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
        return view
    }()
    
    let myServices : UILabel = {
        let label = UILabel()
        label.text = "My Services (3)"
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
    
    let statusButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.mainBlue
        button.setTitle("Following", for: .normal)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(followingPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        view.addSubview(profileName)
        profileName.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        profileName.leftAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: 10).isActive = true
        profileName.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        profileName.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        view.addSubview(star1)
        star1.topAnchor.constraint(equalTo: self.profileName.bottomAnchor, constant: 5).isActive = true
        star1.leftAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: 10).isActive = true
        star1.widthAnchor.constraint(equalToConstant: 20).isActive = true
        star1.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(star2)
        star2.topAnchor.constraint(equalTo: self.profileName.bottomAnchor, constant: 5).isActive = true
        star2.leftAnchor.constraint(equalTo: self.star1.rightAnchor, constant: 5).isActive = true
        star2.widthAnchor.constraint(equalToConstant: 20).isActive = true
        star2.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(star3)
        star3.topAnchor.constraint(equalTo: self.profileName.bottomAnchor, constant: 5).isActive = true
        star3.leftAnchor.constraint(equalTo: self.star2.rightAnchor, constant: 5).isActive = true
        star3.widthAnchor.constraint(equalToConstant: 20).isActive = true
        star3.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(star4)
        star4.topAnchor.constraint(equalTo: self.profileName.bottomAnchor, constant: 5).isActive = true
        star4.leftAnchor.constraint(equalTo: self.star3.rightAnchor, constant: 5).isActive = true
        star4.widthAnchor.constraint(equalToConstant: 20).isActive = true
        star4.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(star5)
        star5.topAnchor.constraint(equalTo: self.profileName.bottomAnchor, constant: 5).isActive = true
        star5.leftAnchor.constraint(equalTo: self.star4.rightAnchor, constant: 5).isActive = true
        star5.widthAnchor.constraint(equalToConstant: 20).isActive = true
        star5.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(seperaterView)
        seperaterView.topAnchor.constraint(equalTo: self.profileImageView.bottomAnchor, constant: 25).isActive = true
        seperaterView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        seperaterView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        seperaterView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(myServices)
        myServices.topAnchor.constraint(equalTo: self.seperaterView.bottomAnchor, constant: 25).isActive = true
        myServices.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 25).isActive = true
        myServices.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        myServices.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: self.myServices.bottomAnchor, constant: 10).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 10).isActive = true
        
        view.addSubview(statusButton)
        statusButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        statusButton.bottomAnchor.constraint(equalTo: self.seperaterView.bottomAnchor, constant: -20).isActive = true
        statusButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        statusButton.leftAnchor.constraint(equalTo: self.star5.rightAnchor, constant: 30).isActive = true
        
        view.backgroundColor = UIColor.white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileCell.self, forCellReuseIdentifier: "profileCell")
        
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
                // stars
                if self.findingRating == true {
                    // find rating
                    Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("rating").observeSingleEvent(of: .value) { (ratingNum) in
                        let value = ratingNum.value as? NSNumber
                        let newNumber = Float(value!)
                        if newNumber == 100 {
                            self.star1.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                            self.star2.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                            self.star3.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                            self.star4.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                            self.star5.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                        } else {
                            // get all ratings
                            self.getAllRatings()
                        }
                    }
                }
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

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .bottom, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        // get array
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("favorites").observe(.childAdded) { (listOfuserFavorite) in
            if let value = listOfuserFavorite.value as? [String : Any] {
                let user = UserStructure()
                user.uid = value["uid"] as? String ?? "Error"
                print("USERUID")
                print(user.uid!)
                print("USERUID")
                if user.uid! == GlobalVariables.userUID {
                    self.updateFollowingButton(isFollowing: true)
                } else {
                    self.updateFollowingButton(isFollowing: false)
                }
            }
        }
    }
    
    func getAllRatings() {
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("ratings").observe(.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                let job = ReviewStructure()
                job.ratingNumber = value["rating-number"] as? Int ?? 0
                self.ratingNumber += 1
                self.finalRating += job.ratingNumber!
            }
            self.finalRating = self.finalRating / self.ratingNumber
            self.findingRating = false
            
            switch self.finalRating {
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
    
    func updateFollowingButton(isFollowing: Bool) {
        switch isFollowing {
        case true:
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.statusButton.backgroundColor = UIColor.mainBlue
                self.statusButton.setTitle("Following", for: .normal)
                self.statusButton.setTitleColor(UIColor.white, for: .normal)
                self.isFollowing = true
                Database.database().reference().child("Users").child(self.userUid).child("fcmToken").observe(.value) { (snapshot) in
                    let token : String = (snapshot.value as? String)!
                    let sender = PushNotificationSender()
                    Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("name").observe(.value) { (snapshot) in
                        let userName : String = (snapshot.value as? String)!
                        sender.sendPushNotification(to: token, title: "Congrats! 🎉", body: "\(userName) started following you!")
                    }
                }
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
        self.myServices.text = "My Services (\(myJobs.count))"
        return myJobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileCell
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
        }
    }

}

class MyProfileCell: UITableViewCell {
    
    let postImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "working")
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
        label.text = "Car Rental"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 1
        return label
    }()
    
    let saleNumber : UILabel = {
        let label = UILabel()
        label.text = "10 sales"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 1
        return label
    }()
    
    let priceNumber : UILabel = {
        let label = UILabel()
        label.text = "$30"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
            
        addSubview(informationView)
        informationView.topAnchor.constraint(equalTo: self.topAnchor, constant: 25).isActive = true
        informationView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -25).isActive = true
        informationView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25).isActive = true
        informationView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25).isActive = true
        
        informationView.addSubview(postImageView)
        postImageView.topAnchor.constraint(equalTo: informationView.topAnchor, constant: 0).isActive = true
        postImageView.leftAnchor.constraint(equalTo: informationView.leftAnchor, constant: 0).isActive = true
        postImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        postImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        informationView.addSubview(priceNumber)
        priceNumber.topAnchor.constraint(equalTo: informationView.topAnchor, constant: 10).isActive = true
        priceNumber.rightAnchor.constraint(equalTo: informationView.rightAnchor, constant: -10).isActive = true
        priceNumber.heightAnchor.constraint(equalToConstant: 25).isActive = true
        priceNumber.widthAnchor.constraint(equalToConstant: 38).isActive = true
        
        informationView.addSubview(titleJob)
        titleJob.topAnchor.constraint(equalTo: self.topAnchor, constant: 40).isActive = true
        titleJob.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -25).isActive = true
        titleJob.leftAnchor.constraint(equalTo: self.postImageView.rightAnchor, constant: 10).isActive = true
        titleJob.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        informationView.addSubview(saleNumber)
        saleNumber.topAnchor.constraint(equalTo: self.titleJob.bottomAnchor, constant: 0).isActive = true
        saleNumber.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -25).isActive = true
        saleNumber.leftAnchor.constraint(equalTo: self.postImageView.rightAnchor, constant: 10).isActive = true
        saleNumber.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
