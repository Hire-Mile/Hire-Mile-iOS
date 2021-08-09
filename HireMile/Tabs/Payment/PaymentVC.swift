//
//  PaymentVC.swift
//  HireMile
//
//  Created by mac on 10/07/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class PaymentVC: UIViewController {

    @IBOutlet weak var colCard: UICollectionView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblServiceFee: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var lblPostTitle: UILabel!
    
    var arrToken = [[String:Any]]()
    
    var ongoingJob:OngoingJobs!
    var userJobPost : UserChat!
    var message: Message?
    var currentJob: JobStructure?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.colCard.register(UINib(nibName: "colPaymentCardCell", bundle: nil), forCellWithReuseIdentifier: "colPaymentCardCell")
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("Cards").observe(.value) { (usernameSnap) in
            print(usernameSnap)
            if let username = usernameSnap.value as? [[String:Any]] {
                self.arrToken = username
                self.colCard.reloadData()
            }
        }
        
        self.lblName.text = userJobPost.name ?? ""
        Database.database().reference().child("Jobs").child(ongoingJob.jobId).observeSingleEvent(of:.value) { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                let job = JobStructure()
                job.authorId = value["author"] as? String ?? "Error"
                job.titleOfPost = value["title"] as? String ?? "Error"
                job.descriptionOfPost = value["description"] as? String ?? "Error"
                job.price = value["price"] as? Int ?? 0
                job.category = value["category"] as? String ?? "Error"
                job.imagePost = value["image"] as? String ?? "Error"
                job.typeOfPrice = value["type-of-price"] as? String ?? "Error"
                job.postId = value["postId"] as? String ?? "Error"
                
                self.lblPostTitle.text = "\(job.titleOfPost!)"
                self.lblDate.text = self.ongoingJob.scheduleTime
                if let date = self.ongoingJob.scheduleDate.toDate(withFormat: "dd-MM-yy") {
                    let customDate = date.toString(withFormat: "MMMM dd")
                    self.lblDate.text = customDate + ", " + self.ongoingJob.scheduleTime
                }
                
                if job.typeOfPrice == "Hourly" {
                    self.lblPrice.text! = "$\(job.price!) / Hour"
                    self.lblTotalAmount.text! = "$\(job.price!) / Hour"
                    self.btnPay.setTitle("Pay $\(job.price!) / Hour", for: .normal)
                } else {
                    self.lblPrice.text! = "$\(job.price!)"
                    self.lblTotalAmount.text! = "\(job.price!)"
                    self.btnPay.setTitle("Pay $\(job.price!)", for: .normal)
                }
                self.currentJob = job
                self.colCard.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    // MARK: Button Action
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddCardClick(_ sender: UIButton) {
        if let profileVC = CommonUtils.getStoryboardVC(StoryBoard.Payment.rawValue, vcIdetifier: AddCardVC.className) as? AddCardVC { //
            profileVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(profileVC,  animated: true)
        }
    }
    
    @IBAction func btnPayClick(_ sender: UIButton) {
        let timestamp = Int(Date().timeIntervalSince1970)
        if((self.ongoingJob) != nil) {
            let ongoingJobRef = Database.database().reference().child("Ongoing-Jobs").child(self.ongoingJob.key)
            let acceptDic = ["job-status":JobStatus.Completed.rawValue,"complete-time": timestamp]
            ongoingJobRef.updateChildValues(acceptDic)
        }
        
        let ref = Database.database().reference().child("Users").child(self.ongoingJob.bookUid)
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String : AnyObject] else {
                return
            }
            debugPrint(dictionary)
            let user = UserChat(dictionary: dictionary)
            user.id = snapshot.key
            if let token : String = (dictionary["fcmToken"] as? String) {
                let sender = PushNotificationSender()
                sender.sendPushNotification(to: token, title: "Congrats! 🎉", body: "\(user.name ?? "") comleted job.", page: true, senderId: Auth.auth().currentUser!.uid, recipient: self.ongoingJob.bookUid)
                
            }
        }
        
        if let message = self.message {
//            let userMessagesRef = Database.database().reference().child("User-Messages").child(fromId).child(toId!).child(message.ke)
//            userMessagesRef.setValue(1)
        }
        
        
        if let profileVC = CommonUtils.getStoryboardVC(StoryBoard.Payment.rawValue, vcIdetifier: PaymentSuccessfulVC.className) as? PaymentSuccessfulVC {
            profileVC.ongoingJob = ongoingJob
            profileVC.userJobPost = self.userJobPost
            profileVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(profileVC,  animated: true)
        }
    }
}

extension PaymentVC: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.arrToken.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colPaymentCardCell", for: indexPath) as! colPaymentCardCell
        let datas = self.arrToken[indexPath.section]
        let cardNumber = "************\(datas["last4"] as! String)"
        if let job = currentJob {
            if job.typeOfPrice == "Hourly" {
                cell.lblAmount.text = "$\(job.price!) / Hour"
            } else {
                cell.lblAmount.text = "$\(job.price!)"
            }
        }
        
        cell.lblCardNumber.text = cardNumber.chunkFormatted(withChunkSize: 4, withSeparator: " ")
        if indexPath.section > 2 {
            cell.lblName.text = "\(datas["name"] as! String)"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let vwWidth = (colCard.frame.size.width)
        return CGSize(width: vwWidth-40, height: 196)
    }
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0)
    }*/
    
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10
}
    //MARK: ====: UIScrollView Delegate :====
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let count = scrollView.contentOffset.x / scrollView.frame.size.width
            
          
        }
}
