//
//  UIView.swift
//  HireMile
//
//  Created by jaydeep vadalia on 04/06/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable extension UIView {
    @IBInspectable
        open var cornerRadius: CGFloat {
            get {
                return layer.cornerRadius
            }
            set(value) {
                layer.cornerRadius = value
            }
        }
    
    @IBInspectable var shadowColor: UIColor?{
        set {
            guard let uiColor = newValue else { return }
            layer.shadowColor = uiColor.cgColor
        }
        get{
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
    }

    @IBInspectable var shadowOpacity: Float{
        set {
            layer.shadowOpacity = newValue
        }
        get{
            return layer.shadowOpacity
        }
    }

    @IBInspectable var shadowOffset: CGSize{
        set {
            layer.shadowOffset = newValue
        }
        get{
            return layer.shadowOffset
        }
    }

    @IBInspectable var shadowRadius: CGFloat{
        set {
            layer.shadowRadius = newValue
        }
        get{
            return layer.shadowRadius
        }
    }
    
    @IBInspectable
        open var borderWidthNew: CGFloat {
            get {
                return layer.borderWidth
            }
            set(value) {
                layer.borderWidth = value
            }
        }
        
        /// A property that accesses the layer.borderColor property.
        @IBInspectable
        open var borderColor: UIColor? {
            get {
                guard let bcolor = layer.borderColor else {
                    return nil
                }
                return UIColor(cgColor: bcolor)
            }
            set(value) {
                layer.borderColor = value?.cgColor
            }
        }
}
