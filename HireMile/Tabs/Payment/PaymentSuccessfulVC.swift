//
//  PaymentSuccessfulVC.swift
//  HireMile
//
//  Created by mac on 11/07/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PaymentSuccessfulVC: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblTransactionID: UILabel!
    @IBOutlet weak var ratingButton: UIButton!
    
    var ongoingJob:OngoingJobs!
    var userJobPost : UserChat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        // Do any additional setup after loading the view.
    }
    
    func initUI() {
        let randomInt = Int.random(in: 1..<5)
        lblTransactionID.text = "\(randomInt)"
        self.ratingButton.setTitle("Rating \(userJobPost.name ?? "")", for: .normal)
        lblName.attributedText = NSMutableAttributedString().normal("You Pay to was").bold(" Henrry correa ").normal("succesfully done.")
        Database.database().reference().child("Jobs").child(ongoingJob.jobId).observe(.value) { (snapshot) in
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

                if job.typeOfPrice == "Hourly" {
                    self.lblAmount.text! = "$\(job.price!) / Hour"
                } else {
                    self.lblAmount.text! = "$\(job.price!)"
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: Button Action
    
    @IBAction func btnRatingHenryClick(_ sender: UIButton) {
        if let VC = CommonUtils.getStoryboardVC(StoryBoard.Payment.rawValue, vcIdetifier: RattingVC.className) as? RattingVC {
            VC.userOther = self.userJobPost
            VC.ongoingJob = self.ongoingJob
            VC.hidesBottomBarWhenPushed = true
            VC.modalPresentationStyle = .fullScreen
            self.navigationController?.present(VC, animated: true)
        }
    }
 
    @IBAction func btnBackToHomeClick(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
