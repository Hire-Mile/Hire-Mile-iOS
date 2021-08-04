//
//  JobStatus.swift
//  HireMile
//
//  Created by jaydeep vadalia on 25/07/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import Foundation


enum JobStatus: Int {
    case Hired = 0
    case Accepted = 1
    case Declined = 2
    case AwaitingPayment = 3
    case CancelledPayment = 4
    case DeclinePayment = 5
    case Completed = 6
}
