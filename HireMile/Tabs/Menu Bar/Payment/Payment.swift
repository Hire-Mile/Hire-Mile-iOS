//
//  Payment.swift
//  HireMile
//
//  Created by JJ Zapata on 11/26/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit

class Payment: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let cashOutLauncher = CashOutLauncher()
    var timer : Timer?
        
    private let refrshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.black
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        return refreshControl
    }()
    
    let tableView : UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.backgroundColor = UIColor.white
        return tableview
    }()
    
    let cash : UILabel = {
        let label = UILabel()
        label.text = "Available cash"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = NSTextAlignment.left
        label.numberOfLines = 1
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cashNumber : UILabel = {
        let label = UILabel()
        label.text = "$500"
        label.font = UIFont.boldSystemFont(ofSize: 19)
        label.textAlignment = NSTextAlignment.right
        label.numberOfLines = 1
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bottomView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 236/255, green: 237/255, blue: 238/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let addCardView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 7
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 20
        view.layer.shadowOpacity = 0.1
        return view
    }()
    
    let cardImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "creditcard.fill")
        imageView.tintColor = UIColor.mainBlue
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let addLabel : UILabel = {
        let label = UILabel()
        label.text = "Add Debit or Credit Card"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = NSTextAlignment.left
        label.numberOfLines = 1
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addButton : UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 242/255, green: 243/255, blue: 244/255, alpha: 1)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = UIColor.black
        return button
    }()
    
    let everythingButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let bottomView2 : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 236/255, green: 237/255, blue: 238/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let loginButton : UIButton = {
        let button = UIButton()
        button.setTitle("Cash Out", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.mainBlue
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 22.5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cashOut), for: .touchUpInside)
        return button
    }()
    
    let bottomView3 : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 236/255, green: 237/255, blue: 238/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
 
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.register(PaymentCell.self, forCellReuseIdentifier: "paymentCellID")
 
        // Do any additional setup after loading the view.
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
 
        // Functions to throw
        self.basicSetup()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFunction), userInfo: nil, repeats: true)
        
    }
 
    func basicSetup() {
        self.view.backgroundColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = "Payment"
        self.navigationController?.navigationBar.tintColor = UIColor.mainBlue
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 247/255, green: 248/255, blue: 248/255, alpha: 1)
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .bottom, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        
        self.view.addSubview(cash)
        self.cash.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        self.cash.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        self.cash.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        self.cash.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        self.view.addSubview(cashNumber)
        self.cashNumber.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        self.cashNumber.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        self.cashNumber.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        self.cashNumber.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        self.view.addSubview(bottomView)
        self.bottomView.topAnchor.constraint(equalTo: self.cashNumber.bottomAnchor, constant: 20).isActive = true
        self.bottomView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        self.bottomView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -15).isActive = true
        self.bottomView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.view.addSubview(addCardView)
        self.addCardView.topAnchor.constraint(equalTo: self.bottomView.bottomAnchor, constant: 25).isActive = true
        self.addCardView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        self.addCardView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        self.addCardView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.addCardView.addSubview(cardImage)
        self.cardImage.topAnchor.constraint(equalTo: self.addCardView.topAnchor, constant: 10).isActive = true
        self.cardImage.leftAnchor.constraint(equalTo: self.addCardView.leftAnchor, constant: 10).isActive = true
        self.cardImage.bottomAnchor.constraint(equalTo: self.addCardView.bottomAnchor, constant: -10).isActive = true
        self.cardImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.addCardView.addSubview(addButton)
        self.addButton.topAnchor.constraint(equalTo: self.addCardView.topAnchor, constant: 10).isActive = true
        self.addButton.rightAnchor.constraint(equalTo: self.addCardView.rightAnchor, constant: -10).isActive = true
        self.addButton.bottomAnchor.constraint(equalTo: self.addCardView.bottomAnchor, constant: -10).isActive = true
        self.addButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.addCardView.addSubview(addLabel)
        self.addLabel.topAnchor.constraint(equalTo: self.addCardView.topAnchor, constant: 10).isActive = true
        self.addLabel.rightAnchor.constraint(equalTo: self.addButton.leftAnchor, constant: -10).isActive = true
        self.addLabel.bottomAnchor.constraint(equalTo: self.addCardView.bottomAnchor, constant: -10).isActive = true
        self.addLabel.leftAnchor.constraint(equalTo: self.cardImage.rightAnchor, constant: 10).isActive = true
        
        self.addCardView.addSubview(everythingButton)
        self.everythingButton.topAnchor.constraint(equalTo: self.addCardView.topAnchor).isActive = true
        self.everythingButton.rightAnchor.constraint(equalTo: self.addCardView.rightAnchor).isActive = true
        self.everythingButton.leftAnchor.constraint(equalTo: self.addCardView.leftAnchor).isActive = true
        self.everythingButton.bottomAnchor.constraint(equalTo: self.addCardView.bottomAnchor).isActive = true
        
        self.view.addSubview(bottomView2)
        self.bottomView2.topAnchor.constraint(equalTo: self.addCardView.bottomAnchor, constant: 25).isActive = true
        self.bottomView2.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        self.bottomView2.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -15).isActive = true
        self.bottomView2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.view.addSubview(loginButton)
        self.loginButton.topAnchor.constraint(equalTo: self.bottomView2.bottomAnchor, constant: 20).isActive = true
        self.loginButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        self.loginButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        self.loginButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.view.addSubview(bottomView3)
        self.bottomView3.topAnchor.constraint(equalTo: self.loginButton.bottomAnchor, constant: 20).isActive = true
        self.bottomView3.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        self.bottomView3.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -15).isActive = true
        self.bottomView3.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.view.addSubview(tableView)
        self.tableView.topAnchor.constraint(equalTo: self.bottomView3.bottomAnchor, constant: 0).isActive = true
        self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
 
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = true
        self.tableView.refreshControl = refrshControl
 
    }
       
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paymentCellID", for: indexPath) as! PaymentCell
        cell.textLabel?.text = "Name"
        cell.detailTextLabel?.text = "Description"
        cell.detailTextLabel?.textColor = UIColor.lightGray
        cell.selectionStyle = .none
        cell.profileImageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    @objc func addButtonPressed() {
        self.navigationController?.present(AddCard(), animated: true, completion: nil)
    }
    
    @objc func cashOut() {
        cashOutLauncher.showAlert()
    }
    
    @objc func timerFunction() {
        if GlobalVariables.isCheckedOut == true {
            let alert = UIAlertController(title: "Success", message: "You have successfully cashed out", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                self.timer?.invalidate()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @objc func refreshAction() {
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(hideRefrsh), userInfo: nil, repeats: false)
    }
    
    @objc func hideRefrsh() {
        self.refrshControl.endRefreshing()
    }

}

class PaymentCell: UITableViewCell {
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 75, y: textLabel!.frame.origin.y, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 75, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let amountSpentOrEarned : UILabel = {
        let label = UILabel()
        label.text = "+ $$"
        label.textAlignment = NSTextAlignment.right
        label.textColor = UIColor.darkGray
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        addSubview(amountSpentOrEarned)
        amountSpentOrEarned.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        amountSpentOrEarned.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        amountSpentOrEarned.widthAnchor.constraint(equalToConstant: 48).isActive = true
        amountSpentOrEarned.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
