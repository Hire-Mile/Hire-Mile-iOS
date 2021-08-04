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
    let runningTime: String
    let scheduleTime: String
    let scheduleDate: String
    let authorId: String
    var isServiceProvider = false
    var price = 0
    
    init(json: JSON) {
        self.bookUid = json["bookUid"].stringValue
        self.jobStatus = JobStatus(rawValue: json["job-status"].intValue)!
        self.jobId = json["jobId"].stringValue
        self.runningTime = json["running-time"].stringValue
        self.scheduleTime = json["scheduleTime"].stringValue
        self.scheduleDate = json["scheduleDate"].stringValue
        self.authorId = json["authorId"].stringValue
    }
}
