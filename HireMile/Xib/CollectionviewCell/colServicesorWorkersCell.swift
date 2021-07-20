//
//  colServicesorWorkersCell.swift
//  HireMile
//
//  Created by mac on 11/07/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit

class colServicesorWorkersCell: UICollectionViewCell {

    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblRat: UILabel!
    @IBOutlet weak var imgService: UIImageView!
    @IBOutlet weak var btnFav: UIButton!
    @IBOutlet weak var vwMain: UIView!
    
    @IBOutlet weak var vwLCons: NSLayoutConstraint!
    @IBOutlet weak var imgHCons: NSLayoutConstraint!
    
    @IBOutlet weak var vwRCons: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
