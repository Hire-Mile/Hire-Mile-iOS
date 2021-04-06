//
//  PushNotificationSender.swift
//  HireMile
//
//  Created by JJ Zapata on 1/3/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Foundation

class PushNotificationSender {
    func sendPushNotification(to token: String, title: String, body: String, page show: Bool, senderId uid: String, recipient ruid: String) {
        if show {
            if let key = Database.database().reference().child("Users").child(token).childByAutoId().key {
                let data : Dictionary<String, Any> = [
                    "timestamp" : Int(Date().timeIntervalSince1970),
                    "title" : title,
                    "description" : body,
                    "author" : uid,
                    "postId" : "\(key)",
                ]
                let postFeed = ["\(key)" : data]
                Database.database().reference().child("Users").child(ruid).child("Notifcations").updateChildValues(postFeed) { (inboxError, ref) in
                    if let inboxError = inboxError {
                        print("There was an error uploading the set JSON to the users notifcation inbox via Firebase: \(inboxError.localizedDescription)")
                    } else {
                        self.pushNotification(to: token, title: title, body: body)
                    }
                }
            }
        } else {
            self.pushNotification(to: token, title: title, body: body)
        }
    }
    
    func pushNotification(to token: String, title: String, body: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "priority" : "high",
                                           "notification" : ["title" : title, "body" : body, "badge" : 1, "sound" : "default", "identifier" : "chatMessage"],
                                           "data" : ["user" : "test_id",
                                           ]
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAwVsWFCs:APA91bEG3TaaNZ3NE755Aus-4zIYtK-9nYuasGlhH9dTIYYqZwQ40BWlcqBdZonDAqxPydwVxybhePnnDh5pN2oeQrjKD5LIGfG24nAa-ws9_i-hIVL8FdBXaooSTOG8mvNZEPZ44h5s", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
