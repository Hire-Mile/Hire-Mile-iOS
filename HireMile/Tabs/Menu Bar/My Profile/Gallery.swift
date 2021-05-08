//
//  Gallery.swift
//  HireMile
//
//  Created by JJ Zapata on 5/8/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase

class Gallery: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let mainButton : MainButton = {
        let mainButton = MainButton(title: "Add Photos")
        mainButton.addTarget(self, action: #selector(addButtonPressed), for: UIControl.Event.touchUpInside)
        return mainButton
    }()
    
    var userId : String? {
        didSet {
            print("set user id as: \(userId!)")
            if userId! == Auth.auth().currentUser!.uid {
                addMainButton()
            }
            backend(withUid: userId!)
        }
    }
    
    var images = [GalleryModel]()
    
    var collectionView : UICollectionView?

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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galeryCellID", for: indexPath) as! GalleryCell
        if let url = images[indexPath.row].url {
            cell.myImageView.loadImage(from: URL(string: url)!)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected image: \(indexPath.item)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: ((self.view.frame.size.width - 60) / 2) , height: ((self.view.frame.size.width - 60) / 2))
        return size
    }
    
    @objc func addButtonPressed() {
        print("[preseedd buton")
    }
    
}

class GalleryCell: UICollectionViewCell {
    
    let myImageView : CustomImageView = {
        let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .orange
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
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
