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
        view.backgroundColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
        return view
    }()
    
    let myServices : UILabel = {
        let label = UILabel()
        label.text = "My Services ()"
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
        
        view.addSubview(myServices)
        myServices.topAnchor.constraint(equalTo: self.seperaterView.bottomAnchor, constant: 25).isActive = true
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
        
        let upload = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(uploadPressed))
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editPressed))
        
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationController?.navigationBar.tintColor = UIColor.mainBlue
        self.navigationItem.rightBarButtonItems = [upload, edit]
        
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
        
        // name
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("name").observe(.value) { (snapshot) in
            let userName : String = (snapshot.value as? String)!
            self.profileName.text = userName
        }
        
        // stars
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("rating").observeSingleEvent(of: .value) { (ratingNum) in
            let value = ratingNum.value as? NSNumber
            let newNumber = Int(value!)
            if newNumber == 100 {
                self.star1.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                self.star2.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                self.star3.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                self.star4.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                self.star5.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
            } else {
                switch newNumber {
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
            self.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.myServices.text = "My Services (\(myJobs.count))"
        return myJobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileCell
        cell.postImageView.loadImageUsingCacheWithUrlString(self.myJobs[indexPath.row].imagePost!)
        cell.titleJob.text = self.myJobs[indexPath.row].titleOfPost!
        cell.postId = self.myJobs[indexPath.row].postId!
        cell.saleNumber.text = self.myJobs[indexPath.row].descriptionOfPost!
        if self.myJobs[indexPath.row].typeOfPrice == "Hourly" {
            cell.priceNumber.text = "$\(self.myJobs[indexPath.row].price!) / Hour"
        } else {
            cell.priceNumber.text = "$\(self.myJobs[indexPath.row].price!)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        GlobalVariables.postImage2.loadImageUsingCacheWithUrlString(self.myJobs[indexPath.row].imagePost!)
        GlobalVariables.postTitle = self.myJobs[indexPath.row].titleOfPost!
        GlobalVariables.postDescription = self.myJobs[indexPath.row].descriptionOfPost!
        GlobalVariables.postPrice = self.myJobs[indexPath.row].price!
        GlobalVariables.authorId = self.myJobs[indexPath.row].authorName!
        GlobalVariables.postId = self.myJobs[indexPath.row].postId!
        GlobalVariables.type = self.myJobs[indexPath.row].typeOfPrice!
        
        self.navigationController?.pushViewController(ViewPostController(), animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
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
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 1
        return label
    }()
    
    let priceNumber : UILabel = {
        let label = UILabel()
        label.text = "Cost"
        label.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        label.textColor = UIColor.mainBlue
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
            
        addSubview(informationView)
        informationView.topAnchor.constraint(equalTo: self.topAnchor, constant: 25).isActive = true
        informationView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -25).isActive = true
        informationView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25).isActive = true
        informationView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25).isActive = true
        
        informationView.addSubview(postImageView)
        postImageView.topAnchor.constraint(equalTo: informationView.topAnchor, constant: 0).isActive = true
        postImageView.leftAnchor.constraint(equalTo: informationView.leftAnchor, constant: 0).isActive = true
        postImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        postImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        informationView.addSubview(priceNumber)
        priceNumber.topAnchor.constraint(equalTo: informationView.topAnchor, constant: 10).isActive = true
        priceNumber.rightAnchor.constraint(equalTo: informationView.rightAnchor, constant: -10).isActive = true
        priceNumber.heightAnchor.constraint(equalToConstant: 25).isActive = true
        priceNumber.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        informationView.addSubview(titleJob)
        titleJob.topAnchor.constraint(equalTo: self.topAnchor, constant: 40).isActive = true
        titleJob.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -25).isActive = true
        titleJob.leftAnchor.constraint(equalTo: self.postImageView.rightAnchor, constant: 10).isActive = true
        titleJob.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        informationView.addSubview(saleNumber)
        saleNumber.topAnchor.constraint(equalTo: self.titleJob.bottomAnchor, constant: 0).isActive = true
        saleNumber.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -25).isActive = true
        saleNumber.leftAnchor.constraint(equalTo: self.postImageView.rightAnchor, constant: 10).isActive = true
        saleNumber.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
