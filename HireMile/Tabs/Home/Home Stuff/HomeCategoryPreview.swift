//
//  HomeCategoryPreview.swift
//  HireMile
//
//  Created by JJ Zapata on 4/8/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit

class HomeCategoryPreview: UIView {
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "hi"
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
