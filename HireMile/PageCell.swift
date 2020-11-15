//
//  PageCell.swift
//  autolayout_lbta
//
//  Created by Brian Voong on 10/12/17.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit

class PageCell: UICollectionViewCell {
    
    let largeImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "hello"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let backdrop: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "backdrop"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        let attributedText = NSMutableAttributedString(string: "\nEarn Money", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 23)])
        attributedText.append(NSAttributedString(string: "\nWith HIREMILE you will be able to generate extra income to your usual job, make your best skills known to your neighbors.", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.black]))
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        attributedText.addAttributes([NSAttributedString.Key.paragraphStyle: style], range: NSMakeRange(0, attributedText.length))
        textView.attributedText = attributedText
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SKIP", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor(red: 187/255, green: 187/255, blue: 187/255, alpha: 1), for: .normal)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("NEXT", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.mainBlue, for: .normal)
        return button
    }()
    
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = 3
        pc.currentPageIndicatorTintColor = .mainBlue
        pc.pageIndicatorTintColor = UIColor(red: 235/255, green: 234/255, blue: 234/255, alpha: 1)
        return pc
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backdrop)
        backdrop.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backdrop.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        backdrop.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        backdrop.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        setupLayout()
    }

    private func setupLayout() {
        let topImageContainerView = UIView()
        addSubview(topImageContainerView)
        topImageContainerView.translatesAutoresizingMaskIntoConstraints = false

        topImageContainerView.topAnchor.constraint(equalTo: topAnchor).isActive = true

        topImageContainerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        topImageContainerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        topImageContainerView.addSubview(largeImageView)
        largeImageView.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor).isActive = true
        largeImageView.centerYAnchor.constraint(equalTo: topImageContainerView.centerYAnchor).isActive = true
        largeImageView.heightAnchor.constraint(equalTo: topImageContainerView.heightAnchor, multiplier: 0.5).isActive = true

        topImageContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true

        addSubview(descriptionTextView)
        descriptionTextView.topAnchor.constraint(equalTo: topImageContainerView.bottomAnchor).isActive = true
        descriptionTextView.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        descriptionTextView.rightAnchor.constraint(equalTo: rightAnchor, constant: -24).isActive = true
        descriptionTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
