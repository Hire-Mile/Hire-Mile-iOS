//
//  CustomImageView.swift
//  HireMile
//
//  Created by JJ Zapata on 1/28/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit
import SDWebImage

let imageCacheCustomImageView = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    
    //var task : URLSessionDataTask!
    
    func loadImage(from url: URL) {
        self.sd_setImage(with: url, completed: nil)
    }
}
