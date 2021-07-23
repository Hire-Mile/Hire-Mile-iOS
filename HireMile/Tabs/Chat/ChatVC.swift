//
//  ChatVC.swift
//  HireMile
//
//  Created by mac on 12/07/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
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

class ChatVC: UIViewController, UserCellDelegate {
   
    @IBOutlet weak var tblChat: UITableView!
    @IBOutlet weak var colChat: UICollectionView!
    @IBOutlet weak var txtInput: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var btnFinish: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var vwMain: UIView!
    
    @IBOutlet weak var vwCostumerJobAccepted: UIView!
    @IBOutlet weak var lblCostumerJobAccepted: UILabel!
    
    @IBOutlet weak var vwWorkerjobAccepted: UIView!
    @IBOutlet weak var lblWorkerjobAccepted: UILabel!
    
    @IBOutlet weak var vwAcceptOrDecline: UIView!
    @IBOutlet weak var lblAcceptOrDeclineUserName: UILabel!
    @IBOutlet weak var lblAcceptOrDeclineWorkName: UILabel!
    @IBOutlet weak var lblAcceptOrDeclineDateTime: UILabel!
    @IBOutlet weak var lblAcceptOrDeclinePrice: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var imgCalender: UIImageView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblChat.register(UINib(nibName: "ChatLeftCell", bundle: nil), forCellReuseIdentifier: "ChatLeftCell")
        
        tblChat.register(UINib(nibName: "ChatRightCell", bundle: nil), forCellReuseIdentifier: "ChatRightCell")
        tblChat.register(UINib(nibName: "AcceptPayCell", bundle: nil), forCellReuseIdentifier: "AcceptPayCell")
        
