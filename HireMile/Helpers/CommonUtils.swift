//
//  CommonUtils.swift
//  HireMile
//
//  Created by jaydeep vadalia on 06/06/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

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
    
    static var topViewController: UINavigationController? {
        let keyWindow = UIApplication.shared.windows.filter { $0.isKeyWindow }.first

        if var topController = keyWindow?.rootViewController as? UITabBarController {
            topController.selectedIndex = 0
            return topController.viewControllers?.first as? UINavigationController
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
    
    static func getAddressFromCoordinates(latitude: Double, logitude: Double, completion: @escaping (String) -> Void){
        // Add below code to get address for touch coordinates.
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: logitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler:
            {
                placemarks, error -> Void in
                var address = ""
                // Place details
                guard let placeMark = placemarks?.first else { return }
                
                // Location name
                if let locationName = placeMark.location {
                    print(locationName)
                    
                }
                // Street address
                if let street = placeMark.thoroughfare {
                    print(street)
                    address = street
                }
                // City
                if let city = placeMark.subAdministrativeArea {
                   address = address + " ," + city
                }
                // Zip code
                if let zip = placeMark.isoCountryCode {
                    print(zip)
                    address = address + " ," + zip
                }
                // Country
                if let country = placeMark.country {
                    print(country)
                    address = address + " ," + country
                }
                completion(address)
        })

    }
}
