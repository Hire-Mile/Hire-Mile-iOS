//
//  CommonUtils.swift
//  HireMile
//
//  Created by jaydeep vadalia on 06/06/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import Foundation
import UIKit
class CommonUtils {
    static func getStoryboardVC(_ kStoryName: String, vcIdetifier: String? = nil) -> UIViewController? {
        let storyboard = UIStoryboard(name: kStoryName, bundle: Bundle.main)
        if let vcID = vcIdetifier {
            let vc = storyboard.instantiateViewController(withIdentifier: vcID)
            return vc
        }
        
        if let initialVC = storyboard.instantiateInitialViewController() {
            return initialVC
        }
        return nil
    }
    
    static func getRecentServices() -> [String] {
        if let recent = UserDefaults.standard.array(forKey: "recent") as? [String] {
            return recent
        }
        return [String]()
    }
    
    static func setRecentServices(str: String) {
        var recent = getRecentServices()
        if !recent.contains(str) {
            recent.append(str)
            if(recent.count > 5) {
                recent.removeFirst()
            }
            UserDefaults.standard.set(recent, forKey: "recent")
        }
    }
}
