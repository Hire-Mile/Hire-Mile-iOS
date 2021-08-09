//
//  OngoingJob.swift
//  HireMile
//
//  Created by jaydeep vadalia on 25/07/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import Foundation


import SwiftyJSON

struct OngoingJobs {
    var key: String = ""
    let bookUid: String
    let jobStatus: JobStatus
    let jobId: String
    let runningTime: Int
    let completeTime: Int
    let cancelTime: Int
    let scheduleTime: String
    let scheduleDate: String
    let authorId: String
    var isServiceProvider = false
    var price = 0
    let rating: JSON
    let time: Int
    
    init(json: JSON) {
        debugPrint(json)
        self.bookUid = json["bookUid"].stringValue
        self.jobStatus = JobStatus(rawValue: json["job-status"].intValue)!
        self.jobId = json["jobId"].stringValue
        self.runningTime = json["running-time"].intValue
        self.completeTime = json["complete-time"].intValue
        self.cancelTime = json["cancel-time"].intValue
        self.scheduleTime = json["scheduleTime"].stringValue
        self.scheduleDate = json["scheduleDate"].stringValue
        self.authorId = json["authorId"].stringValue
        self.rating = json["rating"]
        self.time = json["time"].intValue
    }
}
