//
//  CashOutLauncher.swift
//  HireMile
//
//  Created by JJ Zapata on 11/28/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit

class CashOutLauncher: NSObject {
    
    let height : CGFloat = 500
    
    let blackView = UIView()
    
    let filterView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 30
        return view
    }()
    
    let applyButton : UIButton = {
        let button = UIButton()
        button.setTitle("Cash Out", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.mainBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 25
        return button
    }()
    
    let middleView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let exitButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.imageView?.tintColor = UIColor.black
        button.tintColor = UIColor.black
        return button
    }()
    
    let availableCashLabel : UILabel = {
        let label = UILabel()
        label.text = "Available Cash"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let currency : UILabel = {
        let label = UILabel()
        label.text = "USD"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let amount : UILabel = {
        let label = UILabel()
        label.text = "$500.00"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 45)
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        
        filterView.addSubview(exitButton)
        self.exitButton.rightAnchor.constraint(equalTo: self.filterView.rightAnchor, constant: -30).isActive = true
        self.exitButton.topAnchor.constraint(equalTo: self.filterView.topAnchor, constant: 30).isActive = true
        self.exitButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.exitButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        filterView.addSubview(middleView)
        self.middleView.centerYAnchor.constraint(equalTo: self.filterView.centerYAnchor, constant: -50).isActive = true
        self.middleView.centerXAnchor.constraint(equalTo: self.filterView.centerXAnchor).isActive = true
        self.middleView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        self.middleView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        middleView.addSubview(availableCashLabel)
        self.availableCashLabel.leftAnchor.constraint(equalTo: self.middleView.leftAnchor).isActive = true
        self.availableCashLabel.rightAnchor.constraint(equalTo: self.middleView.rightAnchor).isActive = true
        self.availableCashLabel.topAnchor.constraint(equalTo: self.middleView.topAnchor).isActive = true
        self.availableCashLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        middleView.addSubview(currency)
        self.currency.leftAnchor.constraint(equalTo: self.middleView.leftAnchor).isActive = true
        self.currency.rightAnchor.constraint(equalTo: self.middleView.rightAnchor).isActive = true
        self.currency.bottomAnchor.constraint(equalTo: self.middleView.bottomAnchor).isActive = true
        self.currency.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        middleView.addSubview(amount)
        self.amount.leftAnchor.constraint(equalTo: self.middleView.leftAnchor).isActive = true
        self.amount.rightAnchor.constraint(equalTo: self.middleView.rightAnchor).isActive = true
        self.amount.bottomAnchor.constraint(equalTo: self.middleView.bottomAnchor).isActive = true
        self.amount.topAnchor.constraint(equalTo: self.middleView.topAnchor).isActive = true
    }
    
    func showAlert() {
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
        GlobalVariables.isCheckedOut = true
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.filterView.frame = CGRect(x: 0, y: window.frame.height, width: self.filterView.frame.width, height: self.filterView.frame.height)
            }
        }
    }
}
