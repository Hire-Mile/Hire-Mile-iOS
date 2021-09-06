//
//  ChatVC.swift
//  HireMile
//
//  Created by mac on 12/07/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import Alamofire
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
import SwiftyJSON

class ChatVC: UIViewController, UserCellDelegate,CLLocationManagerDelegate {
    @IBOutlet weak var colChat: UICollectionView!
    @IBOutlet weak var txtInput: UITextView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var btnFinish: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var vwCostumerJobAccepted: UIView!
    @IBOutlet weak var lblCostumerJobAccepted: UILabel!
    
    @IBOutlet weak var vwWorkerjobAccepted: UIView!
    @IBOutlet weak var lblWorkerjobAccepted: UILabel!
    
    @IBOutlet weak var jobTitleView: UIView!
    @IBOutlet weak var vwAcceptOrDecline: UIView!
    @IBOutlet weak var lblAcceptOrDeclineUserName: UILabel!
    @IBOutlet weak var lblAcceptOrDeclineWorkName: UILabel!
    @IBOutlet weak var lblAcceptOrDeclineDateTime: UILabel!
    @IBOutlet weak var lblAcceptOrDeclinePrice: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var imgCalender: UIImageView!
    @IBOutlet weak var moreCircleButton: UIButton!
    @IBOutlet weak var moreView: UIView!
    
