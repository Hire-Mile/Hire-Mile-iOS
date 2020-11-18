//
//  FilterLauncher.swift
//  HireMile
//
//  Created by JJ Zapata on 11/18/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import Foundation
import UIKit

class FilterLauncher: NSObject {
    
    let height : CGFloat = 500
    
    let blackView = UIView()
    
    let filterView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mainBlue
        return view
    }()
    
    override init() {
        super.init()
        // start working here :) 
    }
    
    func showFilter() {
        if let window = UIApplication.shared.keyWindow {
            blackView.frame = window.frame
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.alpha = 0
            window.addSubview(blackView)
            window.addSubview(filterView)
            let y = window.frame.height - height
            filterView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 500)
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.blackView.alpha = 1
                self.filterView.frame = CGRect(x: 0, y: y, width: self.filterView.frame.width, height: self.filterView.frame.height)
            }) { (completion) in
                print("showing view")
            }
        }
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.filterView.frame = CGRect(x: 0, y: window.frame.height, width: self.filterView.frame.width, height: self.filterView.frame.height)
            }
        }
    }
    
}
