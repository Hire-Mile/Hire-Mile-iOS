//
//  ProposalPopup.swift
//  HireMile
//
//  Created by JJ Zapata on 2/2/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import Foundation
import UIKit

class ProposalPopup: NSObject {
    
    let height : CGFloat = 400

    let blackView = UIView()

    let filterView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 30
        return view
    }()

    let applyButton : MainButton = {
        let button = MainButton(title: "Okay")
        return button
    }()

    let filterTitle : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Message Sent!"
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 1
        return label
    }()

    let filterImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "message-sent")
        imageView.layer.cornerRadius = 37.5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init() {
        super.init()

        // start working here :)
    }

    func doStuff() {

        filterView.addSubview(applyButton)
        self.applyButton.leftAnchor.constraint(equalTo: self.filterView.leftAnchor, constant: 30).isActive = true
        self.applyButton.rightAnchor.constraint(equalTo: self.filterView.rightAnchor, constant: -30).isActive = true
        self.applyButton.bottomAnchor.constraint(equalTo: self.filterView.bottomAnchor, constant: -50).isActive = true
        self.applyButton.heightAnchor.constraint(equalToConstant: 45).isActive = true

        filterView.addSubview(filterTitle)
        self.filterTitle.leftAnchor.constraint(equalTo: self.filterView.leftAnchor, constant: 30).isActive = true
        self.filterTitle.rightAnchor.constraint(equalTo: self.filterView.rightAnchor, constant: -30).isActive = true
        self.filterTitle.bottomAnchor.constraint(equalTo: self.applyButton.topAnchor, constant: -25).isActive = true
        self.filterTitle.heightAnchor.constraint(equalToConstant: 80).isActive = true

        filterView.addSubview(filterImage)
        self.filterImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.filterImage.centerXAnchor.constraint(equalTo: self.filterView.centerXAnchor).isActive = true
        self.filterImage.bottomAnchor.constraint(equalTo: self.filterTitle.topAnchor, constant: -25).isActive = true
        self.filterImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }

    func showFilter() {
        if let window = UIApplication.shared.keyWindow {
            blackView.frame = window.frame
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.alpha = 0
            window.addSubview(blackView)
            window.addSubview(filterView)

            let y = window.frame.height - height
            filterView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.blackView.alpha = 1
                self.filterView.frame = CGRect(x: 0, y: y, width: self.filterView.frame.width, height: self.filterView.frame.height)
            }) { (completion) in
                print("showing view")
                self.doStuff()
            }
        }
    }

    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.filterView.frame = CGRect(x: 0, y: window.frame.height, width: self.filterView.frame.width, height: self.filterView.frame.height)
            }
        }
    }
    
}
