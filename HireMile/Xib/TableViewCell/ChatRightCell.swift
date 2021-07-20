//
//  ChatRightCell.swift
//  HireMile
//
//  Created by mac on 12/07/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit

class ChatRightCell: UITableViewCell {

    @IBOutlet weak var lblFileName: UILabel!
    @IBOutlet weak var lblChat: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgFileType: UIImageView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var topSatck: UIStackView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
