//
//  DeleteLauncher.swift
//  HireMile
//
//  Created by JJ Zapata on 1/25/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import Foundation
import UIKit

class DeleteLauncher: NSObject {

    let height : CGFloat = 500

    let blackView = UIView()

    let filterView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 30
        return view
    }()
    
    let stopJob : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete Service", for: .normal)
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    let completeJob : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Keep Service", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.mainBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 25
        return button
    }()

    let filterTitle : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Delete Service?"
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 1
        return label
    }()

    let filterDescription : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Are you sure you want to remove your service? Experience and ratings will not be available to others"
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 3
        return label
    }()

    let filterImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "delete")
        imageView.layer.cornerRadius = 37.5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let exitButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.imageView?.tintColor = UIColor.black
        button.tintColor = UIColor.black
        return button
    }()

    override init() {
        super.init()

        // start working here :)
    }

    func doStuff() {
        self.exitButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        self.completeJob.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
        filterView.addSubview(stopJob)
        self.stopJob.leftAnchor.constraint(equalTo: self.filterView.leftAnchor, constant: 30).isActive = true
        self.stopJob.rightAnchor.constraint(equalTo: self.filterView.rightAnchor, constant: -30).isActive = true
        self.stopJob.bottomAnchor.constraint(equalTo: self.filterView.bottomAnchor, constant: -50).isActive = true
        self.stopJob.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        filterView.addSubview(completeJob)
        self.completeJob.leftAnchor.constraint(equalTo: self.filterView.leftAnchor, constant: 30).isActive = true
        self.completeJob.rightAnchor.constraint(equalTo: self.filterView.rightAnchor, constant: -30).isActive = true
        self.completeJob.bottomAnchor.constraint(equalTo: self.stopJob.topAnchor, constant: -15).isActive = true
        self.completeJob.heightAnchor.constraint(equalToConstant: 50).isActive = true

        filterView.addSubview(filterDescription)
        self.filterDescription.leftAnchor.constraint(equalTo: self.filterView.leftAnchor, constant: 60).isActive = true
        self.filterDescription.rightAnchor.constraint(equalTo: self.filterView.rightAnchor, constant: -60).isActive = true
        self.filterDescription.bottomAnchor.constraint(equalTo: self.completeJob.topAnchor, constant: -25).isActive = true
        self.filterDescription.heightAnchor.constraint(equalToConstant: 60).isActive = true

        filterView.addSubview(filterTitle)
        self.filterTitle.leftAnchor.constraint(equalTo: self.filterView.leftAnchor, constant: 30).isActive = true
        self.filterTitle.rightAnchor.constraint(equalTo: self.filterView.rightAnchor, constant: -30).isActive = true
        self.filterTitle.bottomAnchor.constraint(equalTo: self.filterDescription.topAnchor, constant: -25).isActive = true
        self.filterTitle.heightAnchor.constraint(equalToConstant: 25).isActive = true

        filterView.addSubview(filterImage)
        self.filterImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.filterImage.centerXAnchor.constraint(equalTo: self.filterView.centerXAnchor).isActive = true
        self.filterImage.bottomAnchor.constraint(equalTo: self.filterTitle.topAnchor, constant: -25).isActive = true
        self.filterImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        filterView.addSubview(exitButton)
        self.exitButton.rightAnchor.constraint(equalTo: self.filterView.rightAnchor, constant: -30).isActive = true
        self.exitButton.topAnchor.constraint(equalTo: self.filterView.topAnchor, constant: 30).isActive = true
        self.exitButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.exitButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
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
            filterView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 500)
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
