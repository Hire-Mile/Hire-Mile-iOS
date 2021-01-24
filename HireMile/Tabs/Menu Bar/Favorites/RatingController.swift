//
//  RatingController.swift
//  HireMile
//
//  Created by JJ Zapata on 1/24/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RatingController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
        
        view.backgroundColor = .white
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        // Functions to throw
        self.basicSetup()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
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
        self.tableView.allowsSelection = false
        self.tableView.refreshControl = refrshControl
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
