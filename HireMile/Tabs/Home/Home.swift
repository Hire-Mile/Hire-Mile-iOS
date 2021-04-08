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

class Home: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let imageArray = ["auto-sq", "scissor-sq", "carperter-sq", "clean-sq", "moving-sq", "hair-sq", "NAIL", "phone-sq", "towing-sq", "other-sq"]
    let titles = ["Auto", "Barber", "Carpentry", "Cleaning", "Moving", "Salon", "Beauty", "Technology", "Towing", "Other"]
    
    let imagePicker = UIImagePickerController()
    
    let launcher = FeedbackLauncher()
    
    var timer : Timer?
    var estimateWidth = 160.0
    var cellMarginSize = 5
    var allJobs = [JobStructure]()
    var passingImage : UIImage?
    var openingFromNotification = false
    
    let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor.white
        return scrollView
    }()
    
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
        button.setImage(UIImage(named: "menu-light"), for: .normal)
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(sideMenuTappped), for: .touchUpInside)
        return button
    }()
    
    let searchView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1).cgColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    let searchImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "search")
        imageView.tintColor = UIColor.lightGray
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let searchLabel : UITextField = {
        let label = UITextField()
        label.text = "Search Services"
        label.tintColor = UIColor.black
        label.textColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
        label.textAlignment = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let categoriesLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Browse by category"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.black
        return label
    }()
    
    let styleSwitcher : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "list-icon"), for: .normal)
        button.addTarget(self, action: #selector(switchStyleActionPressed), for: .touchUpInside)
        button.tintColor = UIColor.black
        button.imageView?.contentMode = .scaleAspectFit
        button.backgroundColor = UIColor.white
        return button
    }()
    
    let mapButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setImage(UIImage(named: "map-light"), for: .normal)
