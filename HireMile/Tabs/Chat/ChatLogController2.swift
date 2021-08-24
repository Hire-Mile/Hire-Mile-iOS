//
//  ChatLogController.swift
//  HireMile
//
//  Created by JJ Zapata on 12/26/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseAuth
import AVFoundation
import MBProgressHUD
import FirebaseStorage
import FirebaseDatabase
import MobileCoreServices
import CoreLocation

protocol UserCellDelegate {
    func didPressButton(_ tag: Int)
}

class ChatLogController2: UICollectionViewController, UITextFieldDelegate , UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate, UserCellDelegate {
    
    
    var user : UserChat? {
        didSet {
            navigationItem.title = user?.name
            observeMessages()
        }
    }
    
    let locationManager = CLLocationManager()
    
    var myLocation : CLLocationCoordinate2D?
    
    var isShowingExtra = false
    
    var enableButton : Bool?
    
    var imageView : UIImageView?
    
    var messages = [Message]()
    
    var startingFrame : CGRect?
    
    var blackBackground : UIView?
    
    var messageType = ""
    
    var theMessage = ""
    
    var jobId = ""
    
    var fromKeyboard = false
    
    var chatId = ""
    
    var isShowing = false
    
    var jobRefId = ""
    
    var isSearchingForServiceProvider = true
    
    let cellId = "myCellId"
    
    let imagePicker = UIImagePickerController()
    
    let filterLauncher = FinishLauncher()
    
