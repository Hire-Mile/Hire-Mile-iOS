//
//  CashInAlert.swift
//  HireMile
//
//  Created by JJ Zapata on 12/7/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit

class CashInAlert: NSObject {
    
    let height : CGFloat = 400
    
    let blackView = UIView()
    
    let filterView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 30
        return view
    }()
    
    let applyButton : UIButton = {
        let button = UIButton()
        button.setTitle("APPLY", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.mainBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 25
        return button
    }()
    
    let slider2 : CustomSlider = {
        let slider = CustomSlider()
        slider.thumbTintColor = UIColor.mainBlue
        slider.value = 0.5
        slider.minimumTrackTintColor = UIColor(red: 11/255, green: 113/255, blue: 213/255, alpha: 1)
        slider.maximumTrackTintColor = UIColor(red: 232/255, green: 229/255, blue: 229/255, alpha: 1)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.trackRect(forBounds: CGRect(x: 0, y: 0, width: 10, height: 10))
        return slider
    }()
    
    let bySalesLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "By sales"
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 1
        return label
    }()
    
    let slider1 : CustomSlider = {
        let slider = CustomSlider()
        slider.thumbTintColor = UIColor.mainBlue
        slider.value = 0.5
        slider.minimumTrackTintColor = UIColor(red: 11/255, green: 113/255, blue: 213/255, alpha: 1)
        slider.maximumTrackTintColor = UIColor(red: 232/255, green: 229/255, blue: 229/255, alpha: 1)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.trackRect(forBounds: CGRect(x: 0, y: 0, width: 10, height: 10))
        return slider
    }()
    
    let byDistanceLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "By distance"
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 1
        return label
    }()
    
    let filterTitle : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Filter"
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 1
        return label
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
        self.applyButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        self.exitButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
        filterView.addSubview(applyButton)
        self.applyButton.leftAnchor.constraint(equalTo: self.filterView.leftAnchor, constant: 30).isActive = true
        self.applyButton.rightAnchor.constraint(equalTo: self.filterView.rightAnchor, constant: -30).isActive = true
        self.applyButton.bottomAnchor.constraint(equalTo: self.filterView.bottomAnchor, constant: -50).isActive = true
        self.applyButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        filterView.addSubview(slider2)
        self.slider2.leftAnchor.constraint(equalTo: self.filterView.leftAnchor, constant: 30).isActive = true
        self.slider2.rightAnchor.constraint(equalTo: self.filterView.rightAnchor, constant: -30).isActive = true
        self.slider2.bottomAnchor.constraint(equalTo: self.applyButton.topAnchor, constant: -40).isActive = true
        self.slider2.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        filterView.addSubview(bySalesLabel)
        self.bySalesLabel.leftAnchor.constraint(equalTo: self.filterView.leftAnchor, constant: 30).isActive = true
        self.bySalesLabel.rightAnchor.constraint(equalTo: self.filterView.rightAnchor, constant: -30).isActive = true
        self.bySalesLabel.bottomAnchor.constraint(equalTo: self.slider2.topAnchor, constant: -10).isActive = true
        self.bySalesLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        filterView.addSubview(slider1)
        self.slider1.leftAnchor.constraint(equalTo: self.filterView.leftAnchor, constant: 30).isActive = true
        self.slider1.rightAnchor.constraint(equalTo: self.filterView.rightAnchor, constant: -30).isActive = true
        self.slider1.bottomAnchor.constraint(equalTo: self.bySalesLabel.topAnchor, constant: 0).isActive = true
        self.slider1.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        filterView.addSubview(byDistanceLabel)
        self.byDistanceLabel.leftAnchor.constraint(equalTo: self.filterView.leftAnchor, constant: 30).isActive = true
        self.byDistanceLabel.rightAnchor.constraint(equalTo: self.filterView.rightAnchor, constant: -30).isActive = true
        self.byDistanceLabel.bottomAnchor.constraint(equalTo: self.slider1.topAnchor, constant: -10).isActive = true
        self.byDistanceLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        filterView.addSubview(filterTitle)
        self.filterTitle.leftAnchor.constraint(equalTo: self.filterView.leftAnchor, constant: 30).isActive = true
        self.filterTitle.rightAnchor.constraint(equalTo: self.filterView.rightAnchor, constant: -30).isActive = true
        self.filterTitle.bottomAnchor.constraint(equalTo: self.byDistanceLabel.topAnchor, constant: -25).isActive = true
        self.filterTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
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
            filterView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 400)
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
