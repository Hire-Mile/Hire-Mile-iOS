//
//  NSObject.swift
//  HireMile
//
//  Created by jaydeep vadalia on 04/06/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import Foundation
extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
