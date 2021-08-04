//
//  OtherPostVC.swift
//  HireMile
//
//  Created by mac on 20/07/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import ZKCarousel
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class ViewPostVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var colProfileImg: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPrice1: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var detailView: UIView!
    
    @IBOutlet weak var txtMsg: UITextField!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var vwSend: UIView!
    @IBOutlet weak var lblSend: UILabel!
    @IBOutlet weak var pagecon: UIPageControl!
    @IBOutlet weak var lblPageCount: UILabel!
    
    let launcher = ProposalPopup()
    var height : CGFloat = 0
    var arrayOfStrImages = [String]()
    
//    var postImage2 = UIImageView()
//    var postImageDownlodUrl = ""
//    var postTitle = ""
//    var postDescription = ""
//    var postPrice = 0
//    var userUID = ""
//    var postId = ""
//    var authorId = ""
//    var type = ""
//    var category = ""
    
    var userStructure: UserStructure?
    var jobPost: JobStructure!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        basicSetup()
        self.colProfileImg!.register(UINib(nibName: "CoverPhotoCell", bundle: nil), forCellWithReuseIdentifier: "CoverPhotoCell")
        
        
        self.lblName.text = jobPost.titleOfPost
        self.lblDetail.text = jobPost.descriptionOfPost
        lblCategory.text = jobPost.category
      //  self.height = self.estimateFrameForText(text: self.descriptionLabel.text!).height
        
        if self.jobPost.typeOfPrice == "Hourly" {
            self.lblPrice.text = "$\(String(jobPost.price ?? 0)) / Hour"
            self.lblPrice1.text = "$\(String(jobPost.price ?? 0)) / Hour"
        } else {
            self.lblPrice.text = "$\(String(jobPost.price ?? 0))"
            self.lblPrice1.text = "$\(String(jobPost.price ?? 0))"
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.basicSetup()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgProfile.isUserInteractionEnabled = true
        imgProfile.addGestureRecognizer(tapGestureRecognizer)
        
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(setName), userInfo: nil, repeats: false)
        //lblRate.text = "4.5"
    }
    // MARK: Button Action
    
    override func viewDidLayoutSubviews() {
        pagecon.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 2, y: 2)
        }
    }
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        handleDismiss()
    }
    
    @IBAction func btnReportClick(_ sender: UIButton) {
        pressed()
    }
    
    @IBAction func btnSendClick(_ sender: UIButton) {
        sendPressed()
    }
    @IBAction func btnHireClick(_ sender: UIButton) {
        hirePressed() 
    }
    
    // MARK: Page Function
    
    @objc func pressed() {
        let alert = UIAlertController(title: "Would you like to report this post?", message: "Management And Administration will notice", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Yes, Report Post", style: .default, handler: { (action) in
            let block = UIAlertController(title: "Post Report", message: "", preferredStyle: .alert)
            block.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            let key = Database.database().reference().child("Reported-Posts").childByAutoId().key
            let values = [
                "post-id" : self.jobPost.postId,
                "key" : key,
                "reporter" : Auth.auth().currentUser!.uid
            ]
            Database.database().reference().child("Reported-Posts").child(key!).updateChildValues(values) { (error, ref) in
                self.present(block, animated: true, completion: nil)
            }
        }))
        if let popoverController = alert.popoverPresentationController {
          popoverController.sourceView = self.view
          popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    @objc func sendPressed() {
        if self.txtMsg.text != " " && self.txtMsg.text != "  " && self.txtMsg.text != "   " && self.txtMsg.text != nil && self.txtMsg.text != "  Say Something..." && self.txtMsg.text != "" {
            let ref = Database.database().reference().child("Messages")
            let childRef = ref.childByAutoId()
            let toId = self.jobPost.authorId ?? ""
            let fromId = Auth.auth().currentUser!.uid
            let timestamp = Int(Date().timeIntervalSince1970)
            let key = Database.database().reference().child("Users").child(toId).child("My_Jobs").childByAutoId().key
            let values = ["text": txtMsg.text!, "toId": toId, "fromId": fromId, "timestamp": timestamp, "first-time" : true, "service-provider" : toId, "job-id" : self.jobPost.postId, "job-ref-id" : key, "hasViewed" : false, "text-id" : childRef.key] as [String : Any]
            childRef.updateChildValues(values) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }

                guard let messageId = childRef.key else { return }

                let userMessagesRef = Database.database().reference().child("User-Messages").child(fromId).child(toId).child(messageId)
                userMessagesRef.setValue(1)

                let recipientUserMessagesRef = Database.database().reference().child("User-Messages").child(toId).child(fromId).child(messageId)
                recipientUserMessagesRef.setValue(1)


                Database.database().reference().child("Users").child(toId).child("fcmToken").observe(.value) { (snapshot) in
                    let token : String = (snapshot.value as? String)!
                    let sender = PushNotificationSender()
                    Database.database().reference().child("Users").child(fromId).child("name").observe(.value) { (snapshot) in
                        let name : String = (snapshot.value as? String)!
                        sender.sendPushNotification(to: token, title: "Chat Notification", body: "New message from \(name)", page: true, senderId: Auth.auth().currentUser!.uid, recipient: toId)
                    }
                }

                self.txtMsg.text = nil
                self.txtMsg.resignFirstResponder()

                self.launcher.showFilter()
                self.launcher.applyButton.addTarget(self, action: #selector(self.handleDismiss), for: .touchUpInside)
            }
            print("not empty")
        } else {
            print("empty")
            let alert = UIAlertController(title: "Error", message: "Please enter valid text", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func hirePressed() {
        if let profileVC = CommonUtils.getStoryboardVC(StoryBoard.Appointment.rawValue, vcIdetifier: BookAppointmentVC.className) as? BookAppointmentVC {
            profileVC.hidesBottomBarWhenPushed = true
            profileVC.jobStructure = jobPost
            self.navigationController?.pushViewController(profileVC,  animated: true)
        }
    }
    
    @objc func handleDismiss() {
       
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func setName() {
        Database.database().reference().child("Users").child(self.jobPost.authorId ?? "").observe(.value) { (snapshot) in
            if let userInformation = snapshot.value as? NSDictionary {
                print("userInformation" ,userInformation)
                if let numberOfRating = userInformation["number-of-ratings"] as? String {
                    self.lblRate.text = numberOfRating
                }
                if let name = userInformation["name"] as? String {
                    self.lblTitle.text = name
                    self.jobPost.author.username = name
                }
                if let url = userInformation["profile-image"] as? String {
                    self.imgProfile.sd_setImage(with: URL(string: url), completed: nil)
                    self.jobPost.author.profileImageView = url
                }
            }
        }
    }
    
    func basicSetup() {
        self.view.backgroundColor = UIColor.white
        
        self.txtMsg.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
        txtMsg.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
       
        let array = (self.jobPost.imagePost ?? "").components(separatedBy: ",")
        arrayOfStrImages = array
        self.colProfileImg!.reloadData()
        
        pagecon!.numberOfPages = arrayOfStrImages.count
        pagecon!.currentPage = 0
        lblPageCount.text = "1/\(arrayOfStrImages.count)"
    }
    
    
   
    @objc func textFieldDidChange() {
        self.changeButtonStatus()
    }
    
    func changeButtonStatus() {
        if self.txtMsg.text != " " || self.txtMsg.text != "  " || self.txtMsg.text != "   " {
            self.vwSend.backgroundColor = UIColor.mainBlue
            lblSend.textColor = UIColor.white
        } else {
            self.vwSend.backgroundColor = UIColor(red: 242/255, green: 235/255, blue: 235/255, alpha: 1)
            lblSend.textColor = UIColor(red: 131/255, green: 131/255, blue: 131/255, alpha: 1)
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("began")
        if txtMsg.text != "  Say Something..." {
            //
        } else {
            self.txtMsg.text = "   "
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.frame.origin.y += 90
        return (true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.txtMsg.isFirstResponder {
            self.view.frame.origin.y += 90
            self.view.endEditing(true)
        }
    }
    @objc func keyboardUp(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = 0
            self.view.frame.origin.y -= 90
        }
    }
    
    @objc func keyboardDown(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = 0
        }
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        // send uid
        Database.database().reference().child("Jobs").child(self.jobPost.postId ?? "").child("author").observe(.value) { (snapshot) in
            if let profileUID : String = (snapshot.value as? String) {
                if let profileVC = CommonUtils.getStoryboardVC(StoryBoard.Profile.rawValue, vcIdetifier: UserProfileViewController.className) as? UserProfileViewController {
                    profileVC.userUID = profileUID
                    self.navigationController?.pushViewController(profileVC,  animated: true)
                }
            }
        }
        // following
    }
}
extension ViewPostVC: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfStrImages.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoverPhotoCell", for: indexPath) as! CoverPhotoCell
        cell.vWMain.layer.cornerRadius = 0.0
        cell.imgCoverPhoto.layer.cornerRadius = 0.0
        cell.imgCoverPhoto.sd_setImage(with: URL(string: arrayOfStrImages[indexPath.item]), completed: nil)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: self.view.frame.size.width , height: 340)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0001
    }
    //MARK: ====: UIScrollView Delegate :====
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let count = scrollView.contentOffset.x / scrollView.frame.size.width
            self.pagecon!.currentPage = Int(count)
            lblPageCount.text = "\(Int(count + 1))/\(arrayOfStrImages.count)"
        }
}
