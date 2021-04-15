//
//  AllCategories.swift
//  HireMile
//
//  Created by JJ Zapata on 4/12/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit

class AllCategories: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let imageArray = ["auto-sq", "scissor-sq", "carperter-sq", "clean-sq", "moving-sq", "hair-sq", "NAIL", "phone-sq", "towing-sq", "other-sq"]
    
    let titles = ["Auto", "Barber", "Carpentry", "Cleaning", "Moving", "Salon", "Beauty", "Technology", "Towing", "Other"]
    
    var categoryCollectionView : UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Functions to throw
        addConstraints()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Functions to throw
        self.basicSetup()
    }

    func addConstraints() {
        
        let layou2: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layou2.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layou2.scrollDirection = .vertical
        self.categoryCollectionView = UICollectionView(frame: CGRect(x: 20, y: 20, width: self.view.frame.width - 40, height: 600), collectionViewLayout: layou2)
        self.categoryCollectionView!.alwaysBounceVertical = true
        self.categoryCollectionView!.alwaysBounceHorizontal = false
        self.categoryCollectionView!.dataSource = self
        self.categoryCollectionView!.backgroundColor = UIColor.white
        self.categoryCollectionView!.showsHorizontalScrollIndicator = false
        self.categoryCollectionView!.showsVerticalScrollIndicator = false
        self.categoryCollectionView!.delegate = self
        self.categoryCollectionView!.register(PostCategoryCell.self, forCellWithReuseIdentifier: "postCategoryId")
        self.view.addSubview(self.categoryCollectionView!)
    }

    func basicSetup() {
        self.view.backgroundColor = UIColor.white
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationItem.backButtonTitle = ""
        
        self.title = "Select a category"
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "whiteback"), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCategoryId", for: indexPath) as! PostCategoryCell
        cell.title.text = self.titles[indexPath.row]
        cell.imageView.image = UIImage(named: self.imageArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = CategoryPostController()
        controller.category = self.titles[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 115)
    }

}