//        button.addTarget(self, action: #selector(mapButtonPressed), for: .touchUpInside)
        button.addTarget(self, action: #selector(profileImagePressed), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    let listTableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        return tableView
    }()
    
    let myImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let hireMileLog : UILabel = {
        let label = UILabel()
        label.text = "HireMile"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        return label
    }()
    
    let bigGreeenView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = UIColor(red: 197/255, green: 248/255, blue: 214/255, alpha: 1)
        return view
    }()
    
    let happyImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "happy")!
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        return imageView
    }()
    
    let bannerTitleLarge : UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bannerButtonMain : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Learn more", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(buttonLearnMoreTapped), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let divider : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1)
        view.alpha = 0.1
        return view
    }()
    
    var isGrid = true
    
    var categoryCollectionView : UICollectionView?
    
    lazy var slideInMenu : CGFloat = self.view.frame.width  * 0.30
    
    var isSlideInMenuPresented = false
    
    var menu : SideMenuNavigationController?
    
    var myCollectionView : UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.addSubview(listTableView)
        self.listTableView.register(CategoryCell.self, forCellReuseIdentifier: "listCell")
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
//        self.listTableView.frame = CGRect(x: 15, y: 290, width: self.view.frame.width - 30, height: self.view.frame.height - 400)
        
        let pushManager = PushNotificationManager(userID: Auth.auth().currentUser!.uid)
        pushManager.registerForPushNotifications()
        
        let layou2: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layou2.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layou2.scrollDirection = .horizontal
        
        self.categoryCollectionView = UICollectionView(frame: CGRect(x: 0, y: 215, width: self.view.frame.width - 40, height: 115), collectionViewLayout: layou2)
        self.categoryCollectionView!.translatesAutoresizingMaskIntoConstraints = false
        self.categoryCollectionView!.backgroundColor = UIColor.white
        self.categoryCollectionView!.alwaysBounceVertical = false
        self.categoryCollectionView!.alwaysBounceHorizontal = true
        self.categoryCollectionView!.dataSource = self
        self.categoryCollectionView!.showsHorizontalScrollIndicator = false
        self.categoryCollectionView!.showsVerticalScrollIndicator = false
        self.categoryCollectionView!.delegate = self
        self.categoryCollectionView!.register(HomeCategoryCell.self, forCellWithReuseIdentifier: "CategoryCellID")
        self.categoryCollectionView!.register(HomeCategoryCell.self, forCellWithReuseIdentifier: "CategoryCellID")
        self.scrollView.addSubview(self.categoryCollectionView!)
        
        // Functions to throw
        self.addSubviews()
        self.addConstraints()
        self.menuSetup()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFunction), userInfo: nil, repeats: true)
        
        self.setupCategory()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.observeMessages()
        
        if self.openingFromNotification == true {
            print("opening from notfication")
            self.openingFromNotification = false
        } else {
            print("no notifications")
        }
        
        if GlobalVariables.finishedFeedback == true {
            GlobalVariables.finishedFeedback = false
            self.launcher.showFilter()
        }
        
        // Functions to throw
        self.basicSetup()
        
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
        self.view.addSubview(scrollView)
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width - 40, height: 1200)
        self.scrollView.addSubview(menuButton)
        self.scrollView.addSubview(mapButton)
        self.scrollView.addSubview(hireMileLog)
        self.scrollView.addSubview(searchView)
        self.scrollView.addSubview(searchImage)
        self.scrollView.addSubview(searchLabel)
        self.scrollView.addSubview(searchButton)
        self.scrollView.addSubview(categoriesLabel)
    }
    
    func addConstraints() {
        
        let title1 = NSMutableAttributedString(string: "Earn money by", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 24)])
        title1.append(NSAttributedString(string: "\nposting your skills", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 24)]))
        
        self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        
        self.menuButton.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 0).isActive = true
        self.menuButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.menuButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        self.menuButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        
        self.mapButton.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 0).isActive = true
        self.mapButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.mapButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        self.mapButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        
        self.hireMileLog.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 0).isActive = true
        self.hireMileLog.leftAnchor.constraint(equalTo: self.menuButton.rightAnchor).isActive = true
        self.hireMileLog.rightAnchor.constraint(equalTo: self.mapButton.leftAnchor).isActive = true
        self.hireMileLog.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        self.searchView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.searchView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.searchView.topAnchor.constraint(equalTo: self.hireMileLog.bottomAnchor, constant: 30).isActive = true
        self.searchView.heightAnchor.constraint(equalToConstant: 52).isActive = true

        self.searchImage.widthAnchor.constraint(equalToConstant: 16).isActive = true
        self.searchImage.heightAnchor.constraint(equalToConstant: 16).isActive = true
        self.searchImage.leftAnchor.constraint(equalTo: self.searchView.leftAnchor, constant: 16).isActive = true
        self.searchImage.centerYAnchor.constraint(equalTo: self.searchView.centerYAnchor).isActive = true

        self.searchLabel.delegate = self
        self.searchLabel.leftAnchor.constraint(equalTo: self.searchImage.rightAnchor, constant: 10).isActive = true
        self.searchLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        self.searchLabel.rightAnchor.constraint(equalTo: self.searchView.rightAnchor, constant: -20).isActive = true
        self.searchLabel.centerYAnchor.constraint(equalTo: self.searchView.centerYAnchor).isActive = true

        self.searchButton.topAnchor.constraint(equalTo: self.searchView.topAnchor).isActive = true
        self.searchButton.rightAnchor.constraint(equalTo: self.searchView.rightAnchor).isActive = true
        self.searchButton.leftAnchor.constraint(equalTo: self.searchView.leftAnchor).isActive = true
        self.searchButton.bottomAnchor.constraint(equalTo: self.searchView.bottomAnchor).isActive = true
        
        self.categoriesLabel.topAnchor.constraint(equalTo: self.searchView.bottomAnchor, constant: 55).isActive = true
        self.categoriesLabel.leftAnchor.constraint(equalTo: self.menuButton.leftAnchor).isActive = true
        self.categoriesLabel.heightAnchor.constraint(equalToConstant: 26).isActive = true
        self.categoriesLabel.rightAnchor.constraint(equalTo: self.searchView.rightAnchor).isActive = true
        
        self.scrollView.addSubview(bigGreeenView)
        self.bigGreeenView.topAnchor.constraint(equalTo: categoriesLabel.bottomAnchor, constant: 160).isActive = true
        self.bigGreeenView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.bigGreeenView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.bigGreeenView.heightAnchor.constraint(equalToConstant: 175).isActive = true
        
        self.scrollView.addSubview(happyImage)
        self.happyImage.bottomAnchor.constraint(equalTo: self.bigGreeenView.bottomAnchor).isActive = true
        self.happyImage.rightAnchor.constraint(equalTo: self.bigGreeenView.rightAnchor, constant: -5).isActive = true
        self.happyImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.happyImage.widthAnchor.constraint(equalToConstant: 175).isActive = true
        
        self.bigGreeenView.addSubview(bannerTitleLarge)
        self.bannerTitleLarge.attributedText = title1
        self.bannerTitleLarge.topAnchor.constraint(equalTo: self.bigGreeenView.topAnchor, constant: 24).isActive = true
        self.bannerTitleLarge.leftAnchor.constraint(equalTo: self.bigGreeenView.leftAnchor, constant: 24).isActive = true
        self.bannerTitleLarge.rightAnchor.constraint(equalTo: self.happyImage.centerXAnchor).isActive = true
        self.bannerTitleLarge.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        self.view.addSubview(bannerButtonMain)
        self.bannerButtonMain.topAnchor.constraint(equalTo: bannerTitleLarge.bottomAnchor, constant: 5).isActive = true
        self.bannerButtonMain.leftAnchor.constraint(equalTo: bannerTitleLarge.leftAnchor).isActive = true
        self.bannerButtonMain.widthAnchor.constraint(equalToConstant: 105).isActive = true
        self.bannerButtonMain.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.scrollView.addSubview(divider)
        self.divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        self.divider.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.divider.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.divider.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 25).isActive = true

