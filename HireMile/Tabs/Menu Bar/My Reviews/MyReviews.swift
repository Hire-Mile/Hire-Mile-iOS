//
//  MyReviews.swift
//  HireMile
//
//  Created by JJ Zapata on 11/25/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit

class MyReviews: UITableViewController {
        
    private let refrshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.black
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        return refreshControl
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.register(MyReviewsCell.self, forCellReuseIdentifier: "reviewsCellID")
    
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
        self.navigationController?.navigationBar.topItem?.title = "My Reviews"
        self.navigationController?.navigationBar.tintColor = UIColor.mainBlue
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 247/255, green: 248/255, blue: 248/255, alpha: 1)
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .bottom, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = nil
 
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = true
        self.tableView.refreshControl = refrshControl
    
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewsCellID", for: indexPath) as! MyReviewsCell
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    
    @objc func refreshAction() {
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(hideRefrsh), userInfo: nil, repeats: false)
    }
    
    @objc func hideRefrsh() {
        self.refrshControl.endRefreshing()
    }

}

class MyReviewsCell: UITableViewCell {
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 75, y: textLabel!.frame.origin.y, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 75, y: detailTextLabel!.frame.origin.y - 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let userNameLabel : UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    let star1 : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = UIColor.mainBlue
        return imageView
    }()
    
    let star2 : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = UIColor.mainBlue
        return imageView
    }()
    
    let star3 : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = UIColor.mainBlue
        return imageView
    }()
    
    let star4 : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = UIColor.mainBlue
        return imageView
    }()
    
    let star5 : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
        return imageView
    }()
    
    let reviewLabel : UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.numberOfLines = 3
        label.textColor = UIColor.darkGray
        label.textAlignment = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let postImageView : UIImageView = {
        let imageView = UIImageView()
//        imageView.image = UIImage(named: "working")
        imageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let priceDateLabel : UILabel = {
        let label = UILabel()
        label.text = "Price, Info"
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.darkGray
        label.textAlignment = NSTextAlignment.right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(userNameLabel)
        addSubview(star1)
        addSubview(star2)
        addSubview(star3)
        addSubview(star4)
        addSubview(star5)
        addSubview(reviewLabel)
        addSubview(postImageView)
        addSubview(priceDateLabel)
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        userNameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 16).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        userNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 16).isActive = true
        userNameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        star1.topAnchor.constraint(equalTo: self.userNameLabel.bottomAnchor, constant: 0).isActive = true
        star1.leftAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: 16).isActive = true
        star1.widthAnchor.constraint(equalToConstant: 20).isActive = true
        star1.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        star2.topAnchor.constraint(equalTo: self.userNameLabel.bottomAnchor, constant: 0).isActive = true
        star2.leftAnchor.constraint(equalTo: self.star1.rightAnchor, constant: 5).isActive = true
        star2.widthAnchor.constraint(equalToConstant: 20).isActive = true
        star2.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        star3.topAnchor.constraint(equalTo: self.userNameLabel.bottomAnchor, constant: 0).isActive = true
        star3.leftAnchor.constraint(equalTo: self.star2.rightAnchor, constant: 5).isActive = true
        star3.widthAnchor.constraint(equalToConstant: 20).isActive = true
        star3.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        star4.topAnchor.constraint(equalTo: self.userNameLabel.bottomAnchor, constant: 0).isActive = true
        star4.leftAnchor.constraint(equalTo: self.star3.rightAnchor, constant: 5).isActive = true
        star4.widthAnchor.constraint(equalToConstant: 20).isActive = true
        star4.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        star5.topAnchor.constraint(equalTo: self.userNameLabel.bottomAnchor, constant: 0).isActive = true
        star5.leftAnchor.constraint(equalTo: self.star4.rightAnchor, constant: 5).isActive = true
        star5.widthAnchor.constraint(equalToConstant: 20).isActive = true
        star5.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        reviewLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        reviewLabel.topAnchor.constraint(equalTo: self.star1.bottomAnchor, constant: 10).isActive = true
        reviewLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        reviewLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
        
        postImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        postImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        postImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 10).isActive = true
        postImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        
        priceDateLabel.widthAnchor.constraint(equalToConstant: 115).isActive = true
        priceDateLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        priceDateLabel.bottomAnchor.constraint(equalTo: self.postImageView.topAnchor, constant: -5).isActive = true
        priceDateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
