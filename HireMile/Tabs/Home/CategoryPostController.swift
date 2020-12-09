//
//  CategoryPostController.swift
//  HireMile
//
//  Created by JJ Zapata on 11/18/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit

class CategoryPostController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let filterLauncher = FilterLauncher()

    private let refrshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.black
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        return refreshControl
    }()

    let tableView : UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.separatorStyle = .none
        tableview.register(CategoryCell.self, forCellReuseIdentifier: "categoryCell")
        tableview.backgroundColor = UIColor.white
        return tableview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Functions to throw
        self.addSubviews()
        self.addConstraints()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Functions to throw
        self.basicSetup()
    }

    func addSubviews() {
        self.view.addSubview(self.tableView)
    }

    func addConstraints() {
        self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.tableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 10).isActive = true
    }

    func basicSetup() {
        self.view.backgroundColor = UIColor.white

        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.mainBlue
        self.navigationController?.navigationBar.topItem?.title = "Title"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(filterPressed))

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.refreshControl = refrshControl
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryCell
        // #add target to heart tapped
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hello")
        self.navigationController?.pushViewController(ViewPostController(), animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }

    @objc func filterPressed() {
        filterLauncher.showFilter()
    }

    @objc func refreshAction() {
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(hideRefrsh), userInfo: nil, repeats: false)
    }

    @objc func hideRefrsh() {
        self.refrshControl.endRefreshing()
    }

}

class CategoryCell: UITableViewCell {

    let titleImageView : UIImageView = {
        let imageView = UIImageView()
//        imageView.image = UIImage(named: "haircut")
        imageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let infoView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 15
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 30
        view.layer.shadowOpacity = 0.2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        return view
    }()

    let heartButton : UIButton = {
         let button = UIButton()
         button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
         button.imageView?.tintColor = UIColor.red
         button.tintColor = UIColor.red
         button.layer.cornerRadius = 20
         button.translatesAutoresizingMaskIntoConstraints = false
         button.backgroundColor = UIColor.white
         return button
    }()

    let priceTag : UILabel = {
        let label = UILabel()
        label.text = "Price"
        label.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        label.textColor = UIColor.mainBlue
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()

    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()

    let locationAndTime : UILabel = {
        let label = UILabel()
//        label.text = "3.5mi away  -  10 min ago"
        label.text = "Info"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = UIColor.white
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = UIColor.white
        setup()
    }

    func setup() {
        addSubview(titleImageView)
        titleImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        titleImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        titleImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        titleImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40).isActive = true

        addSubview(infoView)
        infoView.topAnchor.constraint(equalTo: titleImageView.bottomAnchor, constant: -20).isActive = true
        infoView.rightAnchor.constraint(equalTo: titleImageView.rightAnchor, constant: -10).isActive = true
        infoView.leftAnchor.constraint(equalTo: titleImageView.leftAnchor, constant: 10).isActive = true
        infoView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true

        addSubview(heartButton)
        heartButton.topAnchor.constraint(equalTo: titleImageView.topAnchor, constant: 10).isActive = true
        heartButton.rightAnchor.constraint(equalTo: titleImageView.rightAnchor, constant: -10).isActive = true
        heartButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        heartButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

        infoView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 10).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: -10).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: infoView.rightAnchor, constant: -10).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: infoView.leftAnchor, constant: 10).isActive = true

        infoView.addSubview(priceTag)
        priceTag.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 10).isActive = true
        priceTag.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: -10).isActive = true
        priceTag.rightAnchor.constraint(equalTo: infoView.rightAnchor, constant: -10).isActive = true
        priceTag.leftAnchor.constraint(equalTo: infoView.leftAnchor, constant: 10).isActive = true

        addSubview(locationAndTime)
        locationAndTime.topAnchor.constraint(equalTo: titleImageView.topAnchor, constant: 10).isActive = true
        locationAndTime.heightAnchor.constraint(equalToConstant: 20).isActive = true
        locationAndTime.rightAnchor.constraint(equalTo: titleImageView.rightAnchor, constant: -10).isActive = true
        locationAndTime.leftAnchor.constraint(equalTo: titleImageView.leftAnchor, constant: 10).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
