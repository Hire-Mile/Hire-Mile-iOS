//
//  Favorites.swift
//  HireMile
//
//  Created by JJ Zapata on 11/23/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class Favorites: UITableViewController {
    
    var favorites = [UserStructure]()
    
    let removeView = FavoriteRemoveView()
    
    private let refrshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.black
        refreshControl.addTarget(self, action: #selector(refrshThing), for: .valueChanged)
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.register(FavoritesCell.self, forCellReuseIdentifier: "favoritesCellID")
        
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
        self.navigationController?.navigationBar.topItem?.title = "Following"
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .bottom, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = nil

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = true
        self.tableView.refreshControl = refrshControl
        
        self.pullData()
    }
    
    @objc func refrshThing() {
        self.pullData()
        self.refreshControl?.endRefreshing()
    }
    
    func pullData() {
        self.favorites.removeAll()
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("favorites").observe(.childAdded) { (listOfuserFavorite) in
            if let value = listOfuserFavorite.value as? [String : Any] {
                let user = UserStructure()
                user.uid = value["uid"] as? String ?? "Error"
                self.favorites.append(user)
            }
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favorites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesCellID", for: indexPath) as! FavoritesCell
        cell.profileImageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        Database.database().reference().child("Users").child(self.favorites[indexPath.row].uid!).child("name").observe(.value) { (snapshot) in
            let snapshot : String = (snapshot.value as? String)!
            cell.textLabel?.text = snapshot
        }
        Database.database().reference().child("Users").child(self.favorites[indexPath.row].uid!).child("email").observe(.value) { (snapshot) in
            let snapshot : String = (snapshot.value as? String)!
            if snapshot.contains("@") || snapshot.contains(".") {
                cell.detailTextLabel?.text = snapshot
            } else {
                cell.detailTextLabel?.text = "Hiremile Contributer"
            }
        }
        Database.database().reference().child("Users").child(self.favorites[indexPath.row].uid!).child("profile-image").observe(.value) { (snapshot) in
            let snapshot : String = (snapshot.value as? String)!
            if snapshot == "not-yet-selected" {
                cell.profileImageView.image = UIImage(systemName: "person.circle.fill")
                cell.profileImageView.tintColor = UIColor.lightGray
                cell.profileImageView.contentMode = .scaleAspectFill
            } else {
                cell.profileImageView.loadImageUsingCacheWithUrlString(snapshot)
            }
        }
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        cell.detailTextLabel?.isHidden = false
        cell.detailTextLabel?.textColor = UIColor.darkGray
        cell.detailTextLabel?.text = "Position"
        cell.favoriteButton.imageView?.contentMode = .scaleAspectFill
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Database.database().reference().child("Users").child(self.favorites[indexPath.row].uid!).child("name").observe(.value) { (name) in
            let name : String = (name.value as? String)!
            Database.database().reference().child("Users").child(self.favorites[indexPath.row].uid!).child("profile-image").observe(.value) { (snapshot) in
                let snapshot : String = (snapshot.value as? String)!
                if snapshot == "not-yet-selected" {
                    self.removeView.showFilter(withName: name, withImage: snapshot, withUid: self.favorites[indexPath.row].uid!, isImageNil: true)
                } else {
                    self.removeView.showFilter(withName: name, withImage: snapshot, withUid: self.favorites[indexPath.row].uid!, isImageNil: false)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}

class FavoritesCell: UITableViewCell {
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 75, y: textLabel!.frame.origin.y, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 75, y: detailTextLabel!.frame.origin.y - 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let favoriteButton : UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.tintColor = UIColor.mainBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.imageView?.tintColor = UIColor.mainBlue
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(favoriteButton)
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        favoriteButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        favoriteButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        favoriteButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        favoriteButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
