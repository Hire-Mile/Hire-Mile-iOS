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

class Home: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
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
    
    let mapImage : UIButton = {
        let imageView = UIButton(type: .system)
        imageView.setImage(UIImage(named: "location"), for: UIControl.State.normal)
        imageView.addTarget(self, action: #selector(mapButtonPressed), for: UIControl.Event.touchUpInside)
        imageView.backgroundColor = .clear
        imageView.tintColor = UIColor(red: 32/255, green: 14/255, blue: 50/255, alpha: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let searchLabel : UITextField = {
        let label = UITextField()
        label.text = "Search Services or Workers"
        label.tintColor = UIColor.black
        label.textColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
        label.textAlignment = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
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
    
    let viewAllButton : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("View All", for: .normal)
        button.titleLabel?.textAlignment = NSTextAlignment.right
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.addTarget(self, action: #selector(viewAllButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let mapButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(profileImagePressed), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    let myImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let hireMileLog : UILabel = {
        let label = UILabel()
        label.text = "Hiremile"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.mainBlue
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
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Recent"
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    let viewAllButtonCat : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("View All", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.addTarget(self, action: #selector(catButton), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var collectView : UICollectionView?
    
    let titleLabel2 : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Auto"
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    let viewAllButtonCat2 : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("View All", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.addTarget(self, action: #selector(catButton2), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var collectView2 : UICollectionView?
    
    let titleLabel3 : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Barber"
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    let viewAllButtonCat3 : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("View All", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.addTarget(self, action: #selector(catButton3), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var collectView3 : UICollectionView?
    
    let titleLabel4 : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Carpentry"
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    let viewAllButtonCat4 : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("View All", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.addTarget(self, action: #selector(catButton4), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var collectView4 : UICollectionView?
    
    let titleLabel5 : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Cleaning"
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    let viewAllButtonCat5 : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("View All", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.addTarget(self, action: #selector(catButton5), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var collectView5 : UICollectionView?
    
    let titleLabel6 : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Moving"
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    let viewAllButtonCat6 : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("View All", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.addTarget(self, action: #selector(catButton6), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var collectView6 : UICollectionView?
    
    let titleLabel7 : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Salon"
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    let viewAllButtonCat7 : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("View All", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.addTarget(self, action: #selector(catButton7), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var collectView7 : UICollectionView?
    
    let titleLabel8 : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Beauty"
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    let viewAllButtonCat8 : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("View All", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.addTarget(self, action: #selector(catButton8), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var collectView8 : UICollectionView?
    
    let titleLabel9 : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Technology"
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    let viewAllButtonCat9 : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("View All", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.addTarget(self, action: #selector(catButton9), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var collectView9 : UICollectionView?
    
    let titleLabel10 : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Towing"
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    let viewAllButtonCat10 : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("View All", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.addTarget(self, action: #selector(catButton10), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var collectView10 : UICollectionView?
    
    let titleLabel11 : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Other"
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    let viewAllButtonCat11 : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("View All", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.addTarget(self, action: #selector(catButton11), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var collectView11 : UICollectionView?
    
    var categoryCollectionView : UICollectionView?
    
    lazy var slideInMenu : CGFloat = self.view.frame.width  * 0.30
    
    var isSlideInMenuPresented = false
    
    var menu : SideMenuNavigationController?
    
    var myCollectionView : UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pushManager = PushNotificationManager(userID: Auth.auth().currentUser!.uid)
        pushManager.registerForPushNotifications()
        
        let layou2: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layou2.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layou2.scrollDirection = .horizontal
        
        self.categoryCollectionView = UICollectionView(frame: CGRect(x: 0, y: 150, width: self.view.frame.width - 40, height: 115), collectionViewLayout: layou2)
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
        
        self.setupCategory()
        
        self.view = view
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            self.myCollectionView?.reloadData()
        }
    }
    
    func addSubviews() {
        self.view.addSubview(scrollView)
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width - 40, height: 775)
        self.view.addSubview(menuButton)
        self.view.addSubview(mapButton)
        self.view.addSubview(hireMileLog)
        self.scrollView.addSubview(searchView)
        self.scrollView.addSubview(searchImage)
        self.scrollView.addSubview(searchLabel)
        self.scrollView.addSubview(searchButton)
        self.scrollView.addSubview(categoriesLabel)
    }
    
    func addConstraints() {
        
        let title1 = NSMutableAttributedString(string: "Earn money by", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 24)])
        title1.append(NSAttributedString(string: "\nposting your skills", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 24)]))
        
        self.menuButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        self.menuButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.menuButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        self.menuButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        
        self.mapButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        self.mapButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.mapButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        self.mapButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        
        self.hireMileLog.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        self.hireMileLog.leftAnchor.constraint(equalTo: self.menuButton.rightAnchor).isActive = true
        self.hireMileLog.rightAnchor.constraint(equalTo: self.mapButton.leftAnchor).isActive = true
        self.hireMileLog.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 85).isActive = true
        self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        
        self.searchView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.searchView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.searchView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 0).isActive = true
        self.searchView.heightAnchor.constraint(equalToConstant: 52).isActive = true

        self.searchImage.widthAnchor.constraint(equalToConstant: 16).isActive = true
        self.searchImage.heightAnchor.constraint(equalToConstant: 16).isActive = true
        self.searchImage.leftAnchor.constraint(equalTo: self.searchView.leftAnchor, constant: 16).isActive = true
        self.searchImage.centerYAnchor.constraint(equalTo: self.searchView.centerYAnchor).isActive = true
        
        self.scrollView.addSubview(mapImage)
        self.mapImage.widthAnchor.constraint(equalToConstant: 18).isActive = true
        self.mapImage.heightAnchor.constraint(equalToConstant: 18).isActive = true
        self.mapImage.rightAnchor.constraint(equalTo: self.searchView.rightAnchor, constant: -16).isActive = true
        self.mapImage.centerYAnchor.constraint(equalTo: self.searchView.centerYAnchor).isActive = true

        self.searchLabel.delegate = self
        self.searchLabel.leftAnchor.constraint(equalTo: self.searchImage.rightAnchor, constant: 10).isActive = true
        self.searchLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        self.searchLabel.rightAnchor.constraint(equalTo: self.mapImage.leftAnchor, constant: -16).isActive = true
        self.searchLabel.centerYAnchor.constraint(equalTo: self.searchView.centerYAnchor).isActive = true

        self.searchButton.topAnchor.constraint(equalTo: self.searchView.topAnchor).isActive = true
        self.searchButton.rightAnchor.constraint(equalTo: self.searchView.rightAnchor).isActive = true
        self.searchButton.leftAnchor.constraint(equalTo: self.searchView.leftAnchor).isActive = true
        self.searchButton.bottomAnchor.constraint(equalTo: self.searchView.bottomAnchor).isActive = true
        
        self.categoriesLabel.topAnchor.constraint(equalTo: self.searchView.bottomAnchor, constant: 55).isActive = true
        self.categoriesLabel.leftAnchor.constraint(equalTo: self.menuButton.leftAnchor).isActive = true
        self.categoriesLabel.heightAnchor.constraint(equalToConstant: 26).isActive = true
        self.categoriesLabel.rightAnchor.constraint(equalTo: self.searchView.rightAnchor).isActive = true
        
        self.scrollView.addSubview(viewAllButton)
        self.viewAllButton.heightAnchor.constraint(equalToConstant: 26).isActive = true
        self.viewAllButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        self.viewAllButton.centerYAnchor.constraint(equalTo: self.categoriesLabel.centerYAnchor).isActive = true
        self.viewAllButton.rightAnchor.constraint(equalTo: self.searchView.rightAnchor).isActive = true
        
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
        
        self.scrollView.addSubview(bannerButtonMain)
        self.bannerButtonMain.topAnchor.constraint(equalTo: bannerTitleLarge.bottomAnchor, constant: 5).isActive = true
        self.bannerButtonMain.leftAnchor.constraint(equalTo: bannerTitleLarge.leftAnchor).isActive = true
        self.bannerButtonMain.widthAnchor.constraint(equalToConstant: 105).isActive = true
        self.bannerButtonMain.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.scrollView.addSubview(divider)
        self.divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        self.divider.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.divider.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.divider.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 25).isActive = true
        
        self.view.addSubview(self.myImageView)
        self.myImageView.topAnchor.constraint(equalTo: self.mapButton.topAnchor).isActive = true
        self.myImageView.leftAnchor.constraint(equalTo: self.mapButton.leftAnchor).isActive = true
        self.myImageView.rightAnchor.constraint(equalTo: self.mapButton.rightAnchor).isActive = true
        self.myImageView.bottomAnchor.constraint(equalTo: self.mapButton.bottomAnchor).isActive = true
        
        self.scrollView.addSubview(self.titleLabel)
        self.titleLabel.topAnchor.constraint(equalTo: self.bigGreeenView.bottomAnchor, constant: 31).isActive = true
        self.titleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.titleLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true

        self.scrollView.addSubview(self.viewAllButtonCat)
        self.viewAllButtonCat.topAnchor.constraint(equalTo: self.titleLabel.topAnchor).isActive = true
        self.viewAllButtonCat.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.viewAllButtonCat.widthAnchor.constraint(equalToConstant: 75).isActive = true
        self.viewAllButtonCat.heightAnchor.constraint(equalToConstant: 22).isActive = true

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        
        self.collectView = UICollectionView(frame: CGRect(x: 0, y: 525, width: self.view.frame.width - 40, height: 220), collectionViewLayout: layout)
        self.collectView!.translatesAutoresizingMaskIntoConstraints = false
        self.collectView!.backgroundColor = UIColor.white
        self.collectView!.alwaysBounceVertical = false
        self.collectView!.alwaysBounceHorizontal = true
        self.collectView!.dataSource = self
        self.collectView!.showsHorizontalScrollIndicator = false
        self.collectView!.showsVerticalScrollIndicator = false
        self.collectView!.delegate = self
        self.collectView!.register(HomeCategoryCellOther.self, forCellWithReuseIdentifier: "collectViewCell")
        self.collectView!.register(HomeCategoryCellOther.self, forCellWithReuseIdentifier: "collectViewCell")
        self.scrollView.addSubview(collectView!)
        
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("profile-image").observe(.value) { (photoSnap) in
            if let photoUrl = photoSnap.value as? String {
                self.scrollView.bringSubviewToFront(self.myImageView)
                self.myImageView.loadImageUsingCacheWithUrlString(photoUrl)
            }
        }
        
//        scrollView.sendSubviewToBack(viewAllButton)
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
                job.timeStamp = value["time"] as? Int ?? 0
                self.allJobs.append(job)
            }
            let hello = self.allJobs.sorted(by: { $1.timeStamp! > $0.timeStamp! } )
            self.allJobs.removeAll()
            self.allJobs = hello
            self.collectView!.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
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
        } else if collectionView == self.collectView {
            allJobs.reverse()
            return self.allJobs.count
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
        } else if collectionView == self.collectView {
            let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectViewCell", for: indexPath) as! HomeCategoryCellOther
            
            myCell.backgroundColor = .green
            
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
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCellID", for: indexPath) as! HomeCategoryCell
            cell.title.text = self.titles[indexPath.row]
            cell.imageView.image = UIImage(named: self.imageArray[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.myCollectionView {
            let controller = ViewPostController()
            controller.hidesBottomBarWhenPushed = true
            GlobalVariables.postImage2.loadImageUsingCacheWithUrlString(self.allJobs[indexPath.row].imagePost!)
            GlobalVariables.postImageDownlodUrl = self.allJobs[indexPath.row].imagePost!
            GlobalVariables.postTitle = self.allJobs[indexPath.row].titleOfPost!
            GlobalVariables.postDescription = self.allJobs[indexPath.row].descriptionOfPost!
            GlobalVariables.postPrice = self.allJobs[indexPath.row].price!
            GlobalVariables.userUID = self.allJobs[indexPath.row].authorName!
            Database.database().reference().child("Users").child(self.allJobs[indexPath.row].authorName!).child("profile-image").observe(.value) { (snapshot) in
                if let profileImageUrl : String = (snapshot.value as? String) {
                    controller.profileImage.loadImage(from: URL(string: profileImageUrl)!)
                    GlobalVariables.authorId = self.allJobs[indexPath.row].authorName!
                    GlobalVariables.postId = self.allJobs[indexPath.row].postId!
                    GlobalVariables.type = self.allJobs[indexPath.row].typeOfPrice!
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        } else if collectionView == self.collectView {
            let controller = ViewPostController()
            controller.hidesBottomBarWhenPushed = true
            GlobalVariables.postImage2.loadImageUsingCacheWithUrlString(self.allJobs[indexPath.row].imagePost!)
            GlobalVariables.postImageDownlodUrl = self.allJobs[indexPath.row].imagePost!
            GlobalVariables.postTitle = self.allJobs[indexPath.row].titleOfPost!
            GlobalVariables.postDescription = self.allJobs[indexPath.row].descriptionOfPost!
            GlobalVariables.postPrice = self.allJobs[indexPath.row].price!
            GlobalVariables.userUID = self.allJobs[indexPath.row].authorName!
            Database.database().reference().child("Users").child(self.allJobs[indexPath.row].authorName!).child("profile-image").observe(.value) { (snapshot) in
                if let profileImageUrl : String = (snapshot.value as? String) {
                    controller.profileImage.loadImage(from: URL(string: profileImageUrl)!)
                    GlobalVariables.authorId = self.allJobs[indexPath.row].authorName!
                    GlobalVariables.postId = self.allJobs[indexPath.row].postId!
                    GlobalVariables.type = self.allJobs[indexPath.row].typeOfPrice!
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        } else {
            let controller = CategoryPostController()
            controller.hidesBottomBarWhenPushed = true
            controller.category = self.titles[indexPath.row]
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.myCollectionView {
            return CGSize(width: (self.scrollView.contentSize.width / 2) - 10, height: (self.scrollView.contentSize.width / 2) - 10)
        } else if collectionView == self.categoryCollectionView {
            return CGSize(width: 80, height: 115)
        } else  {
            return CGSize(width: self.view.frame.size.width / 2, height: self.view.frame.size.width / 2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
    
    @objc func viewAllButtonPressed() {
        self.navigationController?.pushViewController(AllCategories(), animated: true)
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
        controller.hidesBottomBarWhenPushed = true
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
            let controller = Post()
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true) {
                GlobalVariables.isGoingToPost = false
                self.passingImage = nil
            }
        }
        
    }
    
    @objc func catButton() {
        let controller = CategoryPostController()
        controller.category = self.titleLabel.text
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func catButton2() {
        let controller = CategoryPostController()
        controller.category = self.titleLabel2.text
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func catButton3() {
        let controller = CategoryPostController()
        controller.category = self.titleLabel3.text
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func catButton4() {
        let controller = CategoryPostController()
        controller.category = self.titleLabel4.text
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func catButton5() {
        let controller = CategoryPostController()
        controller.category = self.titleLabel5.text
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func catButton6() {
        let controller = CategoryPostController()
        controller.category = self.titleLabel6.text
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func catButton7() {
        let controller = CategoryPostController()
        controller.category = self.titleLabel7.text
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func catButton8() {
        let controller = CategoryPostController()
        controller.category = self.titleLabel8.text
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func catButton9() {
        let controller = CategoryPostController()
        controller.category = self.titleLabel9.text
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func catButton10() {
        let controller = CategoryPostController()
        controller.category = self.titleLabel10.text
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func catButton11() {
        let controller = CategoryPostController()
        controller.category = self.titleLabel11.text
        self.navigationController?.pushViewController(controller, animated: true)
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
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func profileImagePressed() {
        let controller = MyProfile()
        controller.hidesBottomBarWhenPushed = true
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
}

class HomeCategoryCellOther: UICollectionViewCell {
    
    let firstServiceView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 7
        view.layer.shadowOpacity = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let firstServiceImage : CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return imageView
    }()
    
    let firstTitle : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "Title"
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    let firstPrice : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.mainBlue
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        addSubview(firstServiceView)
        firstServiceView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        firstServiceView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        firstServiceView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        firstServiceView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        
        firstServiceView.addSubview(firstServiceImage)
        firstServiceImage.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        firstServiceImage.layer.cornerRadius = 15
        firstServiceImage.clipsToBounds = true
        firstServiceImage.topAnchor.constraint(equalTo: firstServiceView.topAnchor).isActive = true
        firstServiceImage.leftAnchor.constraint(equalTo: firstServiceView.leftAnchor).isActive = true
        firstServiceImage.rightAnchor.constraint(equalTo: firstServiceView.rightAnchor).isActive = true
        firstServiceImage.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        firstServiceView.addSubview(firstTitle)
        firstTitle.topAnchor.constraint(equalTo: firstServiceImage.bottomAnchor, constant: 7).isActive = true
        firstTitle.leftAnchor.constraint(equalTo: firstServiceView.leftAnchor, constant: 12).isActive = true
        firstTitle.rightAnchor.constraint(equalTo: firstServiceView.rightAnchor, constant: -12).isActive = true
        firstTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true

        firstServiceView.addSubview(firstPrice)
        firstPrice.topAnchor.constraint(equalTo: firstTitle.bottomAnchor).isActive = true
        firstPrice.leftAnchor.constraint(equalTo: firstServiceView.leftAnchor, constant: 12).isActive = true
        firstPrice.rightAnchor.constraint(equalTo: firstServiceView.rightAnchor, constant: -12).isActive = true
        firstPrice.bottomAnchor.constraint(equalTo: firstServiceView.bottomAnchor, constant: -12).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class MenuListController: UITableViewController {
    
    let exitButton : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.black
        button.layer.cornerRadius = 22
        button.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        return button
    }()
    
    var allRatings = [Int]()
    
    var finalRating = 0
    
    var ratingNumber = 0
    
    var rating = 0
    
    var findingRating = true
    
    let items = ["My Jobs", "My Reviews", "Following", "Settings", " ", " ", "Sign Out"]
    let images = ["myjob", "review", "follower", "setting", " ", " ", "logut"]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        tableView.separatorColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.register(SideMenuCellMain.self, forCellReuseIdentifier: "sideMenuCellNormal")
        tableView.register(SideMenuCell.self, forCellReuseIdentifier: "sideMenuCellProfile")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        
        self.tableView.reloadData()
        
        self.view.addSubview(exitButton)
        self.exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
        self.exitButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        self.exitButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        self.exitButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
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
            
            cell.exitButton.addTarget(self, action: #selector(self.dimissMenu), for: .touchUpInside)
            
            // find name
            Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("name").observe(.value) { (snapshot) in
                if let userName : String = (snapshot.value as? String) {
                    cell.nameLabel.text = userName
                }
            }
            
            Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("username").observe(.value) { (snapshot) in
                if let userName : String = (snapshot.value as? String) {
                    cell.emailLabel.text = userName
                }
            }
            
            cell.ratingLabel.text = String(self.rating)
            
            if self.findingRating == true {
                // find rating
                Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("number-of-ratings").observeSingleEvent(of: .value) { (ratingNum) in
                    if let value = ratingNum.value as? NSNumber {
                        let newNumber = Float(value)
                        if newNumber == 0 {
                            cell.ratingView.alpha = 0
                        } else {
                            self.getAllRatings()
                        }
                    }
                }
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sideMenuCellNormal", for: indexPath) as! SideMenuCellMain
            cell.textLabel?.textColor = UIColor.black
            cell.profileImageView.image = UIImage(named: self.images[indexPath.row])
            cell.favoriteButton.removeFromSuperview()
            cell.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
            cell.textLabel?.text = items[indexPath.row]
            
            
            if indexPath.row == 4 || indexPath.row == 5 {
                cell.sideMenuArrow.removeFromSuperview()
            }
            
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            print("profile")
            let controller = MyProfile()
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            switch indexPath.row {
            case 0:
                let controller = MyJobs()
                controller.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(controller, animated: true)
            case 1:
                let controller = MyReviews()
                controller.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(controller, animated: true)
            case 2:
                let controller = Favorites()
                controller.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(controller, animated: true)
            case 3:
                let controller = Settings()
                controller.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(controller, animated: true)
            case 4:
                self.signOut()
            case 5:
                self.signOut()
            default:
                self.signOut()
            }
        }
    }
    
    func signOut() {
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
            let controller = WelcomeScreen()
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 160
        } else {
            return 65
        }
    }
    
    var sideMenu : SideMenuNavigationController?
    
    @objc func dimissMenu() {
        print("dismissing")
//        self.sideMenu!.dismiss(animated: true, completion: nil)
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
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    let emailLabel : UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    let exitButton : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.black
        button.layer.cornerRadius = 22
        button.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        return button
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
    
    @objc func dismissMenu() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        
        addSubview(profileImage)
        self.profileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        self.profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        self.profileImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
        self.profileImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.profileImage.layer.cornerRadius = 30
        
        addSubview(nameLabel)
        nameLabel.anchor(top: profileImage.topAnchor, paddingTop: 0, bottom: profileImage.bottomAnchor, paddingBottom: -30, left: profileImage.rightAnchor, paddingLeft: 20, right: rightAnchor, paddingRight: -10, width: 0, height: 0)
        
        addSubview(emailLabel)
        emailLabel.anchor(top: nameLabel.bottomAnchor, paddingTop: 0, bottom: profileImage.bottomAnchor, paddingBottom: 0, left: profileImage.rightAnchor, paddingLeft: 20, right: rightAnchor, paddingRight: -10, width: 0, height: 0)
        
        selectionStyle = .none
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
        view.layer.shadowRadius = 7
        view.layer.shadowOpacity = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let firstServiceImage : CustomImageView = {
        let imageView = CustomImageView()
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
        firstServiceView.anchor(top: topAnchor, paddingTop: 0, bottom: bottomAnchor, paddingBottom: 0, left: leftAnchor, paddingLeft: 0, right: rightAnchor, paddingRight: 0, width: 0, height: 0)
        
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

class SideMenuCellMain: UITableViewCell {
    
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
    
    let sideMenuArrow : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.right")
        iv.tintColor = UIColor.lightGray
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 75, y: self.contentView.frame.height / 3, width: textLabel!.frame.width, height: textLabel!.frame.height)
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 22.5
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(sideMenuArrow)
        contentView.addSubview(favoriteButton)
    
        textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        self.selectionStyle = .none
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        sideMenuArrow.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        sideMenuArrow.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        sideMenuArrow.widthAnchor.constraint(equalToConstant: 20).isActive = true
        sideMenuArrow.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        favoriteButton.addTarget(self, action: #selector(tapper), for: .touchUpInside)
        favoriteButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
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
