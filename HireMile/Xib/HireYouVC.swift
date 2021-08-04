//
//  HireYouVC.swift
//  HireMile
//
//  Created by mac on 26/07/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class HireYouVC: UIViewController {

    @IBOutlet var vwMain: UIView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var btnView: UIButton!
    var notificationTitle = ""
    var key = ""
    var closure : ((_ name : String)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblName.text = notificationTitle
        
        // Do any additional setup after loading the view.
    }


    @IBAction func btnViewClick(_ sender:UIButton) {
        let notificationObserve =  Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("Notifcations")
        notificationObserve.child(key).child("hasView").setValue(true)
        if (closure != nil){
            closure!("abcd")
            self.dismiss(animated: false, completion: nil)
        }
    }

}