//
//        self.styleSwitcher.topAnchor.constraint(equalTo: self.categoriesLabel.topAnchor).isActive = true
//        self.styleSwitcher.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
//        self.styleSwitcher.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        self.styleSwitcher.widthAnchor.constraint(equalToConstant: 40).isActive = true
//
//        self.listTableView.showsHorizontalScrollIndicator = false
//        self.listTableView.showsVerticalScrollIndicator = false
        
        self.scrollView.addSubview(self.myImageView)
        self.myImageView.topAnchor.constraint(equalTo: self.mapButton.topAnchor).isActive = true
        self.myImageView.leftAnchor.constraint(equalTo: self.mapButton.leftAnchor).isActive = true
        self.myImageView.rightAnchor.constraint(equalTo: self.mapButton.rightAnchor).isActive = true
        self.myImageView.bottomAnchor.constraint(equalTo: self.mapButton.bottomAnchor).isActive = true
        
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("profile-image").observe(.value) { (photoSnap) in
            if let photoUrl = photoSnap.value as? String {
                self.myImageView.loadImageUsingCacheWithUrlString(photoUrl)
            }
        }
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        layout.itemSize = CGSize(width: (self.scrollView.contentSize.width / 2), height: 60)
        
        myCollectionView = UICollectionView(frame: CGRect(x: 0, y: 600, width: self.scrollView.contentSize.width, height: self.scrollView.contentSize.height - 600), collectionViewLayout: layout)
        myCollectionView?.register(HomeCell.self, forCellWithReuseIdentifier: "MyCell")
        myCollectionView?.backgroundColor = UIColor.white
        myCollectionView?.showsHorizontalScrollIndicator = false
        myCollectionView?.showsVerticalScrollIndicator = false
        myCollectionView?.dataSource = self
        myCollectionView?.delegate = self
        scrollView.addSubview(myCollectionView ?? UICollectionView())
        myCollectionView?.refreshControl = refrshControl
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
            self.listTableView.reloadData()
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
            let count = self.allJobs.count
            let height = (self.scrollView.contentSize.width / 2) - 10
            
            let contentSize = (count * Int(height)) - 200
            scrollView.contentSize = CGSize(width: Int(self.view.frame.size.width - 40), height: contentSize)
            
