//
//  AddCardVC.swift
//  HireMile
//
//  Created by mac on 11/07/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit

class AddCardVC: UIViewController {

    @IBOutlet weak var vwError1: UIView!
    @IBOutlet weak var lblError1: UILabel!
    @IBOutlet weak var lblError2: UILabel!
    @IBOutlet weak var imgCardNumber: UIImageView!
    @IBOutlet weak var imgCVV: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCardNumber: UITextField!
    @IBOutlet weak var txtExpiryDate: UITextField!
    @IBOutlet weak var txtCVV: UITextField!
    @IBOutlet weak var btnAddCard: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: Button Action
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddCardClick(_ sender: UIButton) {
        vwError1.isHidden = true
        lblError2.isHidden = true
    }
    
    
    

}
