//
//  SearchController.swift
//  HireMile
//
//  Created by JJ Zapata on 12/1/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit

class SearchController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let results = ["Web Design", "Car Rental", "App Design", "IT"   ]
    
    let xButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(xmarktouched), for: .touchUpInside)
        return button
    }()
    
    let topView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 20
        return view
    }()
    
    let searchTextField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Search"
        tf.tintColor = UIColor.mainBlue
        tf.textColor = UIColor.black
        tf.textAlignment = NSTextAlignment.left
        tf.backgroundColor = UIColor.white
        tf.borderStyle = UITextField.BorderStyle.line
        tf.layer.borderColor = UIColor.white.cgColor
        tf.layer.borderWidth = 1
        tf.font = UIFont.systemFont(ofSize: 20)
        return tf
    }()
    
    let tableView : UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.separatorStyle = .none
        tableview.backgroundColor = UIColor.white
        return tableview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.searchTextField.delegate = self
        self.searchTextField.becomeFirstResponder()
        
        self.tableView.register(SearchCell.self, forCellReuseIdentifier: "mySearchCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.view.addSubview(topView)
        self.topView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.topView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        self.topView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        self.topView.heightAnchor.constraint(equalToConstant: 175).isActive = true
        
        self.view.addSubview(xButton)
        self.xButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.xButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        self.xButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        self.xButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        self.view.addSubview(searchTextField)
        self.searchTextField.topAnchor.constraint(equalTo: self.xButton.bottomAnchor, constant: -5).isActive = true
        self.searchTextField.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        self.searchTextField.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -15).isActive = true
        self.searchTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(tableView)
        self.tableView.topAnchor.constraint(equalTo: self.topView.bottomAnchor, constant: 25).isActive = true
        self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.frame.origin.y = 0
        return (true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.frame.origin.y = 0
        self.view.endEditing(true)
    }
    
    @objc func xmarktouched () {
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mySearchCell", for: indexPath) as! SearchCell
        cell.textLabel?.text = results[indexPath.row]
        cell.selectionStyle = .default
        cell.textLabel?.textColor = UIColor.darkGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            GlobalVariables.presentToCat = true
        }
    }

}

class SearchCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        //
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
