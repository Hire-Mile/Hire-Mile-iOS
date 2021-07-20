//
//  AddpaymentVC.swift
//  HireMile
//
//  Created by mac on 11/07/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit

class AddpaymentVC: UIViewController {

    @IBOutlet weak var lblAddPayment: UILabel!
    @IBOutlet weak var lblDescryption: UILabel!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: Button Action
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func btnCreditorDebitCardClick(_ sender: UIButton) {
       /* if let profileVC = CommonUtils.getStoryboardVC(StoryBoard.Payment.rawValue, vcIdetifier: AddpaymentVC.className) as? AddpaymentVC {
            profileVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(profileVC,  animated: true)
        }*/
        lblDescryption.isHidden = true
        lblAddPayment.isHidden = true
    }
    
    @IBAction func btnGoBackClick(_ sender: UIButton) {
        dismiss(animated: true)
    }


}
