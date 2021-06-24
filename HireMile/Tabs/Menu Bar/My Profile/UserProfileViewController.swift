//
//  UserProfileViewController.swift
//  HireMile
//
//  Created by jaydeep vadalia on 06/06/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import Foundation
import FirebaseDatabase
import FirebaseAuth
import SDWebImage
import Cosmos

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var statusFollowButton: UIButton!
    @IBOutlet weak var tblProfile: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var colMenu: UICollectionView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var noServiceImage: UIImageView!
    @IBOutlet weak var noServiceLabel: UILabel!
    @IBOutlet weak var noServiceView: UIView!
    @IBOutlet weak var followerCount: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var profileRating: CosmosView!
    
    let arrMenu = ["Services","Reviews","Gallery","Followers","Info"]
    var selectIndex = 0
    
    var allJobs = [JobStructure]()
    var myJobs = [JobStructure]()
    var favorites = [String]()
    var isFollowing : Bool?
    var finalRating = 0
    var ratingNumber = 0
    var findingRating = true
    var hires = 0
    var iamfollowedby = 0
    var totalusers = [UserStructure]()
    var finalNumber = 0
    var followers = [UserStructure]()
    var allRatings = [ReviewStructure]()
    
    var userUID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        let w = 414 / 4
        let cellSize = CGSize(width: w - 30 , height:30)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal //.horizontal vertical
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 10.0
        colMenu.setCollectionViewLayout(layout, animated: true)
        UISetUp()
        tblProfile.register(FavoritesCell.self, forCellReuseIdentifier: "followres")
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        // get array
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("favorites").observe(.childAdded) { (listOfuserFavorite) in
            if let value = listOfuserFavorite.value as? [String : Any] {
                let user = UserStructure()
                user.uid = value["uid"] as? String ?? "Error"
                if user.uid! == self.userUID {
                    self.updateFollowingButton(isFollowing: true)
                    return
                }
            }
        }
    }
    
    func UISetUp()  {
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
                job.timeStamp = value["time"] as? Int ?? 0
                job.postId = value["postId"] as? String ?? "Error"
                
                if job.authorName ==  self.userUID {
                    print("my name")
                    self.myJobs.append(job)
                }
            }
            self.myJobs.sort(by: { $1.timeStamp! > $0.timeStamp! } )
            self.tblProfile.reloadData()
        }
        view.backgroundColor = UIColor.white
        
        // image
        let uid = self.userUID
        
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
                    self.profileImageView.sd_setImage(with: URL(string: urlImage), placeholderImage: nil, options: .retryFailed, completed: nil)
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
                        self.tblProfile.reloadData()
                    }
                }
            }
        }
        
        self.getAllFollowers()
        self.getAllRatings()
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
                        if favorite.uid == self.userUID {
                            print("i am followed by \(snapshot.key)")
                            self.iamfollowedby += 1
                            let follower = UserStructure()
                            follower.uid = snapshot.key
                            self.followers.append(follower)
                            self.followerCount.text = "\(self.followers.count) Follower"
                            self.followerCount.isHidden = true
                        }
                    }
                }
            }
        }
    }
    
    func getAllRatings() {
        Database.database().reference().child("Users").child(self.userUID).child("ratings").observe(.childAdded) { (snapshot) in
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
            let finalNumber = self.finalRating / self.ratingNumber
            self.finalNumber = finalNumber
            
            self.ratingLabel.text = "\(String(finalNumber))"
            self.profileRating.rating = Double(finalNumber)
        }
    }
    
     func followingPressed() {
        if self.isFollowing == true {
            Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("favorites").child(self.userUID).removeValue()
            self.updateFollowingButton(isFollowing: false)
        } else {
            self.updateFollowingButton(isFollowing: true)
            let userInformation : Dictionary<String, Any> = [
                "uid" : "\(self.userUID)"
            ]
            let postFeed = ["\(self.userUID)" : userInformation]
            Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("favorites").updateChildValues(postFeed)
            Database.database().reference().child("Users").child(self.userUID).child("fcmToken").observe(.value) { (snapshot) in
                let token : String = (snapshot.value as? String)!
                let sender = PushNotificationSender()
                Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("name").observe(.value) { (snapshot) in
                    let userName : String = (snapshot.value as? String)!
                    sender.sendPushNotification(to: token, title: "Congrats! 🎉", body: "\(userName) started following you!", page: true, senderId: Auth.auth().currentUser!.uid, recipient: self.userUID)
                }
            }
        }
    }
    
    func updateFollowingButton(isFollowing: Bool) {
        switch isFollowing {
        case true:
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.statusFollowButton.backgroundColor = UIColor.mainBlue
                self.statusFollowButton.setTitle("FOLLOWING", for: .normal)
                self.statusFollowButton.setTitleColor(UIColor.white, for: .normal)
                self.isFollowing = true
            } completion: { (completion) in
                print("updated button")
            }
        case false:
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.statusFollowButton.backgroundColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 0.35)
                self.statusFollowButton.setTitle("FOLLOW", for: .normal)
                self.statusFollowButton.setTitleColor(UIColor.mainBlue, for: .normal)
                self.isFollowing = false
            } completion: { (completion) in
                print("updated button")
            }
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
    
    @objc func blockUser() {
        let alert = UIAlertController(title: "Are you sure you want to block this user?", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Yes, Block User", style: .default, handler: { (action) in
            let block = UIAlertController(title: "User blocked", message: "", preferredStyle: .alert)
            block.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
                self.navigationController?.popViewController(animated: true)
            }))
            Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("favorites").child(self.userUID).removeValue()
            self.updateFollowingButton(isFollowing: false)
            self.present(block, animated: true, completion: nil)
        }))
        if let popoverController = alert.popoverPresentationController {
          popoverController.sourceView = self.view
          popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Button Action
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBlockUser(_ sender: UIButton) {
        blockUser()
    }
    
    @IBAction func btnUploadPressed(_ sender: UIButton) {
        uploadPressed()
    }
    
    @IBAction func btnFollowClick(_ sender: UIButton) {
        followingPressed()
    }
    
    @IBAction func btnFollowUserClick(_ sender: UIButton) {
        let follower = self.followers[sender.tag]
        guard let uid = follower.uid else {
            return
        }
        let userInformation : Dictionary<String, Any> = [
            "uid" : "\(uid)"
        ]
        let postFeed = ["\(uid)" : userInformation]
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("favorites").updateChildValues(postFeed)
        Database.database().reference().child("Users").child(uid).child("fcmToken").observe(.value) { (snapshot) in
            let token : String = (snapshot.value as? String)!
            let sender = PushNotificationSender()
            Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("name").observe(.value) { (snapshot) in
                let userName : String = (snapshot.value as? String)!
                sender.sendPushNotification(to: token, title: "Congrats! 🎉", body: "\(userName) started following you!", page: true, senderId: Auth.auth().currentUser!.uid, recipient: uid)
            }
            self.tblProfile.reloadData()
        }
    }
    
    @IBAction func btnUnFollowUserClick(_ sender: UIButton) {
        let follower = self.followers[sender.tag]
        guard let uid = follower.uid else {
            return
        }
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("favorites").child(uid).removeValue()
        self.followers[sender.tag].isFollow = false
        self.tblProfile.reloadData()
    }
}

