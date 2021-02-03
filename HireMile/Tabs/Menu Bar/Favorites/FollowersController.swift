//
//  FollowersController.swift
//  HireMile
//
//  Created by JJ Zapata on 2/3/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class FollowersController: UITableViewController, FavoritesCellProtocol {
    
    var favorites = [String]()
    
    var followers = [UserStructure]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.tableView.separatorColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        self.tableView.register(FavoritesCell.self, forCellReuseIdentifier: "followres")
        
        self.favorites.removeAll()
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("favorites").observe(.childAdded) { (listOfuserFavorite) in
            if let value = listOfuserFavorite.value as? [String : Any] {
                let user = UserStructure()
                user.uid = value["uid"] as? String ?? "Error"
                self.favorites.append(user.uid!)
            }
            self.tableView.reloadData()
        }

        // Do any additional setup after loading the view.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.followers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "followres", for: indexPath) as! FavoritesCell
        cell.profileImageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        Database.database().reference().child("Users").child(self.followers[indexPath.row].uid!).child("name").observe(.value) { (snapshot) in
            let snapshot : String = (snapshot.value as? String)!
            cell.textLabel?.text = snapshot
        }
        Database.database().reference().child("Users").child(self.followers[indexPath.row].uid!).child("profile-image").observe(.value) { (snapshot) in
            let snapshot : String = (snapshot.value as? String)!
            if snapshot == "not-yet-selected" {
                cell.profileImageView.image = UIImage(systemName: "person.circle.fill")
                cell.profileImageView.tintColor = UIColor.lightGray
                cell.profileImageView.contentMode = .scaleAspectFill
            } else {
                cell.profileImageView.loadImageUsingCacheWithUrlString(snapshot)
            }
        }
        // set to following or not following
        if self.favorites.contains(self.followers[indexPath.row].uid!) {
            cell.favoriteButton.backgroundColor = .white
            cell.favoriteButton.setTitle("Following", for: .normal)
            cell.favoriteButton.setTitleColor(UIColor.black, for: .normal)
        } else {
            cell.favoriteButton.backgroundColor = .mainBlue
            cell.favoriteButton.setTitle("Follow", for: .normal)
            cell.favoriteButton.setTitleColor(UIColor.white, for: .normal)
        }
        cell.delegate = self
        cell.index = indexPath
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hello")
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func didSelectFavoriteButton(withIndex index: Int) {
        print("selected index \(index)")
        if self.favorites.contains(self.followers[index].uid!) {
            Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("favorites").child(self.followers[index].uid!).removeValue()
            self.viewDidLoad()
        } else {
            let userInformation : Dictionary<String, Any> = [
                "uid" : "\(self.followers[index].uid!)"
            ]
            let postFeed = ["\(self.followers[index].uid!)" : userInformation]
            Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("favorites").updateChildValues(postFeed)
            Database.database().reference().child("Users").child(self.followers[index].uid!).child("fcmToken").observe(.value) { (snapshot) in
                let token : String = (snapshot.value as? String)!
                let sender = PushNotificationSender()
                Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("name").observe(.value) { (snapshot) in
                    let userName : String = (snapshot.value as? String)!
                    sender.sendPushNotification(to: token, title: "Congrats! 🎉", body: "\(userName) started following you!")
                }
            }
            self.viewDidLoad()
        }
    }

}
