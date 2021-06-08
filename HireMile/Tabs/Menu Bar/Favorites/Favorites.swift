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

class Favorites: UITableViewController, FavoritesCellProtocol {
    
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
        tableView.separatorColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.register(FavoritesCell.self, forCellReuseIdentifier: "favoritesCellID")
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkForRelaod), userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func checkForRelaod() {
        if GlobalVariables.removedSomon == true {
            self.pullData()
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
        self.navigationController?.navigationBar.topItem?.title = "Following"
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .bottom, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = nil

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = true
        self.tableView.refreshControl = refrshControl
        
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.showsVerticalScrollIndicator = false
        
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
                guard let uid = value["uid"] as? String else {
                    return
                }
                user.uid = uid
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
        
        if let uid = self.favorites[indexPath.row].uid {
            Database.database().reference().child("Users").child(uid).child("name").observe(.value) { (snapshot) in
                if let snapshot : String = (snapshot.value as? String) {
                    cell.textLabel?.text = snapshot
                } else {
                    cell.textLabel?.text = "Deleted User"
                    
                    cell.favoriteButton.setTitle("Delete", for: .normal)
                    cell.favoriteButton.backgroundColor = UIColor.systemRed
                    cell.favoriteButton.setTitleColor(UIColor.white, for: .normal)
                    
                    cell.delegate = self
                    cell.index = indexPath
                }
            }
            Database.database().reference().child("Users").child(uid).child("profile-image").observe(.value) { (snapshot) in
                if let snapshot : String = (snapshot.value as? String) {
                    if snapshot == "not-yet-selected" {
                        cell.profileImageView.image = UIImage(systemName: "person.circle.fill")
                        cell.profileImageView.tintColor = UIColor.lightGray
                        cell.profileImageView.contentMode = .scaleAspectFill
                        
                        cell.profileButton.addTarget(self, action: #selector(self.mapsHit), for: .touchUpInside)
                        cell.profileButton.tag = indexPath.row
                    } else {
                        cell.profileImageView.sd_setImage(with: URL(string: snapshot), placeholderImage: nil, options: .retryFailed, completed: nil)
                        cell.profileButton.addTarget(self, action: #selector(self.mapsHit), for: .touchUpInside)
                        cell.profileButton.tag = indexPath.row
                    }
                } else {
                    cell.textLabel?.text = "Deleted User"
                    
                    cell.favoriteButton.titleLabel?.text = "Delete"
                    cell.favoriteButton.backgroundColor = UIColor.systemRed
                    cell.favoriteButton.titleLabel?.textColor = UIColor.white
                    
                    cell.delegate = self
                    cell.index = indexPath
                }
            }
            
            cell.delegate = self
            cell.index = indexPath
        } else {
            cell.textLabel?.text = "Deleted User"
            
            cell.favoriteButton.titleLabel?.text = "Delete"
            cell.favoriteButton.backgroundColor = UIColor.systemRed
            cell.favoriteButton.titleLabel?.textColor = UIColor.white
            
            cell.delegate = self
            cell.index = indexPath
        }
        return cell
    }
    
    @objc func mapsHit(sender: UIButton) {
        let index = sender.tag
        Database.database().reference().child("Users").child(self.favorites[index].uid!).observe(.value) { (snapshot) in
            let profileUID : String = (snapshot.key as? String)!
            if let profileVC = CommonUtils.getStoryboardVC(StoryBoard.Profile.rawValue, vcIdetifier: UserProfileViewController.className) as? UserProfileViewController {
                profileVC.userUID = profileUID
                self.navigationController?.pushViewController(profileVC,  animated: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func didSelectFavoriteButton(withIndex index: Int) {
        print("hi")
        Database.database().reference().child("Users").child(self.favorites[index].uid!).child("name").observe(.value) { (name) in
            if let name : String = (name.value as? String) {
                Database.database().reference().child("Users").child(self.favorites[index].uid!).child("profile-image").observe(.value) { (snapshot) in
                    if let snapshot : String = (snapshot.value as? String) {
                        if snapshot == "not-yet-selected" {
                            self.removeView.showFilter(withName: name, withImage: snapshot, withUid: self.favorites[index].uid!, isImageNil: true)
                        } else {
                            self.removeView.showFilter(withName: name, withImage: snapshot, withUid: self.favorites[index].uid!, isImageNil: false)
                        }
                    }
                }
            } else {
                print("hi1")
                print(self.favorites[index].uid!)
                Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("favorites").child(self.favorites[index].uid!).removeValue()
                self.pullData()
            }
        }
    }

}


protocol FavoritesCellProtocol {
    func didSelectFavoriteButton(withIndex index: Int)
}

class FavoritesCell: UITableViewCell {
    
    var index : IndexPath?
    
    var delegate : FavoritesCellProtocol?
    
    let favoriteButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).cgColor
        button.setTitle("Following", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 85, y: self.contentView.frame.height / 3, width: 200, height: textLabel!.frame.height)
//        textLabel?.backgroundColor = UIColor.mainBlue
        
//        bringSubviewToFront()
//        bringSubviewToFront(favoriteButton)
    }
    
    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 22.5
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let profileButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        contentView.addSubview(profileButton)
        contentView.addSubview(favoriteButton)
    
        textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        self.selectionStyle = .none
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        profileButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25).isActive = true
        profileButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        favoriteButton.addTarget(self, action: #selector(tapper), for: .touchUpInside)
        favoriteButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -25).isActive = true
        favoriteButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        favoriteButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        favoriteButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapper() {
        delegate?.didSelectFavoriteButton(withIndex: (index?.row)!)
    }
}

