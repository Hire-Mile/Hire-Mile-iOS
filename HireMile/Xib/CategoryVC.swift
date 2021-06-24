//
//  CategoryVC.swift
//  HireMile
//
//  Created by mac on 16/06/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit

class CategoryVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var colCategory: UICollectionView!
    
    let imageArray = ["auto-sq", "scissor-sq", "carperter-sq", "clean-sq", "moving-sq", "hair-sq", "NAIL", "phone-sq", "towing-sq", "other-sq"]
    
    let titles = ["Auto", "Barber", "Carpentry", "Cleaning", "Moving", "Salon", "Beauty", "Technology", "Towing", "Other"]
    
    var CategoryData : ((_ name : String, _ imgName : String)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.colCategory.register(UINib(nibName: "CategorysCell", bundle: nil), forCellWithReuseIdentifier: "CategorysCell")
        // Do any additional setup after loading the view.
    }

        @IBAction func btnClose(_ sender: Any) {
            dismiss(animated: true, completion: nil)
        }
        

        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.titles.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategorysCell", for: indexPath) as! CategorysCell
            cell.lblTitle.text = self.titles[indexPath.row]
            cell.imgCategory.image = UIImage(named: self.imageArray[indexPath.row])
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            if (CategoryData != nil){
                CategoryData!(self.titles[indexPath.row], self.imageArray[indexPath.row])
                self.dismiss(animated: false, completion: nil)
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
