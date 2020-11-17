//
//  Home.swift
//  HireMile
//
//  Created by JJ Zapata on 11/16/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit

class Home: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let searchButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.layer.cornerRadius = 20
        button.tintColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1)
        return button
    }()
    
    let menuButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        button.tintColor = UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 1)
        return button
    }()
    
    
    let tableView : UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.separatorStyle = .none
        tableview.register(HomeCell.self, forCellReuseIdentifier: "homeTableViewId")
        tableview.backgroundColor = UIColor.red
        return tableview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Functions to throw
        self.addSubviews()
        self.addConstraints()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Functions to throw
        self.basicSetup()
    }
    
    func addSubviews() {
        self.view.addSubview(searchButton)
        self.view.addSubview(menuButton)
        self.view.addSubview(tableView)
    }
    
    func addConstraints() {
        self.searchButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        self.searchButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.searchButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.searchButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.menuButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        self.menuButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.menuButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.menuButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.tableView.topAnchor.constraint(equalTo: self.menuButton.bottomAnchor, constant: 10).isActive = true
        self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }
    
    func basicSetup() {
        self.view.backgroundColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = true
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return (true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableViewId", for: indexPath) as! HomeCell
        cell.backgroundColor = UIColor.green
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Hello, this needs to be complete :) ")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }

}

class HomeCell: UITableViewCell {
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Nearby Services"
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let seeAllButton : UIButton = {
        let button = UIButton()
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    func setup() {
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, paddingTop: 0, bottom: bottomAnchor, paddingBottom: -140, left: leftAnchor, paddingLeft: 0, right: rightAnchor, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

