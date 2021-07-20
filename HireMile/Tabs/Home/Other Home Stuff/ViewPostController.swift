//
//  ViewPostController.swift
//  HireMile
//
//  Created by JJ Zapata on 11/18/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import ZKCarousel
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class ViewPostController: UIViewController, UITextFieldDelegate {
    
    
    let launcher = ProposalPopup()
    var height : CGFloat = 0
    var collectView : UICollectionView?
    var pagecon : UIPageControl?
    var arrayOfStrImages = [String]()
    
    var postImage2 = UIImageView()
    var postImageDownlodUrl = ""
    var postTitle = ""
    var postDescription = ""
    var postPrice = 0
    var userUID = ""
    var postId = ""
    var authorId = ""
    var type = ""
    
    let carousel : UIImageView = {
        let carousel = UIImageView()
        carousel.contentMode = .scaleAspectFill
        carousel.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        carousel.translatesAutoresizingMaskIntoConstraints = false
        return carousel
    }()
    
    let informationView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 40
        view.layer.cornerRadius = 15
        return view
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Service Title"
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.numberOfLines = 3
        label.textAlignment = .left
        return label
    }()
    
    let descriptionLabel : UILabel = {
        let label = UILabel()
        label.text = "Service Description"
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.textColor = UIColor.black
//        label.isScrollEnabled = true
//        label.alwaysBounceHorizontal = false
//        label.alwaysBounceVertical = true
        label.backgroundColor = .white
        label.textAlignment = .left
//        label.isSelectable = false
//        label.isEditable = false
        return label
    }()
    
    let priceLabel : UITextView = {
        let label = UITextView()
        label.text = "Price"
        label.isSelectable = false
        label.isEditable = false
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.textAlignment = .left
        return label
    }()
    
    let profileImage : CustomImageView = {
        let imageView = CustomImageView()
//        imageView.image = UIImage(named: "woman-profile")
        imageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let textField : UITextField = {
        let tf = UITextField()
        tf.tintColor = UIColor.mainBlue
        tf.textColor = UIColor.black
        tf.backgroundColor = UIColor.white
        tf.borderStyle = .none
        tf.returnKeyType = .done
        tf.placeholder = "Say Something..."
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let seeAllButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.setTitle("SEND", for: .normal)
        button.addTarget(self, action: #selector(sendPressed), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let largeView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1).cgColor
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let lineView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.blue
        return view
    }()
    
    let bottomView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let HireButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 53/255, green: 167/255, blue: 245/255, alpha: 1)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Hire", for: .normal)
        button.addTarget(self, action: #selector(hirePressed), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let priceUserLabel : UILabel = {
        let label = UILabel()
        label.text = "$30"
        label.font = UIFont.systemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = UIColor.black
        label.backgroundColor = .white
        label.textAlignment = .left
        return label
    }()
    
    let rattingLabel : UILabel = {
        let label = UILabel()
        label.text = "4.5 (100)"
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = UIColor.darkGray
        label.backgroundColor = .white
        label.textAlignment = .left
        
        
        
        return label
    }()
    
    
    
    @objc func pressed() {
        let alert = UIAlertController(title: "Would you like to report this post?", message: "Management And Administration will notice", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Yes, Report Post", style: .default, handler: { (action) in
            let block = UIAlertController(title: "Post Report", message: "", preferredStyle: .alert)
            block.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            let key = Database.database().reference().child("Reported-Posts").childByAutoId().key
            let values = [
                "post-id" : self.postId,
                "key" : key,
                "reporter" : Auth.auth().currentUser!.uid
            ]
            Database.database().reference().child("Reported-Posts").child(key!).updateChildValues(values) { (error, ref) in
                self.present(block, animated: true, completion: nil)
            }
        }))
        if let popoverController = alert.popoverPresentationController {
          popoverController.sourceView = self.view
          popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "report"), landscapeImagePhone: UIImage(named: "report"), style: .plain, target: self, action: #selector(pressed))
        
        // Functions to throw
        
