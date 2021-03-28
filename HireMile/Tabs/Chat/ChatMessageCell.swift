//
//  ChatMessageCell.swift
//  HireMile
//
//  Created by JJ Zapata on 12/28/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit
import MapKit

class ChatMessageCell: UICollectionViewCell {
    
    var chatLogController : ChatLogController2?
    
    var delegate: UserCellDelegate?
    
    var index : IndexPath?
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "SAMPLE TEXT FOR NOW"
        tv.textColor = UIColor.white
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.backgroundColor = UIColor.clear
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let bubbleView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.mainBlue
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let myProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var mapView: MKMapView = {
        let imageView = MKMapView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var mapButton: UIButton = {
        let imageView = UIButton()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let timeSent : UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var bubbleWidthAnchor : NSLayoutConstraint?
    var bubbleViewRightAnchor : NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    var leftAnchorRec : NSLayoutConstraint?
    var rightAnchorMe : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageView)
        addSubview(myProfileImageView)
        addSubview(timeSent)
        
        bubbleView.addSubview(messageImageView)
        messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        
        bubbleView.addSubview(mapView)
        mapView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        mapView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        
        contentView.addSubview(mapButton)
        mapButton.addTarget(self, action: #selector(mapButtonAction), for: .touchUpInside)
        mapButton.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        mapButton.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        mapButton.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        mapButton.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bubbleView.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        myProfileImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        myProfileImageView.bottomAnchor.constraint(equalTo: self.bubbleView.bottomAnchor).isActive = true
        myProfileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        myProfileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -48)
        bubbleViewRightAnchor?.isActive = true
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        bubbleView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        
        timeSent.topAnchor.constraint(equalTo: textView.bottomAnchor).isActive = true
        leftAnchorRec = timeSent.leftAnchor.constraint(equalTo: bubbleView.leftAnchor)
        rightAnchorMe = timeSent.rightAnchor.constraint(equalTo: bubbleView.rightAnchor)
        timeSent.widthAnchor.constraint(equalToConstant: 120).isActive = true
        timeSent.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func mapButtonAction() {
        delegate?.didPressButton(index!.row)
    }
    
}
