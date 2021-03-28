//
//  Biometrics.swift
//  HireMile
//
//  Created by JJ Zapata on 3/16/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit

class Biometrics: UIViewController {
    
    let headerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mainBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let laterButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        button.setTitle("Later", for: .normal)
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 24
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.mainBlue.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(laterPressed), for: .touchUpInside)
        return button
    }()
    
    let configureButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.mainBlue
        button.setTitle("Configure", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 24
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(configurePressed), for: .touchUpInside)
        return button
    }()
    
    let informativeLabel : UILabel = {
        let label = UILabel()
        label.text = "Protect your account with biometrics by adding extra layer of security to your HireMile account"
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 5
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "biometrics-image.png")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Setup Biometrics"
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        navigationController?.navigationBar.isHidden = true
        
        updateConstraints()

        // Do any additional setup after loading the view.
    }
    
    func updateConstraints() {
        view.addSubview(headerView)
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        headerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: view.frame.size.height / 2.25).isActive = true
        
        headerView.addSubview(imageView)
        imageView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: -25).isActive = true
        imageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        
        view.addSubview(laterButton)
        laterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        laterButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        laterButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        laterButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        view.addSubview(configureButton)
        configureButton.bottomAnchor.constraint(equalTo: laterButton.topAnchor, constant: -13).isActive = true
        configureButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        configureButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        configureButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        view.addSubview(informativeLabel)
        informativeLabel.bottomAnchor.constraint(equalTo: configureButton.topAnchor).isActive = true
        informativeLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        informativeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        informativeLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        
        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: imageView.leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: imageView.rightAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    @objc func laterPressed() {
        UserDefaults.standard.setValue(false, forKey: "biometrics")
    }
    
    @objc func configurePressed() {
        UserDefaults.standard.setValue(true, forKey: "biometrics")
        let sb = UIStoryboard(name: "TabStoryboard", bundle: nil)
        let vc: UIViewController = sb.instantiateViewController(withIdentifier: "TabbControllerID") as! TabBarController
        UIApplication.shared.keyWindow?.rootViewController = vc
    }

}
