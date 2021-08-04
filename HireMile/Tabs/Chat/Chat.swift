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
import ScrollableSegmentedControl
import SDWebImage
class Chat: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cashInAlert = CashInAlert()
    
    let titles = ["Style", "Style"]
    let descriptions = ["Message", "Message"]
    var tTimer : Timer?
    
//    let messageTitles = ["Name", "Name"]
//    let messageDescriptions = ["Message", "Message"]
        
    private let refrshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.black
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        return refreshControl
    }()
    
//    let segmentedControl : UISegmentedControl = {
//        let segmentedControl = UISegmentedControl()
//        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
//        segmentedControl.insertSegment(withTitle: "Messages", at: 0, animated: true)
//        segmentedControl.insertSegment(withTitle: "Notifications", at: 1, animated: true)
//        segmentedControl.selectedSegmentIndex = 0
//        segmentedControl.layer.cornerRadius = 20
//        segmentedControl.layer.borderColor = UIColor(red: 241/255, green: 239/255, blue: 239/255, alpha: 1).cgColor
//        segmentedControl.layer.borderWidth = 2
//        segmentedControl.layer.masksToBounds = true
//        segmentedControl.backgroundColor = UIColor.mainBlue
//        segmentedControl.setBackgroundImage(UIImage(named: "whiteback"), for: .normal, barMetrics: .default)
//        segmentedControl.setBackgroundImage(UIImage(named: "mainBlue"), for: .selected, barMetrics: .default)
//        segmentedControl.tintColor = UIColor.mainBlue
//        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1)], for: .normal)
//        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
//        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
//        return segmentedControl
//    }()
    
    let segmentedControl : ScrollableSegmentedControl = {
        let segmentedControl = ScrollableSegmentedControl()
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.insertSegment(withTitle: "Messages", at: 0)
        segmentedControl.insertSegment(withTitle: "Notifications", at: 1)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.layer.masksToBounds = true
        segmentedControl.backgroundColor = UIColor.white
        segmentedControl.tintColor = UIColor.mainBlue
        segmentedControl.underlineSelected = true
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 19), NSAttributedString.Key.foregroundColor: UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1)], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 19), NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentContentColor = .blue
        segmentedControl.segmentContentColor = .purple
        segmentedControl.fixedSegmentWidth = false
        return segmentedControl
    }()
    
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.white
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
        image.image = UIImage(named: "not-message")
        image.contentMode = .scaleAspectFit
        image.tintColor = UIColor.mainBlue
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let mainText : UILabel = {
        let label = UILabel()
        label.text = "No messages yet"
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let descText : UILabel = {
        let label = UILabel()
        label.text = "When people contact you about your items on HireMile, you'll see them here!"
        label.numberOfLines = 5
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.showsVerticalScrollIndicator = false
        
        self.mainText.text = "You have no messages"
        self.descText.text = "When people contact you about your items on HireMile, you'll see them here!"
        
        navigationItem.backButtonTitle = " "
        
        self.view.addSubview(segmentedControl)
        self.segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        self.segmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.segmentedControl.widthAnchor.constraint(equalToConstant: 240).isActive = true
        self.segmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(tableView)
        self.tableView.separatorStyle = .none
        self.tableView.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor, constant: 20).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
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
        
        self.view.backgroundColor = UIColor.white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refrshControl
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.register(NotificationCell.self, forCellReuseIdentifier: "myNotificationsCellID")
        tableView.register(MessagesCellCell.self, forCellReuseIdentifier: "myMessagesCellID")
        
        observeMessages()
        
        observeNotificaations()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.items?.last?.badgeValue = nil
        
        self.tabBarController?.tabBar.isHidden = false
        
        self.view.backgroundColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        tTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(supposedToDelete), userInfo: nil, repeats: true)
    }
    
    var messages = [Message]()
    var messagesDictionary = [String : Message]()
    
    var notifications = [NotificationObject]()
    
    func observeNotificaations() {
        self.notifications.removeAll()
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("Notifcations").observe(.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                let notification = NotificationObject()
                notification.title = value["title"] as? String ?? "Error"
                notification.body = value["description"] as? String ?? "Error"
                notification.senderId = value["author"] as? String ?? "Error"
                notification.image = value["image"] as? String ?? "Error"
                notification.postId = value["postId"] as? String ?? "Error"
                notification.date = value["timestamp"] as? Int ?? 0
                self.notifications.append(notification)
            }
            let hello = self.notifications.sorted(by: { $1.date! < $0.date! } )
            self.notifications.removeAll()
            self.notifications = hello
            self.tableView.reloadData()
        }
    }
    
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
            if self.messages.count == 0 {
                self.emptyView.alpha = 1
                self.tableView.alpha = 0
            } else {
                self.emptyView.alpha = 0
                self.tableView.alpha = 1
            }
            return self.messages.count
        } else if segmentedControl.selectedSegmentIndex == 1 {
            if self.notifications.count == 0 {
                self.emptyView.alpha = 1
                self.tableView.alpha = 0
            } else {
                self.emptyView.alpha = 0
                self.tableView.alpha = 1
            }
            return self.notifications.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segmentedControl.selectedSegmentIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myMessagesCellID", for: indexPath) as! MessagesCellCell
            
            let message = messages[indexPath.row]
            cell.message = message

            if let uid = Auth.auth().currentUser?.uid {
                if cell.message?.toId == uid {
                    // maybe blue, depends on viewage
                    if cell.message?.hasViewed == true {
                        // extract blue
                        cell.backgroundColor = .white
                        cell.isRead()
                    } else {
                        // keep blue
                        print("again2")
                        cell.backgroundColor = .white
                        cell.isUnread()
                    }
                } else {
                    // extract blue, not recipient
                    print("again3")
                    cell.backgroundColor = .white
                    cell.isRead()
                }
            }
            
            cell.profileButton.addTarget(self, action: #selector(mapsHit), for: .touchUpInside)
            cell.profileButton.tag = indexPath.row
            
            return cell
        } else if segmentedControl.selectedSegmentIndex == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myNotificationsCellID", for: indexPath) as! NotificationCell
            if let title = self.notifications[indexPath.row].title {
                cell.textLabel?.text = title
            }
            if let body = self.notifications[indexPath.row].body {
                cell.detailTextLabel?.text = body
            }
            if let timestamp = self.notifications[indexPath.row].date {
                let date = Date(timeIntervalSince1970: Double(timestamp))
                let string = date.toStringWithRelativeTime()
                cell.timeStamp.text = string
            }
            let itemNumber = NSNumber(value: indexPath.row)
            if let image = self.notifications[indexPath.row].senderId {
                
                Database.database().reference().child("Users").child(image).child("profile-image").observe(.value) { (snapshot) in
                    if let imageurl = snapshot.value as? String {
                        cell.profileImageView.sd_setImage(with: URL(string: imageurl), placeholderImage: nil, options: .retryFailed, completed: nil)
                    }
                }
            }
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            cell.detailTextLabel?.isHidden = false
            cell.detailTextLabel?.textColor = UIColor.darkGray
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myJobsCellID", for: indexPath) as! MyJobsRunningCell
            return cell
        }
    }
    
    @objc func mapsHit(sender: UIButton) {
        let index = sender.tag
        Database.database().reference().child("Users").child(self.messages[index].chatPartnerId()!).observe(.value) { (snapshot) in
            let profileUID : String = (snapshot.key as? String)!
            if let profileVC = CommonUtils.getStoryboardVC(StoryBoard.Profile.rawValue, vcIdetifier: UserProfileViewController.className) as? UserProfileViewController {
                profileVC.userUID = profileUID
                self.navigationController?.pushViewController(profileVC,  animated: true)
            }
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
            
            GlobalVariables.indexToDelete = indexPath.row
            
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
            if let user = self.notifications[indexPath.row].senderId {
                if let profileVC = CommonUtils.getStoryboardVC(StoryBoard.Profile.rawValue, vcIdetifier: UserProfileViewController.className) as? UserProfileViewController {
                    profileVC.userUID = user
                    self.navigationController?.pushViewController(profileVC,  animated: true)
                }
            }
        } else {
            //
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            let message = self.messages[indexPath.row]
            if let chatPartnerId = message.chatPartnerId() {
                Database.database().reference().child("User-Messages").child(uid).child(chatPartnerId).removeValue { (error, ref) in
                    Database.database().reference().child("User-Messages").child(chatPartnerId).child(uid).removeValue { (error, ref) in
                        if error != nil {
                            print("error deleting message: \(error!.localizedDescription)")
                        } else {
                            print("success")
                            self.messages.remove(at: indexPath.row)
                            self.tableView.deleteRows(at: [indexPath], with: .automatic)
                        }
                    }
                }
            }
        } else {
            print(self.notifications[indexPath.row].postId!)
            Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("Notifcations").child(self.notifications[indexPath.row].postId!).removeValue { (error, ref) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
            self.notifications.remove(at: indexPath.row)
            self.viewDidLoad()
        }
        
    }
    
    @objc func supposedToDelete() {
        if GlobalVariables.isDeleting == true {
            let indexToDelete = GlobalVariables.indexToDelete
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            let message = self.messages[indexToDelete]
            if let chatPartnerId = message.chatPartnerId() {
                Database.database().reference().child("User-Messages").child(uid).child(chatPartnerId).removeValue { (error, ref) in
                    if error != nil {
                        print("error deleting message: \(error!.localizedDescription)")
                    } else {
                        print("success")
                    }
                    GlobalVariables.isDeleting = false
                    self.messages.removeAll()
                    self.tableView.reloadData()
                    self.viewWillAppear(true)
                }
            }
        }
    }
    
    func showChatControllerForUser(_ user: UserChat) {
      /*  let chatLogController = ChatLogController2(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
      */
        if let VC = CommonUtils.getStoryboardVC(StoryBoard.Chat.rawValue, vcIdetifier: ChatVC.className) as? ChatVC {
             VC.hidesBottomBarWhenPushed = true
            VC.userOther = user
             self.navigationController?.pushViewController(VC,  animated: true)
         }
    }
    
    @objc func refreshAction() {
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(hideRefrsh), userInfo: nil, repeats: false)
    }
    
    @objc func hideRefrsh() {
        self.refrshControl.endRefreshing()
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.mainText.text = "You have no messages"
            self.descText.text = "When people contact you about your items on HireMile, you'll see them here!"
            self.bubbleImage.image = UIImage(named: "not-message")
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.tableView.alpha = 1
            } completion: { (complete) in
                if complete {
                    self.emptyView.alpha = 0
                    self.tableView.reloadData()
                }
            }
        } else {
            self.mainText.text = "You have no notifications"
            self.descText.text = "When HireMile sends info about activity or opportunities, you can find them here!"
            self.bubbleImage.image = UIImage(named: "not-notification")
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.tableView.alpha = 0
            } completion: { (complete) in
                if complete {
                    self.emptyView.alpha = 1
                    self.tableView.reloadData()
                }
            }
        }
    }

}

