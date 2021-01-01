//
//  ChatLogController.swift
//  HireMile
//
//  Created by JJ Zapata on 12/26/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import AVFoundation
import FirebaseStorage
import FirebaseDatabase
import MobileCoreServices

class ChatLogController2: UICollectionViewController, UITextFieldDelegate , UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var user : UserChat? {
        didSet {
            navigationItem.title = user?.name
            observeMessages()
        }
    }
    
    var messages = [Message]()
    var startingFrame : CGRect?
    var blackBackground : UIView?
    
    let cellId = "myCellId"
    
    let inputTextField : UITextField = {
        let inputTextField = UITextField()
        inputTextField.placeholder = "Write here"
        inputTextField.textColor = UIColor.black
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
        attachmentButton.setImage(UIImage(systemName: "camera"), for: .normal)
        attachmentButton.tintColor = UIColor.darkGray
        attachmentButton.layer.cornerRadius = 20
        attachmentButton.addTarget(self, action: #selector(didSelectImage), for: .touchUpInside)
        attachmentButton.translatesAutoresizingMaskIntoConstraints = false
        return attachmentButton
    }()
    
    let sendButton : UIButton = {
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("SEND", for: .normal)
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        sendButton.setTitleColor(UIColor.white, for: .normal)
        sendButton.backgroundColor = UIColor.mainBlue
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        sendButton.layer.cornerRadius = 20
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationItem.title = "Chat Log Controller"
        
        collectionView.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 95, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 95, right: 0)
        collectionView.keyboardDismissMode = .interactive
        
        self.setupInputComponents()
        self.setupKeyboardObservers()
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    var containerViewBottomAnchor : NSLayoutConstraint?
    
    func setupInputComponents() {
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
        
        containerView.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.addSubview(attachmentButton)
        attachmentButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        attachmentButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        attachmentButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        attachmentButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.addSubview(inputTextView)
        inputTextView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextView.leftAnchor.constraint(equalTo: attachmentButton.rightAnchor, constant: 10).isActive = true
        inputTextView.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -10).isActive = true
        inputTextView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        inputTextView.addSubview(inputTextField)
        inputTextField.delegate = self
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.leftAnchor.constraint(equalTo: inputTextView.leftAnchor, constant: 10).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: inputTextView.rightAnchor, constant: -10).isActive = true
        inputTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
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
        
        return cell
    }
    
    private func setupCell(cell: ChatMessageCell, message: Message) {
        if let profileImageUrl = self.user?.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        } else {
            cell.profileImageView.backgroundColor = UIColor.clear
            cell.profileImageView.image = UIImage(systemName: "person.circle.fill")
            cell.profileImageView.tintColor = UIColor.lightGray
            cell.profileImageView.contentMode = .scaleAspectFill
        }
        
        if message.fromId == Auth.auth().currentUser?.uid {
            cell.bubbleView.backgroundColor = UIColor.mainBlue
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        } else {
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
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        let message = messages[indexPath.item]
        if let text = message.text {
            height = estimateFrameForText(text: text).height + 15
        } else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue {
            height = CGFloat(imageHeight / imageWidth * 200)
        }
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
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
                self.messages.append(message)
                DispatchQueue.main.async(execute: {
                    self.collectionView.reloadData()
                    let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                    self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                })
            }
        }
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        containerViewBottomAnchor?.constant = -keyboardFrame!.height + 10
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        containerViewBottomAnchor?.constant = 0
        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func didSelectImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeImage as String, kUTTypeVideo as String, kUTTypeMovie as String]
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
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
        let properties = ["text": inputTextField.text!] as [String : Any]
        sendMessageWithProperties(properties)
    }
    
    @objc func handleKeyboardDidShow() {
        if messages.count > 0 {
            let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
            self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    private func sendImageWithImageUrl(imageUrl: String, image: UIImage  ) {
        
        let properties = ["imageUrl": imageUrl, "imageWidth" : image.size.width, "imageHeight" : image.size.height] as [String : Any]
        sendMessageWithProperties(properties)
    }
    
    private func sendMessageWithProperties(_ properties: [String: Any]) {
        let ref = Database.database().reference().child("Messages")
        let childRef = ref.childByAutoId()
        let toId = user?.id
        let fromId = Auth.auth().currentUser!.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        var values : [String : Any] = ["toId": toId, "fromId": fromId, "timestamp": timestamp] as [String : Any]
        
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
        if let keyWindow = UIApplication.shared.keyWindow {
            blackBackground = UIView(frame: keyWindow.frame)
            self.blackBackground?.backgroundColor = .black
            self.blackBackground?.alpha = 0
            keyWindow.addSubview(blackBackground!)
            keyWindow.addSubview(zoomingImageView)
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

}
