//
//  PaymentVC.swift
//  HireMile
//
//  Created by mac on 10/07/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit

class PaymentVC: UIViewController {

    @IBOutlet weak var colCard: UICollectionView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblServiceFee: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var btnPay: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.colCard.register(UINib(nibName: "colPaymentCardCell", bundle: nil), forCellWithReuseIdentifier: "colPaymentCardCell")
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
        if let profileVC = CommonUtils.getStoryboardVC(StoryBoard.Payment.rawValue, vcIdetifier: AddCardVC.className) as? AddCardVC { //
            profileVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(profileVC,  animated: true)
        }
    }
    
    @IBAction func btnPayClick(_ sender: UIButton) {
        if let profileVC = CommonUtils.getStoryboardVC(StoryBoard.Payment.rawValue, vcIdetifier: PaymentSuccessfulVC.className) as? PaymentSuccessfulVC {
          //  profileVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(profileVC,  animated: true)
        }
    }

    /*
     if (textField == self.txtCardNumber){
         if updatedText.count == 0 {
             imgVisa.image = UIImage(named: "visa")
         }else{
             imgVisa.image = UIImage(named: "visacolor")
         }
         if string.count == 0 {
             textField.text = String(text.dropLast()).chunkFormatted(withChunkSize: 4, withSeparator: " ")
         }else {
             let newText = String((text + string)
                 .filter({ $0 != " " }).prefix(16))
             textField.text = newText.chunkFormatted(withChunkSize: 4, withSeparator: " ")
         }
     }
    */

}
extension PaymentVC: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colPaymentCardCell", for: indexPath) as! colPaymentCardCell
        
        let cardNumber = "2312323434563431"
        cell.lblCardNumber.text = cardNumber.chunkFormatted(withChunkSize: 4, withSeparator: " ")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let vwWidth = (colCard.frame.size.width - 40)
            //arrTime[indexPath.row].width(withConstrainedHeight: 40, font: UIFont(name: "Lato-Medium", size:  14.0)!)
        return CGSize(width: vwWidth, height: 196)
    }
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0)
    }*/
    
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10
}
    
}
