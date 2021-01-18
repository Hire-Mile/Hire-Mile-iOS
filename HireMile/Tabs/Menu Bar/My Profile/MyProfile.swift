//
//  MyProfile.swift
//  HireMile
//
//  Created by JJ Zapata on 12/1/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class MyProfile: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var allJobs = [JobStructure]()
    var myJobs = [JobStructure]()
    
    var finalRating = 0
    var ratingNumber = 0
    var findingRating = true
    var hires = 0
    
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        imageView.layer.cornerRadius = 37.5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let profileName : UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 1
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
    
    let seperaterView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return view
    }()
    
    let toolBarView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let secondImportantView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let thirdImportantView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let secondTitleLabel : UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.black
        return label
    }()
    
    let secondDescLabel : UILabel = {
        let label = UILabel()
        label.text = "Hires"
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let thirdTitleLabel : UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.black
        return label
    }()
    
    let thirdDescLabel : UILabel = {
        let label = UILabel()
        label.text = "Jobs"
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let seperaterView2 : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return view
    }()
    
    let myServices : UILabel = {
        let label = UILabel()
        label.text = "My Services"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 1
        return label
    }()
    
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        view.addSubview(profileName)
        profileName.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        profileName.leftAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: 10).isActive = true
        profileName.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        profileName.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        view.addSubview(star1)
        star1.topAnchor.constraint(equalTo: self.profileName.bottomAnchor, constant: 5).isActive = true
        star1.leftAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: 10).isActive = true
        star1.widthAnchor.constraint(equalToConstant: 20).isActive = true
        star1.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(star2)
        star2.topAnchor.constraint(equalTo: self.profileName.bottomAnchor, constant: 5).isActive = true
        star2.leftAnchor.constraint(equalTo: self.star1.rightAnchor, constant: 5).isActive = true
        star2.widthAnchor.constraint(equalToConstant: 20).isActive = true
        star2.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(star3)
        star3.topAnchor.constraint(equalTo: self.profileName.bottomAnchor, constant: 5).isActive = true
        star3.leftAnchor.constraint(equalTo: self.star2.rightAnchor, constant: 5).isActive = true
        star3.widthAnchor.constraint(equalToConstant: 20).isActive = true
        star3.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(star4)
        star4.topAnchor.constraint(equalTo: self.profileName.bottomAnchor, constant: 5).isActive = true
        star4.leftAnchor.constraint(equalTo: self.star3.rightAnchor, constant: 5).isActive = true
        star4.widthAnchor.constraint(equalToConstant: 20).isActive = true
        star4.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(star5)
        star5.topAnchor.constraint(equalTo: self.profileName.bottomAnchor, constant: 5).isActive = true
        star5.leftAnchor.constraint(equalTo: self.star4.rightAnchor, constant: 5).isActive = true
        star5.widthAnchor.constraint(equalToConstant: 20).isActive = true
        star5.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(seperaterView)
        seperaterView.topAnchor.constraint(equalTo: self.profileImageView.bottomAnchor, constant: 25).isActive = true
        seperaterView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        seperaterView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        seperaterView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(toolBarView)
        toolBarView.topAnchor.constraint(equalTo: self.seperaterView.bottomAnchor).isActive = true
        toolBarView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        toolBarView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        toolBarView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        toolBarView.addSubview(secondImportantView)
        secondImportantView.topAnchor.constraint(equalTo: toolBarView.topAnchor).isActive = true
        secondImportantView.leftAnchor.constraint(equalTo: toolBarView.leftAnchor, constant: 15).isActive = true
        secondImportantView.bottomAnchor.constraint(equalTo: toolBarView.bottomAnchor).isActive = true
        secondImportantView.widthAnchor.constraint(equalToConstant: view.frame.width / 2).isActive = true
        
        secondImportantView.addSubview(secondTitleLabel)
        secondTitleLabel.topAnchor.constraint(equalTo: secondImportantView.topAnchor).isActive = true
        secondTitleLabel.leftAnchor.constraint(equalTo: secondImportantView.leftAnchor).isActive = true
        secondTitleLabel.rightAnchor.constraint(equalTo: secondImportantView.rightAnchor).isActive = true
        secondTitleLabel.bottomAnchor.constraint(equalTo: secondImportantView.bottomAnchor, constant: -15).isActive = true
        
        secondImportantView.addSubview(secondDescLabel)
        secondDescLabel.topAnchor.constraint(equalTo: secondImportantView.topAnchor, constant: 25).isActive = true
        secondDescLabel.leftAnchor.constraint(equalTo: secondImportantView.leftAnchor).isActive = true
        secondDescLabel.rightAnchor.constraint(equalTo: secondImportantView.rightAnchor).isActive = true
        secondDescLabel.bottomAnchor.constraint(equalTo: secondImportantView.bottomAnchor).isActive = true
        
        toolBarView.addSubview(thirdImportantView)
        thirdImportantView.topAnchor.constraint(equalTo: toolBarView.topAnchor).isActive = true
        thirdImportantView.rightAnchor.constraint(equalTo: toolBarView.rightAnchor, constant: -15).isActive = true
        thirdImportantView.bottomAnchor.constraint(equalTo: toolBarView.bottomAnchor).isActive = true
        thirdImportantView.widthAnchor.constraint(equalToConstant: view.frame.width / 2).isActive = true
        
        thirdImportantView.addSubview(thirdTitleLabel)
        thirdTitleLabel.topAnchor.constraint(equalTo: thirdImportantView.topAnchor).isActive = true
        thirdTitleLabel.leftAnchor.constraint(equalTo: thirdImportantView.leftAnchor).isActive = true
        thirdTitleLabel.rightAnchor.constraint(equalTo: thirdImportantView.rightAnchor).isActive = true
        thirdTitleLabel.bottomAnchor.constraint(equalTo: thirdImportantView.bottomAnchor, constant: -15).isActive = true
        
        thirdImportantView.addSubview(thirdDescLabel)
        thirdDescLabel.topAnchor.constraint(equalTo: thirdImportantView.topAnchor, constant: 25).isActive = true
        thirdDescLabel.leftAnchor.constraint(equalTo: thirdImportantView.leftAnchor).isActive = true
        thirdDescLabel.rightAnchor.constraint(equalTo: thirdImportantView.rightAnchor).isActive = true
        thirdDescLabel.bottomAnchor.constraint(equalTo: thirdImportantView.bottomAnchor).isActive = true
        
        view.addSubview(seperaterView2)
        seperaterView2.topAnchor.constraint(equalTo: self.toolBarView.bottomAnchor).isActive = true
        seperaterView2.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        seperaterView2.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        seperaterView2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(myServices)
        myServices.topAnchor.constraint(equalTo: self.seperaterView2.bottomAnchor, constant: 25).isActive = true
        myServices.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 25).isActive = true
        myServices.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        myServices.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: self.myServices.bottomAnchor, constant: 10).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 10).isActive = true
        
        view.backgroundColor = UIColor.white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileCell.self, forCellReuseIdentifier: "profileCell")

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationController?.navigationBar.tintColor = UIColor.mainBlue
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let btnProfile = UIButton(type: .system)
        btnProfile.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        btnProfile.setImage(UIImage(systemName: "pencil"), for: .normal)
        btnProfile.tintColor = UIColor.black
        btnProfile.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btnProfile.addTarget(self, action: #selector(self.editPressed), for: .touchUpInside)
        btnProfile.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
        btnProfile.layer.cornerRadius = 25
        btnProfile.layer.masksToBounds = true
        
        let share = UIButton(type: .system)
        share.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        share.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        share.tintColor = UIColor.black
        share.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        share.addTarget(self, action: #selector(self.uploadPressed), for: .touchUpInside)
        share.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
        share.layer.cornerRadius = 25
        share.layer.masksToBounds = true
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: btnProfile), UIBarButtonItem(customView: share)]
        
        // profile image view
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("profile-image").observe(.value) { (snapshot) in
            let profileImageString : String = (snapshot.value as? String)!
            if profileImageString == "not-yet-selected" {
                self.profileImageView.image = UIImage(systemName: "person.circle.fill")
                self.profileImageView.tintColor = UIColor.lightGray
                self.profileImageView.contentMode = .scaleAspectFill
            } else {
                self.profileImageView.loadImageUsingCacheWithUrlString(profileImageString)
                self.profileImageView.tintColor = UIColor.lightGray
                self.profileImageView.contentMode = .scaleAspectFill
            }
        }
        
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("My_Jobs").observe(.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String: Any] {
                let job = MyJobStructure()
                job.type = value["job-status"] as? String ?? "TYPE FALSE"
                if job.type! == "completed" {
                    self.hires += 1
                }
            }
            // update label
            self.secondTitleLabel.text = String(self.hires)
        }
        
        // name
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("name").observe(.value) { (snapshot) in
            let userName : String = (snapshot.value as? String)!
            self.profileName.text = userName
        }
        
        if self.findingRating == true {
            // find rating
            Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("number-of-ratings").observeSingleEvent(of: .value) { (ratingNum) in
                let value = ratingNum.value as? NSNumber
                let newNumber = Float(value!)
                if newNumber == 0 {
                    self.star1.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                    self.star2.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                    self.star3.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                    self.star4.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                    self.star5.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                } else {
                    self.getAllRatings()
                }
            }
        }
        
        self.allJobs.removeAll()
        self.myJobs.removeAll()
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
                
                if job.authorName ==  Auth.auth().currentUser!.uid {
                    print("my name")
                    self.myJobs.append(job)
                }
            }
            self.thirdTitleLabel.text = String(self.myJobs.count)
            self.tableView.reloadData()
        }
    }
    
    func getAllRatings() {
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("ratings").observe(.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                let job = ReviewStructure()
                job.ratingNumber = value["rating-number"] as? Int ?? 0
                self.ratingNumber += 1
                self.finalRating += job.ratingNumber!
            }
            
            let finalNumber = self.finalRating / self.ratingNumber
            
            switch finalNumber {
            case 0:
                self.star1.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                self.star2.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                self.star3.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                self.star4.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                self.star5.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
            case 1:
                self.star1.tintColor = UIColor.mainBlue
                self.star2.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                self.star3.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                self.star4.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                self.star5.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
            case 2:
                self.star1.tintColor = UIColor.mainBlue
                self.star2.tintColor = UIColor.mainBlue
                self.star3.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                self.star4.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                self.star5.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
            case 3:
                self.star1.tintColor = UIColor.mainBlue
                self.star2.tintColor = UIColor.mainBlue
                self.star3.tintColor = UIColor.mainBlue
                self.star4.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                self.star5.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
            case 4:
                self.star1.tintColor = UIColor.mainBlue
                self.star2.tintColor = UIColor.mainBlue
                self.star3.tintColor = UIColor.mainBlue
                self.star4.tintColor = UIColor.mainBlue
                self.star5.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
            case 5:
                self.star1.tintColor = UIColor.mainBlue
                self.star2.tintColor = UIColor.mainBlue
                self.star3.tintColor = UIColor.mainBlue
                self.star4.tintColor = UIColor.mainBlue
                self.star5.tintColor = UIColor.mainBlue
            default:
                print("hello")
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.myServices.text = "My Services"
        return myJobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileCell
        
        cell.selectionStyle = .none
        
        let url = URL(string: self.myJobs[indexPath.row].imagePost!)
        cell.postImageView.kf.setImage(with: url)
        
        cell.titleJob.text = self.myJobs[indexPath.row].titleOfPost!
        cell.postId = self.myJobs[indexPath.row].postId!
        cell.saleNumber.text = self.myJobs[indexPath.row].descriptionOfPost!
        if self.myJobs[indexPath.row].typeOfPrice == "Hourly" {
            cell.priceNumber.text = "$\(self.myJobs[indexPath.row].price!) / Hour"
        } else {
            cell.priceNumber.text = "$\(self.myJobs[indexPath.row].price!)"
        }
        
        cell.deleteButton.addTarget(self, action: #selector(deletePostPressed), for: .touchUpInside)
        cell.editButton.addTarget(self, action: #selector(editPostPressed), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = URL(string: self.myJobs[indexPath.row].imagePost!)
        GlobalVariables.imagePost.kf.setImage(with: url)
        GlobalVariables.postImageDownlodUrl = self.myJobs[indexPath.row].imagePost!
        GlobalVariables.postTitle = self.myJobs[indexPath.row].titleOfPost!
        GlobalVariables.postDescription = self.myJobs[indexPath.row].descriptionOfPost!
        GlobalVariables.postPrice = self.myJobs[indexPath.row].price!
        GlobalVariables.authorId = self.myJobs[indexPath.row].authorName!
        GlobalVariables.postId = self.myJobs[indexPath.row].postId!
        GlobalVariables.type = self.myJobs[indexPath.row].typeOfPrice!
        
        self.navigationController?.pushViewController(ViewPostController(), animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            print("delete")
        }
        return [deleteAction]
    }
    
    @objc func uploadPressed() {
        let text = "Hire or get work on the fastest and easiest platform"
        let url : NSURL = NSURL(string: "https://www.google.com")!
        let vc = UIActivityViewController(activityItems: [text, url], applicationActivities: [])
        if let popoverController = vc.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = self.view.bounds
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func deletePostPressed() {
        print("delete")
    }
    
    @objc func editPostPressed() {
        print("edit")
    }
    
    @objc func editPressed() {
        self.navigationController?.pushViewController(EditProfile(), animated: true)
    }

}

class ProfileCell: UITableViewCell {
    
    var postId = ""
    
    let postImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let informationView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 10
        view.layer.cornerRadius = 15
        return view
    }()
    
    let titleJob : UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 1
        return label
    }()
    
    let saleNumber : UILabel = {
        let label = UILabel()
        label.text = "Sales"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 1
        return label
    }()
    
    let priceNumber : UILabel = {
        let label = UILabel()
        label.text = "Cost"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    let editButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.mainBlue.cgColor
        return button
    }()
    
    let deleteButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.mainBlue.cgColor
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        isUserInteractionEnabled = true
            
        addSubview(informationView)
        informationView.topAnchor.constraint(equalTo: self.topAnchor, constant: 25).isActive = true
        informationView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -25).isActive = true
        informationView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25).isActive = true
        informationView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25).isActive = true
        
        informationView.addSubview(postImageView)
        postImageView.topAnchor.constraint(equalTo: informationView.topAnchor, constant: -10).isActive = true
        postImageView.leftAnchor.constraint(equalTo: informationView.leftAnchor, constant: -10).isActive = true
        postImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        postImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        informationView.addSubview(priceNumber)
        priceNumber.topAnchor.constraint(equalTo: informationView.topAnchor, constant: 10).isActive = true
        priceNumber.rightAnchor.constraint(equalTo: informationView.rightAnchor, constant: -10).isActive = true
        priceNumber.heightAnchor.constraint(equalToConstant: 25).isActive = true
        priceNumber.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        informationView.addSubview(titleJob)
        titleJob.topAnchor.constraint(equalTo: self.topAnchor, constant: 40).isActive = true
        titleJob.rightAnchor.constraint(equalTo: priceNumber.leftAnchor).isActive = true
        titleJob.leftAnchor.constraint(equalTo: self.postImageView.rightAnchor, constant: 25).isActive = true
        titleJob.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        informationView.addSubview(saleNumber)
        saleNumber.topAnchor.constraint(equalTo: self.titleJob.bottomAnchor, constant: -5).isActive = true
        saleNumber.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -25).isActive = true
        saleNumber.leftAnchor.constraint(equalTo: self.postImageView.rightAnchor, constant: 25).isActive = true
        saleNumber.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        contentView.addSubview(editButton)
        editButton.layer.cornerRadius = 15
        editButton.layer.masksToBounds = true
        editButton.topAnchor.constraint(equalTo: saleNumber.bottomAnchor, constant: 7).isActive = true
        editButton.rightAnchor.constraint(equalTo: informationView.rightAnchor, constant: -15).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: 85).isActive = true

        contentView.addSubview(deleteButton)
        deleteButton.layer.cornerRadius = 15
        deleteButton.layer.masksToBounds = true
        deleteButton.topAnchor.constraint(equalTo: saleNumber.bottomAnchor, constant: 7).isActive = true
        deleteButton.rightAnchor.constraint(equalTo: editButton.leftAnchor, constant: -15).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 85).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