    let inputTextField : UITextField = {
        let inputTextField = UITextField()
        inputTextField.placeholder = "Write here"
        inputTextField.textColor = UIColor.black
        inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:) ), for: .editingChanged)
        inputTextField.borderStyle = .none
        inputTextField.layer.cornerRadius = 20
        inputTextField.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        inputTextField.tintColor = UIColor.mainBlue
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        return inputTextField
    }()
    
    let inputTextView : UIView = {
        let inputTextView = UIView()
        inputTextView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        inputTextView.layer.cornerRadius = 20
        inputTextView.translatesAutoresizingMaskIntoConstraints = false
        return inputTextView
    }()
    
    let attachmentButton : UIButton = {
        let attachmentButton = UIButton(type: .system)
        attachmentButton.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        attachmentButton.setImage(UIImage(named: "grid-alone"), for: .normal)
        attachmentButton.tintColor = UIColor.darkGray
        attachmentButton.layer.cornerRadius = 20
        attachmentButton.addTarget(self, action: #selector(didSelectGrid), for: .touchUpInside)
        attachmentButton.translatesAutoresizingMaskIntoConstraints = false
        return attachmentButton
    }()
    
    let cameraButton : UIButton = {
        let attachmentButton = UIButton(type: .system)
        attachmentButton.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        attachmentButton.setImage(UIImage(named: "cam-alone"), for: .normal)
        attachmentButton.tintColor = UIColor.darkGray
        attachmentButton.layer.cornerRadius = 20
        attachmentButton.addTarget(self, action: #selector(didSelectImage), for: .touchUpInside)
        attachmentButton.translatesAutoresizingMaskIntoConstraints = false
        return attachmentButton
    }()
    
    let sendButton : UIButton = {
        let sendButton = UIButton(type: .system)
        sendButton.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        sendButton.layer.cornerRadius = 20
        sendButton.setImage(UIImage(named: "send-inactive"), for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        return sendButton
    }()
    
    let secondContainer : UIView = {
        let secondContainer = UIView()
        secondContainer.backgroundColor = UIColor.white
        secondContainer.translatesAutoresizingMaskIntoConstraints = false
        return secondContainer
    }()
    
    let containerView : UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
//        containerView.addBottomShadow()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    let optionView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let firstButton : UIButton = {
        let view = UIButton()
        view.addTarget(self, action: #selector(booking), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(named: "booking"), for: .normal)
        return view
    }()
    
    let secondButton : UIButton = {
        let view = UIButton()
        view.addTarget(self, action: #selector(didSelectImagePhoto), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(named: "photo"), for: .normal)
        return view
    }()
    
    let thirdButton : UIButton = {
        let view = UIButton()
        view.addTarget(self, action: #selector(location), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(named: "locatiom"), for: .normal)
        return view
    }()
    
    let fourthButton : UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(exitExtra), for: .touchUpInside)
        view.setImage(UIImage(named: "close-circle"), for: .normal)
        return view
    }()
    
    let firstLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Booking"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 118/255, green: 118/255, blue: 118/255, alpha: 1)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    let secondLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Image"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 118/255, green: 118/255, blue: 118/255, alpha: 1)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    let thirdLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Location"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 118/255, green: 118/255, blue: 118/255, alpha: 1)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    let fourthLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Close"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 118/255, green: 118/255, blue: 118/255, alpha: 1)
        label.textAlignment = NSTextAlignment.center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 95, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 95, right: 0)
        collectionView.keyboardDismissMode = .interactive
        
        self.setupInputComponents()
        self.setupKeyboardObservers()
        
        self.enableButton = false
        if enableButton == true {
            self.sendButton.tintColor = UIColor(red: 118/255, green: 118/255, blue: 118/255, alpha: 1)
        } else {
            self.sendButton.tintColor = UIColor(red: 213/255, green: 213/255, blue: 213/255, alpha: 1)
        }
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            for message in self.messages {
                Database.database().reference().child("Messages").child(message.textId!).child("hasViewed").setValue(true)
            }
        }
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "whiteback"), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.backButtonTitle = " "
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 5.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.2
        self.navigationController?.navigationBar.layer.masksToBounds = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    var containerViewBottomAnchor : NSLayoutConstraint?
    
    func setupInputComponents() {
        
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        
        view.addSubview(optionView)
        setupOptionView()
        optionView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        optionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        optionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        optionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        view.addSubview(containerView)
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        view.addSubview(secondContainer)
        secondContainer.topAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        secondContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        secondContainer.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        secondContainer.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        
        containerView.addSubview(attachmentButton)
        attachmentButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        attachmentButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        attachmentButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        attachmentButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.addSubview(cameraButton)
        cameraButton.leftAnchor.constraint(equalTo: attachmentButton.rightAnchor, constant: 16).isActive = true
        cameraButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        cameraButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        cameraButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.addSubview(inputTextView)
        inputTextView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
        inputTextView.leftAnchor.constraint(equalTo: cameraButton.rightAnchor, constant: 16).isActive = true
        inputTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        inputTextView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: inputTextView.rightAnchor, constant: -5).isActive = true
        sendButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        inputTextView.addSubview(inputTextField)
        inputTextField.delegate = self
        inputTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
        inputTextField.leftAnchor.constraint(equalTo: inputTextView.leftAnchor, constant: 10).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: inputTextView.rightAnchor, constant: -45).isActive = true
        inputTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupOptionView() {
        
        let spacing : Int = Int(((self.view.frame.size.width - 60) - 160) / 3)
        print(spacing)
        
        optionView.addSubview(firstButton)
        firstButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        firstButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        firstButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        firstButton.centerYAnchor.constraint(equalTo: optionView.centerYAnchor, constant: -10).isActive = true
        
        optionView.addSubview(fourthButton)
        fourthButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        fourthButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        fourthButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        fourthButton.centerYAnchor.constraint(equalTo: optionView.centerYAnchor, constant: -10).isActive = true
        
        optionView.addSubview(secondButton)
        secondButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        secondButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        secondButton.leftAnchor.constraint(equalTo: firstButton.rightAnchor, constant: CGFloat(spacing)).isActive = true
        secondButton.centerYAnchor.constraint(equalTo: optionView.centerYAnchor, constant: -10).isActive = true
        
        optionView.addSubview(thirdButton)
        thirdButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        thirdButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        thirdButton.leftAnchor.constraint(equalTo: secondButton.rightAnchor, constant: CGFloat(spacing)).isActive = true
        thirdButton.centerYAnchor.constraint(equalTo: optionView.centerYAnchor, constant: -10).isActive = true
        
        optionView.addSubview(firstLabel)
        firstLabel.topAnchor.constraint(equalTo: firstButton.bottomAnchor, constant: 8).isActive = true
        firstLabel.leftAnchor.constraint(equalTo: firstButton.leftAnchor, constant: -15).isActive = true
        firstLabel.rightAnchor.constraint(equalTo: firstButton.rightAnchor, constant: 15).isActive = true
        firstLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        optionView.addSubview(secondLabel)
        secondLabel.topAnchor.constraint(equalTo: secondButton.bottomAnchor, constant: 8).isActive = true
        secondLabel.leftAnchor.constraint(equalTo: secondButton.leftAnchor, constant: -15).isActive = true
        secondLabel.rightAnchor.constraint(equalTo: secondButton.rightAnchor, constant: 15).isActive = true
        secondLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        optionView.addSubview(thirdLabel)
        thirdLabel.topAnchor.constraint(equalTo: thirdButton.bottomAnchor, constant: 8).isActive = true
        thirdLabel.leftAnchor.constraint(equalTo: thirdButton.leftAnchor, constant: -15).isActive = true
        thirdLabel.rightAnchor.constraint(equalTo: thirdButton.rightAnchor, constant: 15).isActive = true
        thirdLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        optionView.addSubview(fourthLabel)
        fourthLabel.topAnchor.constraint(equalTo: fourthButton.bottomAnchor, constant: 8).isActive = true
        fourthLabel.leftAnchor.constraint(equalTo: fourthButton.leftAnchor, constant: -15).isActive = true
        fourthLabel.rightAnchor.constraint(equalTo: fourthButton.rightAnchor, constant: 15).isActive = true
        fourthLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        cell.chatLogController = self
        
        cell.index = indexPath
        
        let message = messages[indexPath.row]
        cell.textView.text = message.text
        setupCell(cell: cell, message: message)
        
        if let text = message.text {
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: text).width + 32
            cell.textView.isHidden = false
        } else if message.imageUrl != nil {
            cell.bubbleWidthAnchor?.constant = 200
            cell.textView.isHidden = true
        }
        
        let btn_left=UIButton(frame: CGRect(x: 8, y: cell.frame.height - 51, width: 32, height: 32))
        btn_left.isUserInteractionEnabled = true
        btn_left.addTarget(self, action: #selector(btnleftClick), for: .touchUpInside)
        cell.addSubview(btn_left)
        
        let btn_right=UIButton(frame: CGRect(x: cell.frame.width - 40, y: cell.frame.height - 51, width: 32, height: 32))
        btn_right.isUserInteractionEnabled = true
        btn_right.addTarget(self, action: #selector(btnrightClick), for: .touchUpInside)
        cell.addSubview(btn_right)
        
        cell.messageImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageTap)))
        
        cell.delegate = self
        
        return cell
    }
    
    @objc func btnrightClick(_ sender: UIButton) {
        if let profileVC = CommonUtils.getStoryboardVC(StoryBoard.Profile.rawValue, vcIdetifier: MyProfilesVC.className) as? MyProfilesVC {
            profileVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(profileVC,  animated: true)
        }
        print("right")
    }
    
    @objc func btnleftClick(_ sender: UIButton) {
        if let profileVC = CommonUtils.getStoryboardVC(StoryBoard.Profile.rawValue, vcIdetifier: UserProfileViewController.className) as? UserProfileViewController {
            profileVC.userUID = user!.id!
            self.navigationController?.pushViewController(profileVC,  animated: true)
        }
        print("left")
    }
    
    private func setupCell(cell: ChatMessageCell, message: Message) {
        
        if let profileImageUrl = self.user?.profileImageUrl {
           // cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        } else {
            cell.profileImageView.backgroundColor = UIColor.clear
           // cell.profileImageView.image = UIImage(systemName: "person.circle.fill")
            cell.profileImageView.tintColor = UIColor.lightGray
            cell.profileImageView.contentMode = .scaleAspectFill
        }
        
        // get time sent
        if let seconds = message.timestamp?.doubleValue {
            let timeStampDate = Date(timeIntervalSince1970: seconds)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            cell.timeSent.text = dateFormatter.string(from: timeStampDate)
        }
        
        if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("Users").child(uid).child("profile-image").observe(.value) { (snapshot) in
                let profileImageString : String = (snapshot.value as? String)!
                if profileImageString == "not-yet-selected" {
                   // cell.myProfileImageView.image = UIImage(systemName: "person.circle.fill")
                    cell.myProfileImageView.tintColor = UIColor.lightGray
                    cell.myProfileImageView.contentMode = .scaleAspectFill
                } else {
                  //  cell.myProfileImageView.loadImageUsingCacheWithUrlString(profileImageString)
                    cell.myProfileImageView.tintColor = UIColor.lightGray
                    cell.myProfileImageView.contentMode = .scaleAspectFill
                }
            }
        }
        
        if message.fromId == Auth.auth().currentUser?.uid {
            // current user
            cell.leftAnchorRec?.isActive = false
            cell.rightAnchorMe?.isActive = true
            cell.timeSent.textAlignment = NSTextAlignment.right
            cell.bubbleView.backgroundColor = UIColor.mainBlue
            cell.textView.textColor = UIColor.white
            cell.myProfileImageView.isHidden = false
            cell.profileImageView.isHidden = true
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        } else {
            // recipient
            cell.leftAnchorRec?.isActive = true
            cell.rightAnchorMe?.isActive = false
            cell.timeSent.textAlignment = NSTextAlignment.left
            cell.myProfileImageView.isHidden = true
            cell.profileImageView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
            cell.textView.textColor = UIColor.black
            cell.profileImageView.isHidden = false
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
        
        if let messageImageUrl = message.imageUrl {
            //cell.messageImageView.loadImageUsingCacheWithUrlString(messageImageUrl)
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor.clear
        } else {
            cell.messageImageView.isHidden = true
        }
        
        // location setup
        if let location = message.isLocation {
            if location {
                cell.mapView.isHidden = false
                cell.mapButton.isHidden = false
                if let long = message.long, let lat = message.lat {
                    let annotation = MKPointAnnotation()
                    annotation.title = "Location"
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    annotation.coordinate = coordinate
                    let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
                    cell.mapView.setRegion(region, animated: false)
                    cell.mapView.addAnnotation(annotation)
                }
                cell.bubbleWidthAnchor?.constant = 200
            } else {
                cell.mapView.isHidden = true
                cell.mapButton.isHidden = true
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        let message = messages[indexPath.item]
        if let text = message.text {
            height = estimateFrameForText(text: text).height + 15
        } else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue {
            height = CGFloat(imageHeight / imageWidth * 200)
        } else if let location = message.isLocation {
            if location {
                height = 150
            }
        }
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height + 25)
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid, let toId = user?.id else {
            return
        }
        let userMessagesRef = Database.database().reference().child("User-Messages").child(uid).child(toId)
        userMessagesRef.observe(.childAdded) { (snapshot) in
            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child("Messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value) { (dictSnap) in
                guard let dictionary = dictSnap.value as? [String : Any] else {
                    return
                }
                let message = Message(dictionary: dictionary)
                
                if let jobRefId = message.jobRefId {
                    self.jobRefId = jobRefId
                    GlobalVariables.jobRefId = jobRefId
                }
                
                if self.isSearchingForServiceProvider {
                    if message.serviceProvider == Auth.auth().currentUser!.uid {
                        GlobalVariables.chatPartnerId = message.chatPartnerId()!
                        self.isSearchingForServiceProvider = false
                        print("i am jorge, the worker")
                        if message.firstTime == true {
                            print("first time")
                            self.chatId = messageId
                            self.jobId = message.postId!
                            self.theMessage = message.text!
                            self.firstTimeFunction()
                        }
                        GlobalVariables.jobId = message.postId!
                        GlobalVariables.chatPartnerId = message.chatPartnerId()!
                    } else {
                        print("henry")
                        if message.firstTime == false {
                            let btnProfile = UIButton(type: .system)
                            btnProfile.frame = CGRect(x: 0, y: 0, width: 80, height: 20)
                            btnProfile.setTitle("FINISH", for: .normal)
                            btnProfile.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
                            btnProfile.addTarget(self, action: #selector(self.requestButtonPressed), for: .touchUpInside)
                            btnProfile.setTitleColor(UIColor.white, for: .normal)
                            btnProfile.backgroundColor = UIColor.mainBlue
                            btnProfile.layer.cornerRadius = 10
                            btnProfile.layer.masksToBounds = true
                            self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: btnProfile)]
                            if let messagePostId = message.postId {
                                GlobalVariables.jobId = messagePostId
                            }
                        }
                    }
                }
                GlobalVariables.postIdFeedback = self.jobId
                GlobalVariables.chatPartnerId = message.chatPartnerId()!
                self.messages.append(message)
                DispatchQueue.main.async(execute: {
                    self.collectionView.reloadData()
                    let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                    self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                })
            }
        }
    }
    
    @objc func requestButtonPressed() {
        containerViewBottomAnchor?.constant = 0
        self.inputTextField.resignFirstResponder()
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
        }
        self.filterLauncher.showFilter()
        self.filterLauncher.completeJob.addTarget(self, action: #selector(self.completeJobButton), for: .touchUpInside)
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        print("UIDevice.current.screenType")
        print(UIDevice.current.screenType)
        print("UIDevice.current.screenType")
        switch UIDevice.current.screenType {
        case .iPhones_6Plus_6sPlus_7Plus_8Plus:
            containerViewBottomAnchor?.constant = -keyboardFrame!.height
        default:
            containerViewBottomAnchor?.constant = -keyboardFrame!.height + 25
        }
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        self.fromKeyboard = false
        containerViewBottomAnchor?.constant = 0
        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func didSelectImage() {
        self.imagePicker.sourceType = .camera
        self.imagePicker.allowsEditing = false
        self.imagePicker.delegate = self
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    @objc func didSelectImagePhoto() {
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = false
        self.imagePicker.delegate = self
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    @objc func booking() {
        let key = false
        if key == true {
            let booking = Booking()
            self.navigationController?.pushViewController(booking, animated: true)
        } else {
            let alert = UIAlertController(title: "Feature Unavailable", message: "This feature is coming soon! Stay tuned!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func location() {
        checkLocationServices()
         
         MBProgressHUD.showAdded(to: view, animated: true)
         if let location = self.locationManager.location?.coordinate {
             let properties = [
                 "isLocation" : true,
                 "long-cord" : location.longitude,
                 "lat-cord" : location.latitude
             ] as [String : Any]
             sendMessageWithProperties(properties)
             MBProgressHUD.hide(for: self.view, animated: true)
         } else {
             MBProgressHUD.hide(for: self.view, animated: true)
             let alert = UIAlertController(title: "Error", message: "Please make sure all locaation settings are allowed", preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
             present(alert, animated: true, completion: nil)
         }
    }
    
    @objc func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            print("TURN ON")
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            let alert = UIAlertController(title: "Cannot find location", message: "Please go to Settings and allow location to view this screen!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            let alert = UIAlertController(title: "Cannot find location", message: "Your location is marked as 'restricted'", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            break
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            print("its a video")
            handleVideoSelectedForUrl(videoUrl)
        } else {
            handleImageSelectedForInfo(info)
        }
            
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func handleVideoSelectedForUrl(_ url: URL) {
        let filename = UUID().uuidString + ".mov"
        
        print(filename)
        
        let ref = Storage.storage().reference().child("Message_Movies").child(filename)
        
        
        let uploadTask = ref.putFile(from: url, metadata: nil, completion: { (_, err) in
            if let err = err {
                print("Failed to upload movie:", err.localizedDescription, "  end")
                return
            }
        })
    }
    
    fileprivate func thumbnailImageForFileUrl(_ fileUrl: URL) -> UIImage? {
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch let err {
            print(err)
        }
        
        return nil
    }
    
    fileprivate func handleImageSelectedForInfo(_ info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            uploadToFirebaseStorageUsingImage(selectedImage, completion: { (imageUrl) in
                self.sendMessageWithImageUrl(imageUrl, image: selectedImage)
            })
        }
    }
    
    fileprivate func sendMessageWithImageUrl(_ imageUrl: String, image: UIImage) {
        let properties: [String: AnyObject] = ["imageUrl": imageUrl as AnyObject, "imageWidth": image.size.width as AnyObject, "imageHeight": image.size.height as AnyObject]
        sendMessageWithProperties(properties)
    }
    
    fileprivate func uploadToFirebaseStorageUsingImage(_ image: UIImage, completion: @escaping (_ imageUrl: String) -> ()) {
        let imageName = UUID().uuidString
        let ref = Storage.storage().reference().child("Message_Images").child(imageName)
        
        if let uploadData = image.jpegData(compressionQuality: 0.2) {
            ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print("Failed to upload image:", error!)
                    return
                }
                
                ref.downloadURL(completion: { (url, err) in
                    if let err = err {
                        print(err)
                        return
                    }
                    completion(url?.absoluteString ?? "")
                })
                
            })
        }
    }
    
    @objc func handleSend() {
        if inputTextField.text != nil && inputTextField.text != "" {
            let properties = ["text": inputTextField.text!] as [String : Any]
            sendMessageWithProperties(properties)
        }
    }
    
    @objc func handleKeyboardDidShow() {
        if messages.count > 0 {
            self.fromKeyboard = true
            let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
            self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    private func sendImageWithImageUrl(imageUrl: String, image: UIImage) {
        let properties = ["imageUrl": imageUrl, "imageWidth" : image.size.width, "imageHeight" : image.size.height] as [String : Any]
        sendMessageWithProperties(properties)
    }
    
    private func sendMessageWithProperties(_ properties: [String: Any]) {
        let ref = Database.database().reference().child("Messages")
        let childRef = ref.childByAutoId()
        let toId = user?.id
        let fromId = Auth.auth().currentUser!.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        var values : [String : Any] = ["toId": toId, "fromId": fromId, "timestamp": timestamp, "first-time" : false, "service-provider" : "??", "text-id" : childRef.key, "hasViewed" : false] as [String : Any]
        
        // append properties
        properties.forEach({values[$0] = $1})
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error ?? "")
                return
            }
            
            guard let messageId = childRef.key else { return }
            
            let userMessagesRef = Database.database().reference().child("User-Messages").child(fromId).child(toId!).child(messageId)
            userMessagesRef.setValue(1)
            
            let recipientUserMessagesRef = Database.database().reference().child("User-Messages").child(toId!).child(fromId).child(messageId)
            recipientUserMessagesRef.setValue(1)
            
            
            Database.database().reference().child("Users").child(toId!).child("fcmToken").observe(.value) { (snapshot) in
                let token : String = (snapshot.value as? String)!
                let sender = PushNotificationSender()
                Database.database().reference().child("Users").child(fromId).child("name").observe(.value) { (snapshot) in
                    let name : String = (snapshot.value as? String)!
                    sender.sendPushNotification(to: token, title: "Chat Notification", body: "New message from \(name)", page: false, senderId: Auth.auth().currentUser!.uid, recipient: toId!)
                    self.checkNilValueTextField()
                }
            }
            
            self.inputTextField.text = nil
        }
    }
    
    func performZoomInForStartingImageView(startingImageView: UIImageView) {
        
        startingFrame = startingImageView.superview?.convert((startingImageView.frame), to: nil)
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.layer.cornerRadius = 16
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        
        let exitButton = UIButton(type: .system)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.backgroundColor = .clear
        exitButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        exitButton.tintColor = UIColor.white
        self.imageView = zoomingImageView
        exitButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOutButton)))
        
        if let keyWindow = UIApplication.shared.keyWindow {
            blackBackground = UIView(frame: keyWindow.frame)
            self.blackBackground?.backgroundColor = .black
            self.blackBackground?.alpha = 0
            keyWindow.addSubview(blackBackground!)
            keyWindow.addSubview(zoomingImageView)
            
            blackBackground?.addSubview(exitButton)
            exitButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
            exitButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
            exitButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
            exitButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                zoomingImageView.center = keyWindow.center
                self.blackBackground?.alpha = 1
            }

        }
    }
    
    @objc func handleZoomOut(tapGesture: UITapGestureRecognizer) {
        if let zoomOutImageView = tapGesture.view {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackground?.alpha = 0
            } completion: { (completed) in
                zoomOutImageView.removeFromSuperview()
            }
        }
    }
    
    @objc func handleZoomOutButton() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.blackBackground?.alpha = 0
            self.imageView?.alpha = 0
        } completion: { (completed) in
        }
    }
    
    let myView : UIView = {
        let myView = UIView()
        myView.translatesAutoresizingMaskIntoConstraints = false
        myView.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
        return myView
    }()
    
    let jobTitle : UILabel = {
        let jobTitle = UILabel()
        jobTitle.text = "Service Title"
        jobTitle.textColor = UIColor.black
        jobTitle.font = UIFont.boldSystemFont(ofSize: 20)
        jobTitle.translatesAutoresizingMaskIntoConstraints = false
        jobTitle.textAlignment = NSTextAlignment.center
        return jobTitle
    }()
    
    func firstTimeFunction() {
        print("first time")
        
        self.view.addSubview(myView)
        myView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        myView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        myView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        myView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        let infoView = UIView()
        infoView.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
        infoView.layer.cornerRadius = 20
        infoView.translatesAutoresizingMaskIntoConstraints = false
        myView.addSubview(infoView)
        infoView.leftAnchor.constraint(equalTo: myView.leftAnchor, constant: 30).isActive = true
        infoView.rightAnchor.constraint(equalTo: myView.rightAnchor, constant: -30).isActive = true
        infoView.topAnchor.constraint(equalTo: myView.topAnchor, constant: 150).isActive = true
        infoView.bottomAnchor.constraint(equalTo: myView.bottomAnchor, constant: -100).isActive = true
        
        let postImageView = UIImageView()
        postImageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        postImageView.layer.cornerRadius = 30
        postImageView.contentMode = .scaleAspectFill
        postImageView.layer.masksToBounds = true
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        myView.addSubview(postImageView)
        postImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        postImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        postImageView.centerYAnchor.constraint(equalTo: infoView.topAnchor, constant: 35).isActive = true
        postImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        infoView.addSubview(jobTitle)
        jobTitle.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 23).isActive = true
        jobTitle.leftAnchor.constraint(equalTo: infoView.leftAnchor, constant: 0).isActive = true
        jobTitle.rightAnchor.constraint(equalTo: infoView.rightAnchor, constant: 0).isActive = true
        jobTitle.heightAnchor.constraint(equalToConstant: 25).isActive = true

        let priceTitle = UILabel()
        priceTitle.text = "Price"
        priceTitle.textColor = UIColor.black
        priceTitle.font = UIFont.systemFont(ofSize: 25)
        priceTitle.translatesAutoresizingMaskIntoConstraints = false
        priceTitle.textAlignment = NSTextAlignment.center
        infoView.addSubview(priceTitle)
        priceTitle.topAnchor.constraint(equalTo: jobTitle.bottomAnchor, constant: 4).isActive = true
        priceTitle.leftAnchor.constraint(equalTo: infoView.leftAnchor, constant: 0).isActive = true
        priceTitle.rightAnchor.constraint(equalTo: infoView.rightAnchor, constant: 0).isActive = true
        priceTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true

        let messageDescription = UILabel()
        messageDescription.translatesAutoresizingMaskIntoConstraints = false
        messageDescription.text = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam"
        messageDescription.numberOfLines = 6
        messageDescription.font = UIFont.systemFont(ofSize: 14)
        messageDescription.textColor = UIColor.darkGray
        messageDescription.textAlignment = NSTextAlignment.center
        infoView.addSubview(messageDescription)
        messageDescription.topAnchor.constraint(equalTo: priceTitle.bottomAnchor, constant: 15).isActive = true
        messageDescription.rightAnchor.constraint(equalTo: infoView.rightAnchor, constant: -15).isActive = true
        messageDescription.leftAnchor.constraint(equalTo: infoView.leftAnchor, constant: 15).isActive = true
        messageDescription.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: -150).isActive = true

        let buttonView = UIView()
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        infoView.addSubview(buttonView)
        buttonView.topAnchor.constraint(equalTo: messageDescription.bottomAnchor).isActive = true
        buttonView.leftAnchor.constraint(equalTo: infoView.leftAnchor, constant: 15).isActive = true
        buttonView.rightAnchor.constraint(equalTo: infoView.rightAnchor, constant: -15).isActive = true
        buttonView.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: -15).isActive = true

        let declineButton = UIButton(type: .system)
        declineButton.setTitle("Decline", for: .normal)
        declineButton.setTitleColor(UIColor.mainBlue, for: .normal)
        declineButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        declineButton.addTarget(self, action: #selector(decline), for: .touchUpInside)
        declineButton.translatesAutoresizingMaskIntoConstraints = false
        infoView.addSubview(declineButton)
        declineButton.topAnchor.constraint(equalTo: buttonView.topAnchor, constant: 10).isActive = true
        declineButton.leftAnchor.constraint(equalTo: buttonView.leftAnchor, constant: 10).isActive = true
        declineButton.widthAnchor.constraint(equalToConstant: self.view.frame.width / 3).isActive = true
        declineButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        let acceptButton = MainButton(title: "Accept")
        acceptButton.setTitleColor(UIColor.white, for: .normal)
        acceptButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        acceptButton.addTarget(self, action: #selector(accept), for: .touchUpInside)
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        infoView.addSubview(acceptButton)
        acceptButton.topAnchor.constraint(equalTo: buttonView.topAnchor, constant: 10).isActive = true
        acceptButton.rightAnchor.constraint(equalTo: buttonView.rightAnchor, constant: -10).isActive = true
        acceptButton.widthAnchor.constraint(equalToConstant: self.view.frame.width / 3).isActive = true
        acceptButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // add other objects to view
        print("jobid: \(jobId)")
        Database.database().reference().child("Jobs").child(jobId).observe(.value) { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                let job = JobStructure()
                job.authorId = value["author"] as? String ?? "Error"
                job.titleOfPost = value["title"] as? String ?? "Error"
                job.descriptionOfPost = value["description"] as? String ?? "Error"
                job.price = value["price"] as? Int ?? 0
                job.category = value["category"] as? String ?? "Error"
                job.imagePost = value["image"] as? String ?? "Error"
                job.typeOfPrice = value["type-of-price"] as? String ?? "Error"
                job.postId = value["postId"] as? String ?? "Error"

                postImageView.loadImageUsingCacheWithUrlString(job.imagePost!)
                self.jobTitle.text = "\(job.titleOfPost!)"
                if job.typeOfPrice == "Hourly" {
                    priceTitle.text! = "$\(job.price!) / Hour"
                } else {
                    priceTitle.text! = "$\(job.price!)"
                }
                messageDescription.text! = self.theMessage
            }
        }
    }
    
    @objc func decline() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        self.view.addSubview(darkView)
        self.darkView.alpha = 0
        self.darkView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.darkView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.darkView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.darkView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.view.addSubview(mainView)
        self.mainView.alpha = 0
        self.mainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.mainView.layer.cornerRadius = 25
        self.mainView.heightAnchor.constraint(equalToConstant: 280).isActive = true
        self.mainView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.mainView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.mainView.addSubview(filterTitle)
        self.filterTitle.leftAnchor.constraint(equalTo: self.mainView.leftAnchor, constant: 30).isActive = true
        self.filterTitle.rightAnchor.constraint(equalTo: self.mainView.rightAnchor, constant: -30).isActive = true
        self.filterTitle.topAnchor.constraint(equalTo: self.mainView.topAnchor, constant: 45).isActive = true
        self.filterTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.mainView.addSubview(exitButton)
        self.exitButton.rightAnchor.constraint(equalTo: self.mainView.rightAnchor, constant: -30).isActive = true
        self.exitButton.topAnchor.constraint(equalTo: self.mainView.topAnchor, constant: 30).isActive = true
        self.exitButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.exitButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.mainView.addSubview(tf)
        self.tf.topAnchor.constraint(equalTo: self.filterTitle.bottomAnchor, constant: 25).isActive = true
        self.tf.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 40).isActive = true
        self.tf.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -40).isActive = true
        self.tf.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.tf.becomeFirstResponder()
        self.tf.delegate = self
        
        self.mainView.addSubview(bottomBar)
        self.bottomBar.topAnchor.constraint(equalTo: self.tf.bottomAnchor).isActive = true
        self.bottomBar.leftAnchor.constraint(equalTo: self.tf.leftAnchor).isActive = true
        self.bottomBar.rightAnchor.constraint(equalTo: self.tf.rightAnchor).isActive = true
        self.bottomBar.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        let declineButton = UIButton(type: .system)
        declineButton.setTitle("I'm busy", for: .normal)
        declineButton.setTitleColor(UIColor.darkGray, for: .normal)
        declineButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        declineButton.addTarget(self, action: #selector(imbusy), for: .touchUpInside)
        declineButton.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        declineButton.layer.cornerRadius = 25
        declineButton.layer.borderWidth = 2
        declineButton.layer.borderColor = UIColor.darkGray.cgColor
        declineButton.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(declineButton)
        declineButton.topAnchor.constraint(equalTo: bottomBar.bottomAnchor, constant: 30).isActive = true
        declineButton.leftAnchor.constraint(equalTo: bottomBar.leftAnchor).isActive = true
        declineButton.widthAnchor.constraint(equalToConstant: self.view.frame.width / 3).isActive = true
        declineButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let acceptButton = UIButton(type: .system)
        acceptButton.setTitle("Not interested", for: .normal)
        acceptButton.setTitleColor(UIColor.darkGray, for: .normal)
        acceptButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        acceptButton.layer.cornerRadius = 25
        acceptButton.layer.borderWidth = 2
        acceptButton.layer.borderColor = UIColor.darkGray.cgColor
        acceptButton.addTarget(self, action: #selector(notInterested), for: .touchUpInside)
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(acceptButton)
        acceptButton.topAnchor.constraint(equalTo: bottomBar.bottomAnchor, constant: 30).isActive = true
        acceptButton.rightAnchor.constraint(equalTo: bottomBar.rightAnchor).isActive = true
        acceptButton.widthAnchor.constraint(equalToConstant: self.view.frame.width / 3).isActive = true
        acceptButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("OK", for: .normal)
        doneButton.setTitleColor(UIColor.mainBlue, for: .normal)
//        doneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.black)
        doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(doneButton)
        doneButton.topAnchor.constraint(equalTo: acceptButton.bottomAnchor).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        doneButton.rightAnchor.constraint(equalTo: acceptButton.rightAnchor).isActive = true
        
        handlePopInPopOut()
    }
    
    @objc func handleImageTap(tapGesture: UITapGestureRecognizer) {
        containerViewBottomAnchor?.constant = 0
        self.inputTextField.resignFirstResponder()
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
        }
        if let imageView = tapGesture.view as? UIImageView {
            self.performZoomInForStartingImageView(startingImageView: imageView)
        }
    }
    
    @objc func handleMapTap() {
        print("hrye")
    }
    
    var bottomConstraint : NSLayoutConstraint?
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            self.mainView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -keyboardHeight).isActive = true
        }
    }
    
    let darkView : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.black
        button.addTarget(self, action: #selector(handlePopInPopOut), for: .touchUpInside)
        return button
    }()
    
    let tf : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Write here"
        tf.tintColor = UIColor.mainBlue
        tf.textColor = UIColor.black
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let filterTitle : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Why are you declining?"
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 1
        return label
    }()
    
    let exitButton : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(handlePopInPopOut), for: .touchUpInside)
        button.imageView?.tintColor = UIColor.black
        button.tintColor = UIColor.black
        return button
    }()
    
    let bottomBar : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.darkGray
        return view
    }()
    
    @objc func handlePopInPopOut() {
        if self.isShowing {
            UIView.animate(withDuration: 0.5) {
                self.darkView.alpha = 0.0
                self.mainView.alpha = 0.0
                self.tf.resignFirstResponder()
            } completion: { (completed) in
                if completed {
                    // completion
                    self.isShowing = false
                }
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.darkView.alpha = 0.5
                self.mainView.alpha = 1.0
            } completion: { (completed) in
                if completed {
                    // completion
                    self.isShowing = true
                }
            }
        }
    }
    
    @objc func imbusy() {
        self.tf.text = "I'm busy"
    }
    
    @objc func notInterested() {
        self.tf.text = "Not interested"
    }
    
    let mainView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    @objc func accept() {
        self.myView.removeFromSuperview()
        // if user accepts or declines, mark the first message as first time false
        Database.database().reference().child("Messages").child(chatId).child("first-time").setValue(false)
        // add to running
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("My_Jobs")
        let timestamp = Int(Date().timeIntervalSince1970)
        let infoToAdd : Dictionary<String, Any> = [
            "author-uid" : "\(user!.id!)",
            "is-rating-nil" : true,
            "job-key" : "\(self.jobId)",
            "job-status" : "running",
            "rating" : 0,
            "reason-or-description" : "NULL",
            "running-time" : timestamp
        ]
        let postFeed = ["\(self.jobRefId)" : infoToAdd]
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("My_Jobs").updateChildValues(postFeed)
        
        Database.database().reference().child("Users").child(GlobalVariables.chatPartnerId).child("fcmToken").observe(.value) { (snapshot) in
            if let token : String = (snapshot.value as? String) {
                let sender = PushNotificationSender()
                sender.sendPushNotification(to: token, title: "Service Accepted", body: "A recent job job proposal of yours has been accepted. Check your chats!", page: true, senderId: Auth.auth().currentUser!.uid, recipient: GlobalVariables.chatPartnerId)
            }
        }
    }
    
    @objc func doneButtonPressed() {
        if self.tf.text != "" {
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            let message = self.messages[0]
            if let chatPartnerId = message.chatPartnerId() {
                GlobalVariables.chatPartnerId = chatPartnerId
                Database.database().reference().child("User-Messages").child(uid).child(chatPartnerId).removeValue { (error, ref) in
                    if error != nil {
                        print("error deleting message: \(error!.localizedDescription)")
                    } else {
                        // send notification to user
                        Database.database().reference().child("Users").child(chatPartnerId).child("fcmToken").observe(.value) { (snapshot) in
                            if let token : String = (snapshot.value as? String) {
                                let sender = PushNotificationSender()
                                sender.sendPushNotification(to: token, title: "Service Declined", body: "\(self.jobTitle.text!) was declined: \(self.tf.text!)", page: true, senderId: Auth.auth().currentUser!.uid, recipient: chatPartnerId)
                                GlobalVariables.isDeleting = true
                                GlobalVariables.indexToDelete = GlobalVariables.indexToDelete
                                self.navigationController?.popViewController(animated: true)
                            } else {
                                GlobalVariables.isDeleting = true
                                GlobalVariables.indexToDelete = GlobalVariables.indexToDelete
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Please give some sort of reasoning", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func completeJobButton() {
        // show loader for 1 second
        self.filterLauncher.handleDismiss()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            MBProgressHUD.hide(for: self.view, animated: true)
            let feedbackController = FeedbackController()
            self.navigationController?.pushViewController(feedbackController, animated: true)
        }
    }
    
    @objc func stopJobButton() {
        print("cancel job")
        self.filterLauncher.handleDismiss()
        // send message to user that job is cancelled
        let properties = ["text": "HIREMILE: This conversation and service has been deleted. For more information, please navigate to the 'My Jobs' section."] as [String : Any]
        self.sendMessageWithProperties(properties)
        // remove all children in messages for corresponding job
        GlobalVariables.finishedFeedback = true
        // send user a notification
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("name").observe(.value) { (snapshot) in
            let name : String = (snapshot.value as? String)!
            Database.database().reference().child("Users").child(GlobalVariables.chatPartnerId).child("fcmToken").observe(.value) { (snapshot) in
                if let token : String = (snapshot.value as? String) {
                    let sender = PushNotificationSender()
                    Database.database().reference().child("Users").child(GlobalVariables.chatPartnerId).child("My_Jobs").child(GlobalVariables.jobRefId).child("job-status").setValue("cancelled")
                    let timestamp = Int(Date().timeIntervalSince1970)
                    Database.database().reference().child("Users").child(GlobalVariables.chatPartnerId).child("My_Jobs").child(GlobalVariables.jobRefId).child("cancel-stamp").setValue(timestamp)
                    sender.sendPushNotification(to: token, title: "\(name) cancelled your service!", body: "Open 'My Jobs' to find more", page: true, senderId: Auth.auth().currentUser!.uid, recipient: GlobalVariables.chatPartnerId)
                    self.nextAction()
                } else {
                    self.nextAction()
                }
            }
        }
    }
    
    func nextAction() {
        GlobalVariables.finishedFeedback = true
        let sb = UIStoryboard(name: "TabStoryboard", bundle: nil)
        let vc: UIViewController = sb.instantiateViewController(withIdentifier: "TabbControllerID") as! TabBarController
        UIApplication.shared.keyWindow?.rootViewController = vc
    }
    
    fileprivate func checkNilValueTextField() {
        if self.inputTextField.text == nil || self.inputTextField.text == "" {
            self.enableButton = false
            if enableButton == true {
                self.sendButton.tintColor = UIColor(red: 118/255, green: 118/255, blue: 118/255, alpha: 1)
            } else {
                self.sendButton.tintColor = UIColor(red: 213/255, green: 213/255, blue: 213/255, alpha: 1)
            }
        } else {
            self.enableButton = true
            if enableButton == true {
                self.sendButton.tintColor = UIColor(red: 118/255, green: 118/255, blue: 118/255, alpha: 1)
            } else {
                self.sendButton.tintColor = UIColor(red: 213/255, green: 213/255, blue: 213/255, alpha: 1)
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        checkNilValueTextField()
    }
    
    @objc func didSelectGrid() {
        self.inputTextField.resignFirstResponder()
        isShowing.toggle()
        setupOpenArea()
    }
    
    func setupOpenArea() {
        if isShowing == true {
            UIView.animate(withDuration: 0.2) {
                self.containerView.alpha = 0
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.containerView.alpha = 1
            }
        }
    }
    
    @objc func exitExtra() {
        UIView.animate(withDuration: 0.2) {
            self.containerView.alpha = 1
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        if let location = message.isLocation {
            if location {
                inputTextField.resignFirstResponder()
                let mapPage = MapPage()
                mapPage.location = CLLocationCoordinate2D(latitude: message.lat!, longitude: message.long!)
                navigationController?.pushViewController(mapPage, animated: true)
            }
        }
    }
    
    func didPressButton(_ tag: Int) {
        print("selected location with index: \(tag)")
        let message = messages[tag]
        if let location = message.isLocation {
            if location {
                inputTextField.resignFirstResponder()
                let mapPage = MapPage()
                mapPage.location = CLLocationCoordinate2D(latitude: message.lat!, longitude: message.long!)
                navigationController?.pushViewController(mapPage, animated: true)
            }
        }
    }

}