//            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
//            layout.itemSize = CGSize(width: (self.scrollView.contentSize.width / 2), height: 60)
//
//            myCollectionView = UICollectionView(frame: CGRect(x: 0, y: 600, width: self.scrollView.contentSize.width, height: self.scrollView.contentSize.height - 600), collectionViewLayout: layout)
//            myCollectionView?.register(HomeCell.self, forCellWithReuseIdentifier: "MyCell")
//            myCollectionView?.backgroundColor = UIColor.white
//            myCollectionView?.showsHorizontalScrollIndicator = false
//            myCollectionView?.showsVerticalScrollIndicator = false
//            myCollectionView?.dataSource = self
//            myCollectionView?.delegate = self
//            scrollView.addSubview(myCollectionView ?? UICollectionView())
//            myCollectionView?.refreshControl = refrshControl
            
            if count == 0 || count == nil {
                print("nil count")
            } else {
                myCollectionView?.frame.size.height = scrollView.contentSize.height - 600
            }
            
            return count
        } else {
            return self.titles.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.myCollectionView {
            let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! HomeCell
            myCell.firstServiceButton.addTarget(self, action: #selector(servicePressed), for: .touchUpInside)
            
            if let urlAddress = self.allJobs[indexPath.row].imagePost {
                let url = URL(string: urlAddress)
                myCell.firstServiceImage.loadImage(from: url!)
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
            return CGSize(width: (self.scrollView.contentSize.width / 2) - 10, height: (self.scrollView.contentSize.width / 2) - 10)
        } else {
            return CGSize(width: 80, height: 115)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allJobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! CategoryCell
        cell.backgroundColor = .white
        cell.titleImageView.loadImage(from: URL(string: self.allJobs[indexPath.row].imagePost!)!)
        cell.titleLabel.text = self.allJobs[indexPath.row].titleOfPost!
        cell.desscription.text = self.allJobs[indexPath.row].descriptionOfPost!
        cell.postId = self.allJobs[indexPath.row].postId!
        if self.allJobs[indexPath.row].typeOfPrice == "Hourly" {
            cell.priceTag.text = "$\(self.allJobs[indexPath.row].price!) / Hour"
        } else {
            cell.priceTag.text = "$\(self.allJobs[indexPath.row].price!)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        menu?.menuWidth = self.view.frame.width - 50
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    @objc func sideMenuTappped() {
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.menu?.dismiss(animated: true, completion: nil)
//        }
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
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func buttonLearnMoreTapped() {
        let url = URL(string: "https://hiremile.com")!
        UIApplication.shared.open(url)
    }
    
    @objc func timerFunction() {
        if GlobalVariables.presentToCat == true {
            
            GlobalVariables.postImage2.loadImageUsingCacheWithUrlString(GlobalVariables.catId.imagePost!)
            GlobalVariables.postImageDownlodUrl = GlobalVariables.catId.imagePost!
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
        
        if GlobalVariables.presentToUserProfile == true {
            GlobalVariables.userUID = GlobalVariables.userPresentationId
            self.navigationController?.pushViewController(OtherProfile(), animated: true)
            GlobalVariables.presentToUserProfile = false
        }
        
        if GlobalVariables.isSearching {
            GlobalVariables.isSearching = false
            let controller = CategoryPostController()
            controller.category = GlobalVariables.searchCat
            GlobalVariables.searchCat = ""
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        if GlobalVariables.isGoingToPost == true {
            print("postingggg")
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
            if let popoverController = alert.popoverPresentationController {
              popoverController.sourceView = self.view
              popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            }
            self.present(alert, animated: true, completion: nil)
            GlobalVariables.isGoingToPost = false
        }
        
        if self.passingImage != nil {
            GlobalVariables.postImage = passingImage!
            let controller = Post()
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
            self.passingImage = nil
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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
    
    @objc func mapButtonPressed() {
        let controller = Map()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func profileImagePressed() {
        let controller = MyProfile()
        self.navigationController?.pushViewController(controller, animated: true)
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
                            // extract blue
                            tabBarController?.tabBar.items?.last?.badgeValue = nil
                        } else {
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
    
    @objc func switchStyleActionPressed() {
        if self.isGrid == true {
            self.styleSwitcher.imageView!.image = UIImage(named: "grid")
            self.styleSwitcher.setImage(UIImage(named: "grid"), for: .normal)
            self.convertToList()
        } else {
            self.styleSwitcher.imageView!.image = UIImage(named: "list-icon")
            self.styleSwitcher.setImage(UIImage(named: "list-icon"), for: .normal)
            self.convertToGrid()
        }
        
    }
    
    func convertToList() {
        print("switching to list")
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.myCollectionView?.alpha = 0
        } completion: { (isCompleted) in
            if isCompleted {
                self.isGrid = false
            }
        }
    }
    
    func convertToGrid() {
        print("switching to grid")
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.myCollectionView?.alpha = 1
        } completion: { (isCompleted) in
            if isCompleted {
                self.isGrid = true
            }
        }
    }

}
