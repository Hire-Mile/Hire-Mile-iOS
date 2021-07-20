//
//  RattingVC.swift
//  HireMile
//
//  Created by mac on 11/07/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit

class RattingVC: UIViewController {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRattig: UILabel!
    @IBOutlet weak var txtDescryption: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: Button Action
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func btnSubmitClick(_ sender: UIButton) {
        
    }
 
    
}
