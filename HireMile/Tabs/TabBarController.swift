//
//  TabBarControllerMain.swift
//  HireMile
//
//  Created by JJ Zapata on 11/16/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase

class TabBarController: UITabBarController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    let imagePicker = UIImagePickerController()

    var passingImage : UIImage?

    var timer : Timer?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = tabBar.standardAppearance
        appearance.shadowImage = nil
        appearance.shadowColor = nil
        tabBar.standardAppearance = appearance;

        self.hidesBottomBarWhenPushed = true
        tabBar.tintColor = UIColor.mainBlue
        let middleButton = UIButton()
        view.addSubview(middleButton)
        
        let homeController = CommonUtils.getStoryboardVC(StoryBoard.Home.rawValue, vcIdetifier: HomeVC.className) as! HomeVC 
        homeController.tabBarItem.image = UIImage(named: "home-inactive1")
        homeController.tabBarItem.selectedImage = UIImage(named: "home1")
        let navHomeVC = UINavigationController(rootViewController: homeController)
        
        
        let myScheduleVC = CommonUtils.getStoryboardVC(StoryBoard.Schedule.rawValue, vcIdetifier: MYScheduleVC.className) as! MYScheduleVC
        myScheduleVC.tabBarItem.image = UIImage(named: "mySchedule-unselected")
        myScheduleVC.tabBarItem.selectedImage = UIImage(named: "mySchedule-selected")
        myScheduleVC.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        let addController = UINavigationController(rootViewController: Chat())

        let chatController = UINavigationController(rootViewController: Chat())
        chatController.tabBarItem.image = UIImage(named: "message-unselected")
        chatController.tabBarItem.selectedImage = UIImage(named: "message-selected")
        chatController.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let menuVC = CommonUtils.getStoryboardVC(StoryBoard.Menu.rawValue, vcIdetifier: MenuVC.className) as! MenuVC
        menuVC.tabBarItem.isEnabled = false
        viewControllers = [navHomeVC, myScheduleVC ,addController ,chatController, menuVC]
        
        tabBar.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    
    

}


class TabBarController2: UITabBar {

    private var middleButton = UIButton()
    private var menuButton = UIButton()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupMiddleButton()
        setupMenuButton()
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.isHidden {
            return super.hitTest(point, with: event)
        }

        let from = point
        let to = middleButton.center

        return sqrt((from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)) <= 39 ? middleButton : super.hitTest(point, with: event)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
              var size = super.sizeThatFits(size)
              size.height = 90
              return size
         }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        middleButton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 0)
        let lastWidth = UIScreen.main.bounds.width/5
        menuButton.center = CGPoint(x: UIScreen.main.bounds.width - lastWidth + (lastWidth/2), y: 23)
    }

    func setupMiddleButton() {
        middleButton.frame.size = CGSize(width: 80, height: 80)
        middleButton.backgroundColor = UIColor.mainBlue
        middleButton.setTitleColor(UIColor.white, for: .normal)
        middleButton.setImage(UIImage(named: "postButton"), for: .normal)
        middleButton.layer.cornerRadius = 40
        middleButton.layer.masksToBounds = true
        middleButton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 65)
        middleButton.addTarget(self, action: #selector(test), for: .touchUpInside)
        addSubview(middleButton)
    }

    func setupMenuButton() {
        menuButton.frame.size = CGSize(width: 30, height: 30)
        menuButton.setTitleColor(UIColor.white, for: .normal)
        menuButton.setImage(UIImage(named: "menu-unselect"), for: .normal)
        menuButton.setImage(UIImage(named: "menu-select"), for: .selected)
        menuButton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 65)
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        addSubview(menuButton)
    }
    
    @objc func menuButtonTapped() {
        let menuVC = CommonUtils.getStoryboardVC(StoryBoard.Menu.rawValue, vcIdetifier: MenuVC.className) as! MenuVC
        menuVC.modalPresentationStyle = .overCurrentContext
        menuVC.completionHandler = {index in
            switch index {
            case 0:
                let controller = MyJobs()
                controller.hidesBottomBarWhenPushed = true
                CommonUtils.topViewController?.pushViewController(controller, animated: false)
                break
            case 1:
                let controller = MyReviews()
                controller.hidesBottomBarWhenPushed = true
                CommonUtils.topViewController?.pushViewController(controller, animated: false)
                break
            case 2:
//                let controller = CommonUtils.getStoryboardVC(StoryBoard.Payment.rawValue, vcIdetifier: PaymentVC.className) as! PaymentVC
//                controller.hidesBottomBarWhenPushed = true
//                CommonUtils.topViewController?.pushViewController(controller, animated: false)
                break
            case 3:
                let controller = Favorites()
                controller.hidesBottomBarWhenPushed = true
                CommonUtils.topViewController?.pushViewController(controller, animated: false)
                break
            case 4:
                let controller = Settings()
                controller.hidesBottomBarWhenPushed = true
                CommonUtils.topViewController?.pushViewController(controller, animated: false)
            case 5:
                self.signOut()
            default:
                self.signOut()
            }
        }
        topMostController?.present(menuVC, animated: true, completion: nil)
        debugPrint("menu button tapped")
    }

    
    @objc func test() {
        GlobalVariables.isGoingToPost = true
    }
        
    func signOut() {
        let alert = UIAlertController(title: "Are you sure you want to sign out?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print("Error signing out: \(signOutError)")
                let errorAlert = UIAlertController(title: "Error", message: signOutError.localizedDescription, preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.topMostController?.present(errorAlert, animated: true, completion: nil)
            }
            let controller = WelcomeScreen()
            controller.modalPresentationStyle = .fullScreen
            UIApplication.shared.keyWindow?.rootViewController = controller
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.topMostController?.present(alert, animated: true, completion: nil)
    }
}

