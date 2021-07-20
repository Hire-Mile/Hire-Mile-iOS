//
//  MenuVC.swift
//  HireMile
//
//  Created by mac on 11/07/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit

class MenuVC: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var colMenu: UICollectionView!
    var completionHandler: ((Int)->Void)?
    let arrMenu = ["My Jobs"," Review"," Payment","Follower","Settings","Log out"]
    let arrimgMenu = ["myjob","review","payment","follower","setting","logut"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.colMenu.register(UINib(nibName: "CategorysCell", bundle: nil), forCellWithReuseIdentifier: "CategorysCell")
        // Do any additional setup after loading the view.
    }
    
    // MARK: Button Action
    
    @IBAction func btnClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension MenuVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.arrMenu.count
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategorysCell", for: indexPath) as! CategorysCell
  //  cell.imgCategory.cornerRadius = 25
 //   cell.imgCategory.backgroundColor = UIColor(named: "F3F3F3")
    cell.imgCategory.contentMode = .scaleAspectFit
    cell.lblTitle.text = self.arrMenu[indexPath.row]
    cell.imgCategory.image = UIImage(named: self.arrimgMenu[indexPath.row])
    return cell
}

func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.dismiss(animated: true) {
        self.completionHandler!(indexPath.row)
    }
    
}

func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let vwWidth = self.view.frame.size.width / 3
    return CGSize(width: vwWidth - 30, height: 100)
}
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
return 10
}

}
