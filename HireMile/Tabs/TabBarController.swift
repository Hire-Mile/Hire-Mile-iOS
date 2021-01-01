//
//  TabBarControllerMain.swift
//  HireMile
//
//  Created by JJ Zapata on 11/16/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    var passingImage : UIImage?
    
    var timer : Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hidesBottomBarWhenPushed = true
        
//        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerFunction), userInfo: nil, repeats: true)
        
        tabBar.tintColor = UIColor.mainBlue
        
        let middleButton = UIButton()
        
        view.addSubview(middleButton)
        
        let homeController = UINavigationController(rootViewController: Home())
        homeController.tabBarItem.image = UIImage(systemName: "house")
        homeController.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        
        let addController = UINavigationController(rootViewController: Chat())
        
        let chatController = UINavigationController(rootViewController: Chat())
        chatController.tabBarItem.image = UIImage(systemName: "text.bubble")
        chatController.tabBarItem.selectedImage = UIImage(systemName: "text.bubble.fill")
        
        viewControllers = [homeController, addController, chatController]

        // Do any additional setup after loading the view.
    }

}


class TabBarController2: UITabBar {

    private var middleButton = UIButton()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupMiddleButton()
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.isHidden {
            return super.hitTest(point, with: event)
        }
        
        let from = point
        let to = middleButton.center

        return sqrt((from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)) <= 39 ? middleButton : super.hitTest(point, with: event)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        middleButton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 0)
    }

    func setupMiddleButton() {
        middleButton.frame.size = CGSize(width: 70, height: 70)
        middleButton.backgroundColor = UIColor.mainBlue
        middleButton.setTitleColor(UIColor.white, for: .normal)
        middleButton.setImage(UIImage(named: "postButton"), for: .normal)
        middleButton.layer.cornerRadius = 35
        middleButton.layer.masksToBounds = true
        middleButton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 65)
        middleButton.addTarget(self, action: #selector(test), for: .touchUpInside)
        addSubview(middleButton)
    }

    @objc func test() {
        print("my name is jeff")
        GlobalVariables.isGoingToPost = true
    }
}

