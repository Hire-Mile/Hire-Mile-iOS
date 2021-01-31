//
//  CustomImageView.swift
//  HireMile
//
//  Created by JJ Zapata on 1/28/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit

let imageCacheCustomImageView = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    
    var task : URLSessionDataTask!
    
    func loadImage(from url: URL) {
        image = nil
        if let task = task {
            task.cancel()
        }
        if let imageFromCache = imageCacheCustomImageView.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, let newImage = UIImage(data: data) else {
                return
            }
            imageCacheCustomImageView.setObject(newImage, forKey: url.absoluteString as AnyObject)
            DispatchQueue.main.async {
                self.image = newImage
            }
        }
        task.resume()
    }
}
