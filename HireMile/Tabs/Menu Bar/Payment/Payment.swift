//
//  Payment.swift
//  HireMile
//
//  Created by JJ Zapata on 11/26/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit

class Payment: UIViewController {
    
    let cash : UILabel = {
        let label = UILabel()
        label.text = "Available cash"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = NSTextAlignment.left
        label.numberOfLines = 1
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cashNumber : UILabel = {
        let label = UILabel()
        label.text = "$500.00"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = NSTextAlignment.right
        label.numberOfLines = 1
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bottomView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 236/255, green: 237/255, blue: 238/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let addCardView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 7
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 20
        view.layer.shadowOpacity = 0.1
        return view
    }()
    
    let cardImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "creditcard.fill")
        imageView.tintColor = UIColor.mainBlue
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let addLabel : UILabel = {
        let label = UILabel()
        label.text = "Add Debit or Credit Card"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = NSTextAlignment.left
        label.numberOfLines = 1
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addButton : UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 242/255, green: 243/255, blue: 244/255, alpha: 1)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = UIColor.black
        return button
    }()
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
 
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.allowsSelection = true
//        tableView.register(MyReviewsCell.self, forCellReuseIdentifier: "reviewsCellID")
 
        // Do any additional setup after loading the view.
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
 
        // Functions to throw
        self.basicSetup()
    }
 
    func basicSetup() {
        self.view.backgroundColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = "Payment"
        self.navigationController?.navigationBar.tintColor = UIColor.mainBlue
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 247/255, green: 248/255, blue: 248/255, alpha: 1)
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .bottom, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        
        self.view.addSubview(cash)
        self.cash.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        self.cash.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        self.cash.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        self.cash.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        self.view.addSubview(cashNumber)
        self.cashNumber.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        self.cashNumber.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        self.cashNumber.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        self.cashNumber.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        self.view.addSubview(bottomView)
        self.bottomView.topAnchor.constraint(equalTo: self.cashNumber.bottomAnchor, constant: 20).isActive = true
        self.bottomView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        self.bottomView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -15).isActive = true
        self.bottomView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.view.addSubview(addCardView)
        self.addCardView.topAnchor.constraint(equalTo: self.bottomView.bottomAnchor, constant: 25).isActive = true
        self.addCardView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        self.addCardView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        self.addCardView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.addCardView.addSubview(cardImage)
        self.cardImage.topAnchor.constraint(equalTo: self.addCardView.topAnchor, constant: 10).isActive = true
        self.cardImage.leftAnchor.constraint(equalTo: self.addCardView.leftAnchor, constant: 10).isActive = true
        self.cardImage.bottomAnchor.constraint(equalTo: self.addCardView.bottomAnchor, constant: -10).isActive = true
        self.cardImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.addCardView.addSubview(addButton)
        self.addButton.topAnchor.constraint(equalTo: self.addCardView.topAnchor, constant: 10).isActive = true
        self.addButton.rightAnchor.constraint(equalTo: self.addCardView.rightAnchor, constant: -10).isActive = true
        self.addButton.bottomAnchor.constraint(equalTo: self.addCardView.bottomAnchor, constant: -10).isActive = true
        self.addButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.addCardView.addSubview(addLabel)
        self.addLabel.topAnchor.constraint(equalTo: self.addCardView.topAnchor, constant: 10).isActive = true
        self.addLabel.rightAnchor.constraint(equalTo: self.addButton.leftAnchor, constant: -10).isActive = true
        self.addLabel.bottomAnchor.constraint(equalTo: self.addCardView.bottomAnchor, constant: -10).isActive = true
        self.addLabel.leftAnchor.constraint(equalTo: self.cardImage.rightAnchor, constant: 10).isActive = true
 
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
//        self.tableView.allowsSelection = true
 
    }

}