    var userOther : UserChat? {
        didSet {
            navigationItem.title = userOther?.name
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
    
    var ongoingJob:OngoingJobs!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        self.finishButtonEnable(enable: false)
        colChat.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        colChat.register(UINib(nibName: AcceptPaymentCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: AcceptPaymentCollectionViewCell.className)
        self.lblTitle.text = userOther?.name ?? ""
        observeMessages()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            for message in self.messages {
                Database.database().reference().child("Messages").child(message.textId!).child("hasViewed").setValue(true)
            }
        }
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func initUI() {
        txtInput.placeholder = "Write here"
        txtInput.delegate = self
    }
    
    // MARK: Page Funtion
    
    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid, let toId = userOther?.id else {
            return
        }
        let ongoingJobRef = Database.database().reference().child("Ongoing-Jobs")
        ongoingJobRef
            .queryOrdered(byChild: "bookUid")
            .queryEqual(toValue: uid)
            .observe(.value, with: { snapshot in
                var customerJobs = [OngoingJobs]()
                if let jobDictionary = snapshot.value as? NSDictionary {
                    for key in jobDictionary.allKeys {
                    if let key = key as? String {
                            if let dic = jobDictionary[key] as? NSDictionary {
                                let json = JSON(dic)
                                var ongoing = OngoingJobs(json: json)
                                ongoing.key = key
                                ongoing.isServiceProvider = false
                                if ongoing.authorId != toId {
                                    continue
                                }
                                if(ongoing.jobStatus.rawValue >= JobStatus.Completed.rawValue) {
                                    continue
                                }
                                customerJobs.append(ongoing)
                                //self.firstTimeFunction(onGoinjob: self.ongoingJob)
                                //return
                            }
                        }
                    }
                }
                ongoingJobRef
                    .queryOrdered(byChild: "authorId")
                    .queryEqual(toValue: uid)
                    .observe(.value, with: { snapshot in
                        var workerJobs = [OngoingJobs]()
                        if let jobDictionary = snapshot.value as? NSDictionary {
                            for key in jobDictionary.allKeys {
                            if let key = key as? String {
                                    if let dic = jobDictionary[key] as? NSDictionary {
                                        let json = JSON(dic)
                                        var ongoing = OngoingJobs(json: json)
                                        ongoing.key = key
                                        ongoing.isServiceProvider = true
                                        if ongoing.bookUid != toId {
                                            continue
                                        }
                                        if(ongoing.jobStatus.rawValue >= JobStatus.Completed.rawValue) {
                                            continue
                                        }
                                        workerJobs.append(ongoing)
                                        //self.firstTimeFunction(onGoinjob: self.ongoingJob)
                                        //return
                                    }
                                }
                            }
                        }
                        let allJobs = customerJobs + workerJobs
                        self.ongoingJob = allJobs.max(by: { job1, job2 in
                            return job1.time < job2.time
                        })
                        if((self.ongoingJob) != nil) {
                            self.firstTimeFunction(onGoinjob: self.ongoingJob)
                        }
                        self.colChat.reloadData()
                    })
            })
        
        
        
        let userMessagesRef = Database.database().reference().child("User-Messages").child(uid).child(toId)
        userMessagesRef.observe(.childAdded) { (snapshot) in
            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child("Messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value) { (dictSnap) in
                debugPrint(dictSnap)
                guard let dictionary = dictSnap.value as? [String : Any] else {
                    return
                }
                let message = Message(dictionary: dictionary)
//
//                if let jobRefId = message.jobRefId {
//                    self.jobRefId = jobRefId
//                    GlobalVariables.jobRefId = jobRefId
//                }
                
//                if self.isSearchingForServiceProvider {
//                    if message.serviceProvider != Auth.auth().currentUser!.uid {
//                        GlobalVariables.chatPartnerId = message.chatPartnerId()!
//                        self.isSearchingForServiceProvider = false
//                        if message.firstTime == true {
//                            print("first time")
//                            self.chatId = messageId
//                            self.jobId = message.postId!
//                            self.theMessage = message.text!
//                            
//                        }
//                        //GlobalVariables.jobId = message.postId!
//                        GlobalVariables.chatPartnerId = message.chatPartnerId()!
//                    } else {
//                        print("henry")
//                        if message.firstTime == false {
//                          
//                            
//                           
//                            if let messagePostId = message.postId {
//                                GlobalVariables.jobId = messagePostId
//                            }
//                        }
//                    }
//                }
//                GlobalVariables.postIdFeedback = self.jobId
//                GlobalVariables.chatPartnerId = message.chatPartnerId()!
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
    
    
    func firstTimeFunction(onGoinjob: OngoingJobs) {
        Database.database().reference().child("Jobs").child(onGoinjob.jobId).observeSingleEvent(of:.value) { (snapshot) in
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
                self.ongoingJob.price = job.price ?? 0
                self.imgUser.sd_setImage(with: URL(string: self.userOther?.profileImageUrl ?? ""), completed: nil)
                self.lblAcceptOrDeclineWorkName.text = "\(job.titleOfPost!)"
                self.lblAcceptOrDeclineDateTime.text = onGoinjob.scheduleTime
                if let date = onGoinjob.scheduleDate.toDate(withFormat: "dd-MM-yy") {
                    let customDate = date.toString(withFormat: "MMMM dd")
                    self.lblAcceptOrDeclineDateTime.text = customDate + ", " + onGoinjob.scheduleTime
                }
                self.updateJobView(onGoinjob: onGoinjob)
                if job.typeOfPrice == "Hourly" {
                    self.lblAcceptOrDeclinePrice.text! = "$\(job.price!) / Hour"
                } else {
                    self.lblAcceptOrDeclinePrice.text! = "$\(job.price!)"
                }
                self.lblCategory.text = (job.titleOfPost ?? "") + " " + (self.lblAcceptOrDeclinePrice.text ?? "")
                self.jobTitleView.isHidden = false
            }
        }
    }
    
    private func updateJobView(onGoinjob: OngoingJobs) {
        if onGoinjob.isServiceProvider {
            switch self.ongoingJob.jobStatus {
                case .Hired:
                    self.vwAcceptOrDecline.isHidden = false
                    self.vwWorkerjobAccepted.isHidden = true
                    self.vwCostumerJobAccepted.isHidden = true
                    break
                case .Accepted:
                    self.lblWorkerjobAccepted.attributedText = NSMutableAttributedString().normal("You have ").bold("accepted the job. ").normal("Chat with the customer to define job details.")
                    self.vwAcceptOrDecline.isHidden = true
                    self.vwWorkerjobAccepted.isHidden = false
                    self.vwCostumerJobAccepted.isHidden = true
                    self.finishButtonEnable(enable: true)
                    break
                case .Declined:
                    self.lblWorkerjobAccepted.attributedText = NSMutableAttributedString().normal("You have ").bold("Declined the job. ")
                    self.vwAcceptOrDecline.isHidden = true
                    self.vwWorkerjobAccepted.isHidden = false
                    self.vwCostumerJobAccepted.isHidden = true
                    self.finishButtonEnable(enable: false)
                    break
                case .AwaitingPayment:
                    self.vwAcceptOrDecline.isHidden = true
                    self.vwWorkerjobAccepted.isHidden = true
                    self.vwCostumerJobAccepted.isHidden = true
                    self.finishButtonEnable(enable: false)
                    break
                case .CancelledPayment:
                    break
                case .DeclinePayment:
                    break
                case .Completed:
                    self.finishButtonEnable(enable: false)
                break
            }
            
        } else {
            switch self.ongoingJob.jobStatus {
                case .Hired:
                    self.lblCostumerJobAccepted.attributedText = NSMutableAttributedString().bold("You sent to \(self.userOther?.name ?? "") ").normal("a job\napplication job application   ")
                    self.vwAcceptOrDecline.isHidden = true
                    self.vwWorkerjobAccepted.isHidden = true
                    self.vwCostumerJobAccepted.isHidden = false
                    self.finishButtonEnable(enable: false)
                    break
                case .Accepted:
                    self.lblCostumerJobAccepted.attributedText = NSMutableAttributedString().bold(self.userOther?.name ?? "").normal(" accept your Job Offer,\nPlease, Chat with him to define the details\nof the job")
                    self.vwAcceptOrDecline.isHidden = true
                    self.vwWorkerjobAccepted.isHidden = true
                    self.vwCostumerJobAccepted.isHidden = false
                    self.finishButtonEnable(enable: false)
                    break
                case .Declined:
                    self.lblCostumerJobAccepted.attributedText = NSMutableAttributedString().bold(self.userOther?.name ?? "").normal(" declined your Job Offer")
                    self.vwAcceptOrDecline.isHidden = true
                    self.vwWorkerjobAccepted.isHidden = true
                    self.vwCostumerJobAccepted.isHidden = false
                    self.finishButtonEnable(enable: false)
                    break
                case .AwaitingPayment:
                    self.vwAcceptOrDecline.isHidden = true
                    self.vwWorkerjobAccepted.isHidden = true
                    self.vwCostumerJobAccepted.isHidden = true
                    self.finishButtonEnable(enable: false)
                    break
                case .CancelledPayment:
                    break
                case .DeclinePayment:
                    break
                case .Completed:
                    self.finishButtonEnable(enable: false)
                    break
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
        
        if let profileImageUrl = self.userOther?.profileImageUrl {
            cell.profileImageView.sd_setImage(with: URL(string: profileImageUrl), for: .normal, completed: nil)
        } else {
            cell.profileImageView.backgroundColor = UIColor.clear
            cell.profileImageView.setImage(UIImage(systemName: "person.circle.fill"), for: .normal)
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
                    cell.myProfileImageView.setImage(UIImage(systemName: "person.circle.fill"), for: .normal)
                    cell.myProfileImageView.tintColor = UIColor.lightGray
                    cell.myProfileImageView.contentMode = .scaleAspectFill
                } else {
                    cell.myProfileImageView.sd_setImage(with: URL(string: profileImageString), for: .normal, completed: nil)
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
            cell.messageImageView.isUserInteractionEnabled = true
            cell.messageImageView.sd_setImage(with: URL(string: messageImageUrl), for: .normal, completed: nil)//loadImageUsingCacheWithUrlString(messageImageUrl)
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor.clear
            cell.messageImageView.addTarget(self, action: #selector(handleImageTap(tapGesture:)), for: .touchUpInside)
            cell.messageImageView.didMoveToWindow()
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
        } else {
            cell.mapView.isHidden = true
            cell.mapButton.isHidden = true
        }
    }
    
    func finishButtonEnable(enable: Bool) {
        self.btnFinish.isEnabled = enable
        if enable {
            self.btnFinish.setTitle("Finish", for: .normal)
            self.btnFinish.backgroundColor = UIColor.mainBlue
            self.btnFinish.setTitleColor(.white, for: .normal)
        } else {
            self.btnFinish.setTitle("Finish", for: .normal)
            self.btnFinish.backgroundColor = UIColor.lightGray
            self.btnFinish.setTitleColor(.white, for: .normal)
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
    
    @objc func handleImageTap(tapGesture: UIButton) {
        self.txtInput.resignFirstResponder()
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
        }
        if let imageView = tapGesture.imageView as? UIImageView {
            self.performZoomInForStartingImageView(startingImageView: imageView)
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
 

    // MARK: send Message With Properties
    
    private func sendMessageWithProperties(_ properties: [String: Any]) {
        let ref = Database.database().reference().child("Messages")
        let childRef = ref.childByAutoId()
        let toId = userOther?.id
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
                }
            }
            
            self.txtInput.text = nil
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
    
    // MARK: job finis
    
    @objc func completeJobButton() {
        // show loader for 1 second
        self.filterLauncher.handleDismiss()
        let timestamp = Int(Date().timeIntervalSince1970)
        if((self.ongoingJob) != nil) {
            let ongoingJobRef = Database.database().reference().child("Ongoing-Jobs").child(self.ongoingJob.key)
            let acceptDic = ["job-status":JobStatus.AwaitingPayment.rawValue,"complete-time":timestamp]
            ongoingJobRef.updateChildValues(acceptDic)
        }
        
        let ref = Database.database().reference().child("Users").child(self.ongoingJob.authorId)
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String : AnyObject] else {
                return
            }
            debugPrint(dictionary)
            let user = UserChat(dictionary: dictionary)
            user.id = snapshot.key
            if let token : String = (dictionary["fcmToken"] as? String) {
                let sender = PushNotificationSender()
                sender.sendPushNotification(to: token, title: "Congrats! 🎉", body: "\(user.name ?? "") submitted a completed Job request", page: true, senderId: Auth.auth().currentUser!.uid, recipient: self.ongoingJob.authorId)
                
            }
        }
        
        let messageRref = Database.database().reference().child("Messages")
        let childRef = messageRref.childByAutoId()
        let toId = userOther?.id
        let fromId = Auth.auth().currentUser!.uid
        let values : [String : Any] = ["toId": toId ?? "", "fromId": fromId, "timestamp": timestamp,  "ongoingjobkey" : self.ongoingJob.key, "text-id" : childRef.key ?? "", "job-status":JobStatus.AwaitingPayment.rawValue, "text": "You submitted a completed Job request to \(userOther?.name ?? "")"] as [String : Any]
        
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
                }
            }
            
            self.txtInput.text = nil
        }
        if let VC = CommonUtils.getStoryboardVC(StoryBoard.Payment.rawValue, vcIdetifier: RattingVC.className) as? RattingVC {
            VC.userOther = self.userOther
            VC.ongoingJob = self.ongoingJob
            VC.hidesBottomBarWhenPushed = true
            VC.modalPresentationStyle = .overCurrentContext
            self.navigationController?.present(VC, animated: true)
        }
    }
    
    func nextAction() {
        GlobalVariables.finishedFeedback = true
        let sb = UIStoryboard(name: "TabStoryboard", bundle: nil)
        let vc: UIViewController = sb.instantiateViewController(withIdentifier: "TabbControllerID") as! TabBarController
        UIApplication.shared.keyWindow?.rootViewController = vc
    }
    
    // MARK: Button Action
    @IBAction func didTapOnBookingButton(_ sender: Any) {
        let myScheduleVC = CommonUtils.getStoryboardVC(StoryBoard.Schedule.rawValue, vcIdetifier: MYScheduleVC.className) as! MYScheduleVC
        self.navigationController?.pushViewController(myScheduleVC, animated: true)
    }
    
    @IBAction func didTapOnFileButton(_ sender: Any) {
    }
    
    @IBAction func didTapOnPhotoButton(_ sender: UIButton) {
        self.btnCameraClick(sender)
    }
    
    @IBAction func didTapOnLocationButton(_ sender: Any) {
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
    
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
  
    @IBAction func btnFinishClick(_ sender: UIButton) {
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("Stripe").observeSingleEvent(of:.value) { (usernameSnap) in
            print(usernameSnap)
            if let dict = usernameSnap.value as? [String:Any] {
                let json = JSON(dict)
                let id = json["id"].stringValue
                if id == "" {
                    
                } else {
                    self.checkAccountDetails(token: id)
                }
            } else {
                
            }
        }
        return
//        self.filterLauncher.showFilter()
//        self.filterLauncher.completeJob.addTarget(self, action: #selector(self.completeJobButton), for: .touchUpInside)
    }
    
    func postRequest(token:String) {
        let parameters: [String: Any] = [
                "account" : token,
                "refresh_url" : "https://example.com/reauth",
                "return_url" : "https://example.com/return",
                "type": "account_onboarding"
            ]
        let header = HTTPHeaders.init([HTTPHeader.init(name: "Content-Type", value: "application/x-www-form-urlencoded"),HTTPHeader.init(name: "Authorization", value: "Bearer sk_test_T7azo8VosFz9hDdPCsnYK5mm")])//
        AF.request("https://api.stripe.com/v1/account_links", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: header, interceptor: nil, requestModifier: nil).responseJSON { (response) in
            if let data = response.data {
                let json = JSON(data)
                debugPrint(json)
                let url = json["url"].stringValue
                if let webVC = CommonUtils.getStoryboardVC(StoryBoard.Payment.rawValue, vcIdetifier: StripeWebViewController.className) as? StripeWebViewController {
                    webVC.webUrl = url
                    webVC.modalPresentationStyle = .overFullScreen
                    self.present(webVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    func checkAccountDetails(token:String) {
        let header = HTTPHeaders.init([HTTPHeader.init(name: "Content-Type", value: "application/x-www-form-urlencoded"),HTTPHeader.init(name: "Authorization", value: "Bearer sk_test_T7azo8VosFz9hDdPCsnYK5mm")])//
        AF.request("https://api.stripe.com/v1/accounts/\(token)", method: .post, parameters: [:], encoding: URLEncoding.default, headers: header, interceptor: nil, requestModifier: nil).responseJSON { (response) in
            if let data = response.data {
                let json = JSON(data)
                let payoutsEnabled = json["payouts_enabled"].boolValue
                if (payoutsEnabled == true) {
                    
                } else {
                    self.postRequest(token: token)
                }
            }
        }
    }
    
    func createAnAccount() {
        let header = HTTPHeaders.init([HTTPHeader.init(name: "Content-Type", value: "application/x-www-form-urlencoded"),HTTPHeader.init(name: "Authorization", value: "Bearer sk_test_T7azo8VosFz9hDdPCsnYK5mm")])//
        AF.request("https://api.stripe.com/v1/accounts", method: .post, parameters: [:], encoding: URLEncoding.default, headers: header, interceptor: nil, requestModifier: nil).responseJSON { (response) in
            if let data = response.data {
                let json = JSON(data)
                let payoutsEnabled = json["payouts_enabled"].boolValue
                if (payoutsEnabled == true) {
                    
                } else {
                    self.postRequest(token: token)
                }
            }
        }
    }
    
    @IBAction func btnPolygonClick(_ sender: UIButton) {

    }
    
    @IBAction func btnMoreClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        moreView.isHidden = !sender.isSelected
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
        vwCostumerJobAccepted.isHidden = true
        
        if txtInput.text != nil && txtInput.text != "" {
            let properties = ["text": txtInput.text!] as [String : Any]
            sendMessageWithProperties(properties)
        }
    }
    
    @IBAction func btnCostumerJobAcceptedCloseClick(_ sender: UIButton) {
        vwCostumerJobAccepted.isHidden = true
    }

    @IBAction func btnAcceptedClick(_ sender: UIButton) {
        vwAcceptOrDecline.isHidden = true
        let timestamp = Int(Date().timeIntervalSince1970)
        if((self.ongoingJob) != nil) {
            let ongoingJobRef = Database.database().reference().child("Ongoing-Jobs").child(self.ongoingJob.key)
            let acceptDic = ["job-status":JobStatus.Accepted.rawValue,"running-time": timestamp]
            ongoingJobRef.updateChildValues(acceptDic)
        }
        
        let ref = Database.database().reference().child("Users").child(self.ongoingJob.authorId)
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String : AnyObject] else {
                return
            }
            debugPrint(dictionary)
            let user = UserChat(dictionary: dictionary)
            user.id = snapshot.key
            if let token : String = (dictionary["fcmToken"] as? String) {
                let sender = PushNotificationSender()
                sender.sendPushNotification(to: token, title: "Congrats! 🎉", body: "\(user.name ?? "") accepted your job request.", page: true, senderId: Auth.auth().currentUser!.uid, recipient: self.ongoingJob.authorId)
                
            }
        }
    }
    
    @IBAction func btnDeclineClick(_ sender: UIButton) {
        vwAcceptOrDecline.isHidden = true
        let timestamp = Int(Date().timeIntervalSince1970)
        if((self.ongoingJob) != nil) {
            let ongoingJobRef = Database.database().reference().child("Ongoing-Jobs").child(self.ongoingJob.key)
            let acceptDic = ["job-status":JobStatus.Declined.rawValue,"cancel-time": timestamp]
            ongoingJobRef.updateChildValues(acceptDic)
        }
        
        let ref = Database.database().reference().child("Users").child(self.ongoingJob.authorId)
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String : AnyObject] else {
                return
            }
            debugPrint(dictionary)
            let user = UserChat(dictionary: dictionary)
            user.id = snapshot.key
            if let token : String = (dictionary["fcmToken"] as? String) {
                let sender = PushNotificationSender()
                sender.sendPushNotificationHire(to: token, title: "Alert!", body: "\(user.name ?? "") declined your job request.", page: true, senderId: Auth.auth().currentUser!.uid, recipient: self.ongoingJob.authorId)
                
            }
        }
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
            profileVC.userUID = userOther!.id!
            self.navigationController?.pushViewController(profileVC,  animated: true)
        }
        print("left")
    }
    
    @objc func btnAcceptAndPayClick(_ sender: UIButton) {
        let message = self.messages[sender.tag]
        if let paymentVC = CommonUtils.getStoryboardVC(StoryBoard.Payment.rawValue, vcIdetifier: PaymentVC.className) as? PaymentVC {
            paymentVC.userJobPost = self.userOther
            paymentVC.ongoingJob = self.ongoingJob
            paymentVC.message = message
            self.navigationController?.pushViewController(paymentVC,  animated: true)
        }
    }
    
    @objc func btnDeclineAndPayClick(_ sender: UIButton) {
        let message = self.messages[sender.tag]
        let timestamp = Int(Date().timeIntervalSince1970)
        if((self.ongoingJob) != nil) {
            let ongoingJobRef = Database.database().reference().child("Ongoing-Jobs").child(self.ongoingJob.key)
            let acceptDic = ["job-status":JobStatus.DeclinePayment.rawValue,"cancel-time": timestamp]
            ongoingJobRef.updateChildValues(acceptDic)
        }
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
        let message = messages[indexPath.row]
        if((ongoingJob) != nil) {
            if ongoingJob.isServiceProvider {
                
            } else {
                if message.jobStatus == .AwaitingPayment {
                    let acceptCell  = collectionView.dequeueReusableCell(withReuseIdentifier: AcceptPaymentCollectionViewCell.className, for: indexPath) as! AcceptPaymentCollectionViewCell
                    if let profileImageUrl = self.userOther?.profileImageUrl {
                        acceptCell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
                    } else {
                        acceptCell.profileImageView.backgroundColor = UIColor.clear
                        acceptCell.profileImageView.image = UIImage(systemName: "person.circle.fill")
                        acceptCell.profileImageView.tintColor = UIColor.lightGray
                        acceptCell.profileImageView.contentMode = .scaleAspectFill
                    }
                    acceptCell.descLabel.text = "\(self.userOther?.name ?? "") requests the\ntermination of the job, do you agree?"
                    acceptCell.acceptPayButton.tag = indexPath.item
                    acceptCell.acceptPayButton.addTarget(self, action: #selector(btnAcceptAndPayClick(_:)), for: .touchUpInside)
                    acceptCell.declineButton.tag = indexPath.item
                    acceptCell.declineButton.addTarget(self, action: #selector(btnDeclineAndPayClick(_:)), for: .touchUpInside)
                    acceptCell.acceptPayButton.isEnabled = false
                    acceptCell.declineButton.isEnabled = false
                    if message.ongoingjobkey == self.ongoingJob.key {
                        if self.ongoingJob.jobStatus == .AwaitingPayment {
                            acceptCell.acceptPayButton.isEnabled = true
                            acceptCell.declineButton.isEnabled = true
                        }
                    }
                    return acceptCell
                }
            }
        }
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        cell.chatLogControllerVC = self
        
        cell.index = indexPath
        
        setupCell(cell: cell, message: message)
        cell.textView.text = message.text
        if((ongoingJob) != nil) {
            if ongoingJob.isServiceProvider {
                if message.jobStatus == .AwaitingPayment {
                    cell.textView.attributedText = NSMutableAttributedString().bold("You").normal(" submitted a completed Job request to\n").bold(self.userOther?.name ?? "")
                    cell.bubbleView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.968627451, blue: 0.9882352941, alpha: 1)
                }
            }
        }
        
        
        if let text = message.text {
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: text).width + 32
            cell.textView.isHidden = false
        } else if message.imageUrl != nil {
            cell.bubbleWidthAnchor?.constant = 200
            cell.textView.isHidden = true
        }
        
       // let btn_left=UIButton(frame: CGRect(x: 8, y: cell.frame.height - 51, width: 32, height: 32))
        cell.profileImageView.addTarget(self, action: #selector(btnleftClick), for: .touchUpInside)
        //cell.addSubview(btn_left)

        //let btn_right=UIButton(frame: CGRect(x: cell.frame.width - 40, y: cell.frame.height - 51, width: 32, height: 32))
        cell.myProfileImageView.addTarget(self, action: #selector(btnrightClick), for: .touchUpInside)
        //cell.addSubview(btn_right)
        
//        let btn_image=UIButton(frame: CGRect(x: 0 , y: 0, width: cell.messageImageView.frame.width, height: cell.messageImageView.frame.height))
//        btn_image.addTarget(self, action: #selector(handleImageTap(tapGesture:)), for: .touchUpInside)
//        cell.addSubview(btn_image)
        
        
        
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        let width = UIScreen.main.bounds.width
        
        let message = messages[indexPath.item]
        if((ongoingJob) != nil) {
            if ongoingJob.isServiceProvider {
                if message.jobStatus == .AwaitingPayment {
                    
                }
            } else {
                if message.jobStatus == .AwaitingPayment {
                    return CGSize(width: width, height: 162)
                }
            }
        }
        
        if let text = message.text {
            height = estimateFrameForText(text: text).height + 15
        } else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue {
            height = CGFloat(imageHeight / imageWidth * 200)
        } else if let location = message.isLocation {
            if location {
                height = 150
            }
        }
        return CGSize(width: width, height: height + 25)
    }
}

extension ChatVC : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = textView.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = textView.text.count > 0
        }
        sendButton.isSelected = textView.text.count > 0
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        sendButton.isSelected = textView.text.count > 0
        return true
    }
}
