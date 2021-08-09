//
//  Message.swift
//  HireMile
//
//  Created by JJ Zapata on 12/27/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class Message: NSObject {
    var key: String?
    var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?
    var imageUrl: String?
    
    var imageWidth: NSNumber?
    var imageHeight: NSNumber?
    
    var firstTime: Bool?
    var serviceProvider : String?
    var postId : String?
    
    var jobRefId : String?
    
    var hasViewed : Bool?
    
    var textId : String?
    
    var isLocation : Bool?
    var long : Double?
    var lat : Double?
    var jobStatus = JobStatus(rawValue: 0)
    var ongoingjobkey: String?
    
    init(dictionary: [String: Any]) {
        self.fromId = dictionary["fromId"] as? String
        self.text = dictionary["text"] as? String
        self.toId = dictionary["toId"] as? String
        self.timestamp = dictionary["timestamp"] as? NSNumber
        self.imageUrl = dictionary["imageUrl"] as? String
        
        self.imageWidth = dictionary["imageWidth"] as? NSNumber
        self.imageHeight = dictionary["imageHeight"] as? NSNumber
        
        self.firstTime = dictionary["first-time"] as? Bool ?? false
        self.serviceProvider = dictionary["service-provider"] as? String
        self.postId = dictionary["job-id"] as? String
        
        self.jobRefId = dictionary["job-ref-id"] as? String
        
        self.hasViewed = dictionary["hasViewed"] as? Bool ?? true
        
        self.textId = dictionary["text-id"] as? String ?? "Error"
        
        self.isLocation = dictionary["isLocation"] as? Bool ?? false
        self.long = dictionary["long-cord"] as? Double
        self.lat = dictionary["lat-cord"] as? Double
        if let jobstatus = dictionary["job-status"] as? Int {
            self.jobStatus = JobStatus(rawValue: jobstatus)
        }
        self.ongoingjobkey = dictionary["ongoingjobkey"] as? String ?? ""
    }
    
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }

}