extension UserProfileViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectIndex {
        case 0 :
            if self.myJobs.count == 0 {
                self.noServiceImage.image = UIImage(named: "not-service")!
                self.noServiceLabel.text = "No Services"
                self.noServiceView.isHidden = false
            } else {
                self.noServiceView.isHidden = true
            }
            return myJobs.count
        case 1 :
            if self.allRatings.count == 0 {
                self.noServiceImage.image = UIImage(named: "no-review")!
                self.noServiceLabel.text = "No Reviews"
                self.noServiceView.isHidden = false
            } else {
                self.noServiceView.isHidden = true
            }
            return allRatings.count
        case 2 :
            return 0
        case 3 :
            return followers.count
        case 4 :
            if self.myJobs.count == 0 {
                self.noServiceImage.image = UIImage(named: "not-service")!
                self.noServiceLabel.text = "No Services"
                self.noServiceView.isHidden = false
            } else {
                self.noServiceView.isHidden = true
            }
            return myJobs.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch selectIndex {
        case 0 :
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileServiceTableViewCell.className, for: indexPath) as! ProfileServiceTableViewCell
            cell.selectionStyle = .none
            cell.backgroundColor = .white
            cell.profileImageView.sd_setImage(with: URL(string: self.myJobs[indexPath.row].imagePost!), placeholderImage: nil, options: .retryFailed, completed: nil)
            if let titleJob = self.myJobs[indexPath.row].titleOfPost {
                cell.titleLabel.text = titleJob
            }
            if let saleNumber = self.myJobs[indexPath.row].descriptionOfPost {
                cell.descriptionLabel.text = saleNumber
            }
            if let typeOfPrice = self.myJobs[indexPath.row].typeOfPrice {
                if typeOfPrice == "Hourly" {
                    cell.priceLabel.text = "$\(self.myJobs[indexPath.row].price!) / Hour"
                } else {
                    cell.priceLabel.text = "$\(self.myJobs[indexPath.row].price!)"

                }
            }
            
