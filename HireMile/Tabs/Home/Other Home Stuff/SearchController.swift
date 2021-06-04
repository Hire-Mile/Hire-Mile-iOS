//
//  SearchController.swift
//  HireMile
//
//  Created by JJ Zapata on 3/28/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import Foundation
import FirebaseAuth
import FirebaseDatabase
import ScrollableSegmentedControl
import SDWebImage

class SearchController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let results = ["Web Design", "Car Rental", "App Design", "IT"]
    let categories = ["Auto", "Barber", "Carpentry", "Cleaning", "Moving", "Salon", "Beauty", "Technology", "Towing"]
    var keywords = [String]()
    var users = [UserStructure]()
    var allJobs = [JobStructure]()
    var justRes = [String]()
    var isSearching = true
    var allUsers = [UserProfileStructure]()
    var userres = [UserProfileStructure]()
    
    let xButton : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(xmarktouched), for: .touchUpInside)
        return button
    }()
    
    let searchView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
        view.layer.cornerRadius = 12
        return view
    }()
    
    let searchTextField : CustomTextField = {
        let tf = CustomTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Search"
        tf.tintColor = UIColor(red: 42/255, green: 38/255, blue: 38/255, alpha: 1)
        tf.textColor = UIColor.black
        tf.textAlignment = NSTextAlignment.left
        tf.backgroundColor = UIColor.clear
        tf.borderStyle = UITextField.BorderStyle.none
        tf.font = UIFont.systemFont(ofSize: 20)
        return tf
    }()
    
    let tableView : UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.separatorStyle = .none
        tableview.backgroundColor = UIColor.white
        tableview.showsVerticalScrollIndicator = false
        tableview.showsHorizontalScrollIndicator = false
        return tableview
    }()
    
    let categoriesLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Popular Categories"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 1)
        return label
    }()
    
    let resultsLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Results (0)"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 1)
        return label
    }()
    
    let segmentedControl : ScrollableSegmentedControl = {
        let segmentedControl = ScrollableSegmentedControl()
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.insertSegment(withTitle: "Services", at: 0)
        segmentedControl.insertSegment(withTitle: "People", at: 1)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.layer.masksToBounds = true
        segmentedControl.backgroundColor = UIColor.white
        segmentedControl.tintColor = UIColor.mainBlue
        segmentedControl.underlineSelected = true
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1)], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentContentColor = .red
        segmentedControl.segmentContentColor = .purple
        segmentedControl.fixedSegmentWidth = true
        return segmentedControl
    }()
    
    var mode = "services"
    
    var keyBoardBottomConstraint : NSLayoutConstraint?
    
    var bottomTableViewConstraint : NSLayoutConstraint?
    
    var categoryCollectionView : UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handle(keyboardShowNotification:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        
        self.searchTextField.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
        
        self.view.backgroundColor = UIColor.white
        
        self.searchTextField.delegate = self
        self.searchTextField.becomeFirstResponder()
        
        self.tableView.register(SearchCellKeyword.self, forCellReuseIdentifier: "SearcListCell")
        self.tableView.register(SearchProfilkeCell.self, forCellReuseIdentifier: "Saefls")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.view.addSubview(xButton)
        self.xButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.xButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        self.xButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        self.xButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.view.addSubview(searchView)
        self.searchView.centerYAnchor.constraint(equalTo: self.xButton.centerYAnchor).isActive = true
        self.searchView.leftAnchor.constraint(equalTo: self.xButton.rightAnchor, constant: 10).isActive = true
        self.searchView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        self.searchView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.searchView.addSubview(searchTextField)
        self.searchTextField.setImage(image: UIImage(systemName: "magnifyingglass")!)
        self.searchTextField.topAnchor.constraint(equalTo: self.searchView.topAnchor).isActive = true
        self.searchTextField.bottomAnchor.constraint(equalTo: self.searchView.bottomAnchor).isActive = true
        self.searchTextField.leftAnchor.constraint(equalTo: self.searchView.leftAnchor, constant: 10).isActive = true
        self.searchTextField.rightAnchor.constraint(equalTo: self.searchView.rightAnchor, constant: -20).isActive = true
        
        self.view.addSubview(segmentedControl)
        self.segmentedControl.topAnchor.constraint(equalTo: self.searchView.bottomAnchor, constant: 12).isActive = true
        self.segmentedControl.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.segmentedControl.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.segmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.pullData()
        self.pullUsers()
        
        self.view.addSubview(tableView)
        self.tableView.backgroundColor = UIColor.white
        self.tableView.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor, constant: 12).isActive = true
        self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.bottomTableViewConstraint = self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -15)
        
        self.bottomTableViewConstraint?.isActive = true

        // Do any additional setup after loading the view.
    }
    
    @objc private func handle(keyboardShowNotification notification: Notification) {
        // 1
        print("Keyboard show notification")
        
        // 2
        if let userInfo = notification.userInfo,
            // 3
            let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                let height = keyboardRectangle.height
                self.keyBoardBottomConstraint = self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -height)
                self.keyBoardBottomConstraint?.isActive = true
                self.bottomTableViewConstraint?.isActive = false
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCategoryCellID", for: indexPath) as! SearchCategoryCell
        cell.title.text = self.categories[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = 80
        let message = categories[indexPath.item]
        width = estimateFrameForText(text: message).width
        return CGSize(width: self.categories[indexPath.item].width(withConstrainedHeight: 45, font: UIFont.systemFont(ofSize: 14)) * 2, height: 45)
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.searchTextField.resignFirstResponder()
        GlobalVariables.isSearching = true
        GlobalVariables.searchCat = self.categories[indexPath.row]
        self.dismiss(animated: true, completion: nil)
    }
    
    func pullData() {
        self.allJobs.removeAll()
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
                self.allJobs.append(job)
            }
            self.allJobs.reverse()
            self.pullData2()
        }
    }
    
    func pullData2() {
        let blockedWords = ["The", "the", "a", "A", "An", "an", "this", "This", "i", "I", "need", "Need", "must", "Must", "someone", "Someone", "somebody", "Somebody", "that", "That", "can", "Can", "he", "He", "she", "She", "", " ", "and", "And", "For", "for"]
        
        // append all words from post descriptions and or titles
        for post in allJobs {
            let title = post.titleOfPost!.lowercased()
            let description = post.descriptionOfPost!.lowercased()

            let titles = title.components(separatedBy: " ")
            let descriptions = description.components(separatedBy: " ")
            
            keywords.append(contentsOf: titles)
            keywords.append(contentsOf: descriptions)
        }
        
        // remove blocked words
        for word in blockedWords {
            if keywords.contains(word) {
                keywords.removeAll(where: { $0 == word})
            }
        }
        
        keywords = keywords.removingDuplicates()
    }
    
    func pullUsers() {
        self.users.removeAll()
        Database.database().reference().child("Users").observe(.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                let user = UserProfileStructure()
                user.userid = snapshot.key
                user.username = value["username"] as? String
                user.name = value["name"] as? String
                user.userimage = value["profile-image"] as? String
                user.email = value["email"] as? String
                
                if user.userid == nil || user.username == nil || user.name == nil || user.userimage == nil || user.email == nil {
                    return
                } else {
                    self.allUsers.append(user)
                }
            }
            self.allUsers.reverse()
            self.tableView.reloadData()
        }
    }
    
    @objc func textFieldChange() {
        
        if self.mode == "services" {
            self.justRes = self.keywords.filter({$0.lowercased().prefix(self.searchTextField.text!.lowercased().count).contains(self.searchTextField.text!.lowercased())})
        } else if self.mode == "workers" {
            print("worker filter")
            self.userres = self.allUsers.filter({$0.username!.lowercased().prefix(self.searchTextField.text!.lowercased().count).contains(self.searchTextField.text!.lowercased())})
        }
        
        
        
        self.isSearching = true
        self.tableView.reloadData()
        
        if self.searchTextField.text == "" {
            self.isSearching = false
            self.tableView.reloadData()
        }
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.mode = "services"
            self.tableView.reloadData()
        } else {
            self.mode = "workers"
            self.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.mode == "services" {
            if self.isSearching {
                self.resultsLabel.text = "Results (\(self.justRes.count))"
                return self.justRes.count
            }
            return self.allJobs.count
        } else {
            if self.isSearching {
                self.resultsLabel.text = "Results (\(self.allUsers.count))"
                return self.userres.count
            }
            return self.allUsers.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.mode == "services" {
            return 50
        } else {
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.mode == "services" {
            if self.isSearching {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SearcListCell", for: indexPath) as! SearchCellKeyword
//                cell.titleImageView.loadImage(from: URL(string: self.justRes[indexPath.row].imagePost!)!)
//                cell.titleLabel.text = self.justRes[indexPath.row].titleOfPost!
//                cell.postId = self.justRes[indexPath.row].postId!
//                if self.justRes[indexPath.row].typeOfPrice == "Hourly" {
//                    cell.priceTag.text = "$\(self.justRes[indexPath.row].price!) / Hour"
//                } else {
//                    cell.priceTag.text = "$\(self.justRes[indexPath.row].price!)"
//                }
                
                cell.textLabel?.text = justRes[indexPath.row].capitalized
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SearcListCell", for: indexPath) as! SearchCellKeyword
//                cell.backgroundColor = .white
//                cell.titleImageView.loadImage(from: URL(string: self.allJobs[indexPath.row].imagePost!)!)
//                cell.titleLabel.text = self.allJobs[indexPath.row].titleOfPost!
//                cell.desscription.text = self.allJobs[indexPath.row].descriptionOfPost!
//                cell.postId = self.allJobs[indexPath.row].postId!
//                if self.allJobs[indexPath.row].typeOfPrice == "Hourly" {
//                    cell.priceTag.text = "$\(self.allJobs[indexPath.row].price!) / Hour"
//                } else {
//                    cell.priceTag.text = "$\(self.allJobs[indexPath.row].price!)"
//                }
                
                cell.textLabel?.text = keywords[indexPath.row].capitalized
                
                return cell
            }
        } else {
            if self.isSearching {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Saefls", for: indexPath) as! SearchProfilkeCell
                cell.labelName.text = self.userres[indexPath.row].name ?? "Deleted User"
                
                cell.profileImageView.sd_setImage(with: URL(string: self.userres[indexPath.row].userimage ?? "error")!, placeholderImage: nil, options: .retryFailed, completed: nil)
                cell.labelInfo.text = self.userres[indexPath.row].email ?? "Hiremile User"
                
                var numberOfPosts = 0
                Database.database().reference().child("Jobs").observe(.childAdded, with: { (jobSnap) in
                    if let value = jobSnap.value as? [String : Any] {
                        let job = JobStructure()
                        job.authorName = value["author"] as? String ?? "Error"
                        if job.authorName == self.userres[indexPath.row].userid! {
                            numberOfPosts += 1
                        }
                    }
                    cell.labelInfo.text = "\(self.userres[indexPath.row].username ?? "Hiremile User") | \(numberOfPosts) Skills"
                })
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Saefls", for: indexPath) as! SearchProfilkeCell
                cell.labelName.text = self.allUsers[indexPath.row].name ?? "Deleted User"
                cell.labelInfo.text = self.allUsers[indexPath.row].email ?? "Hiremile User"
                cell.profileImageView.sd_setImage(with: URL(string: self.allUsers[indexPath.row].userimage ?? "error")!, placeholderImage: nil, options: .retryFailed, completed: nil)
                
                var numberOfPosts = 0
                Database.database().reference().child("Jobs").observe(.childAdded, with: { (jobSnap) in
                    if let value = jobSnap.value as? [String : Any] {
                        let job = JobStructure()
                        job.authorName = value["author"] as? String ?? "Error"
                        if job.authorName == self.allUsers[indexPath.row].userid! {
                            numberOfPosts += 1
                        }
                    }
                    cell.labelInfo.text = "\(self.allUsers[indexPath.row].username ?? "Hiremile User") | \(numberOfPosts) Skills"
                })
                
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.mode == "services" {
            if self.isSearching {
                let controller = SearchResults()
                controller.modalPresentationStyle = .fullScreen
                controller.keyword = self.justRes[indexPath.row]
                self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
            } else {
                let controller = SearchResults()
                controller.modalPresentationStyle = .fullScreen
                controller.keyword = self.keywords[indexPath.row]
                self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
            }
        } else {
            if self.searchTextField.text == "" {
                self.dismiss(animated: true) {
                    GlobalVariables.userPresentationId = self.allUsers[indexPath.row].userid!
                    GlobalVariables.presentToUserProfile = true
                }
            }
            if self.isSearching {
                self.dismiss(animated: true) {
                    GlobalVariables.userPresentationId = self.userres[indexPath.row].userid!
                    GlobalVariables.presentToUserProfile = true
                }
            } else {
                self.dismiss(animated: true) {
                    GlobalVariables.userPresentationId = self.allUsers[indexPath.row].userid!
                    GlobalVariables.presentToUserProfile = true
                }
            }
        }
    }
    
    @objc func xmarktouched () {
        navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("returning")
        self.keyBoardBottomConstraint?.isActive = false
        self.bottomTableViewConstraint?.isActive = true
        textField.resignFirstResponder()
        self.view.frame.origin.y = 0
        return (true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.keyBoardBottomConstraint?.isActive = false
        self.bottomTableViewConstraint?.isActive = true
        self.view.frame.origin.y = 0
        self.view.endEditing(true)
    }

}

class SearchCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        //
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class SearchCategoryCell: UICollectionViewCell {
    
    let title : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.numberOfLines = 2
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let mainView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 245/255, green: 254/255, blue: 255, alpha: 1)
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = .white
        
        self.addSubview(self.mainView)
        self.mainView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        self.mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        self.mainView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        self.mainView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        

        self.mainView.addSubview(title)
        self.title.bottomAnchor.constraint(equalTo: self.mainView.bottomAnchor, constant: -3).isActive = true
        self.title.topAnchor.constraint(equalTo: self.mainView.topAnchor, constant: 3).isActive = true
        self.title.rightAnchor.constraint(equalTo: self.mainView.rightAnchor, constant: -3).isActive = true
        self.title.leftAnchor.constraint(equalTo: self.mainView.leftAnchor, constant: 3).isActive = true
    }
    
}


class CustomTextField : UITextField {
    
    var clearButton : UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

//        self.clearButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 15, height: 15)))
//        clearButton?.setImage(UIImage(systemName: "xmark")!, for: .normal)
//
//        self.rightView = clearButton
//        clearButton?.addTarget(self, action: #selector(clearClicked), for: .touchUpInside)
//
//        self.clearButtonMode = .never
//        self.rightViewMode = .always
    }

    @objc func clearClicked() {
        self.text = ""
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


class SearchProfilkeCell: UITableViewCell {
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 75, y: self.contentView.frame.height / 3, width: textLabel!.frame.width, height: textLabel!.frame.height)
    }
    
    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let labelName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Name"
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let labelInfo: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Followers - Services"
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.lightGray
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let sideMenuArrow : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.right")
        iv.tintColor = UIColor.lightGray
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(labelName)
        addSubview(sideMenuArrow)
        addSubview(labelInfo)
    
        textLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        
        self.selectionStyle = .none
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        sideMenuArrow.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        sideMenuArrow.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        sideMenuArrow.widthAnchor.constraint(equalToConstant: 20).isActive = true
        sideMenuArrow.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        labelName.leftAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: 20).isActive = true
        labelName.rightAnchor.constraint(equalTo: self.sideMenuArrow.leftAnchor, constant: -12).isActive = true
        labelName.topAnchor.constraint(equalTo: self.topAnchor, constant: 25).isActive = true
        labelName.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        labelInfo.leftAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: 20).isActive = true
        labelInfo.rightAnchor.constraint(equalTo: self.sideMenuArrow.leftAnchor, constant: -12).isActive = true
        labelInfo.topAnchor.constraint(equalTo: self.labelName.bottomAnchor, constant: 5).isActive = true
        labelInfo.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class UserProfileStructure: NSObject {
    
    var username : String?
    var name : String?
    var userid : String?
    var userfollowers : String?
    var userservices : Int?
    var userimage : String?
    var email : String?
    
}


class SearchCellKeyword : UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = UIColor.white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
