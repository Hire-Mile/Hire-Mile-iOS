//
//  SearchController.swift
//  HireMile
//
//  Created by JJ Zapata on 12/1/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SearchController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let results = ["Web Design", "Car Rental", "App Design", "IT"   ]
    var users = [UserStructure]()
    var allJobs = [JobStructure]()
    var justRes = [JobStructure]()
    var isSearching = true
    
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
        
        self.searchTextField.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
        
        self.view.backgroundColor = UIColor.white
        
        self.searchTextField.delegate = self
        self.searchTextField.becomeFirstResponder()
        
        self.tableView.register(CategoryCell.self, forCellReuseIdentifier: "mySearchCell")
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
        
        self.pullData()

        // Do any additional setup after loading the view.
    }
    
    func pullData() {
        self.allJobs.removeAll()
        Database.database().reference().child("Jobs").observe(.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                let job = JobStructure()
                job.authorName = value["author"] as? String ?? "Error"
                job.titleOfPost = value["title"] as? String ?? "Error"
                job.descriptionOfPost = value["description"] as? String ?? "Error"
                job.price = value["price"] as? Int ?? 0
                job.category = value["category"] as? String ?? "Error"
                job.imagePost = value["image"] as? String ?? "Error"
                job.typeOfPrice = value["type-of-price"] as? String ?? "Error"
                job.postId = value["postId"] as? String ?? "Error"
                self.allJobs.append(job)
            }
            self.allJobs.reverse()
            self.tableView.reloadData()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.isSearching = false
        self.tableView.reloadData()
        textField.resignFirstResponder()
        self.view.frame.origin.y = 0
        return (true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isSearching = false
        self.tableView.reloadData()
        self.view.frame.origin.y = 0
        self.view.endEditing(true)
    }
    
    @objc func xmarktouched () {
        self.isSearching = false
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldChange() {
        
        self.justRes = self.allJobs.filter({$0.titleOfPost!.prefix(self.searchTextField.text!.count).contains(self.searchTextField.text!)})
        
        self.isSearching = true
        self.tableView.reloadData()
        
        // implment search function for sorting here
        
        print("info")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSearching {
            return self.justRes.count
        } else {
            return self.allJobs.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.isSearching {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mySearchCell", for: indexPath) as! CategoryCell
            cell.titleImageView.loadImageUsingCacheWithUrlString(self.justRes[indexPath.row].imagePost!)
            cell.titleLabel.text = self.justRes[indexPath.row].titleOfPost!
            cell.postId = self.justRes[indexPath.row].postId!
            if self.justRes[indexPath.row].typeOfPrice == "Hourly" {
                cell.priceTag.text = "$\(self.justRes[indexPath.row].price!) / Hour"
            } else {
                cell.priceTag.text = "$\(self.justRes[indexPath.row].price!)"
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mySearchCell", for: indexPath) as! CategoryCell
            cell.titleImageView.loadImageUsingCacheWithUrlString(self.allJobs[indexPath.row].imagePost!)
            cell.titleLabel.text = self.allJobs[indexPath.row].titleOfPost!
            cell.postId = self.allJobs[indexPath.row].postId!
            if self.allJobs[indexPath.row].typeOfPrice == "Hourly" {
                cell.priceTag.text = "$\(self.allJobs[indexPath.row].price!) / Hour"
            } else {
                cell.priceTag.text = "$\(self.allJobs[indexPath.row].price!)"
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isSearching {
            self.dismiss(animated: true) {
                GlobalVariables.catId = self.justRes[indexPath.row]
                GlobalVariables.presentToCat = true
            }
        } else {
            self.dismiss(animated: true) {
                GlobalVariables.catId = self.allJobs[indexPath.row]
                GlobalVariables.presentToCat = true
            }
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