//        let url = URL(string: GlobalVariables.postImageDownlodUrl)
//        self.carousel.kf.setImage(with: url)
//        GlobalVariables.postImageDownlodUrl = ""
        self.carousel.sd_setImage(with: URL(string: postImageDownlodUrl), completed: nil)
        
        self.titleLabel.text = postTitle
        self.descriptionLabel.text = postDescription
        self.height = self.estimateFrameForText(text: self.descriptionLabel.text!).height
        self.addSubviews()
        self.addConstraints()
        self.addColletionView()
        if type == "Hourly" {
            self.priceLabel.text = "$\(postPrice) / Hour"
        } else {
            self.priceLabel.text = "$\(postPrice)"
        }
       
        /* self.postId = postId
         self.authorId = authorId
         print(authorId)
        self.authorId = authorId
        */
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Functions to throw
        self.basicSetup()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(setName), userInfo: nil, repeats: false)
        rattingLabelText(str: "4.5 (100)")
    }
    
    @objc func setName() {
        Database.database().reference().child("Users").child(self.authorId).child("name").observe(.value) { (snapshot) in
            if let name : String = (snapshot.value as? String) {
                self.navigationItem.title = name
            }
        }
        Database.database().reference().child("Users").child(self.authorId).child("profile-image").observe(.value) { (snapshot) in
            if let url : String = (snapshot.value as? String) {
                self.profileImage.sd_setImage(with: URL(string: url), completed: nil)
            }
        }
    }
    
    func addSubviews() {
              
        self.view.addSubview(self.carousel)
        self.view.addSubview(self.informationView)
        self.informationView.addSubview(self.titleLabel)
        self.informationView.addSubview(self.descriptionLabel)
        self.informationView.addSubview(self.priceLabel)
        self.informationView.addSubview(self.profileImage)
        self.view.addSubview(self.largeView)
        self.largeView.addSubview(self.seeAllButton)
        self.largeView.addSubview(self.textField)
        self.view.addSubview(self.lineView)
        self.view.addSubview(self.bottomView)
        self.bottomView.addSubview(self.HireButton)
        self.bottomView.addSubview(self.priceUserLabel)
        self.bottomView.addSubview(self.rattingLabel)
        
      
    }
    
    func addConstraints() {
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        
        let heightConstraint = self.informationView.heightAnchor.constraint(equalToConstant: 175)
        let bottomConstraint = self.informationView.bottomAnchor.constraint(equalTo: self.priceLabel.bottomAnchor)
        
        self.carousel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.carousel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.carousel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.carousel.heightAnchor.constraint(equalToConstant: self.view.frame.height / 3).isActive = true
        
        self.informationView.topAnchor.constraint(equalTo: self.carousel.bottomAnchor, constant: 20).isActive = true
        self.informationView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        self.informationView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        heightConstraint.isActive = true
        bottomConstraint.isActive = false
        
        self.titleLabel.topAnchor.constraint(equalTo: self.informationView.topAnchor, constant: 15).isActive = true
        self.titleLabel.leftAnchor.constraint(equalTo: self.informationView.leftAnchor, constant: 15).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: self.informationView.rightAnchor, constant: -75).isActive = true
        self.titleLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 150).isActive = true
        
        self.descriptionLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: -5).isActive = true
        self.descriptionLabel.leftAnchor.constraint(equalTo: self.informationView.leftAnchor, constant: 15).isActive = true
        self.descriptionLabel.rightAnchor.constraint(equalTo: self.informationView.rightAnchor, constant: -75).isActive = true
        self.descriptionLabel.heightAnchor.constraint(equalToConstant: self.height + 30).isActive = true
        
        self.priceLabel.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: -15).isActive = true
        self.priceLabel.leftAnchor.constraint(equalTo: self.informationView.leftAnchor, constant: 10).isActive = true
        self.priceLabel.rightAnchor.constraint(equalTo: self.informationView.rightAnchor, constant: -15).isActive = true
        self.priceLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.profileImage.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: -15).isActive = true
        self.profileImage.rightAnchor.constraint(equalTo: self.informationView.rightAnchor, constant: -15).isActive = true
        self.profileImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.profileImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.largeView.topAnchor.constraint(equalTo: self.informationView.bottomAnchor, constant: 20).isActive = true
        self.largeView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.largeView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.largeView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.seeAllButton.rightAnchor.constraint(equalTo: self.largeView.rightAnchor).isActive = true
        self.seeAllButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.seeAllButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.seeAllButton.centerYAnchor.constraint(equalTo: self.largeView.centerYAnchor).isActive = true
        
        self.textField.topAnchor.constraint(equalTo: self.largeView.topAnchor).isActive = true
        self.textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.textField.leftAnchor.constraint(equalTo: self.largeView.leftAnchor, constant: 20).isActive = true
        self.textField.rightAnchor.constraint(equalTo: self.seeAllButton.leftAnchor, constant: -10).isActive = true
        
        self.lineView.topAnchor.constraint(equalTo: self.largeView.bottomAnchor, constant: 60).isActive = true
        self.lineView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant:5).isActive = true
        self.lineView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5).isActive = true
        self.lineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        self.bottomView.topAnchor.constraint(equalTo: self.lineView.bottomAnchor, constant: 20).isActive = true
        self.bottomView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 5).isActive = true
        self.bottomView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5).isActive = true
        self.bottomView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.HireButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 125).isActive = true
        self.HireButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.HireButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.HireButton.topAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 20).isActive = true
        
        self.priceUserLabel.topAnchor.constraint(equalTo: self.bottomView.topAnchor, constant: 10).isActive = true
        self.priceUserLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        self.priceUserLabel.leftAnchor.constraint(equalTo: self.bottomView.leftAnchor, constant: 20).isActive = true
        self.priceUserLabel.rightAnchor.constraint(equalTo: self.HireButton.leftAnchor, constant: -10).isActive = true
        
        self.rattingLabel.topAnchor.constraint(equalTo: self.priceUserLabel.bottomAnchor, constant: 5).isActive = true
        self.rattingLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        self.rattingLabel.leftAnchor.constraint(equalTo: self.bottomView.leftAnchor, constant: 20).isActive = true
        self.rattingLabel.rightAnchor.constraint(equalTo: self.HireButton.leftAnchor, constant: -10).isActive = true
        
        heightConstraint.isActive = false
        bottomConstraint.isActive = true
        
    }
    
    func addColletionView()  {
      
        print(self.carousel.frame.size.height)

        let array = postImageDownlodUrl.components(separatedBy: ",")
        arrayOfStrImages = array
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
    //    let vwWidth = (self.view.frame.width)
     //   layout.itemSize = CGSize(width: vwWidth, height: 250)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
       
        
        self.collectView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240), collectionViewLayout: layout)
        self.collectView!.translatesAutoresizingMaskIntoConstraints = false
        self.collectView!.backgroundColor = UIColor.white
        self.collectView!.alwaysBounceVertical = false
        self.collectView!.alwaysBounceHorizontal = true
        self.collectView!.dataSource = self
        self.collectView!.showsHorizontalScrollIndicator = false
        self.collectView!.showsVerticalScrollIndicator = false
        self.collectView!.delegate = self
        self.collectView!.isPagingEnabled = true
        self.collectView!.register(UINib(nibName: "CoverPhotoCell", bundle: nil), forCellWithReuseIdentifier: "CoverPhotoCell")
        self.view.addSubview(collectView!)

        self.collectView!.reloadData()
        
        self.pagecon = UIPageControl(frame: CGRect(x: 0, y: 220, width: self.view.frame.width , height: 10))
        pagecon!.numberOfPages = arrayOfStrImages.count
        pagecon!.currentPage = 0
        pagecon!.pageIndicatorTintColor = UIColor.darkGray
        pagecon!.currentPageIndicatorTintColor = UIColor.white
        self.view.addSubview(self.pagecon!)
        self.carousel.isHidden = true
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], context: nil)
    }
    
    func basicSetup() {
        self.view.backgroundColor = UIColor.white
        
        self.textField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationItem.backButtonTitle = ""
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "whiteback"), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func changeButtonStatus() {
        if self.textField.text != " " || self.textField.text != "  " || self.textField.text != "   " {
            self.seeAllButton.backgroundColor = UIColor.mainBlue
            self.seeAllButton.setTitleColor(UIColor.white, for: .normal)
        } else {
            self.seeAllButton.backgroundColor = UIColor(red: 242/255, green: 235/255, blue: 235/255, alpha: 1)
            self.seeAllButton.setTitleColor(UIColor(red: 131/255, green: 131/255, blue: 131/255, alpha: 1), for: .normal)
        }
    }
    
    @objc func keyboardUp(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = 0
            self.view.frame.origin.y -= 90
        }
    }
    
    @objc func keyboardDown(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = 0
        }
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        // send uid
        Database.database().reference().child("Jobs").child(postId).child("author").observe(.value) { (snapshot) in
            if let profileUID : String = (snapshot.value as? String) {
                if let profileVC = CommonUtils.getStoryboardVC(StoryBoard.Profile.rawValue, vcIdetifier: UserProfileViewController.className) as? UserProfileViewController {
                    profileVC.userUID = profileUID
                    self.navigationController?.pushViewController(profileVC,  animated: true)
                }
            }
        }
        // following
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("began")
        if textField.text != "  Say Something..." {
            //
        } else {
            self.textField.text = "   "
        }
    }
    
    @objc func textFieldDidChange() {
        self.changeButtonStatus()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.frame.origin.y += 90
        return (true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.textField.isFirstResponder {
            self.view.frame.origin.y += 90
            self.view.endEditing(true)
        }
    }
    
    func calculateHeight(text: String, width: CGFloat) -> CGFloat {
            let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
            let boundingBox = text.boundingRect(with: constraintRect,
                                            options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                            attributes: [NSAttributedString.Key.font: self],
                                            context: nil)
            return boundingBox.height
        }
    
    @objc func sendPressed() {
        if self.textField.text != " " && self.textField.text != "  " && self.textField.text != "   " && self.textField.text != nil && self.textField.text != "  Say Something..." && self.textField.text != "" {
            let ref = Database.database().reference().child("Messages")
            let childRef = ref.childByAutoId()
            let toId = authorId
            let fromId = Auth.auth().currentUser!.uid
            let timestamp = Int(Date().timeIntervalSince1970)
            let key = Database.database().reference().child("Users").child(toId).child("My_Jobs").childByAutoId().key
            let values = ["text": textField.text!, "toId": toId, "fromId": fromId, "timestamp": timestamp, "first-time" : true, "service-provider" : toId, "job-id" : self.postId, "job-ref-id" : key, "hasViewed" : false, "text-id" : childRef.key] as [String : Any]
            childRef.updateChildValues(values) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }

                guard let messageId = childRef.key else { return }

                let userMessagesRef = Database.database().reference().child("User-Messages").child(fromId).child(toId).child(messageId)
                userMessagesRef.setValue(1)

                let recipientUserMessagesRef = Database.database().reference().child("User-Messages").child(toId).child(fromId).child(messageId)
                recipientUserMessagesRef.setValue(1)


                Database.database().reference().child("Users").child(toId).child("fcmToken").observe(.value) { (snapshot) in
                    let token : String = (snapshot.value as? String)!
                    let sender = PushNotificationSender()
                    Database.database().reference().child("Users").child(fromId).child("name").observe(.value) { (snapshot) in
                        let name : String = (snapshot.value as? String)!
                        sender.sendPushNotification(to: token, title: "Chat Notification", body: "New message from \(name)", page: true, senderId: Auth.auth().currentUser!.uid, recipient: toId)
                    }
                }

                self.textField.text = nil
                self.textField.resignFirstResponder()

                self.launcher.showFilter()
                self.launcher.applyButton.addTarget(self, action: #selector(self.handleDismiss), for: .touchUpInside)
            }
            print("not empty")
        } else {
            print("empty")
            let alert = UIAlertController(title: "Error", message: "Please enter valid text", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func hirePressed() {
        print("Hire Pressed")
        if let profileVC = CommonUtils.getStoryboardVC(StoryBoard.Appointment.rawValue, vcIdetifier: BookAppointmentVC.className) as? BookAppointmentVC {
            profileVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(profileVC,  animated: true)
        }
    }
    
    @objc func handleDismiss() {
        self.launcher.handleDismiss()
        self.navigationController?.popViewController(animated: true)
    }

    func rattingLabelText(str : String)  {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named:"starSelected")
        let attachmentString1 = NSAttributedString(attachment: imageAttachment)
        let completeText = NSMutableAttributedString(string: " ")
        completeText.append(attachmentString1)
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: str)
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightGray, range: NSRange(location:3,length:6))
        completeText.append(myMutableString)
        rattingLabel.attributedText = completeText
    }
}
extension ViewPostController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate  {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfStrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoverPhotoCell", for: indexPath) as! CoverPhotoCell
        cell.vWMain.layer.cornerRadius = 0.0
        cell.imgCoverPhoto.layer.cornerRadius = 0.0
        cell.imgCoverPhoto.sd_setImage(with: URL(string: arrayOfStrImages[indexPath.item]), completed: nil)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: self.view.frame.size.width , height: 240)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    //MARK: ====: UIScrollView Delegate :====
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let count = scrollView.contentOffset.x / scrollView.frame.size.width
            self.pagecon!.currentPage = Int(count)
        }
    
}

