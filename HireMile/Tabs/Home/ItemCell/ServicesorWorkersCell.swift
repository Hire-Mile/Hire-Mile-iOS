//
//  ServicesorWorkersCell.swift
//  HireMile
//
//  Created by jaydeep vadalia on 21/07/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase

class ServicesorWorkersCell: UITableViewCell {
    @IBOutlet weak var colServicesorWorkers: UICollectionView!
    @IBOutlet weak var lblService: UILabel!
    @IBOutlet weak var btnViewAll: UIButton!
    var arrayJobs:[JobStructure] = [JobStructure]()
    var homeVC: HomeVC!
    override func awakeFromNib() {
        super.awakeFromNib()
        colServicesorWorkers.register(UINib(nibName: "colServicesorWorkersCell", bundle: nil), forCellWithReuseIdentifier: "colServicesorWorkersCell")
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
        colServicesorWorkers.delegate = dataSourceDelegate
        colServicesorWorkers.dataSource = dataSourceDelegate
        colServicesorWorkers.tag = row
        colServicesorWorkers.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        get {
            return colServicesorWorkers.contentOffset.x
        }set {
            colServicesorWorkers.contentOffset.x = newValue
        }
    }
}

extension ServicesorWorkersCell: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayJobs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "colServicesorWorkersCell", for: indexPath) as! colServicesorWorkersCell
        myCell.backgroundColor = .clear
        if collectionView.tag != 0 {
            myCell.imgService.layer.cornerRadius = 20
            myCell.vwMain.layer.cornerRadius = 20
            myCell.btnFav.isHidden = true
            myCell.imgHCons.constant = 143
            //myCell.vwLCons.constant = 10.0
            //myCell.vwRCons.constant = 10.0
        }else{
            myCell.imgService.layer.cornerRadius = 20
            myCell.vwMain.layer.cornerRadius = 20
            myCell.btnFav.isHidden = false
            myCell.imgHCons.constant = 135
        }
        myCell.imgService.sd_setImage(with: URL(string: self.arrayJobs[indexPath.item].imagePost!), placeholderImage: nil, options: .retryFailed, completed: nil)
        myCell.lblServiceName.text = self.arrayJobs[indexPath.item].titleOfPost!
        
        //            myCell.lblRat.text = "\(allJobsByCategory[indexPath.section][indexPath.row])"
        
        if self.arrayJobs[indexPath.item].typeOfPrice == "Hourly" {
            myCell.lblPrice.text = "$\(self.arrayJobs[indexPath.item].price!) / Hour"
        } else {
            myCell.lblPrice.text = "$\(self.arrayJobs[indexPath.item].price!)"
        }
        
        myCell.btnFav.addAction(for: .touchUpInside) {
            print("Fav")
        }
        return myCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let controller = CommonUtils.getStoryboardVC(StoryBoard.Home.rawValue, vcIdetifier: ViewPostVC.className) as? ViewPostVC {
            controller.hidesBottomBarWhenPushed = true
            
            let Jobs = self.arrayJobs[indexPath.item]
            controller.postImage2.loadImageUsingCacheWithUrlString(Jobs.imagePost!)
            controller.postImageDownlodUrl = Jobs.imagePost!
            controller.postTitle = Jobs.titleOfPost!
            controller.postDescription = Jobs.descriptionOfPost!
            controller.postPrice = Jobs.price!
            controller.userUID = Jobs.authorName!
            controller.category = Jobs.category!
            controller.authorId = Jobs.authorName!
            controller.postId = Jobs.postId!
            controller.type = Jobs.typeOfPrice!
            self.homeVC.navigationController?.pushViewController(controller, animated: true)
            /*Database.database().reference().child("Users").child(Jobs.authorName!).child("profile-image").observe(.value) { (snapshot) in
                if let profileImageUrl : String = (snapshot.value as? String) {
//                        controller.imgProfile.sd_setImage(with: URL(string: profileImageUrl), completed: nil)
                    
                }
            }*/
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag != 0 {
            let vwWidth = UIScreen.main.bounds.width / 1.4
            return CGSize(width: vwWidth, height: 259)
        } else {
            let vwWidth = UIScreen.main.bounds.width / 1.2
            return CGSize(width: vwWidth, height: 267)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
}
