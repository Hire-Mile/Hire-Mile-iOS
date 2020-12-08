//
//  MyJobs.swift
//  HireMile
//
//  Created by JJ Zapata on 11/28/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit

class MyJobs: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let segmentedControl : UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.insertSegment(withTitle: "Running", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Completed", at: 1, animated: true)
        segmentedControl.insertSegment(withTitle: "Canceled", at: 2, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = UIColor.white
        segmentedControl.setBackgroundImage(UIImage(named: "whiteback"), for: .normal, barMetrics: .default)
        segmentedControl.setDividerImage(UIImage(named: "whiteback"), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .compact)
        segmentedControl.tintColor = UIColor.clear
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1)], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    let buttonBar : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.mainBlue
        return view
    }()
    
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.white
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
    
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MyJobsRunningCell.self, forCellReuseIdentifier: "myJobsCellID")
        tableView.register(MyJobsCompletedgCell.self, forCellReuseIdentifier: "myJobsCompletedCellID")
        tableView.register(MyJobsCanceledCell.self, forCellReuseIdentifier: "myJobsCabcekkedCellID")
    
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
        self.navigationController?.navigationBar.topItem?.title = "My Jobs"
        self.navigationController?.navigationBar.tintColor = UIColor.mainBlue
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 247/255, green: 248/255, blue: 248/255, alpha: 1)
    
        self.view.addSubview(segmentedControl)
        self.segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.segmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.segmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(buttonBar)
        self.buttonBar.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor).isActive = true
        self.buttonBar.leftAnchor.constraint(equalTo: self.segmentedControl.leftAnchor).isActive = true
        self.buttonBar.heightAnchor.constraint(equalToConstant: 3).isActive = true
        self.buttonBar.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1 / CGFloat(segmentedControl.numberOfSegments)).isActive = true
        
        self.view.addSubview(tableView)
        self.tableView.topAnchor.constraint(equalTo: self.buttonBar.bottomAnchor).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    @objc func segmentedControlValueChanged(_ semder: UISegmentedControl) {
        UIView.animate(withDuration: 0.3) {
            print(self.segmentedControl.numberOfSegments)
            print(self.segmentedControl.selectedSegmentIndex)
            self.buttonBar.frame.origin.x = (self.segmentedControl.frame.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
            self.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return 3
        } else if segmentedControl.selectedSegmentIndex == 1 {
            return 1
        } else if segmentedControl.selectedSegmentIndex == 2 {
            return 2
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentedControl.selectedSegmentIndex == 0 {
            print("end job prompt")
        } else if segmentedControl.selectedSegmentIndex == 1 {
            print("nothing")
        } else if segmentedControl.selectedSegmentIndex == 2 {
            print("nothing")
        } else {
            print("shouldnt be printed :)")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segmentedControl.selectedSegmentIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myJobsCellID", for: indexPath) as! MyJobsRunningCell
//            cell.profileImageView.image = UIImage(named: "profilepic")
            return cell
        } else if segmentedControl.selectedSegmentIndex == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myJobsCompletedCellID", for: indexPath) as! MyJobsCompletedgCell
//            cell.profileImageView.backgroundColor = .green
//            cell.profileImageView.image = UIImage(named: "profilepic")
            cell.selectionStyle = .none
            return cell
        } else if segmentedControl.selectedSegmentIndex == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myJobsCabcekkedCellID", for: indexPath) as! MyJobsCanceledCell
//            cell.profileImageView.image = UIImage(named: "profilepic")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myJobsCellID", for: indexPath) as! MyJobsRunningCell
            cell.textLabel?.text = "Cell Running"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if segmentedControl.selectedSegmentIndex == 0 {
            return 185
        } else if segmentedControl.selectedSegmentIndex == 1 {
            return 135
        } else if segmentedControl.selectedSegmentIndex == 2 {
            return 125
        } else {
            return 0
        }
    }
    
}

class MyJobsRunningCell: UITableViewCell {
            
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 75, y: textLabel!.frame.origin.y, width: textLabel!.frame.width,height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 75, y: detailTextLabel!.frame.origin.y - 2, width:detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 30
        imageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
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
    
    let reviewLabel : UILabel = {
        let label = UILabel()
        label.text = "Job Title\n Price"
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
//        label.text = "24 Feb. 2018"
        label.text = "Date"
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.darkGray
        label.textAlignment = NSTextAlignment.right
        return label
    }()
    
    let endJobView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 17.5
        view.layer.borderColor = UIColor.mainBlue.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    let endJobLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "End Job"
        label.textColor = UIColor.mainBlue
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 1
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubview(profileImageView)
        addSubview(userNameLabel)
        addSubview(reviewLabel)
        addSubview(postImageView)
        addSubview(priceDateLabel)
        addSubview(endJobView)
        addSubview(endJobLabel)
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        userNameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant:16).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        userNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 16).isActive = true
        userNameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        reviewLabel.leftAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: 16).isActive = true
        reviewLabel.topAnchor.constraint(equalTo: self.userNameLabel.bottomAnchor).isActive = true
        reviewLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        reviewLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        postImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        postImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        postImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        postImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        
        priceDateLabel.widthAnchor.constraint(equalToConstant: 115).isActive = true
        priceDateLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        priceDateLabel.bottomAnchor.constraint(equalTo: self.postImageView.topAnchor, constant: -5).isActive = true
        priceDateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        
        endJobView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        endJobView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        endJobView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        endJobView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        endJobLabel.leftAnchor.constraint(equalTo: endJobView.leftAnchor).isActive = true
        endJobLabel.topAnchor.constraint(equalTo: endJobView.topAnchor).isActive = true
        endJobLabel.rightAnchor.constraint(equalTo: endJobView.rightAnchor).isActive = true
        endJobLabel.bottomAnchor.constraint(equalTo: endJobView.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MyJobsCompletedgCell: UITableViewCell {
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
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
//        label.text = "He's a laborius worker, finished everytime, and recommend him to all"
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
//        label.text = "$30, 24 Feb. 2018"
        label.text = "Date"
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.darkGray
        label.textAlignment = NSTextAlignment.right
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
//
//        //ios 9 constraint anchors
//        //need x,y,width,height anchors
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
}

class MyJobsCanceledCell: UITableViewCell {
            
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 75, y: textLabel!.frame.origin.y, width: textLabel!.frame.width,height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 75, y: detailTextLabel!.frame.origin.y - 2, width:detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
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
    
    let reviewLabel : UILabel = {
        let label = UILabel()
        label.text = "Job Title\nReasoning"
        label.numberOfLines = 3
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let postImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let priceDateLabel : UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.darkGray
        label.textAlignment = NSTextAlignment.right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubview(profileImageView)
        addSubview(userNameLabel)
        addSubview(reviewLabel)
        addSubview(postImageView)
        addSubview(priceDateLabel)
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        userNameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant:16).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        userNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 16).isActive = true
        userNameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        reviewLabel.leftAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: 16).isActive = true
        reviewLabel.topAnchor.constraint(equalTo: self.userNameLabel.bottomAnchor).isActive = true
        reviewLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        reviewLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        postImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        postImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        postImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
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
