//
//  Password.swift
//  HireMile
//
//  Created by JJ Zapata on 11/20/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit

class Password: UITableViewController {

    private let titles = ["Change Password", "Reset Password"]
    private let pages = [ChangePassword(), Password()]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "passwordPageCellID")

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
        self.navigationController?.navigationBar.prefersLargeTitles = false    
        self.navigationController?.navigationBar.topItem?.title = "Password"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "passwordPageCellID", for: indexPath) as! SettingsCell
        cell.textLabel?.text = titles[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(pages[indexPath.row], animated: true)
    }

}
