//
//  HomeVC.swift
//  HireMile
//
//  Created by mac on 11/07/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import MBProgressHUD
import SDWebImage
import CoreLocation

class HomeVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var colCategory: UICollectionView!
    @IBOutlet weak var tblHome: UITableView!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblNotificationCount: UILabel!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var btnProfile: UIButton!
    
    let imageArray = ["auto-sq", "scissor-sq", "carperter-sq", "clean-sq", "moving-sq", "hair-sq", "NAIL", "phone-sq", "towing-sq", "other-sq"]
    
    let titles = ["Auto", "Barber", "Carpentry", "Cleaning", "Moving", "Salon", "Beauty", "Technology", "Towing", "Other"]
    
    let imagePicker = UIImagePickerController()
    
    let launcher = FeedbackLauncher()
    
    var timer : Timer?
    
    var estimateWidth = 160.0
    
    var cellMarginSize = 5
    
    var allJobs = [JobStructure]()
    
    var allJobsByCategory = [[JobStructure]]()
    
    var passingImage : UIImage?
    
    var openingFromNotification = false
    
    let locationManager = CLLocationManager()
    
    var storedOffsets = [Int: CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UISetUp()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: SetUP View
    
    func UISetUp()  {
      
        
        checkLocationAuthorization()
        let pushManager = PushNotificationManager(userID: Auth.auth().currentUser!.uid)
        pushManager.registerForPushNotifications()
        
        self.colCategory!.translatesAutoresizingMaskIntoConstraints = false
        self.colCategory!.dataSource = self
        self.colCategory!.delegate = self
        self.colCategory.register(UINib(nibName: "CategorysCell", bundle: nil), forCellWithReuseIdentifier: "CategorysCell")
        
        // Functions to throw
    //    self.menuSetup()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFunction), userInfo: nil, repeats: true)
        
        txtSearch.addAction(for: .editingChanged) {
            print("View All!")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("profile-image").observe(.value) { (photoSnap) in
            if let photoUrl = photoSnap.value as? String {
                self.view.bringSubviewToFront(self.btnProfile)
                self.btnProfile.sd_setImage(with: URL(string: photoUrl), for: .normal, completed: nil)
               // self.btnProfile.setTitle(, for: .normal)
             //   self.myImageView.sd_setImage(with: URL(string: photoUrl), completed: nil)
            }
        }
        
        self.observeMessages()
        
        if self.openingFromNotification == true {
            print("opening from notfication")
            self.openingFromNotification = false
        } else {
            print("no notifications")
        }
        if GlobalVariables.finishedFeedback == true {
            GlobalVariables.finishedFeedback = false
            self.launcher.showFilter()
        }
        
        // Functions to throw
        self.basicSetup()
        self.setupCategory()
        self.view = view
    }
    
    func basicSetup() {
        self.view.backgroundColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = true
        navigationItem.backButtonTitle = " "
    }
    
    @objc func setupCategory() {
           MBProgressHUD.showAdded(to: self.view, animated: true)
           self.allJobs.removeAll()
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
                   job.timeStamp = value["time"] as? Int ?? 0
                   self.allJobs.append(job)
               }
               
               let hello = self.allJobs.sorted(by: { $1.timeStamp! > $0.timeStamp! } )
               self.allJobsByCategory.removeAll()
               self.allJobs.removeAll()
               self.allJobs = hello
               self.allJobsByCategory.append(hello)
               let arrcat = ["Carpentry","Auto","Towing","Technology",  "Cleaning","Barber","Salon","Moving","Beauty","Other"]
               for cat in arrcat {
                   let cat = hello.filter { $0.category!.contains(cat) }
                   if cat.count > 0 {
                       self.allJobsByCategory.append(cat)

                   }
               }
               self.tblHome.reloadData()
               MBProgressHUD.hide(for: self.view, animated: true)
           }
       }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return (true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func refreshAction() {
        self.setupCategory()
    }
    
    @objc func searchButtonPressed() {
        let controller = SearchController()
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func buttonLearnMoreTapped() {
        let url = URL(string: "https://hiremileapp.netlify.app/")!
        UIApplication.shared.open(url)
    }
    
    @objc func timerFunction() {
        if GlobalVariables.presentToCat == true {
            let controller = ViewPostController()
            controller.postImage2.loadImageUsingCacheWithUrlString(GlobalVariables.catId.imagePost!)
            controller.postImageDownlodUrl = GlobalVariables.catId.imagePost!
            controller.postTitle = GlobalVariables.catId.titleOfPost!
            controller.postDescription = GlobalVariables.catId.descriptionOfPost!
            controller.postPrice = GlobalVariables.catId.price!
            controller.authorId = GlobalVariables.catId.authorName!
            controller.postId = GlobalVariables.catId.postId!
            controller.type = GlobalVariables.catId.typeOfPrice!
            self.navigationController?.pushViewController(controller, animated: true)
            GlobalVariables.presentToCat = false
            GlobalVariables.catId = JobStructure()
        }
        
        if GlobalVariables.presentToUserProfile == true {
            if let profileVC = CommonUtils.getStoryboardVC(StoryBoard.Profile.rawValue, vcIdetifier: UserProfileViewController.className) as? UserProfileViewController {
                profileVC.userUID = GlobalVariables.userPresentationId
                self.navigationController?.pushViewController(profileVC,  animated: true)
            }
            GlobalVariables.presentToUserProfile = false
        }
        
        if GlobalVariables.isSearching {
            GlobalVariables.isSearching = false
            let controller = CategoryPostController()
            controller.category = GlobalVariables.searchCat
            GlobalVariables.searchCat = ""
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        if GlobalVariables.isGoingToPost == true {
            if let editVC = CommonUtils.getStoryboardVC(StoryBoard.Profile.rawValue, vcIdetifier: CreatePosts.className) as? CreatePosts {
                editVC.hidesBottomBarWhenPushed = true
                GlobalVariables.isGoingToPost = false
                self.passingImage = nil
                if let navVC = self.tabBarController?.selectedViewController as? UINavigationController {
                    navVC.pushViewController(editVC, animated: true)
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            self.passingImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            self.passingImage = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    var messages = [Message]()
    var messagesDictionary = [String : Message]()
    
    func observeMessages() {
        self.messages.removeAll()
        self.messagesDictionary.removeAll()
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("User-Messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let userId = snapshot.key
            Database.database().reference().child("User-Messages").child(uid).child(userId).observe(.childAdded) { (snapshot) in
                let messageId = snapshot.key
                self.fetchMessageWithMessageId(messageId: messageId)
            }
        }, withCancel: nil)
    }
    
    private func fetchMessageWithMessageId(messageId: String) {
        let messagesReference = Database.database().reference().child("Messages").child(messageId)
        messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message(dictionary: dictionary)
                if let chatPartnerId = message.chatPartnerId() {
                    self.messagesDictionary[chatPartnerId] = message
                }
                self.attemptReloadData()
            }
        }, withCancel: nil)
    }
    
    var ssstimer : Timer?
    
    func attemptReloadData() {
        self.ssstimer?.invalidate()
        self.ssstimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReload), userInfo: nil, repeats: false)
    }
    
    @objc func mapButtonPressed() {
        let controller = Map()
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func profileImagePressed() {
       if let profileVC = CommonUtils.getStoryboardVC(StoryBoard.Profile.rawValue, vcIdetifier: MyProfilesVC.className) as? MyProfilesVC {
            profileVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(profileVC,  animated: true)
        }
    }
    
    @objc func handleReload() {
        self.messages = Array(self.messagesDictionary.values)
        self.messages.sort(by: { (message1, message2) -> Bool in
            if let timestamp1 = message1.timestamp, let timestamp2 = message2.timestamp {
                return timestamp1.intValue > timestamp2.intValue
            }
            return false
        })
        //this will crash because of background thread, so lets call this on dispatch_async main thread
        DispatchQueue.main.async(execute: {
            self.reloadData()
        })
    }
    
    func reloadData() {
        for message in self.messages {
            if message.hasViewed == false {
                if let uid = Auth.auth().currentUser?.uid {
                    if message.toId == uid {
                        // maybe blue, depends on viewage
                        if message.hasViewed == true {
                            // extract blue
                            if ((tabBarController?.tabBar.items?.indices.contains(3)) != nil) {
                                tabBarController?.tabBar.items?[3].badgeValue = nil
                            }
                            
                        } else {
                            // keep blue
                            if ((tabBarController?.tabBar.items?.indices.contains(3)) != nil) {
                                tabBarController?.tabBar.items?[3].badgeValue = "1"
                            }
                        }
                    } else {
                        // extract blue, not recipient
                    }
                }
            }
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            let alert = UIAlertController(title: "Cannot find location", message: "Please go to Settings and allow location to view this screen!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            let alert = UIAlertController(title: "Cannot find location", message: "Your location is marked as 'restricted'", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        case .authorizedAlways:
            
            break
        }
    }
    // MARK: Button Action
    
    @IBAction func btnLocationClick(_ sender: UIButton) {
        let controller = Map()
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    //    self.navigationController?.present(controller, animated: true)
    }
  
    @IBAction func btnScheduleClick(_ sender: UIButton) {
        let myScheduleVC = CommonUtils.getStoryboardVC(StoryBoard.Schedule.rawValue, vcIdetifier: MYScheduleVC.className) as! MYScheduleVC
        self.navigationController?.pushViewController(myScheduleVC, animated: true)
    }
    
    @IBAction func btnNotificationClick(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 3
    }
  
    @IBAction func btnProfileClick(_ sender: UIButton) {
        if let profileVC = CommonUtils.getStoryboardVC(StoryBoard.Profile.rawValue, vcIdetifier: MyProfilesVC.className) as? MyProfilesVC {
             profileVC.hidesBottomBarWhenPushed = true
             self.navigationController?.pushViewController(profileVC,  animated: true)
       }
    }
    
    @IBAction func btnSearchClick(_ sender: UIButton) {
        let controller = SearchController()
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnLearnMoreCLick(_ sender: UIButton) {
        let url = URL(string: "https://hiremileapp.netlify.app/")!
        UIApplication.shared.open(url)
    }
    
    @IBAction func btnViewAllClick(_ sender: UIButton) {
        self.navigationController?.pushViewController(AllCategories(), animated: true)
    }
    
    @IBAction func btnViewAllCategoryClick(_ sender: UIButton) {
            let controller = CategoryPostController()
            if sender.tag == 0  {
                controller.category = "Recommend for you"
            }else{
                controller.category = allJobsByCategory[sender.tag].first?.category  //"Recent"
            }
            self.navigationController?.pushViewController(controller, animated: true)
    }


}




extension HomeVC : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allJobsByCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServicesorWorkersCell", for: indexPath) as! ServicesorWorkersCell
        cell.selectionStyle = .none
        cell.homeVC = self
        if let category = allJobsByCategory[indexPath.row].first?.category {
            if indexPath.row == 0 {
                cell.lblService.text = "Recommend for you"
            }else{
                cell.lblService.text = category
            }
        }
        cell.btnViewAll.tag = indexPath.row
        cell.btnViewAll.addTarget(self, action: #selector(self.btnViewAllCategoryClick(_:)), for: .touchUpInside)
        cell.arrayJobs = allJobsByCategory[indexPath.row]
        cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: cell, forRow: indexPath.row)
        
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //guard let tableViewCell = cell as? ServicesorWorkersCell else { return }
        
        //tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.section)
        //tableViewCell.collectionViewOffset = storedOffsets[indexPath.section] ?? 0
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //guard let tableViewCell = cell as? ServicesorWorkersCell else { return }

        //storedOffsets[indexPath.section] = tableViewCell.collectionViewOffset
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 315
        }else{
            return 295
        }
        //UITableView.automaticDimension
        
    }
    
    
}


extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategorysCell", for: indexPath) as! CategorysCell
        cell.lblTitle.text = self.titles[indexPath.row]
        cell.imgCategory.image = UIImage(named: self.imageArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = CategoryPostController()
        controller.hidesBottomBarWhenPushed = true
        controller.category = self.titles[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 93)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
}
