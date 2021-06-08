//
//  ProfileReviewTableViewCell.swift
//  HireMile
//
//  Created by jaydeep vadalia on 06/06/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit
import Cosmos
class ProfileReviewTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileImageView1: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
