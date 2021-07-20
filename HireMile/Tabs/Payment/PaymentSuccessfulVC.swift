//
//  PaymentSuccessfulVC.swift
//  HireMile
//
//  Created by mac on 11/07/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit

class PaymentSuccessfulVC: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblTransactionID: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: Button Action
    
    @IBAction func btnRatingHenryClick(_ sender: UIButton) {
        if let VC = CommonUtils.getStoryboardVC(StoryBoard.Payment.rawValue, vcIdetifier: RattingVC.className) as? RattingVC {
            VC.hidesBottomBarWhenPushed = true
           // VC.modalPresentationStyle = .fullScreen
            self.navigationController?.present(VC, animated: true)
        }
    }
 
    @IBAction func btnBackToHomeClick(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
