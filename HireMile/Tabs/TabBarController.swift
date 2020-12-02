//
//  TabBarControllerMain.swift
//  HireMile
//
//  Created by JJ Zapata on 11/16/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = UIColor.mainBlue
        
        let middleButton = UIButton()
        middleButton.frame.size = CGSize(width: 70, height: 70)
        middleButton.backgroundColor = UIColor.mainBlue
        middleButton.setTitleColor(UIColor.white, for: .normal)
        middleButton.setImage(UIImage(named: "postButton"), for: .normal)
        middleButton.layer.cornerRadius = 35
        middleButton.layer.masksToBounds = true
        middleButton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 65)
        middleButton.addTarget(self, action: #selector(openPost), for: .touchUpInside)
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
    
    @objc func openPost() {
        let controller = Post()
        controller.modalPresentationStyle = .overFullScreen
        self.present(controller, animated: true, completion: nil)
    }

}
