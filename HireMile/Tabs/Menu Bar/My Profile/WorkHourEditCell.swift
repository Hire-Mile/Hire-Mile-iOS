//
//  WorkHourEditCell.swift
//  HireMile
//
//  Created by JJ Zapata on 3/13/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit

class WorkHourEditCell: UITableViewCell {
    
    let plusIcon : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "plus")
        imageView.tintColor = UIColor(red: 171/255, green: 169/255, blue: 169/255, alpha: 1)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        return imageView
    }()
    
    let bottomView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1)
        view.alpha = 0.24
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let checkBox : CheckBox = {
        let checkbox = CheckBox()
        checkbox.style = .tick
        checkbox.borderStyle = .roundedSquare(radius: 3)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        return checkbox
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        addSubview(plusIcon)
        plusIcon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        plusIcon.widthAnchor.constraint(equalToConstant: 16).isActive = true
        plusIcon.heightAnchor.constraint(equalToConstant: 16).isActive = true
        plusIcon.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        addSubview(bottomView)
        bottomView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        bottomView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        addSubview(checkBox)
        checkBox.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        checkBox.widthAnchor.constraint(equalToConstant: 16).isActive = true
        checkBox.heightAnchor.constraint(equalToConstant: 16).isActive = true
        checkBox.leftAnchor.constraint(equalTo: leftAnchor).isActive = true

        // Configure the view for the selected state
    }

}
