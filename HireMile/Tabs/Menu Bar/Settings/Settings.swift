//
//  Settings.swift
//  HireMile
//
//  Created by JJ Zapata on 11/20/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit

class Settings: UITableViewController {  // change to tableview tonoller
    
    let titles = ["Edit Profile", "Password", "youremail@gmail.com"]
    let images = ["person.crop.circle", "lock", "envelope"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "settingsCellID")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Functions to throw
        self.basicSetup()
    }
    
    func basicSetup() {
        self.view.backgroundColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = "Settings"
        self.navigationController?.navigationBar.tintColor = UIColor.mainBlue

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCellID", for: indexPath) as! SettingsCell
        cell.textLabel?.text = titles[indexPath.row]
        cell.profileImageView.image = UIImage(systemName: images[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(EditProfile(), animated: true)
        case 1:
            self.navigationController?.pushViewController(Password(), animated: true)
        default:
            self.navigationController?.pushViewController(Email(), animated: true)
        }
    }

}

class SettingsCell: UITableViewCell {

    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIColor.black
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        textLabel?.frame = CGRect(x: 55, y: textLabel!.frame.origin.y + 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