            return cell
        case 1 :
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileReviewTableViewCell.className, for: indexPath) as! ProfileReviewTableViewCell
            cell.backgroundColor = .white
            cell.selectionStyle = .none
            if let uid = self.allRatings[indexPath.row].userUid {
                Database.database().reference().child("Users").child(uid).child("name").observe(.value) { (snapshot) in
                    if let nameString : String = (snapshot.value as? String) {
                        cell.usernameLabel.text! = nameString
                    } else {
                        cell.usernameLabel.text! = "Unknown"
                    }
                }
                Database.database().reference().child("Users").child(uid).child("profile-image").observe(.value) { (snapshot) in
                    if let profileImageString : String = (snapshot.value as? String) {
                        if profileImageString == "not-yet-selected" {
                            cell.userProfileView.image = UIImage(systemName: "person.circle.fill")
                            cell.userProfileView.tintColor = UIColor.lightGray
                            cell.userProfileView.contentMode = .scaleAspectFill
                        } else {
                            cell.userProfileView.loadImageUsingCacheWithUrlString(profileImageString)
                            cell.userProfileView.tintColor = UIColor.lightGray
                            cell.userProfileView.contentMode = .scaleAspectFill
                        }
                    } else {
                        cell.userProfileView.image = UIImage(systemName: "person.circle.fill")
                        cell.userProfileView.tintColor = UIColor.lightGray
                        cell.userProfileView.contentMode = .scaleAspectFill
                    }
                }
            }

            if let rating = self.allRatings[indexPath.row].ratingNumber {
                if rating == 100 {
                    cell.ratingView.rating = 0.0
                } else {
                    cell.ratingView.rating = Double(rating)
                }
            }

            if let description = self.allRatings[indexPath.row].descriptionOfRating {
                cell.descriptionLabel.text! = description
            }
            
            if let postId = self.allRatings[indexPath.row].postId {
                Database.database().reference().child("Jobs").child(postId).observe(.value) { snapshot in
                    if let pictureString : String = (snapshot.childSnapshot(forPath: "image").value as? String) {
                        cell.postProfileView.sd_setImage(with: URL(string: pictureString), placeholderImage: nil, options: .retryFailed, completed: nil)
                    }
                    if let titleString : String = (snapshot.childSnapshot(forPath: "title").value as? String) {
                        cell.postTitleLabel.text = titleString
                    }
                    if let priceString : Int = (snapshot.childSnapshot(forPath: "price").value as? Int) {
                        cell.priceLabel.text = "$\(priceString)"
                    }
                    if let timestamp : Int = (snapshot.childSnapshot(forPath: "time").value as? Int) {
                        if timestamp > 0 {
                            let doubleTimeStamp = Double(timestamp)
                            let date = doubleTimeStamp.getDateStringFromUnixTime(dateStyle: .medium, timeStyle: .none)
                            cell.dateLabel.text = date
                        }
                    }
                }
            }
            
            return cell
        case 2:
            print("fdf")
            let cell = tableView.dequeueReusableCell(withIdentifier: "followres", for: indexPath) as! FavoritesCell
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileFollowersTableViewCell.className, for: indexPath) as! ProfileFollowersTableViewCell
            cell.selectionStyle = .none
            cell.profileImageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
            if let uid = self.followers[indexPath.row].uid {
                Database.database().reference().child("Users").child(uid).child("name").observe(.value) { (snapshot) in
                    if let snapshot : String = (snapshot.value as? String) {
                        cell.usernameLabel.text = snapshot
                        //cell.index = indexPath
                    }
                }
                
                Database.database().reference().child("Users").child(uid).child("username").observe(.value) { (snapshot) in
                    if let snapshot : String = (snapshot.value as? String) {
                        cell.useremailLabel.text = "@"+snapshot
                        //cell.index = indexPath
                    }
                }
                
                Database.database().reference().child("Users").child(uid).child("profile-image").observe(.value) { (snapshot) in
                    let snapshot : String = (snapshot.value as? String)!
                    
                    if snapshot == "not-yet-selected" {
                        cell.profileImageView.image = UIImage(systemName: "person.circle.fill")
                        cell.profileImageView.tintColor = UIColor.lightGray
                        cell.profileImageView.contentMode = .scaleAspectFill
                    } else {
                        cell.profileImageView.sd_setImage(with: URL(string: snapshot)!, placeholderImage: nil, options: .retryFailed, completed: nil)
                    }
                }
                if self.followers[indexPath.row].isFollow {
                    cell.btnFollow.isHidden = true
                    cell.btnDelete.isHidden = false
                } else {
                    cell.btnFollow.isHidden = false
                    cell.btnDelete.isHidden = true
                }
                cell.btnDelete.tag = indexPath.row
                cell.btnFollow.tag = indexPath.row
                cell.btnFollow.addTarget(self, action: #selector(self.btnFollowUserClick(_:)), for: .touchUpInside)
                cell.btnDelete.addTarget(self, action: #selector(self.btnUnFollowUserClick(_:)), for: .touchUpInside)
                Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("favorites").child(uid).observe(.value) { (listOfuserFavorite) in
                    if let value = listOfuserFavorite.value as? [String : Any] {
                        let user = UserStructure()
                        user.uid = value["uid"] as? String ?? "Error"
                        if user.uid! == uid {
                            self.followers[indexPath.row].isFollow = true
                            cell.btnFollow.isHidden = true
                            cell.btnDelete.isHidden = false
                        } else {
                            self.followers[indexPath.row].isFollow = false
                            cell.btnFollow.isHidden = false
                            cell.btnDelete.isHidden = true
                        }
                    }
                }
            }
            return cell
        case 4:
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
                if typeOfPrice == "Hourly" {
                    cell.priceNumber.text = "$\(self.myJobs[indexPath.row].price!) / Hour"
                } else {
                    cell.priceNumber.text = "$\(self.myJobs[indexPath.row].price!)"
                }
            }
            
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch selectIndex {
        case 0 :
            let controller = ViewPostController()
            controller.postImage2.loadImageUsingCacheWithUrlString(self.myJobs[indexPath.row].imagePost!)
            controller.postImageDownlodUrl = self.myJobs[indexPath.row].imagePost!
            controller.postTitle = self.myJobs[indexPath.row].titleOfPost!
            controller.postDescription = self.myJobs[indexPath.row].descriptionOfPost!
            controller.postPrice = self.myJobs[indexPath.row].price!
            controller.authorId = self.myJobs[indexPath.row].authorName!
            controller.postId = self.myJobs[indexPath.row].postId!
            controller.type = self.myJobs[indexPath.row].typeOfPrice!
            Database.database().reference().child("Users").child(self.myJobs[indexPath.row].authorName!).child("profile-image").observe(.value) { (snapshot) in
                if let name : String = (snapshot.value as? String) {
                    controller.profileImage.sd_setImage(with: URL(string: name), completed: nil)
                }
            }
            self.navigationController?.pushViewController(controller, animated: true)
        case 1 :
            if let uid = self.allRatings[indexPath.row].userUid {
                if let profileVC = CommonUtils.getStoryboardVC(StoryBoard.Profile.rawValue, vcIdetifier: UserProfileViewController.className) as? UserProfileViewController {
                    profileVC.userUID = uid
                    self.navigationController?.pushViewController(profileVC,  animated: true)
                }
            }
        case 2 :
           print("other")
        case 3 :
            if let profileVC = CommonUtils.getStoryboardVC(StoryBoard.Profile.rawValue, vcIdetifier: UserProfileViewController.className) as? UserProfileViewController {
                profileVC.userUID = self.followers[indexPath.row].uid!
                self.navigationController?.pushViewController(profileVC,  animated: true)
            }
            print("info tap")
        case 4 :
            print("other")
        default:
            print("other")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch selectIndex {
        case 0 :
            return UITableView.automaticDimension
        case 1 :
            return UITableView.automaticDimension
        case 2 :
            return 175
        case 3 :
            return 70
        case 4 :
            return 150
        default:
            return 150
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch selectIndex {
        case 0 :
            return 175
        case 1 :
            return 135
        case 2 :
            return 175
        case 3 :
            return 70
        case 4 :
            return 150
        default:
            return 150
        }
    }
}

extension UserProfileViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrMenu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.titleLabel.text = arrMenu[indexPath.item]
        
        DispatchQueue.main.async(execute: {() -> Void in
            let border = CALayer()
            border.frame = CGRect(x: 15, y: cell.frame.size.height - 2, width: cell.frame.size.width - 30, height: cell.frame.size.height)
            border.borderWidth = 2
            cell.layer.masksToBounds = true
            if self.selectIndex == indexPath.item {
                border.borderColor = UIColor.black.cgColor
                cell.titleLabel.textColor = UIColor.black
                cell.titleLabel.font = UIFont.init(name: "Lato-Black", size: 14)
            }else{
                border.borderColor = UIColor.white.cgColor
                cell.layer.borderColor = UIColor.white.cgColor
                cell.titleLabel.textColor = UIColor.lightGray
                cell.titleLabel.font = UIFont.init(name: "Lato-Medium", size: 14)
            }
            cell.layer.addSublayer(border)
        })
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectIndex = indexPath.item
        colMenu.reloadData()
        
        self.followerCount.isHidden = true
        switch selectIndex {
        case 0 :
            UIView.animate(withDuration: 0.5) {
                self.tblProfile.alpha = 1
            } completion: { (complete) in
                self.tblProfile.reloadData()
            }
        case 1 :
            UIView.animate(withDuration: 0.5) {
                self.tblProfile.alpha = 1
            } completion: { (complete) in
                self.tblProfile.reloadData()
            }
        case 2 :
            let gallery = Gallery()
            gallery.userId = self.userUID
            self.present(gallery, animated: true, completion: nil)
            selectIndex = 0
            UIView.animate(withDuration: 0.5) {
                self.tblProfile.alpha = 1
            } completion: { (complete) in
                self.tblProfile.reloadData()
            }
        case 3 :
            self.followerCount.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.tblProfile.alpha = 1
            } completion: { (complete) in
                self.tblProfile.reloadData()
            }
        case 4 :
            let infoPage = InfoPage()
            infoPage.rating = finalRating ?? 0
            infoPage.followers = self.followers.count
            let user = UserStructure()
            user.uid = self.userUID
            infoPage.user = user
            self.present(infoPage, animated: true, completion: nil)
            selectIndex = 0
            UIView.animate(withDuration: 0.5) {
                self.tblProfile.alpha = 1
            } completion: { (complete) in
                self.tblProfile.reloadData()
            }
        default:
           print("default")
        }
        
     
        
    }
    
    
}

class MenuCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
}