class NotificationCell: UITableViewCell {
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 75, y: textLabel!.frame.origin.y, width: ((self.frame.width - 75) - 90), height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 75, y: detailTextLabel!.frame.origin.y + 2, width: ((self.frame.width - 75) - 30), height: detailTextLabel!.frame.height)
        selectionStyle = .none
        
        self.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        self.detailTextLabel?.isHidden = false
        self.detailTextLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        self.detailTextLabel?.textColor = UIColor.darkGray
    }
    
    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let timeStamp : UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textColor = UIColor.darkGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        addSubview(timeStamp)
        timeStamp.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        timeStamp.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -5).isActive = true
        timeStamp.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeStamp.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
//        textLabel?.rightAnchor.constraint(equalTo: timeStamp.leftAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MessagesCellCell: UITableViewCell {
    
    private let cache = NSCache<NSNumber, UIImage>()
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    
    var message : Message? {
        didSet {
            self.profileImageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
            
            self.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            self.detailTextLabel?.isHidden = false
            self.detailTextLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
            self.detailTextLabel?.textColor = UIColor.darkGray
            
            self.detailTextLabel?.text = message?.text
            
            if let seconds = message?.timestamp?.doubleValue {
                let date = Date(timeIntervalSince1970: Double(seconds))
                let string = date.toStringWithRelativeTime()
                timeStamp.text = string
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
                            self.profileImageView.sd_setImage(with: URL(string: photoString), completed: nil)
                        }
                    }
                }
            }
        }
    }
    
    let profileButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let timeStamp : UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textColor = UIColor.darkGray
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 75, y: textLabel!.frame.origin.y, width: self.frame.width-150, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 75, y: detailTextLabel!.frame.origin.y + 2, width: ((self.frame.width - 75) - 30), height: detailTextLabel!.frame.height)
        selectionStyle = .none
    }
    
    let hasSeenView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        view.layer.cornerRadius = 12.5
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let numberLabel : UILabel = {
        let label = UILabel()
        label.text = "1+"
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    var isUnreadConstraints = [NSLayoutConstraint]()
    var isReadConstraints = [NSLayoutConstraint]()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        contentView.addSubview(profileButton)
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        profileButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        profileButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        hasSeenView.addSubview(numberLabel)
        numberLabel.topAnchor.constraint(equalTo: hasSeenView.topAnchor).isActive = true
        numberLabel.bottomAnchor.constraint(equalTo: hasSeenView.bottomAnchor).isActive = true
        numberLabel.leftAnchor.constraint(equalTo: hasSeenView.leftAnchor).isActive = true
        numberLabel.rightAnchor.constraint(equalTo: hasSeenView.rightAnchor).isActive = true
        
        self.isUnreadConstraints = [
                                    hasSeenView.centerYAnchor.constraint(equalTo: self.profileImageView.topAnchor, constant: 5),
                                    hasSeenView.centerXAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: -5),
                                    hasSeenView.widthAnchor.constraint(equalToConstant: 25),
                                    hasSeenView.heightAnchor.constraint(equalToConstant: 25),
            
                                    timeStamp.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
                                    timeStamp.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -5),
                                    timeStamp.widthAnchor.constraint(equalToConstant: 100),
                                    timeStamp.heightAnchor.constraint(equalToConstant: 15)
                                ]
            
        self.isReadConstraints = [
                                    timeStamp.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
                                    timeStamp.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -5),
                                    timeStamp.widthAnchor.constraint(equalToConstant: 100),
                                    timeStamp.heightAnchor.constraint(equalToConstant: 15)
                                ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isUnread() {
        self.addSubview(timeStamp)
        self.addSubview(hasSeenView)
        NSLayoutConstraint.deactivate(self.isReadConstraints)
        NSLayoutConstraint.activate(self.isUnreadConstraints)
    }
    
    func isRead() {
        self.addSubview(timeStamp)
        self.hasSeenView.removeFromSuperview()
        NSLayoutConstraint.deactivate(self.isUnreadConstraints)
        NSLayoutConstraint.activate(self.isReadConstraints)
    }
    
    func mapsHit(sender: UIButton){
            let indexPathOfThisCell = sender.tag
            print("This button is at \(indexPathOfThisCell) row")
            // get indexPath.row from cell
            // do something with it

        }
}
