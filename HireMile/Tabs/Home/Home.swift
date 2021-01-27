//
//  Home.swift
//  HireMile
//
//  Created by JJ Zapata on 11/16/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit
import SideMenu
import Firebase
import Kingfisher
import FirebaseAuth
import FirebaseDatabase
import MBProgressHUD

class Home: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let imageArray = ["barber", "hair-salon", "nail", "cleaning", "Towing", "phone", "moving", "Carpentry"]
    let titles = ["Barbers", "Salons", "Nails", "Cleaning", "Auto", "Technology", "Moving", "Carpenter"]
    
    let imagePicker = UIImagePickerController()
    var timer : Timer?
    var estimateWidth = 160.0
    var cellMarginSize = 16.0
    var allJobs = [JobStructure]()
    var passingImage : UIImage?
    var openingFromNotification = false
    
    private let refrshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.black
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        return refreshControl
    }()
    
    let searchButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let menuButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "36775"), for: .normal)
        button.addTarget(self, action: #selector(sideMenuTappped), for: .touchUpInside)
        return button
    }()
    
    let searchView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        return view
    }()
    
    let searchImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = UIColor.lightGray
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let searchLabel : UILabel = {
        let label = UILabel()
        label.text = "Search Services"
        label.textColor = UIColor.lightGray
        label.textAlignment = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let categoriesLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Browse by category"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.black
        return label
    }()
    
    var categoryCollectionView : UICollectionView?
    
    lazy var slideInMenu : CGFloat = self.view.frame.width  * 0.30
    
    var isSlideInMenuPresented = false
    
    var menu : SideMenuNavigationController?
    
    var myCollectionView : UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pushManager = PushNotificationManager(userID: Auth.auth().currentUser!.uid)
        pushManager.registerForPushNotifications()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 60, height: 60)
        
        myCollectionView = UICollectionView(frame: CGRect(x: 6, y: 290, width: self.view.frame.width - 12, height: self.view.frame.height - 325), collectionViewLayout: layout)
        myCollectionView?.register(HomeCell.self, forCellWithReuseIdentifier: "MyCell")
        myCollectionView?.backgroundColor = UIColor.white
        myCollectionView?.dataSource = self
        myCollectionView?.delegate = self
        view.addSubview(myCollectionView ?? UICollectionView())
        myCollectionView?.refreshControl = refrshControl
        
        let layou2: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layou2.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layou2.scrollDirection = .horizontal
        
        self.categoryCollectionView = UICollectionView(frame: CGRect(x: 20, y: 155, width: self.view.frame.width - 40, height: 115), collectionViewLayout: layou2)
        self.categoryCollectionView!.translatesAutoresizingMaskIntoConstraints = false
        self.categoryCollectionView!.backgroundColor = UIColor.white
        self.categoryCollectionView!.alwaysBounceVertical = false
        self.categoryCollectionView!.alwaysBounceHorizontal = true
        self.categoryCollectionView!.dataSource = self
        self.categoryCollectionView!.showsHorizontalScrollIndicator = false
        self.categoryCollectionView!.showsVerticalScrollIndicator = false
        self.categoryCollectionView!.delegate = self
        self.categoryCollectionView!.register(HomeCategoryCell.self, forCellWithReuseIdentifier: "CategoryCellID")
        view.addSubview(self.categoryCollectionView!)
        
        // Functions to throw
        self.addSubviews()
        self.addConstraints()
        self.menuSetup()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFunction), userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.observeMessages()
        
        if self.openingFromNotification == true {
            print("opening from notfication")
            let alert = UIAlertController(title: "help", message: "help[[ ehelp", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            self.openingFromNotification = false
        } else {
            print("no hahah")
        }
        
        if GlobalVariables.finishedFeedback == true {
            let alert = UIAlertController(title: "Success", message: "Thanks for your feedback!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                GlobalVariables.isDeleting = true
                print(GlobalVariables.indexToDelete)
                GlobalVariables.finishedFeedback = false
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        // Functions to throw
        self.basicSetup()
        
        self.setupCategory()
        
        self.view = view
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setupGrid()
        DispatchQueue.main.async {
            self.myCollectionView?.reloadData()
        }
    }
    
    func addSubviews() {
        self.view.addSubview(menuButton)
        self.view.addSubview(searchView)
        self.view.addSubview(searchImage)
        self.view.addSubview(searchLabel)
        self.view.addSubview(searchButton)
        self.view.addSubview(categoriesLabel)
    }
    
    func addConstraints() {
        
        self.menuButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 65).isActive = true
        self.menuButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.menuButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.menuButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.searchView.leftAnchor.constraint(equalTo: self.menuButton.rightAnchor, constant: 20).isActive = true
        self.searchView.centerYAnchor.constraint(equalTo: self.menuButton.centerYAnchor).isActive = true
        self.searchView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.searchView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        
        self.searchImage.widthAnchor.constraint(equalToConstant: 25).isActive = true
        self.searchImage.heightAnchor.constraint(equalToConstant: 25).isActive = true
        self.searchImage.leftAnchor.constraint(equalTo: self.searchView.leftAnchor, constant: 20).isActive = true
        self.searchImage.centerYAnchor.constraint(equalTo: self.searchView.centerYAnchor).isActive = true
        
        self.searchLabel.leftAnchor.constraint(equalTo: self.searchImage.rightAnchor, constant: 10).isActive = true
        self.searchLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        self.searchLabel.rightAnchor.constraint(equalTo: self.searchView.rightAnchor, constant: 10).isActive = true
        self.searchLabel.centerYAnchor.constraint(equalTo: self.searchView.centerYAnchor).isActive = true
        
        self.searchButton.topAnchor.constraint(equalTo: self.searchView.topAnchor, constant: 0).isActive = true
        self.searchButton.rightAnchor.constraint(equalTo: self.searchView.rightAnchor).isActive = true
        self.searchButton.leftAnchor.constraint(equalTo: self.searchView.leftAnchor).isActive = true
        self.searchButton.bottomAnchor.constraint(equalTo: self.searchView.bottomAnchor).isActive = true
        
        self.categoriesLabel.topAnchor.constraint(equalTo: self.searchView.bottomAnchor, constant: 15).isActive = true
        self.categoriesLabel.leftAnchor.constraint(equalTo: self.menuButton.leftAnchor).isActive = true
        self.categoriesLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.categoriesLabel.rightAnchor.constraint(equalTo: self.searchView.rightAnchor).isActive = true
    }
    
    func basicSetup() {
        self.view.backgroundColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = true
        navigationItem.backButtonTitle = " "
    }
    
    @objc func setupCategory() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
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
            self.myCollectionView?.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
            self.refrshControl.endRefreshing()
        }

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return (true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == self.myCollectionView {
            return 1
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.myCollectionView {
            return self.allJobs.count
        } else {
            return self.titles.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.myCollectionView {
            let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! HomeCell
            myCell.firstServiceButton.addTarget(self, action: #selector(servicePressed), for: .touchUpInside)
            
            if let url = self.allJobs[indexPath.row].imagePost {
                myCell.firstServiceImage.loadImageUsingCacheWithUrlString(url)
            }
            
            myCell.firstTitle.text = self.allJobs[indexPath.row].titleOfPost!
            if self.allJobs[indexPath.row].typeOfPrice == "Hourly" {
                myCell.firstPrice.text = "$\(self.allJobs[indexPath.row].price!) / Hour"
            } else {
                myCell.firstPrice.text = "$\(self.allJobs[indexPath.row].price!)"
            }
            myCell.backgroundColor = UIColor.white
            return myCell
        } else if collectionView == self.categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCellID", for: indexPath) as! HomeCategoryCell
            cell.title.text = self.titles[indexPath.row]
            cell.imageView.image = UIImage(named: self.imageArray[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCellID", for: indexPath) as! HomeCategoryCell
            cell.title.text = self.titles[indexPath.row]
            cell.imageView.image = UIImage(named: self.imageArray[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.myCollectionView {
            GlobalVariables.postImage2.loadImageUsingCacheWithUrlString(self.allJobs[indexPath.row].imagePost!)
            GlobalVariables.postImageDownlodUrl = self.allJobs[indexPath.row].imagePost!
            GlobalVariables.postTitle = self.allJobs[indexPath.row].titleOfPost!
            GlobalVariables.postDescription = self.allJobs[indexPath.row].descriptionOfPost!
            GlobalVariables.postPrice = self.allJobs[indexPath.row].price!
            GlobalVariables.userUID = self.allJobs[indexPath.row].authorName!
            GlobalVariables.authorId = self.allJobs[indexPath.row].authorName!
            GlobalVariables.postId = self.allJobs[indexPath.row].postId!
            GlobalVariables.type = self.allJobs[indexPath.row].typeOfPrice!
            self.navigationController?.pushViewController(ViewPostController(), animated: true)
        } else {
            let controller = CategoryPostController()
            controller.category = self.titles[indexPath.row]
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.myCollectionView {
            let width = self.calculateWidth()
            return CGSize(width: width, height: width)
        } else {
            return CGSize(width: 90, height: 115)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func calculateWidth() -> CGFloat {
        let estimatedWidth = CGFloat(estimateWidth)
        let cellCount = floor(CGFloat(self.view.frame.size.width / estimatedWidth))
        let margin = CGFloat(cellMarginSize * 2)
        let width = (self.view.frame.size.width - CGFloat(cellMarginSize) * (cellCount - 1) - margin) / cellCount
        return width
    }
    
    func setupGrid() {
        let flow = myCollectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumInteritemSpacing = CGFloat(self.cellMarginSize)
        flow.minimumLineSpacing = CGFloat(self.cellMarginSize)
    }
    
    func menuSetup() {
        menu = SideMenuNavigationController(rootViewController: MenuListController())
        menu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    @objc func sideMenuTappped() {
        self.present(menu!, animated: true, completion: nil)
    }
    
    @objc func servicePressed() {
        navigationController?.pushViewController(ViewPostController(), animated: true)
    }
    
    @objc func seeAllPressed() {
        navigationController?.pushViewController(CategoryPostController(), animated: true)
    }
    
    func seeAllPressedRow() {
        navigationController?.pushViewController(CategoryPostController(), animated: true)
    }
    
    @objc func refreshAction() {
        self.setupCategory()
    }
    
    @objc func searchButtonPressed() {
        let controller = SearchController()
        controller.modalPresentationStyle = .overFullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func timerFunction() {
        if GlobalVariables.presentToCat == true {
            
            GlobalVariables.postImage2.loadImageUsingCacheWithUrlString(GlobalVariables.catId.imagePost!)
            let url = URL(string: GlobalVariables.catId.imagePost!)
            GlobalVariables.imagePost.kf.setImage(with: url)
            GlobalVariables.postTitle = GlobalVariables.catId.titleOfPost!
            GlobalVariables.postDescription = GlobalVariables.catId.descriptionOfPost!
            GlobalVariables.postPrice = GlobalVariables.catId.price!
            GlobalVariables.authorId = GlobalVariables.catId.authorName!
            GlobalVariables.postId = GlobalVariables.catId.postId!
            GlobalVariables.type = GlobalVariables.catId.typeOfPrice!
            self.navigationController?.pushViewController(ViewPostController(), animated: true)
            GlobalVariables.presentToCat = false
            GlobalVariables.catId = JobStructure()
        }
        
        if GlobalVariables.isGoingToPost == true {
            let alert = UIAlertController(title: "Choose Your Source", message: "Where should you get your cover photo from?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.allowsEditing = true
                self.imagePicker.delegate = self
                self.present(self.imagePicker, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            GlobalVariables.isGoingToPost = false
        }
        
        if self.passingImage != nil {
            GlobalVariables.postImage = passingImage!
            let controller = Post()
            controller.modalPresentationStyle = .fullScreen
            timer?.invalidate()
            self.present(controller, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            self.passingImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            self.passingImage = originalImage
        }
        dismiss(animated: true, completion: nil)
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
                print("featcu")
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
    
    var ssstimer : Timer?
    
    func attemptReloadData() {
        self.ssstimer?.invalidate()
        self.ssstimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReload), userInfo: nil, repeats: false)
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
            print("reload")
            self.reloadData()
        })
    }
    
    func reloadData() {
        for message in self.messages {
            if message.hasViewed == false {
                if let uid = Auth.auth().currentUser?.uid {
                    if message.toId == uid {
                        // maybe blue, depends on viewage
                        if message.hasViewed == true {
                            print("has viewed is true")
                            // extract blue
                        } else {
                            print("has viewed is NOT true")
                            // keep blue
                            tabBarController?.tabBar.items?.last?.badgeValue = "1"
                        }
                    } else {
                        // extract blue, not recipient
                    }
                }
            }
        }
    }

}

class HomeCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    let firstServiceView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 30
        view.layer.shadowOpacity = 0.09
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let firstServiceImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.image = UIImage(named: "working")
        imageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return imageView
    }()
    
    let firstLocationLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .heavy)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "1 Mile Away"
        return label
    }()
    
    let firstTitle : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 87/255, green: 87/255, blue: 87/255, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.text = "Title"
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    let firstPrice : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 13, weight: .heavy)
        label.text = "Price"
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    let firstServiceButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
    }
    
    func setup() {
        
        addSubview(firstServiceView)
        firstServiceView.anchor(top: topAnchor, paddingTop: 10, bottom: bottomAnchor, paddingBottom: -10, left: leftAnchor, paddingLeft: 10, right: rightAnchor, paddingRight: -10, width: 0, height: 0)
        
        firstServiceView.addSubview(firstServiceImage)
        firstServiceImage.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        firstServiceImage.layer.cornerRadius = 15
        firstServiceImage.clipsToBounds = true
        firstServiceImage.anchor(top: firstServiceView.topAnchor, paddingTop: 0, bottom: firstServiceView.bottomAnchor, paddingBottom: -50, left: firstServiceView.leftAnchor, paddingLeft: 0, right: firstServiceView.rightAnchor, paddingRight: 0, width: 0, height: 0)
        
        firstServiceView.addSubview(firstLocationLabel)
        firstLocationLabel.anchor(top: firstServiceView.topAnchor, paddingTop: 5, bottom: firstServiceView.bottomAnchor, paddingBottom: -125, left: firstServiceView.leftAnchor, paddingLeft: 6, right: firstServiceView.rightAnchor, paddingRight: 0, width: 0, height: 0)
        
        firstServiceView.addSubview(firstTitle)
        firstTitle.anchor(top: firstServiceImage.bottomAnchor, paddingTop: 5, bottom: firstServiceView.bottomAnchor, paddingBottom: -25, left: firstServiceView.leftAnchor, paddingLeft: 6, right: firstServiceView.rightAnchor, paddingRight: 6, width: 0, height: 0)
        
        firstServiceView.addSubview(firstPrice)
        firstPrice.anchor(top: firstTitle.bottomAnchor, paddingTop: 0, bottom: firstServiceView.bottomAnchor, paddingBottom: -7, left: firstServiceView.leftAnchor, paddingLeft: 6, right: firstServiceView.rightAnchor, paddingRight: 6, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class MenuListController: UITableViewController {
    
    var allRatings = [Int]()
    
    var finalRating = 0
    
    var ratingNumber = 0
    
    var rating
        = 0
    
    var findingRating = true
    
    let items = ["Recent", "My Jobs", "My Reviews", "Favorites", "Settings", "Sign Out"]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        tableView.separatorColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "sideMenuCellNormal")
        tableView.register(SideMenuCell.self, forCellReuseIdentifier: "sideMenuCellProfile")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return items.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sideMenuCellProfile", for: indexPath) as! SideMenuCell
            
            // find image
            Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("profile-image").observe(.value) { (snapshot) in
                let profileImageString : String = (snapshot.value as? String)!
                if profileImageString == "not-yet-selected" {
                    cell.profileImage.image = UIImage(systemName: "person.circle.fill")
                    cell.profileImage.tintColor = UIColor.lightGray
                    cell.profileImage.contentMode = .scaleAspectFill
                } else {
                    cell.profileImage.loadImageUsingCacheWithUrlString(profileImageString)
                    cell.profileImage.tintColor = UIColor.lightGray
                    cell.profileImage.contentMode = .scaleAspectFill
                }
            }
            
            // find name
            Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("name").observe(.value) { (snapshot) in
                let userName : String = (snapshot.value as? String)!
                cell.nameLabel.text = userName
            }
            
            cell.ratingLabel.text = String(self.rating)
            
            if self.findingRating == true {
                // find rating
                Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("number-of-ratings").observeSingleEvent(of: .value) { (ratingNum) in
                    let value = ratingNum.value as? NSNumber
                    let newNumber = Float(value!)
                    if newNumber == 0 {
                        cell.ratingView.alpha = 0
                    } else {
                        self.getAllRatings()
                    }
                }
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sideMenuCellNormal", for: indexPath)
            cell.textLabel?.textColor = UIColor.black
            cell.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
            cell.textLabel?.text = items[indexPath.row]
            return cell
        }
    }
    
    func getAllRatings() {
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("ratings").observe(.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                let job = ReviewStructure()
                job.ratingNumber = value["rating-number"] as? Int ?? 0
                self.ratingNumber += 1
                self.finalRating += job.ratingNumber!
            }
            
            let finalNumber = self.finalRating / self.ratingNumber
            
            self.rating = finalNumber
             
            self.findingRating = false
            self.tableView.reloadData()
        }
    }
    
//    func getAllRatings() {
//        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("ratings").observe(.childAdded) { (snapshot) in
//            if let value = snapshot.value as? [String : Any] {
//                let job = ReviewStructure()
//                job.ratingNumber = value["rating-number"] as? Int ?? 0
//                self.ratingNumber += 1
//                self.finalRating += job.ratingNumber!
//            }
//        }
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            print("profile")
            self.navigationController?.pushViewController(MyProfile(), animated: true)
        } else {
            switch indexPath.row {
            case 0:
                print("0")
                let controller = CategoryPostController()
                controller.category = "Trending"
                GlobalVariables.categoryName = "Trending"
                self.navigationController?.pushViewController(controller, animated: true)
            case 1:
                print("my jobs")
                self.navigationController?.pushViewController(MyJobs(), animated: true)
            case 2:
                print("4")
                self.navigationController?.pushViewController(MyReviews(), animated: true)
            case 3:
                print("5")
                self.navigationController?.pushViewController(Favorites(), animated: true)
            case 4:
                print("6")
                self.navigationController?.pushViewController(Settings(), animated: true)
            case 5:
                let alert = UIAlertController(title: "Are you sure you want to sign out?", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                    let firebaseAuth = Auth.auth()
                    do {
                        try firebaseAuth.signOut()
                    } catch let signOutError as NSError {
                        print("Error signing out: \(signOutError)")
                        let errorAlert = UIAlertController(title: "Error", message: signOutError.localizedDescription, preferredStyle: .alert)
                        errorAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                        self.present(errorAlert, animated: true, completion: nil)
                    }
                    let controller = SignIn()
                    controller.modalPresentationStyle = .fullScreen
                    self.present(controller, animated: true, completion: nil)
                }))
                alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            default:
                print("other")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200
        } else {
            return 65
        }
    }
    
}

class SideMenuCell : UITableViewCell {
    
    let profileImage : UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor.lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.heavy)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    let ratingView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let ratingIcon : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = UIColor.mainBlue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let ratingLabel : UILabel = {
        let label = UILabel()
        label.text = "4.5 "
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.heavy)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        
        addSubview(profileImage)
        profileImage.anchor(top: topAnchor, paddingTop: 20, bottom: bottomAnchor, paddingBottom: -60, left: leftAnchor, paddingLeft: 57, right: rightAnchor, paddingRight: -57, width: 0, height: 0)
        self.profileImage.layer.cornerRadius = 60
        
        addSubview(nameLabel)
        nameLabel.anchor(top: profileImage.bottomAnchor, paddingTop: -10, bottom: bottomAnchor, paddingBottom: -10, left: leftAnchor, paddingLeft: 10, right: rightAnchor, paddingRight: -10, width: 0, height: 0)
        
        addSubview(ratingView)
        ratingView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: -24).isActive = true
        ratingView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        ratingView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        ratingView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        ratingView.addSubview(ratingLabel)
        ratingLabel.widthAnchor.constraint(equalToConstant: ratingLabel.intrinsicContentSize.width).isActive = true
        ratingLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -13.5).isActive = true
        ratingLabel.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor).isActive = true
        
        ratingView.addSubview(ratingIcon)
        ratingIcon.topAnchor.constraint(equalTo: ratingView.topAnchor, constant: 3).isActive = true
        ratingIcon.bottomAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: -3).isActive = true
        ratingIcon.leftAnchor.constraint(equalTo: ratingLabel.rightAnchor, constant: 0).isActive = true
        ratingIcon.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        selectionStyle = .none
    }
    
}
