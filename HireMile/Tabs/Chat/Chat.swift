//
//  Chat.swift
//  HireMile
//
//  Created by JJ Zapata on 11/16/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class Chat: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cashInAlert = CashInAlert()
    
    let titles = ["Style", "Style"]
    let descriptions = ["Message", "Message"]
    
//    let messageTitles = ["Name", "Name"]
//    let messageDescriptions = ["Message", "Message"]
        
    private let refrshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.black
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        return refreshControl
    }()
    
    let segmentedControl : UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.insertSegment(withTitle: "Messages", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Notifications", at: 1, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.layer.cornerRadius = 20
        segmentedControl.layer.borderColor = UIColor(red: 241/255, green: 239/255, blue: 239/255, alpha: 1).cgColor
        segmentedControl.layer.borderWidth = 2
        segmentedControl.layer.masksToBounds = true
        segmentedControl.backgroundColor = UIColor.mainBlue
        segmentedControl.setBackgroundImage(UIImage(named: "whiteback"), for: .normal, barMetrics: .default)
        segmentedControl.setBackgroundImage(UIImage(named: "mainBlue"), for: .selected, barMetrics: .default)
        segmentedControl.tintColor = UIColor.mainBlue
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1)], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.white
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(segmentedControl)
        self.segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        self.segmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.segmentedControl.widthAnchor.constraint(equalToConstant: 250).isActive = true
        self.segmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(tableView)
        self.tableView.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor, constant: 20).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.backgroundColor = UIColor.white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refrshControl
        tableView.register(NotificationCell.self, forCellReuseIdentifier: "myNotificationsCellID")
        tableView.register(MessagesCellCell.self, forCellReuseIdentifier: "myMessagesCellID")
        
        observeMessages()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        
        self.view.backgroundColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = "Chat"
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    var messages = [Message]()
    var messagesDictionary = [String : Message]()
    
    func observeMessages() {
        self.messages.removeAll()
        self.messagesDictionary.removeAll()
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("User-Messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let userId = snapshot.key
            Database.database().reference().child("User-Messages").child(uid).child(userId).observe(.childAdded) { (snapshot) in
                let messageId = snapshot.key
                self.fetchMessageWithMessageId(messageId: messageId)
            }
        }, withCancel: nil)
    }
    
    private func fetchMessageWithMessageId(messageId: String) {
        let messagesReference = Database.database().reference().child("Messages").child(messageId)
        messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message(dictionary: dictionary)
                if let chatPartnerId = message.chatPartnerId() {
                    self.messagesDictionary[chatPartnerId] = message
                }
                self.attemptReloadData()
            }
        }, withCancel: nil)
    }
    
    var timer : Timer?
    
    func attemptReloadData() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReload), userInfo: nil, repeats: false)
    }
    
    @objc func handleReload() {
        self.messages = Array(self.messagesDictionary.values)
        self.messages.sort(by: { (message1, message2) -> Bool in
            if let timestamp1 = message1.timestamp, let timestamp2 = message2.timestamp {
                return timestamp1.intValue > timestamp2.intValue
            }
            return false
        })
        //this will crash because of background thread, so lets call this on dispatch_async main thread
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return self.messages.count
        } else if segmentedControl.selectedSegmentIndex == 1 {
            return 0
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segmentedControl.selectedSegmentIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myMessagesCellID", for: indexPath) as! MessagesCellCell
            
            let message = messages[indexPath.row]
            cell.message = message
            
            return cell
        } else if segmentedControl.selectedSegmentIndex == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myNotificationsCellID", for: indexPath) as! NotificationCell
            cell.profileImageView.image = UIImage(named: "ProfileIcon")
            cell.textLabel?.text = titles[indexPath.row]
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            cell.detailTextLabel?.isHidden = false
            cell.detailTextLabel?.textColor = UIColor.darkGray
            cell.detailTextLabel?.text = descriptions[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myJobsCellID", for: indexPath) as! MyJobsRunningCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if segmentedControl.selectedSegmentIndex == 0 {
            return 80
        } else if segmentedControl.selectedSegmentIndex == 1 {
            return 90
        } else {
            return 125
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentedControl.selectedSegmentIndex == 0 {
            
            let message = messages[indexPath.row]
            guard let chatPartnerId = message.chatPartnerId() else {
                return
            }
            
            let ref = Database.database().reference().child("Users").child(chatPartnerId)
            ref.observe(.value) { (snapshot) in
                guard let dictionary = snapshot.value as? [String : AnyObject] else {
                    return
                }
                let user = UserChat(dictionary: dictionary)
                user.id = chatPartnerId
                self.showChatControllerForUser(user)
            }
            
        } else if segmentedControl.selectedSegmentIndex == 1 {
        } else {
            //
        }
    }
    
    func showChatControllerForUser(_ user: UserChat) {
        let chatLogController = ChatLogController2(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    @objc func refreshAction() {
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(hideRefrsh), userInfo: nil, repeats: false)
    }
    
    @objc func hideRefrsh() {
        self.refrshControl.endRefreshing()
    }
    
    @objc func segmentedControlValueChanged(_ semder: UISegmentedControl) {
        self.tableView.reloadData()
    }

}

class NotificationCell: UITableViewCell {
        
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MessagesCellCell: UITableViewCell {
    
    var message : Message? {
        didSet {
            self.profileImageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
            
            self.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            self.detailTextLabel?.isHidden = false
            self.detailTextLabel?.textColor = UIColor.darkGray
            
            // remove unread circle
            self.hasSeenView.removeFromSuperview()
            self.timeStamp.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            
            self.detailTextLabel?.text = message?.text
            
            if let seconds = message?.timestamp?.doubleValue {
                let timeStampDate = Date(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                timeStamp.text = dateFormatter.string(from: timeStampDate)
            }
            
            setupNameAndAvatoar()
        }
    }
    
    private func setupNameAndAvatoar() {
        if let id = message?.chatPartnerId() {
            let ref = Database.database().reference().child("Users").child(id)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String : Any] {
                    self.textLabel?.text = dictionary["name"] as? String
                    if dictionary["profile-image"] as? String == "not-yet-selected" {
                        self.profileImageView.backgroundColor = UIColor.clear
                        self.profileImageView.image = UIImage(systemName: "person.circle.fill")
                        self.profileImageView.tintColor = UIColor.lightGray
                        self.profileImageView.contentMode = .scaleAspectFill
                    } else {
                        if let photoString = dictionary["profile-image"] as? String {
                            self.profileImageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
                            self.profileImageView.loadImageUsingCacheWithUrlString(photoString)
                        }
                    }
                }
            }
        }
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let timeStamp : UILabel = {
        let label = UILabel()
        label.text = "10 mins"
        label.textAlignment = NSTextAlignment.right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.darkGray
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 75, y: textLabel!.frame.origin.y, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 75, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let hasSeenView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mainBlue
        view.layer.cornerRadius = 12.5
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        addSubview(hasSeenView)
        hasSeenView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        hasSeenView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 10).isActive = true
        hasSeenView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        hasSeenView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        addSubview(timeStamp)
        timeStamp.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        timeStamp.bottomAnchor.constraint(equalTo: self.hasSeenView.topAnchor, constant: -5).isActive = true
        timeStamp.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeStamp.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