        colChat.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        vwMain.isHidden = true
        self.lblTitle.text = user?.name ?? ""
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        vwMain.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            for message in self.messages {
                Database.database().reference().child("Messages").child(message.textId!).child("hasViewed").setValue(true)
            }
        }
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: Page Funtion
    
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
                        if message.firstTime != true {
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
                          
                            self.btnFinish.setTitle("Finish", for: .normal)
                            self.btnFinish.backgroundColor = UIColor.mainBlue
                            self.btnFinish.setTitleColor(.white, for: .normal)
                           
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
//                    self.tblChat.reloadData()
//                    let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
//                    self.tblChat?.scrollToRow(at: indexPath, at: .bottom, animated: true)
                    
                    self.colChat.reloadData()
                    let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                    self.colChat?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                })
            }
        }
    }
    
    
    func firstTimeFunction() {
        print("first time")
        
        print("jobid: \(jobId)")
        Database.database().reference().child("Jobs").child(jobId).observe(.value) { (snapshot) in
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

                self.vwAcceptOrDecline.isHidden = false
                self.imgUser.sd_setImage(with: URL(string: self.user?.profileImageUrl ?? ""), completed: nil)
                self.lblAcceptOrDeclineWorkName.text = "\(job.titleOfPost!)"
                if job.typeOfPrice == "Hourly" {
                    self.lblAcceptOrDeclinePrice.text! = "$\(job.price!) / Hour"
                } else {
                    self.lblAcceptOrDeclinePrice.text! = "$\(job.price!)"
                }
            }
        }
    }
    
    // MARK: Cell data fill
    
    func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    func setupCell(cell: ChatMessageCell, message: Message) {
        
        if let profileImageUrl = self.user?.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        } else {
            cell.profileImageView.backgroundColor = UIColor.clear
            cell.profileImageView.image = UIImage(systemName: "person.circle.fill")
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
                    cell.myProfileImageView.image = UIImage(systemName: "person.circle.fill")
                    cell.myProfileImageView.tintColor = UIColor.lightGray
                    cell.myProfileImageView.contentMode = .scaleAspectFill
                } else {
                    cell.myProfileImageView.loadImageUsingCacheWithUrlString(profileImageString)
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
            cell.messageImageView.loadImageUsingCacheWithUrlString(messageImageUrl)
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
    
    func didPressButton(_ tag: Int) {
        print("selected location with index: \(tag)")
        let message = messages[tag]
        if let location = message.isLocation {
            if location {
             //   inputTextField.resignFirstResponder()
                let mapPage = MapPage()
                mapPage.location = CLLocationCoordinate2D(latitude: message.lat!, longitude: message.long!)
                navigationController?.pushViewController(mapPage, animated: true)
            }
        }
    }
    
    // MARK: Image  video Upload
    
    func handleVideoSelectedForUrl(_ url: URL) {
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
    
    func handleImageSelectedForInfo(_ info: [UIImagePickerController.InfoKey : Any]) {
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
    
    // MARK: Text message Upload
    
    func checkNilValueTextField() {
       if self.txtInput.text == nil || self.txtInput.text == "" {
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

    // MARK: send Message With Properties
    
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
            
            self.txtInput.text = nil
        }
    }
    
    // MARK: job finis
    
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
    
    // MARK: Button Action
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
  
    @IBAction func btnFinishClick(_ sender: UIButton) {
        
        self.txtInput.resignFirstResponder()
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
        }
        self.filterLauncher.showFilter()
        self.filterLauncher.completeJob.addTarget(self, action: #selector(self.completeJobButton), for: .touchUpInside)
        self.filterLauncher.stopJob.addTarget(self, action: #selector(self.stopJobButton), for: .touchUpInside)
    }
    
    @IBAction func btnPolygonClick(_ sender: UIButton) {
        
    }
    
    @IBAction func btnMoreClick(_ sender: UIButton) {
    }
  
    @IBAction func btnCameraClick(_ sender: UIButton) {
        
        let alertVC = ChooseYourSourceVC.init(nibName: "ChooseYourSourceVC", bundle: nil)
        alertVC.modalPresentationStyle = .custom
        alertVC.imgName = {(info,img) -> Void in
            if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                print("its a video")
                self.handleVideoSelectedForUrl(videoUrl)
            } else {
                self.handleImageSelectedForInfo(info)
            }
        }
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
    @IBAction func btnSendClick(_ sender: UIButton) {
        vwMain.isHidden = true
        vwCostumerJobAccepted.isHidden = true
        
        if txtInput.text != nil && txtInput.text != "" {
            let properties = ["text": txtInput.text!] as [String : Any]
            sendMessageWithProperties(properties)
        }
    }
    
    @IBAction func btnCostumerJobAcceptedCloseClick(_ sender: UIButton) {
        vwCostumerJobAccepted.isHidden = true
    }

    @IBAction func btnAcceptedAndPayClick(_ sender: UIButton) {
        vwAcceptOrDecline.isHidden = true
    }
    
    @IBAction func btnDeclineClick(_ sender: UIButton) {
        vwAcceptOrDecline.isHidden = true
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
}

extension ChatVC: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        cell.chatLogControllerVC = self
        
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
        
     /*   cell.messageImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageTap)))
        */
        cell.delegate = self
        
        return cell
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
    
    
}

extension ChatVC: UITableViewDelegate,UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let message = messages[indexPath.row]
       
        print("isLocation",message.isLocation!)
        print("text",message.text)
        print("imageUrl",message.imageUrl)
        if message.fromId == Auth.auth().currentUser?.uid {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRightCell", for: indexPath) as! ChatRightCell
            // current user
           
            
            cell.lblChat.text = message.text
            
            if let text = message.text {
                cell.lblChat.isHidden = false
            } else if message.imageUrl != nil {
                cell.lblChat.isHidden = true
            }
            
            // get time sent
            if let seconds = message.timestamp?.doubleValue {
                let timeStampDate = Date(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                cell.lblTime.text = dateFormatter.string(from: timeStampDate)
            }
            
            if let uid = Auth.auth().currentUser?.uid {
                Database.database().reference().child("Users").child(uid).child("profile-image").observe(.value) { (snapshot) in
                    let profileImageString : String = (snapshot.value as? String)!
                    if profileImageString == "not-yet-selected" {
                        cell.imgUser.image = UIImage(systemName: "person.circle.fill")
                        cell.imgUser.tintColor = UIColor.lightGray
                        cell.imgUser.contentMode = .scaleAspectFill
                    } else {
                        cell.imgUser.loadImageUsingCacheWithUrlString(profileImageString)
                        cell.imgUser.tintColor = UIColor.lightGray
                        cell.imgUser.contentMode = .scaleAspectFill
                    }
                }
            }
            return cell
        } else {
            // recipient
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatLeftCell", for: indexPath) as! ChatLeftCell
            cell.leftAnchorRec?.isActive = true
            cell.rightAnchorMe?.isActive = false
           
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
            
            cell.lblChat.text = message.text
            
            if let text = message.text {
                cell.lblChat.isHidden = false
            } else if message.imageUrl != nil {
                cell.lblChat.isHidden = true
            }
            
            // get time sent
            if let seconds = message.timestamp?.doubleValue {
                let timeStampDate = Date(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                cell.lblTime.text = dateFormatter.string(from: timeStampDate)
            }
            
            if let uid = Auth.auth().currentUser?.uid {
                Database.database().reference().child("Users").child(uid).child("profile-image").observe(.value) { (snapshot) in
                    let profileImageString : String = (snapshot.value as? String)!
                    if profileImageString == "not-yet-selected" {
                        cell.imgUser.image = UIImage(systemName: "person.circle.fill")
                        cell.imgUser.tintColor = UIColor.lightGray
                        cell.imgUser.contentMode = .scaleAspectFill
                    } else {
                        cell.imgUser.loadImageUsingCacheWithUrlString(profileImageString)
                        cell.imgUser.tintColor = UIColor.lightGray
                        cell.imgUser.contentMode = .scaleAspectFill
                    }
                }
            }
            return cell
        }
        
        
                
        
      /*  let btn_left=UIButton(frame: CGRect(x: 8, y: cell.frame.height - 51, width: 32, height: 32))
        btn_left.isUserInteractionEnabled = true
        btn_left.addTarget(self, action: #selector(btnleftClick), for: .touchUpInside)
        cell.addSubview(btn_left)
        
        let btn_right=UIButton(frame: CGRect(x: cell.frame.width - 40, y: cell.frame.height - 51, width: 32, height: 32))
        btn_right.isUserInteractionEnabled = true
        btn_right.addTarget(self, action: #selector(btnrightClick), for: .touchUpInside)
        cell.addSubview(btn_right)
        
        cell.messageImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageTap)))
        
        */
        
        
       
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
}
