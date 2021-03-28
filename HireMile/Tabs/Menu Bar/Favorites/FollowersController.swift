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
        
        if let uid = self.followers[indexPath.row].uid {
            Database.database().reference().child("Users").child(uid).child("name").observe(.value) { (snapshot) in
                if let snapshot : String = (snapshot.value as? String) {
                    cell.textLabel?.text = snapshot
                    cell.delegate = self
                    cell.index = indexPath
                }
            }
            
            Database.database().reference().child("Users").child(uid).child("profile-image").observe(.value) { (snapshot) in
                let snapshot : String = (snapshot.value as? String)!
                if snapshot == "not-yet-selected" {
                    cell.profileImageView.image = UIImage(systemName: "person.circle.fill")
                    cell.profileImageView.tintColor = UIColor.lightGray
                    cell.profileImageView.contentMode = .scaleAspectFill
                } else {
                    cell.profileImageView.loadImageUsingCacheWithUrlString(snapshot)
                }
            }
            
            if self.favorites.contains(uid) {
                cell.favoriteButton.backgroundColor = .white
                cell.favoriteButton.setTitle("Following", for: .normal)
                cell.favoriteButton.setTitleColor(UIColor.black, for: .normal)
            } else {
                cell.favoriteButton.backgroundColor = .mainBlue
                cell.favoriteButton.setTitle("Follow", for: .normal)
                cell.favoriteButton.setTitleColor(UIColor.white, for: .normal)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let profileUID : String = self.followers[indexPath.row].uid {
            GlobalVariables.userUID = profileUID
            let controller = OtherProfile()
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func didSelectFavoriteButton(withIndex index: Int) {
        print("selected index \(index)")
        if let uid = self.followers[index].uid {
            if self.favorites.contains(uid) {
                Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("favorites").child(uid).removeValue()
                self.viewDidLoad()
            } else {
                let userInformation : Dictionary<String, Any> = [
                    "uid" : "\(self.followers[index].uid!)"
                ]
                let postFeed = ["\(self.followers[index].uid!)" : userInformation]
                Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("favorites").updateChildValues(postFeed)
                Database.database().reference().child("Users").child(self.followers[index].uid!).child("fcmToken").observe(.value) { (snapshot) in
                    if let token : String = (snapshot.value as? String) {
                        let sender = PushNotificationSender()
                        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("name").observe(.value) { (snapshot) in
                            if let userName : String = (snapshot.value as? String) {
                                sender.sendPushNotification(to: token, title: "Congrats! 🎉", body: "\(userName) started following you!", page: true, senderId: Auth.auth().currentUser!.uid, recipient: self.followers[index].uid!)
                            }
                        }
                    }
                }
                self.viewDidLoad()
            }
        }
    }

}
