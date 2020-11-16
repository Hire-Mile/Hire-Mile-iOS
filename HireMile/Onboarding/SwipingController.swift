//
//  SwipingController.swift
//  HireMile
//
//  Created by JJ Zapata on 11/15/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import Foundation
import UIKit

class SwipingController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let imageNames = ["onboarding1", "onboarding2", "onboarding3"]
    let backdropNames = ["backdrop", "backdrop1", "backdrop2"]
    let headerString = ["Earn Money", "Select the best", "Creative feedback"]
    let descriptionString = ["With HIREMILE you will be able to generate extra income to your usual job, make your best skills known to your neighbors.", "Search among the best workers near your neighborhood, for any task or project that you need to perform quickly and efficiently.", "You will be able to qualify workers with audios, emojis, or photos, thus you will help us that the excellence in our community increases. "]

    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SKIP", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor(red: 187/255, green: 187/255, blue: 187/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        return button
    }()

    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("NEXT", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.mainBlue, for: .normal)
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return button
    }()

    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = imageNames.count
        pc.currentPageIndicatorTintColor = .mainBlue
        pc.pageIndicatorTintColor = UIColor(red: 235/255, green: 234/255, blue: 234/255, alpha: 1)
        return pc
    }()
    
    private let getStartedButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.mainBlue
        button.setTitle("GET STARTED", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = true
        button.addTarget(self, action: #selector(getStarted), for: .touchUpInside)
        return button
    }()
    
    private let getStartedView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mainBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    fileprivate func setupBottomControls() {
        let bottomControlsStackView = UIStackView(arrangedSubviews: [previousButton, pageControl, nextButton])
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomControlsStackView.distribution = .fillEqually

        view.addSubview(bottomControlsStackView)

        NSLayoutConstraint.activate([
            bottomControlsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomControlsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomControlsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomControlsStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupBottomControls()

        collectionView.backgroundColor = .white
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.isPagingEnabled = true
    }

    @objc private func handleNext() {
        // Work on this
        let nextIndex = min(pageControl.currentPage + 1, imageNames.count - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        if self.pageControl.currentPage == 2 {
            // Remove Necessary Items
            self.pageControl.removeFromSuperview()
            self.previousButton.removeFromSuperview()
            self.nextButton.removeFromSuperview()
            // Disable Scroll On CollectionView
            self.collectionView.isScrollEnabled = false
            // Add Views
            self.view.addSubview(self.getStartedView)
            self.view.addSubview(self.getStartedButton)
            // Add Contraints For View
            self.getStartedView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            self.getStartedView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
            self.getStartedView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            self.getStartedView.heightAnchor.constraint(equalToConstant: 80).isActive = true
            // Add Contraints For Button
            self.getStartedButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
            self.getStartedButton.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
            self.getStartedButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            self.getStartedButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        }
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    @objc private func handleSkip() {
        // Work on this
        let nextIndex = IndexPath(item: imageNames.count - 1, section: 0)
        pageControl.currentPage = 3
        collectionView.scrollToItem(at: nextIndex, at: .centeredHorizontally, animated: true)
    }
    
    @objc private func getStarted() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        let controller = UINavigationController(rootViewController: SignIn())
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageNames.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PageCell
        cell.backdrop.image = UIImage(named: backdropNames[indexPath.row])
        cell.largeImageView.image = UIImage(named: imageNames[indexPath.row])
        cell.largeImageView.layer.cornerRadius = 13
        cell.largeImageView.clipsToBounds = true
        let attributedText = NSMutableAttributedString(string: "\n\(self.headerString[indexPath.row])", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 23)])
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        attributedText.append(NSAttributedString(string: "\n\(self.descriptionString[indexPath.row])", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.black]))
        attributedText.addAttributes([NSAttributedString.Key.paragraphStyle: style], range: NSMakeRange(0, attributedText.length))
        cell.descriptionTextView.attributedText = attributedText
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        pageControl.currentPage = Int(x / view.frame.width)
        if x / view.frame.width == 2 {
            // Remove Necessary Items
            self.pageControl.removeFromSuperview()
            self.previousButton.removeFromSuperview()
            self.nextButton.removeFromSuperview()
            // Disable Scroll On CollectionView
            self.collectionView.isScrollEnabled = false
            // Add Views
            self.view.addSubview(self.getStartedView)
            self.view.addSubview(self.getStartedButton)
            // Add Contraints For View
            self.getStartedView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            self.getStartedView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
            self.getStartedView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            self.getStartedView.heightAnchor.constraint(equalToConstant: 80).isActive = true
            // Add Contraints For Button
            self.getStartedButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
            self.getStartedButton.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
            self.getStartedButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            self.getStartedButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        }
    }

}
