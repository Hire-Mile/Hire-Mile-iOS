//
//  SwipingController.swift
//  HireMile
//
//  Created by JJ Zapata on 11/15/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import Foundation
import UIKit

class SwipingController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let imageNames = ["hello", "hello", "hello"]
    let backdropNames = ["backdrop", "backdrop1", "backdrop2"]
    let headerString = ["With HIREMILE you will be able to generate extra income to your usual job, make your best skills known to your neighbors.", "Search among the best workers near your neighborhood, for any task or project that you need to perform quickly and efficiently.", "You will be able to qualify workers with audios, emojis, or photos, thus you will help us that the excellence in our community increases. "]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.isPagingEnabled = true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageNames.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PageCell
        cell.backdrop.image = UIImage(named: backdropNames[indexPath.row])
        cell.largeImageView.image = UIImage(named: imageNames[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
}
