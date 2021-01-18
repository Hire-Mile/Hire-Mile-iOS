//
//  MyReviews.swift
//  HireMile
//
//  Created by JJ Zapata on 11/25/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class MyReviews: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var ratings = [ReviewStructure]()
    
    var isRatingsNil = true
        
    private let refrshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.black
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        return refreshControl
    }()
    
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let emptyView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let contentView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bubbleImage : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "star.fill")
        image.contentMode = .scaleAspectFit
        image.tintColor = UIColor.mainBlue
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let mainText : UILabel = {
        let label = UILabel()
        label.text = "No ratings yet"
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let descText : UILabel = {
        let label = UILabel()
        label.text = "When people mark your job as complete, you find your ratings here!"
        label.numberOfLines = 5
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.register(MyReviewsCell.self, forCellReuseIdentifier: "reviewsCellID")
        
        self.view.addSubview(tableView)
        self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.tableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        self.view.addSubview(self.emptyView)
        self.emptyView.alpha = 0
        self.emptyView.topAnchor.constraint(equalTo: self.tableView.topAnchor).isActive = true
        self.emptyView.leftAnchor.constraint(equalTo: self.tableView.leftAnchor).isActive = true
        self.emptyView.rightAnchor.constraint(equalTo: self.tableView.rightAnchor).isActive = true
        self.emptyView.bottomAnchor.constraint(equalTo: self.tableView.bottomAnchor).isActive = true
        
        self.emptyView.addSubview(self.contentView)
        self.contentView.centerXAnchor.constraint(equalTo: self.emptyView.centerXAnchor).isActive = true
        self.contentView.centerYAnchor.constraint(equalTo: self.emptyView.centerYAnchor, constant: -50).isActive = true
        self.contentView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        self.contentView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        self.contentView.addSubview(bubbleImage)
        self.bubbleImage.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.bubbleImage.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.bubbleImage.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        self.bubbleImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.contentView.addSubview(mainText)
        self.mainText.topAnchor.constraint(equalTo: self.bubbleImage.bottomAnchor).isActive = true
        self.mainText.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.mainText.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        self.mainText.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.contentView.addSubview(descText)
        self.descText.topAnchor.constraint(equalTo: self.mainText.bottomAnchor, constant: -10).isActive = true
        self.descText.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: -20).isActive = true
        self.descText.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 20).isActive = true
        self.descText.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        // get the number of ratings
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("number-of-ratings").observe(.value) { (snapshot) in
            let value = snapshot.value as? NSNumber
            let newNumber = Float(value!)
            // and create and if statement if the user has any ratings or not.
            if newNumber == 0 {
                // show nothing on the tableview
                self.tableView.reloadData()
            } else {
                // if the user does have ratings, need to put them into the tableview
                self.searchForReviews()
            }
        }
    
        // Do any additional setup after loading the view.
    }
    
    func searchForReviews() {
        self.ratings.removeAll()
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("ratings").observe(.childAdded) { (snapshotRatings) in
            if let value = snapshotRatings.value as? [String: Any] {
                let rating = ReviewStructure()
                rating.userUid = value["user-id"] as? String ?? "Error"
                rating.ratingNumber = value["rating-number"] as? Int ?? 0
                rating.postId = value["post-id"] as? String ?? "Error"
                rating.descriptionOfRating = value["description"] as? String ?? "Error"
                self.isRatingsNil = false
                self.ratings.append(rating)
            }
            self.ratings.reverse()
            self.tableView.reloadData()
        }
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
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = UIColor.white
 
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = true
        self.tableView.refreshControl = refrshControl
    
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isRatingsNil == true {
            self.noRatings()
            return 0
        } else {
            self.yesRatings()
            return self.ratings.count
        }
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewsCellID", for: indexPath) as! MyReviewsCell
        Database.database().reference().child("Jobs").child(self.ratings[indexPath.row].postId!).child("image").observeSingleEvent(of: .value, with: { (snapshot) in
            if let imageUrl : String = (snapshot.value as? String) {
                cell.postImageView.loadImageUsingCacheWithUrlString(imageUrl)
            } else {
                print("not able to find")
            }
        })
        Database.database().reference().child("Users").child(self.ratings[indexPath.row].userUid!).child("name").observe(.value) { (snapshot) in
            let name : String = (snapshot.value as? String)!
            cell.userNameLabel.text = name
        }
        Database.database().reference().child("Users").child(self.ratings[indexPath.row].userUid!).child("profile-image").observe(.value) { (snapshot) in
            let profileImageString : String = (snapshot.value as? String)!
            if profileImageString == "not-yet-selected" {
                cell.profileImageView.image = UIImage(systemName: "person.circle.fill")
                cell.profileImageView.tintColor = UIColor.lightGray
                cell.profileImageView.contentMode = .scaleAspectFill
            } else {
                cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageString)
                cell.profileImageView.tintColor = UIColor.lightGray
                cell.profileImageView.contentMode = .scaleAspectFill
            }
        }
        print("review")
        print(self.ratings[indexPath.row].ratingNumber!)
        print("review")
        cell.reviewLabel.text = self.ratings[indexPath.row].descriptionOfRating!
        switch Int(self.ratings[indexPath.row].ratingNumber!) {
            case 0:
                cell.star1.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                cell.star2.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                cell.star3.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                cell.star4.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                cell.star5.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
            case 1:
                cell.star1.tintColor = UIColor.mainBlue
                cell.star2.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                cell.star3.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                cell.star4.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                cell.star5.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
            case 2:
                cell.star1.tintColor = UIColor.mainBlue
                cell.star2.tintColor = UIColor.mainBlue
                cell.star3.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                cell.star4.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                cell.star5.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
            case 3:
                cell.star1.tintColor = UIColor.mainBlue
                cell.star2.tintColor = UIColor.mainBlue
                cell.star3.tintColor = UIColor.mainBlue
                cell.star4.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
                cell.star5.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
            case 4:
                cell.star1.tintColor = UIColor.mainBlue
                cell.star2.tintColor = UIColor.mainBlue
                cell.star3.tintColor = UIColor.mainBlue
                cell.star4.tintColor = UIColor.mainBlue
                cell.star5.tintColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
            case 5:
                cell.star1.tintColor = UIColor.mainBlue
                cell.star2.tintColor = UIColor.mainBlue
                cell.star3.tintColor = UIColor.mainBlue
                cell.star4.tintColor = UIColor.mainBlue
                cell.star5.tintColor = UIColor.mainBlue
            default:
                print("different review value, star cannot be formed: \(Int(self.ratings[indexPath.row].ratingNumber!))")
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    
    @objc func refreshAction() {
        self.tableView.reloadData()
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(hideRefrsh), userInfo: nil, repeats: false)
    }
    
    @objc func hideRefrsh() {
        self.refrshControl.endRefreshing()
    }
    
    func noRatings() {
        UIView.animate(withDuration: 0.3) {
            self.emptyView.alpha = 1
            self.tableView.alpha = 0
        }
    }
    
    func yesRatings() {
        UIView.animate(withDuration: 0.3) {
            self.emptyView.alpha = 0
            self.tableView.alpha = 1
        }
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
        return imageView
    }()
    
    let star2 : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "star.fill")
        return imageView
    }()
    
    let star3 : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "star.fill")
        return imageView
    }()
    
    let star4 : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "star.fill")
        return imageView
    }()
    
    let star5 : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "star.fill")
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
