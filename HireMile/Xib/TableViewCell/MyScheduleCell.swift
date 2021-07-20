//
//  MyScheduleCell.swift
//  HireMile
//
//  Created by mac on 10/07/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit

class MyScheduleCell: UITableViewCell {

    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTime1: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var vwLeft: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
