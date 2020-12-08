//
//  Home.swift
//  HireMile
//
//  Created by JJ Zapata on 11/16/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit
import SideMenu

class Home: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var timer : Timer?
    
    private let refrshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.black
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        return refreshControl
    }()
    
    let searchButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.layer.cornerRadius = 20
        button.tintColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1)
        return button
    }()
    
    let menuButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        button.addTarget(self, action: #selector(sideMenuTappped), for: .touchUpInside)
        button.tintColor = UIColor(red: 39/255, green: 39/255, blue: 39/255, alpha: 1)
        return button
    }()
    
    
    let tableView : UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.separatorStyle = .none
        tableview.register(HomeCell.self, forCellReuseIdentifier: "homeTableViewId")
        tableview.backgroundColor = UIColor.white
        return tableview
    }()
    
    lazy var slideInMenu : CGFloat = self.view.frame.width  * 0.30
    
    var isSlideInMenuPresented = false
    
    var menu : SideMenuNavigationController?
    
    let titles = ["Cat. Name", "Cat. Name", "Cat. Name", "Cat. Name"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Functions to throw
        self.addSubviews()
        self.addConstraints()
        self.menuSetup()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFunction), userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Functions to throw
        self.basicSetup()
    }
    
    func addSubviews() {
        self.view.addSubview(searchButton)
        self.view.addSubview(menuButton)
        self.view.addSubview(tableView)
    }
    
    func addConstraints() {
        self.searchButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        self.searchButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.searchButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.searchButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.menuButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        self.menuButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.menuButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.menuButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.tableView.topAnchor.constraint(equalTo: self.menuButton.bottomAnchor, constant: 10).isActive = true
        self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }
    
    func basicSetup() {
        self.view.backgroundColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = true
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.refreshControl = refrshControl
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return (true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableViewId", for: indexPath) as! HomeCell
        cell.titleLabel.text = titles[indexPath.row]
        cell.firstServiceButton.addTarget(self, action: #selector(servicePressed), for: .touchUpInside)
        cell.secondServiceButton.addTarget(self, action: #selector(servicePressed), for: .touchUpInside)
        cell.seeAllButton.addTarget(self, action: #selector(seeAllPressed), for: .touchUpInside)
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        seeAllPressedRow()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
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
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(hideRefrsh), userInfo: nil, repeats: false)
    }
    
    @objc func hideRefrsh() {
        self.refrshControl.endRefreshing()
    }
    
    @objc func searchButtonPressed() {
        let controller = SearchController()
        controller.modalPresentationStyle = .overFullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func timerFunction() {
        if GlobalVariables.presentToCat == true {
            self.navigationController?.pushViewController(CategoryPostController(), animated: true)
            GlobalVariables.presentToCat = false
        }
        
    }

}

class HomeCell: UITableViewCell {
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Nearby Services"
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let seeAllButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 242/255, green: 235/255, blue: 235/255, alpha: 1)
        button.setTitleColor(UIColor(red: 131/255, green: 131/255, blue: 131/255, alpha: 1), for: .normal)
        button.setTitle("SEE ALL", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.heavy)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
    
    let secondServiceView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 20
        view.layer.shadowOpacity = 0.1
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
    
    let secondServiceImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.image = UIImage(named: "designing")
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
    
    let secondLocationLabel : UILabel = {
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
    
    let secondTitle : UILabel = {
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
    
    let secondPrice : UILabel = {
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
    
    let secondServiceButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setup()
    }
    
    func setup() {
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, paddingTop: 0, bottom: bottomAnchor, paddingBottom: -165, left: leftAnchor, paddingLeft: 20, right: rightAnchor, paddingRight: -20, width: 0, height: 0)
        
        addSubview(seeAllButton)
        seeAllButton.anchor(top: topAnchor, paddingTop: 5, bottom: bottomAnchor, paddingBottom: -165, left: leftAnchor, paddingLeft: frame.width / 1.2, right: rightAnchor, paddingRight: -20, width: 0, height: 0)
        seeAllButton.layer.cornerRadius = 15
        seeAllButton.clipsToBounds = true
        
        addSubview(firstServiceView)
        firstServiceView.anchor(top: titleLabel.bottomAnchor, paddingTop: 10, bottom: bottomAnchor, paddingBottom: -10, left: leftAnchor, paddingLeft: 20, right: rightAnchor, paddingRight: -(self.frame.width / 1.6), width: 0, height: 0)
        
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
        
        addSubview(secondServiceView)
        secondServiceView.anchor(top: titleLabel.bottomAnchor, paddingTop: 10, bottom: bottomAnchor, paddingBottom: -10, left: firstServiceView.rightAnchor, paddingLeft: 20, right: rightAnchor, paddingRight: -20, width: 0, height: 0)
        
        secondServiceView.addSubview(secondServiceImage)
        secondServiceImage.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        secondServiceImage.layer.cornerRadius = 15
        secondServiceImage.clipsToBounds = true
        secondServiceImage.anchor(top: secondServiceView.topAnchor, paddingTop: 0, bottom: secondServiceView.bottomAnchor, paddingBottom: -50, left: secondServiceView.leftAnchor, paddingLeft: 0, right: secondServiceView.rightAnchor, paddingRight: 0, width: 0, height: 0)
        
        secondServiceView.addSubview(secondLocationLabel)
        secondLocationLabel.anchor(top: secondServiceView.topAnchor, paddingTop: 5, bottom: secondServiceView.bottomAnchor, paddingBottom: -125, left: secondServiceView.leftAnchor, paddingLeft: 6, right: secondServiceView.rightAnchor, paddingRight: 0, width: 0, height: 0)
        
        secondServiceView.addSubview(secondTitle)
        secondTitle.anchor(top: secondServiceImage.bottomAnchor, paddingTop: 5, bottom: secondServiceView.bottomAnchor, paddingBottom: -25, left: secondServiceView.leftAnchor, paddingLeft: 6, right: secondServiceView.rightAnchor, paddingRight: 6, width: 0, height: 0)
        
        secondServiceView.addSubview(secondPrice)
        secondPrice.anchor(top: secondTitle.bottomAnchor, paddingTop: 0, bottom: secondServiceView.bottomAnchor, paddingBottom: -7, left: secondServiceView.leftAnchor, paddingLeft: 6, right: secondServiceView.rightAnchor, paddingRight: 6, width: 0, height: 0)
        
        firstServiceView.addSubview(firstServiceButton)
        firstServiceButton.anchor(top: firstServiceView.topAnchor, paddingTop: 0, bottom: firstServiceView.bottomAnchor, paddingBottom: 0, left: firstServiceView.leftAnchor, paddingLeft: 0, right: firstServiceView.rightAnchor, paddingRight: 0, width: 0, height: 0)
        
        secondServiceView.addSubview(secondServiceButton)
        secondServiceButton.anchor(top: secondServiceView.topAnchor, paddingTop: 0, bottom: secondServiceView.bottomAnchor, paddingBottom: 0, left: secondServiceView.leftAnchor, paddingLeft: 0, right: secondServiceView.rightAnchor, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class MenuListController: UITableViewController {
    
    let items = ["Recent", "My Jobs", "Payment", "My Reviews", "Favorites", "Settings", "Sign Out"]
        
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
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sideMenuCellNormal", for: indexPath)
            cell.textLabel?.textColor = UIColor.black
            cell.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
            cell.textLabel?.text = items[indexPath.row]
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            print("profile")
            self.navigationController?.pushViewController(MyProfile(), animated: true)
        } else {
            switch indexPath.row {
            case 0:
                print("0")
                self.navigationController?.pushViewController(CategoryPostController(), animated: true)
            case 1:
                print("1")
                self.navigationController?.pushViewController(MyJobs(), animated: true)
            case 2:
                print("3")
                self.navigationController?.pushViewController(Payment(), animated: true)
            case 3:
                print("4")
                self.navigationController?.pushViewController(MyReviews(), animated: true)
            case 4:
                print("5")
                self.navigationController?.pushViewController(Favorites(), animated: true)
            case 5:
                print("6")
                self.navigationController?.pushViewController(Settings(), animated: true)
            case 6:
                let alert = UIAlertController(title: "Are you sure you want to sign out?", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
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
        self.profileImage.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        
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
