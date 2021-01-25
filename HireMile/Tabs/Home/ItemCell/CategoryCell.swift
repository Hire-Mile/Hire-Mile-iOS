//
//  CategoryCell.swift
//  HireMile
//
//  Created by JJ Zapata on 1/25/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit

class HomeCategoryCell: UICollectionViewCell {
    
    let title : UILabel = {
        let label = UILabel()
        label.text = "Hi"
        label.textColor = UIColor.darkGray
        label.numberOfLines = 2
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let circleView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 35
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = .white
        
        self.addSubview(title)
        self.title.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.title.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.title.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.title.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.addSubview(circleView)
        self.circleView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.circleView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10).isActive = true
        self.circleView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        self.circleView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.circleView.addSubview(imageView)
        self.imageView.centerXAnchor.constraint(equalTo: self.circleView.centerXAnchor).isActive = true
        self.imageView.centerYAnchor.constraint(equalTo: self.circleView.centerYAnchor).isActive = true
        self.imageView.widthAnchor.constraint(equalToConstant: 58).isActive = true
        self.imageView.heightAnchor.constraint(equalToConstant: 58).isActive = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
}
