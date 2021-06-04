//
//  Gallery.swift
//  HireMile
//
//  Created by JJ Zapata on 5/8/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD

class Gallery: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let mainButton : MainButton = {
        let mainButton = MainButton(title: "Add Photos")
        mainButton.addTarget(self, action: #selector(addButtonPressed), for: UIControl.Event.touchUpInside)
        return mainButton
    }()
    
    let pickerController = UIImagePickerController()
    
    let filterLauncher = PostSourceLauncher()
    
    var userId : String? {
        didSet {
            print("set user id as: \(userId!)")
            GlobalVariables.imageGalleryId = userId!
            if userId! == Auth.auth().currentUser!.uid {
                addMainButton()
            }
            backend(withUid: userId!)
        }
    }
    
    var images = [GalleryModel]()
    
    var blackBackground : UIView?
    
    var startingFrame : CGRect?
    
    var imageView : UIImageView?
    
    var collectionView : UICollectionView?
    
    let noServiceImage : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "succes-fed-cam")
        return imageView
    }()
    
    let noServiceLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Gallery Empty"
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor(red: 179/255, green: 185/255, blue: 196/255, alpha: 1)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layou2: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layou2.scrollDirection = .vertical
        
        self.collectionView = UICollectionView(frame: CGRect(x: 25, y: 75, width: self.view.frame.width - 50, height: self.view.frame.size.height - 175), collectionViewLayout: layou2)
        self.collectionView!.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView!.backgroundColor = UIColor.white
        self.collectionView!.alwaysBounceVertical = true
        self.collectionView!.alwaysBounceHorizontal = false
        self.collectionView!.dataSource = self
        self.collectionView!.showsHorizontalScrollIndicator = false
        self.collectionView!.showsVerticalScrollIndicator = false
        self.collectionView!.delegate = self
        self.collectionView!.register(GalleryCell.self, forCellWithReuseIdentifier: "galeryCellID")
        self.view.addSubview(self.collectionView!)
        
        view.backgroundColor = UIColor.white
        
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(globalCheck), userInfo: nil, repeats: true)

        // Do any additional setup after loading the view.
    }
    
    private func backend(withUid id: String) {
        images.removeAll()
        Database.database().reference().child("Users").child(id).child("gallery").observe(DataEventType.childAdded) { snapshot in
            if let value = snapshot.value as? [String : Any] {
                let image = GalleryModel()
                image.id = snapshot.key
                image.time = value["time"] as? Int
                image.url = value["url"] as? String
                if image.url != nil && image.time != nil {
                    self.images.append(image)
                }
            }
            self.images.sort(by: { $0.time! > $1.time! } )
            self.collectionView?.reloadData()
        }
    }
    
    private func addMainButton() {
        view.addSubview(mainButton)
        mainButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mainButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        mainButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        mainButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25).isActive = true
    }
    
    private func uploadImage(image: UIImage?) {
        // show loading
        MBProgressHUD.showAdded(to: view, animated: true)
        // action
        if let imageData = image?.jpegData(compressionQuality: 0.8) {
            let root = Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("gallery")
            let key = root.childByAutoId().key!
            let storage = Storage.storage().reference().child("Users").child(Auth.auth().currentUser!.uid).child("gallery").child(key)
            let metadata = StorageMetadata()
            root.child(key)
            metadata.contentType = "image/jpg"
            storage.putData(imageData, metadata: metadata) { (storageMetadata, putError) in
                if putError == nil && storageMetadata != nil {
                    storage.downloadURL { (url, downloadError) in
                        if let metalImageUrl = url?.absoluteString {
                            let post = [
                                "key" : key,
                                "url" : metalImageUrl,
                                "time" : Int(Date().timeIntervalSince1970)
                            ] as [String : Any]
                            let feed = [key : post]
                            Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("gallery").updateChildValues(feed) { setValueError, setValRef in
                                if setValueError == nil {
                                    // hide loading
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                    // refresh view
                                    if let id = self.userId {
                                        self.userId = "\(id)"
                                    }
                                }
                            }
                        } else {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            self.simpleAlert(title: "Error", message: downloadError!.localizedDescription)
                        }
                    }
                } else {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.simpleAlert(title: "Error", message: putError!.localizedDescription)
                }
            }
        } else {
            // hide loading
            MBProgressHUD.hide(for: view, animated: true)
            simpleAlert(title: "Error", message: "Unable to cache image, please try again.")
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if images.count == 0 {
            addEtraView()
        } else {
            removeEtraView()
        }
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galeryCellID", for: indexPath) as! GalleryCell
        cell.myImageView.sd_setImage(with: URL(string: self.images[indexPath.row].url!), placeholderImage: nil, options: .retryFailed, completed: nil)
        cell.myImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageTap)))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected image: \(indexPath.item)")
        let controller = ViewGalleryItemController()
        let image = self.images[indexPath.row]
        controller.url = image.url!
        controller.author = userId!
        controller.id = image.id!
        self.present(controller, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: ((self.view.frame.size.width - 60) / 2) , height: ((self.view.frame.size.width - 60) / 2))
        return size
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let edited = info[.editedImage] as? UIImage {
            dismiss(animated: true) {
                self.uploadImage(image: edited)
            }
        } else if let original = info[.originalImage] as? UIImage {
            dismiss(animated: true) {
                self.uploadImage(image: original)
            }
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addButtonPressed() {
        presentPhotoPopup()
    }
    
    private func presentPhotoPopup() {
        self.filterLauncher.showFilter()
        self.filterLauncher.completeJob.addTarget(self, action: #selector(self.completeJobButton), for: .touchUpInside)
        self.filterLauncher.stopJob.addTarget(self, action: #selector(self.stopJobButton), for: .touchUpInside)
    }
    
    @objc func stopJobButton() {
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = .camera
        self.present(pickerController, animated: true, completion: filterLauncher.handleDismiss)
    }
    
    @objc func completeJobButton() {
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true, completion: filterLauncher.handleDismiss)
    }
    
    @objc func handleImageTap(tapGesture: UITapGestureRecognizer) {
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
        }
        if let imageView = tapGesture.view as? UIImageView {
            self.performZoomInForStartingImageView(startingImageView: imageView)
        }
    }
    
    func addEtraView() {
        self.view.addSubview(self.noServiceImage)
        self.noServiceImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -200).isActive = true
        self.noServiceImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.noServiceImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.noServiceImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.view.addSubview(self.noServiceLabel)
        self.noServiceLabel.topAnchor.constraint(equalTo: self.noServiceImage.bottomAnchor, constant: 25).isActive = true
        self.noServiceLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.noServiceLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.noServiceLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.noServiceImage.alpha = 1
        self.noServiceLabel.alpha = 1
    }
    
    func removeEtraView() {
        self.noServiceImage.alpha = 0
        self.noServiceLabel.alpha = 0
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
    
    @objc func globalCheck() {
//        print("global variabling")
//        if GlobalVariables.imageGalleryId != "" {
//            print("global variabling2")
//            backend(withUid: GlobalVariables.imageGalleryId)
//        }
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
    
}

class GalleryCell: UICollectionViewCell {
    
    let myImageView : CustomImageView = {
        let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .unselectedColor
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        addSubview(myImageView)
        myImageView.topAnchor.constraint(equalTo: topAnchor, constant: 7).isActive = true
        myImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 7).isActive = true
        myImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -7).isActive = true
        myImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
