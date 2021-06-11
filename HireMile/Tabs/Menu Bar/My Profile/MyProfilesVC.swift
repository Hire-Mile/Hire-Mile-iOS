//
//  MyProfilesVC.swift
//  HireMile
//
//  Created by mac on 09/06/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import Foundation
import FirebaseDatabase
import FirebaseAuth
import SDWebImage
import Cosmos

class MyProfilesVC: UIViewController {

    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var statusFollowButton: UIButton!
    @IBOutlet weak var tblProfile: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var colMenu: UICollectionView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var noServiceImage: UIImageView!
    @IBOutlet weak var noServiceLabel: UILabel!
    @IBOutlet weak var noServiceView: UIView!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var profileRating: CosmosView!
    
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
    
    var isFollowing : Bool?
    var userUID = ""
    
    let arrMenu = ["Services","Reviews","Gallery","Followers","Info"]
    var selectIndex = 0
    
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
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        // get array
    }

    
    func UISetUp()  {
    
        self.allJobs.removeAll()
        self.myJobs.removeAll()
        
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
                            job.timeStamp = value["time"] as? Int ?? 0
                            job.postId = value["postId"] as? String ?? "Error"
                            
                            if job.authorName == uid {
                                self.myJobs.append(job)
                            }
                        }
                        self.myJobs.sort(by: { $1.timeStamp! < $0.timeStamp! } )
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
      //   self.thirdTitleLabel.text = String(self.ratingNumber)
         print("updating rating label")
         let finalNumber = self.finalRating / self.ratingNumber
         self.finalNumber = finalNumber
         self.ratingLabel.text = "\(String(finalNumber))"
        self.profileRating.rating = Double(finalNumber)
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
    
    @objc func editPressed() {
        self.navigationController?.pushViewController(EditProfile(), animated: true)
    }
    

    
    // MARK: Button Action
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBlockUser(_ sender: UIButton) {
        editPressed()
    }
    
    @IBAction func btnUploadPressed(_ sender: UIButton) {
        uploadPressed()
    }
    
    
    @objc func didTapEditButton(sender: UIButton) {
        let url = URL(string: self.myJobs[sender.tag].imagePost!)
        GlobalVariables.imagePost.sd_setImage(with: url, completed: nil)
        GlobalVariables.postImageDownlodUrl = self.myJobs[indexPathrow].imagePost!
        GlobalVariables.postTitle = self.myJobs[indexPathrow].titleOfPost!
        GlobalVariables.postDescription = self.myJobs[indexPathrow].descriptionOfPost!
        GlobalVariables.postPrice = self.myJobs[indexPathrow].price!
        GlobalVariables.authorId = self.myJobs[indexPathrow].authorName!
        GlobalVariables.postId = self.myJobs[indexPathrow].postId!
        GlobalVariables.type = self.myJobs[indexPathrow].typeOfPrice!
        self.navigationController?.pushViewController(EditPost(), animated: true)
    }
    @objc func didTapDeleteButton(sender: UIButton) {
        self.indexTappeedd = sender.tag
        self.filterLauncher.stopJob.addTarget(self, action: #selector(self.deletePostPressed), for: .touchUpInside)
        self.filterLauncher.showFilter()
    }
    
    @objc func deletePostPressed() {
        Database.database().reference().child("Jobs").child(self.myJobs[indexTappeedd].postId!).removeValue()
        self.filterLauncher.handleDismiss()
        self.viewDidLoad()
    }
    
}


extension MyProfilesVC : UITableViewDelegate,UITableViewDataSource {
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
            let cell = tableView.dequeueReusableCell(withIdentifier: MyProfileReviewTableViewCell.className, for: indexPath) as! MyProfileReviewTableViewCell
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
            
            cell.editButton.tag = indexPath.row
            cell.deleteButton.tag = indexPath.row
            cell.editButton.addTarget(self, action: #selector(didTapEditButton(sender:)), for: .touchUpInside)
            
            cell.deleteButton.addTarget(self, action: #selector(didTapDeleteButton(sender:)), for: .touchUpInside)
            
            
            return cell
        case 1 :
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileReviewTableViewCell.className, for: indexPath) as! ProfileReviewTableViewCell
            cell.backgroundColor = .white
            cell.selectionStyle = .none
            if let uid = self.allRatings[indexPath.row].userUid {
                Database.database().reference().child("Users").child(uid).child("name").observe(.value) { (snapshot) in
                    if let nameString : String = (snapshot.value as? String) {
                        cell.titleLabel.text! = nameString
                    } else {
                        cell.titleLabel.text! = "Unknown"
                    }
                }
                Database.database().reference().child("Users").child(uid).child("profile-image").observe(.value) { (snapshot) in
                    if let profileImageString : String = (snapshot.value as? String) {
                        if profileImageString == "not-yet-selected" {
                            cell.profileImageView1.image = UIImage(systemName: "person.circle.fill")
                            cell.profileImageView1.tintColor = UIColor.lightGray
                            cell.profileImageView1.contentMode = .scaleAspectFill
                        } else {
                            cell.profileImageView1.loadImageUsingCacheWithUrlString(profileImageString)
                            cell.profileImageView1.tintColor = UIColor.lightGray
                            cell.profileImageView1.contentMode = .scaleAspectFill
                        }
                    } else {
                        cell.profileImageView1.image = UIImage(systemName: "person.circle.fill")
                        cell.profileImageView1.tintColor = UIColor.lightGray
                        cell.profileImageView1.contentMode = .scaleAspectFill
                    }
                }
            }
            
    /*        if let timestamp = self.allRatings[indexPath.row].timestamp {
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
*/
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
                Database.database().reference().child("Jobs").child(postId).child("image").observe(.value) { (snapshot) in
                    if let pictureString : String = (snapshot.value as? String) {
                        cell.profileImageView.sd_setImage(with: URL(string: pictureString), placeholderImage: nil, options: .retryFailed, completed: nil)
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
            debugPrint(self.followers)
            if let uid = self.followers[indexPath.row].uid {
                Database.database().reference().child("Users").child(uid).child("name").observe(.value) { (snapshot) in
                    if let snapshot : String = (snapshot.value as? String) {
                        cell.usernameLabel.text = snapshot
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
            GlobalVariables.postImageDownlodUrl = self.myJobs[indexPath.row].imagePost!
            GlobalVariables.postTitle = self.myJobs[indexPath.row].titleOfPost!
            GlobalVariables.postDescription = self.myJobs[indexPath.row].descriptionOfPost!
            GlobalVariables.postPrice = self.myJobs[indexPath.row].price!
            GlobalVariables.authorId = self.myJobs[indexPath.row].authorName!
            GlobalVariables.postId = self.myJobs[indexPath.row].postId!
            GlobalVariables.type = self.myJobs[indexPath.row].typeOfPrice!
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
            return 90
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
            return 90
        case 4 :
            return 150
        default:
            return 150
        }
    }
}

extension MyProfilesVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
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
        debugPrint(selectIndex)
        colMenu.reloadData()
        
        
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
            gallery.userId = Auth.auth().currentUser!.uid
            self.present(gallery, animated: true, completion: nil)
            selectIndex = 0
            UIView.animate(withDuration: 0.5) {
                self.tblProfile.alpha = 1
            } completion: { (complete) in
                self.tblProfile.reloadData()
            }
        case 3 :
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
            user.uid = Auth.auth().currentUser!.uid
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

class MyProfileReviewTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileImageView1: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
