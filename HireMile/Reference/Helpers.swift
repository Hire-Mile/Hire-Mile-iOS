//
//  Helpers.swift
//  HireMile
//
//  Created by JJ Zapata on 11/16/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

extension UIColor {
    static var mainBlue = UIColor(red: 53/255, green: 167/255, blue: 245/255, alpha: 1)
    static var unselectedColor : UIColor = UIColor(red: 171/255, green: 169/255, blue: 169/255, alpha: 1)
    static var selectedColor : UIColor = UIColor(red: 118/255, green: 118/255, blue: 118/255, alpha: 1)
    static var boldSelectedColor : UIColor = UIColor(red: 93/255, green: 93/255, blue: 93/255, alpha: 1)
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        let ctx = UIGraphicsGetCurrentContext()
        self.setFill()
        ctx!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, paddingTop: CGFloat, bottom: NSLayoutYAxisAnchor?, paddingBottom: CGFloat, left: NSLayoutXAxisAnchor?, paddingLeft: CGFloat, right: NSLayoutXAxisAnchor?, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: paddingRight).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    func edgeTo(_ view: UIView) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    func pinTo(_ view: UIView, with constant: CGFloat) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constant).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension UITextField {
    func setInputViewDatePicker(target: Any, selector: Selector) {
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .date
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
        }
        self.inputView = datePicker
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
}

extension UIButton {
    func setAtributedTextWithImagePrefix(image: UIImage, text: String, for state: UIControl.State) {
        let fullString = NSMutableAttributedString()
        let imageString = getImageAttributedString(image: image)
        fullString.append(imageString)
        fullString.append(NSAttributedString(string: "  " + text))
        self.attributedTitle(for: state)
    }
    func getImageAttributedString(image: UIImage) -> NSAttributedString {
        let buttonHeight = self.frame.height
        let resizedImage = image.getResizedWithAspect(maxHeight: buttonHeight - 10)
        let imageAttachment = NSTextAttachment()
        imageAttachment.bounds = CGRect(x: 0, y: ((self.titleLabel?.font.capHeight)! - resizedImage!.size.height).rounded() / 2, width: resizedImage!.size.width, height: resizedImage!.size.height)
        imageAttachment.image = resizedImage
        let image1String = NSAttributedString(attachment: imageAttachment)
        return image1String
        
    }
}

extension UIImage {
    func getResized(size: CGSize) -> UIImage? {
        if UIScreen.main.responds(to: #selector(NSDecimalNumberBehaviors.scale)) {
            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        } else {
            UIGraphicsBeginImageContext(size)
        }
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    func getResizedWithAspect(scaleToMaxWidth width: CGFloat? = nil, maxHeight height: CGFloat? = nil) -> UIImage? {
        let oldWidth = self.size.width
        let oldHeight = self.size.height
        var scaleToWidth = oldWidth
        if let width = width {
            scaleToWidth = width
        }
        var scaleToHeight = oldHeight
        if let height = height {
            scaleToHeight = height
        }
        let scaleFactor = (oldWidth > oldHeight) ? scaleToWidth / oldWidth : scaleToHeight / oldHeight
        let newHeight = oldHeight * scaleFactor
        let newWidth = oldWidth * scaleFactor
        let newSize = CGSize(width: newWidth, height: newHeight)
        return getResized(size: newSize)
    }
}

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    func loadImageUsingCacheWithUrlString(_ urlString: String) {
        self.sd_setImage(with: URL(string: urlString), completed: nil)
    }
    
    func downsample(imageAt imageURL: URL,
                    to pointSize: CGSize,
                    scale: CGFloat = UIScreen.main.scale) -> UIImage? {

        // Create an CGImageSource that represent an image
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions) else {
            return nil
        }
        
        // Calculate the desired dimension
        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
        
        // Perform downsampling
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
        ] as CFDictionary
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
            return nil
        }
        
        // Return the downsampled image as UIImage
        return UIImage(cgImage: downsampledImage)
    }
}

enum VerticalLocation: String {
    case bottom
    case top
}

extension UIView {
    func addShadow(location: VerticalLocation, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        switch location {
        case .bottom:
             addShadow(offset: CGSize(width: 0, height: 10), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -10), color: color, opacity: opacity, radius: radius)
        }
    }
    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
}

extension UIView {
func addBottomShadow() {
    layer.masksToBounds = false
    layer.shadowRadius = 120
    layer.shadowOpacity = 0.5
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = CGSize(width: 0 , height: 0)
//    layer.shadowPath = UIBezierPath(rect: CGRect(x: 0,
//                                                 y: bounds.maxY - layer.shadowRadius,
//                                                 width: bounds.width,
//                                                 height: layer.shadowRadius)).cgPath
}
}

// Example use: myView.addBorder(toSide: .Left, withColor: UIColor.redColor().CGColor, andThickness: 1.0)

extension UIView {
    
    enum ViewSide {
        case Left, Right, Top, Bottom
    }

    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        switch side {
        case .Left: border.frame = CGRect(x: 0.0, y: 0.0, width: thickness, height: frame.height); break
            case .Right: border.frame = CGRect(x: frame.width-thickness, y: 0.0, width: thickness, height: frame.height); break
            case .Top: border.frame = CGRect(x: 0.0, y: 0.0, width: frame.width, height: thickness); break
            case .Bottom: border.frame = CGRect(x: 0.0, y: frame.height-thickness, width: frame.width, height: thickness); break
        }
        
        layer.addSublayer(border)
    }
    
}
extension UIDevice {
    var iPhoneX: Bool { UIScreen.main.nativeBounds.height == 2436 }
    var iPhone: Bool { UIDevice.current.userInterfaceIdiom == .phone }
    var iPad: Bool { UIDevice().userInterfaceIdiom == .pad }
    enum ScreenType: String {
        case iPhones_4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhones_X_XS = "iPhone X or iPhone XS"
        case iPhone_XR_11 = "iPhone XR or iPhone 11"
        case iPhone_XSMax_ProMax = "iPhone XS Max or iPhone Pro Max"
        case iPhone_11Pro = "iPhone 11 Pro"
        case unknown
    }
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1792:
            return .iPhone_XR_11
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2426:
            return .iPhone_11Pro
        case 2436:
            return .iPhones_X_XS
        case 2688:
            return .iPhone_XSMax_ProMax
        default:
            return .unknown
        }
    }

}
extension UISegmentedControl{
    func removeBorder(){
        let backgroundImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor, andSize: self.bounds.size)
        self.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)

        let deviderImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor, andSize: CGSize(width: 1.0, height: self.bounds.size.height))
        self.setDividerImage(deviderImage, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 67/255, green: 129/255, blue: 244/255, alpha: 1.0)], for: .selected)
    }

    func addUnderlineForSelectedSegment(){
        removeBorder()
        let underlineWidth: CGFloat = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let underlineHeight: CGFloat = 2.0
        let underlineXPosition = CGFloat(selectedSegmentIndex * Int(underlineWidth))
        let underLineYPosition = self.bounds.size.height - 1.0
        let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
        let underline = UIView(frame: underlineFrame)
        underline.backgroundColor = UIColor(red: 67/255, green: 129/255, blue: 244/255, alpha: 1.0)
        underline.tag = 1
        self.addSubview(underline)
    }

    func changeUnderlinePosition(){
        guard let underline = self.viewWithTag(1) else {return}
        let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
        UIView.animate(withDuration: 0.1, animations: {
            underline.frame.origin.x = underlineFinalXPosition
        })
    }
}

extension UIImage{

    class func getColoredRectImageWith(color: CGColor, andSize size: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let graphicsContext = UIGraphicsGetCurrentContext()
        graphicsContext?.setFillColor(color)
        let rectangle = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        graphicsContext?.fill(rectangle)
        let rectangleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rectangleImage!
    }
}
extension UITextField {
    
    func setInputViewDatePickerForSignUp(target: Any, selector: Selector) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        datePicker.datePickerMode = .date //2
        // iOS 14 and above
        if #available(iOS 14, *) {// Added condition for iOS 14
          datePicker.preferredDatePickerStyle = .wheels
          datePicker.sizeToFit()
        }
        self.inputView = datePicker //3
        
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar //9
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
    func setImage(image: UIImage) {
        let imageMobile = UIImageView(frame: CGRect(x: 1.0, y: 5.0, width: 20.0, height: 20.0))
        imageMobile.image = image
        imageMobile.tintColor = UIColor(red: 162/255, green: 162/255, blue: 162/255, alpha: 1)
        imageMobile.contentMode = UIView.ContentMode.scaleAspectFill
        let imageContainerView = UIView(frame: CGRect(x: 20.0, y: 0.0, width: 30.0, height: 30.0))
        imageContainerView.addSubview(imageMobile)
        leftView = imageContainerView
        leftViewMode = .always
    }
    
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

extension UILabel {
    func addKern(_ kernValue: CGFloat) {
        guard let attributedText = attributedText,
            attributedText.string.count > 0,
            let fullRange = attributedText.string.range(of: attributedText.string) else {
                return
        }
        let updatedText = NSMutableAttributedString(attributedString: attributedText)
        updatedText.addAttributes([
            .kern: kernValue
            ], range: NSRange(fullRange, in: attributedText.string))
        self.attributedText = updatedText
    }
}

class MainButton : UIButton {

    init(title buttonTitle: String) {
        super.init(frame: .zero)
        
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel?.textColor = UIColor.white
        
        layer.cornerRadius = 14
        
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = UIColor.mainBlue
        
        setTitleColor(UIColor.lightGray, for: UIControl.State.highlighted)
        setTitle(buttonTitle, for: UIControl.State.normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("error fatal")
    }

}

class MainSecondaryButton : UIButton {

    init(title buttonTitle: String) {
        super.init(frame: .zero)
        
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel?.textColor = UIColor.mainBlue
        
        layer.cornerRadius = 14
        
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = UIColor.white

        layer.borderColor = UIColor.mainBlue.cgColor
        layer.borderWidth = 2
        
        setTitleColor(UIColor.lightGray, for: UIControl.State.highlighted)
        setTitleColor(UIColor.mainBlue, for: UIControl.State.normal)
        setTitle(buttonTitle, for: UIControl.State.normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("error fatal")
    }

}

class MainTextField : UITextField {

    let insets : UIEdgeInsets

    init(insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12), placeholderString: String) {
        self.insets = insets
        super.init(frame: .zero)

        let placeholderStringAttr = NSAttributedString(string: placeholderString, attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 179/255, green: 185/255, blue: 196/255, alpha: 1), NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)])
        attributedPlaceholder = placeholderStringAttr

        tintColor = UIColor.mainBlue
        
        font = UIFont.systemFont(ofSize: 16)
        
        translatesAutoresizingMaskIntoConstraints = false

        layer.cornerRadius = 14
        layer.borderWidth = 2
        layer.borderColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1).cgColor
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not yet been implemented")
    }

}

public extension Date {
    
    // MARK: - Convert from String
    
    /*
        Creates a new Date based on a string of a specified format. Supports optional timezone and locale.
    */
    init?(fromString string: String, format:DateFormatType, timeZone: TimeZoneType = .local, locale: Locale = Foundation.Locale.current, isLenient: Bool = true) {
        guard !string.isEmpty else {
            return nil
        }
        var string = string
        switch format {
            case .dotNet:
                let pattern = "\\\\?/Date\\((\\d+)(([+-]\\d{2})(\\d{2}))?\\)\\\\?/"
                let regex = try! NSRegularExpression(pattern: pattern)
                guard let match = regex.firstMatch(in: string, range: NSRange(location: 0, length: string.utf16.count)) else {
                    return nil
                }
                 #if swift(>=4.0)
                let dateString = (string as NSString).substring(with: match.range(at: 1))
                #else
                let dateString = (string as NSString).substring(with: match.rangeAt(1))
                #endif
                let interval = Double(dateString)! / 1000.0
                self.init(timeIntervalSince1970: interval)
                return
            case .rss, .altRSS:
                if string.hasSuffix("Z") {
                    string = string[..<string.index(string.endIndex, offsetBy: -1)].appending("GMT")
                }
            case .isoDateTimeMilliSec, .isoDateTimeSec, .isoDateTime, .isoYear,. isoDate, .isoYearMonth:
                if #available(iOS 10.0, watchOS 4, tvOS 10, macOS 11, *) {
                    let formatter = Date.cachedDateFormatters.cachedISOFormatter(format, timeZone: timeZone, locale: locale)
                    guard let date = formatter.date(from: string) else {
                        return nil
                    }
                    self.init(timeInterval: 0, since: date)
                    return
                }
            default:
                break
        }
        let formatter = Date.cachedDateFormatters.cachedFormatter(
            format.stringFormat,
            timeZone: timeZone.timeZone,
            locale: locale,
            isLenient: isLenient)
        guard let date = formatter.date(from: string) else {
            return nil
        }
        self.init(timeInterval: 0, since: date)
    }
    
    /*
        Creates a new Date based on the first date detected on a string using data dectors.
    */
    init?(detectFromString string: String) {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue)
        let matches = detector?.matches(in: string, options: [], range: NSMakeRange(0, string.utf16.count))
        if let date = matches?.first?.date {
            self.init()
            self = date
        } else {
            return nil
        }
    }
    
    // MARK: - Convert to String
    
    /// Converts the date to string using the short date and time style.
    func toString(style:DateStyleType = .short) -> String {
        switch style {
        case .short:
            return self.toString(dateStyle: .short, timeStyle: .short, isRelative: false)
        case .medium:
            return self.toString(dateStyle: .medium, timeStyle: .medium, isRelative: false)
        case .long:
            return self.toString(dateStyle: .long, timeStyle: .long, isRelative: false)
        case .full:
            return self.toString(dateStyle: .full, timeStyle: .full, isRelative: false)
        case .ordinalDay:
            let formatter = Date.cachedDateFormatters.cachedNumberFormatter()
            if #available(iOSApplicationExtension 9.0, *) {
                formatter.numberStyle = .ordinal
            }
            return formatter.string(from: component(.day)! as NSNumber)!
        case .weekday:
            let weekdaySymbols = Date.cachedDateFormatters.cachedFormatter().weekdaySymbols!
            let string = weekdaySymbols[component(.weekday)!-1] as String
            return string
        case .shortWeekday:
            let shortWeekdaySymbols = Date.cachedDateFormatters.cachedFormatter().shortWeekdaySymbols!
            return shortWeekdaySymbols[component(.weekday)!-1] as String
        case .veryShortWeekday:
            let veryShortWeekdaySymbols = Date.cachedDateFormatters.cachedFormatter().veryShortWeekdaySymbols!
            return veryShortWeekdaySymbols[component(.weekday)!-1] as String
        case .month:
            let monthSymbols = Date.cachedDateFormatters.cachedFormatter().monthSymbols!
            return monthSymbols[component(.month)!-1] as String
        case .shortMonth:
            let shortMonthSymbols = Date.cachedDateFormatters.cachedFormatter().shortMonthSymbols!
            return shortMonthSymbols[component(.month)!-1] as String
        case .veryShortMonth:
            let veryShortMonthSymbols = Date.cachedDateFormatters.cachedFormatter().veryShortMonthSymbols!
            return veryShortMonthSymbols[component(.month)!-1] as String
        }
    }
    
    /// Converts the date to string based on a date format, optional timezone and optional locale.
    func toString(format: DateFormatType, timeZone: TimeZoneType = .local, locale: Locale = Locale.current) -> String {
        var useLocale = locale
        
        switch format {
        case .dotNet:
            let offset = Foundation.NSTimeZone.default.secondsFromGMT() / 3600
            let nowMillis = 1000 * self.timeIntervalSince1970
            return String(format: format.stringFormat, nowMillis, offset)
        case .isoDateTimeMilliSec, .isoDateTimeSec, .isoDateTime,
             .isoYear,. isoDate, .isoYearMonth:
            if #available(iOS 10.0, watchOS 4, tvOS 10, macOS 11, *) {
                let formatter = Date.cachedDateFormatters.cachedISOFormatter(format, timeZone: timeZone, locale: useLocale)
                return formatter.string(from: self)
            } else {
                useLocale = Locale(identifier: "en_US_POSIX")
            }
        default:
            break
        }
        let formatter = Date.cachedDateFormatters.cachedFormatter(format.stringFormat, timeZone: timeZone.timeZone, locale: useLocale)
        return formatter.string(from: self)
    }
    
    /// Converts the date to string based on DateFormatter's date style and time style with optional relative date formatting, optional time zone and optional locale.
    func toString(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style, isRelative: Bool = false, timeZone: Foundation.TimeZone = Foundation.NSTimeZone.local, locale: Locale = Locale.current) -> String {
        let formatter = Date.cachedDateFormatters.cachedFormatter(dateStyle, timeStyle: timeStyle, doesRelativeDateFormatting: isRelative, timeZone: timeZone, locale: locale)
        return formatter.string(from: self)
    }
    
    /// Converts the date to string based on a relative time language. i.e. just now, 1 minute ago etc...
    func toStringWithRelativeTime(strings:[RelativeTimeStringType:String]? = nil) -> String {
        let time = self.timeIntervalSince1970
        let now = Date().timeIntervalSince1970
        
        let sec:Double = abs(now - time)
        let min:Double = round(sec/60)
        let hr:Double = round(min/60)
        let d:Double = round(hr/24)
        
        switch toRelativeTime() {
        case .nowPast:
            return strings?[.nowPast] ?? NSLocalizedString("just now", comment: "Date format")
        case .nowFuture:
            return strings?[.nowFuture] ?? NSLocalizedString("in a few seconds", comment: "Date format")
        case .secondsPast:
            return String(
                format: strings?[.secondsPast] ?? NSLocalizedString("%.f seconds ago", comment: "Date format"),
                sec
            )
        case .secondsFuture:
            return String(
                format: strings?[.secondsFuture] ?? NSLocalizedString("in %.f seconds", comment: "Date format"),
                sec
            )
        case .oneMinutePast:
            return strings?[.oneMinutePast] ?? NSLocalizedString("1 minute ago", comment: "Date format")
        case .oneMinuteFuture:
            return strings?[.oneMinuteFuture] ?? NSLocalizedString("in 1 minute", comment: "Date format")
        case .minutesPast:
            return String(
                format: strings?[.minutesPast] ?? NSLocalizedString("%.f minutes ago", comment: "Date format"),
                min
            )
        case .minutesFuture:
            return String(
                format: strings?[.minutesFuture] ?? NSLocalizedString("in %.f minutes", comment: "Date format"),
                min
            )
        case .oneHourPast:
            return strings?[.oneHourPast] ?? NSLocalizedString("last hour", comment: "Date format")
        case .oneHourFuture:
            return strings?[.oneHourFuture] ?? NSLocalizedString("next hour", comment: "Date format")
        case .hoursPast:
            return String(
                format: strings?[.hoursPast] ?? NSLocalizedString("%.f hours ago", comment: "Date format"),
                hr
            )
        case .hoursFuture:
            return String(
                format: strings?[.hoursFuture] ?? NSLocalizedString("in %.f hours", comment: "Date format"),
                hr
            )
        case .oneDayPast:
            return strings?[.oneDayPast] ?? NSLocalizedString("yesterday", comment: "Date format")
        case .oneDayFuture:
            return strings?[.oneDayFuture] ?? NSLocalizedString("tomorrow", comment: "Date format")
        case .daysPast:
            return String(
                format: strings?[.daysPast] ?? NSLocalizedString("%.f days ago", comment: "Date format"),
                d
            )
        case .daysFuture:
            return String(
                format: strings?[.daysFuture] ?? NSLocalizedString("in %.f days", comment: "Date format"),
                d
            )
        case .oneWeekPast:
            return strings?[.oneWeekPast] ?? NSLocalizedString("last week", comment: "Date format")
        case .oneWeekFuture:
            return strings?[.oneWeekFuture] ?? NSLocalizedString("next week", comment: "Date format")
        case .weeksPast:
            let string = strings?[.weeksPast] ?? NSLocalizedString("%.f weeks ago", comment: "Date format")
            return String(format: string, Double(abs(since(Date(), in: .week))))
        case .weeksFuture:
            let string = strings?[.weeksFuture] ?? NSLocalizedString("in %.f weeks", comment: "Date format")
            return String(format: string, Double(abs(since(Date(), in: .week))))
        case .oneMonthPast:
            return strings?[.oneMonthPast] ?? NSLocalizedString("last month", comment: "Date format")
        case .oneMonthFuture:
            return strings?[.oneMonthFuture] ?? NSLocalizedString("next month", comment: "Date format")
        case .monthsPast:
            let string = strings?[.monthsPast] ?? NSLocalizedString("%.f months ago", comment: "Date format")
            return String(format: string, Double(abs(since(Date(), in: .month))))
        case .monthsFuture:
            let string = strings?[.monthsFuture] ?? NSLocalizedString("in %.f months", comment: "Date format")
            return String(format: string, Double(abs(since(Date(), in: .month))))
        case .oneYearPast:
            return strings?[.oneYearPast] ?? NSLocalizedString("last year", comment: "Date format")
        case .oneYearFuture:
            return strings?[.oneYearFuture] ?? NSLocalizedString("next year", comment: "Date format")
        case .yearsPast:
            let string = strings?[.yearsPast] ?? NSLocalizedString("%.f years ago", comment: "Date format")
            return String(format: string, Double(abs(since(Date(), in: .year))))
        case .yearsFuture:
            let string = strings?[.yearsFuture] ?? NSLocalizedString("in %.f years", comment: "Date format")
            return String(format: string, Double(abs(since(Date(), in: .year))))
        }
    }
    
    /// Converts the date to  a relative time language. i.e. .nowPast, .minutesFuture
    func toRelativeTime() -> RelativeTimeStringType {
        let time = self.timeIntervalSince1970
        let now = Date().timeIntervalSince1970
        let isPast = now - time > 0
        
        let sec:Double = abs(now - time)
        let min:Double = round(sec/60)
        let hr:Double = round(min/60)
        let d:Double = round(hr/24)
        
        if sec < 60 {
            if sec < 10 {
                if isPast {
                    return .nowPast
                } else {
                    return .nowFuture
                }
            } else {
                if isPast {
                    return .secondsPast
                } else {
                    return .secondsFuture
                }
            }
        }
        if min < 60 {
            if min == 1 {
                if isPast {
                    return .oneMinutePast
                } else {
                    return .oneMinuteFuture
                }
            } else {
                if isPast {
                    return .minutesPast
                } else {
                    return .minutesFuture
                }
            }
        }
        if hr < 24 {
            if hr == 1 {
                if isPast {
                    return .oneHourPast
                } else {
                    return .oneHourFuture
                }
            } else {
                if isPast {
                    return .hoursPast
                } else {
                    return .hoursFuture
                }
            }
        }
        if d < 7 {
            if d == 1 {
                if isPast {
                    return .oneDayPast
                } else {
                    return .oneDayFuture
                }
            } else {
                if isPast {
                    return .daysPast
                } else {
                    return .daysFuture
                }
            }
        }
        if d < 28 {
            if isPast {
                if compare(.isLastWeek) {
                    return .oneWeekPast
                } else {
                    return .weeksPast
                }
            } else {
                if compare(.isNextWeek) {
                    return .oneWeekFuture
                } else {
                    return .weeksFuture
                }
            }
        }
        if compare(.isThisYear) {
            if isPast {
                if compare(.isLastMonth) {
                    return .oneMonthPast
                } else {
                    return .monthsPast
                }
            } else {
                if compare(.isNextMonth) {
                    return .oneMonthFuture
                } else {
                    return .monthsFuture
                }
            }
        }
        if isPast {
            if compare(.isLastYear) {
                return .oneYearPast
            } else {
                return .yearsPast
            }
        } else {
            if compare(.isNextYear) {
                return .oneYearFuture
            } else {
                return .yearsFuture
            }
        }
    }
    
    
    // MARK: - Compare Dates
    
    /// Compares dates to see if they are equal while ignoring time.
    func compare(_ comparison:DateComparisonType) -> Bool {
        switch comparison {
            case .isToday:
                return compare(.isSameDay(as: Date()))
            case .isTomorrow:
                let comparison = Date().adjust(.day, offset:1)
                return compare(.isSameDay(as: comparison))
            case .isYesterday:
                let comparison = Date().adjust(.day, offset: -1)
                return compare(.isSameDay(as: comparison))
            case .isSameDay(let date):
                return component(.year) == date.component(.year)
                    && component(.month) == date.component(.month)
                    && component(.day) == date.component(.day)
            case .isThisWeek:
                return self.compare(.isSameWeek(as: Date()))
            case .isNextWeek:
                let comparison = Date().adjust(.week, offset:1)
                return compare(.isSameWeek(as: comparison))
            case .isLastWeek:
                let comparison = Date().adjust(.week, offset:-1)
                return compare(.isSameWeek(as: comparison))
            case .isSameWeek(let date):
                if component(.week) != date.component(.week) {
                    return false
                }
                // Ensure time interval is under 1 week
                return abs(self.timeIntervalSince(date)) < Date.weekInSeconds
            case .isThisMonth:
                return self.compare(.isSameMonth(as: Date()))
            case .isNextMonth:
                let comparison = Date().adjust(.month, offset:1)
                return compare(.isSameMonth(as: comparison))
            case .isLastMonth:
                let comparison = Date().adjust(.month, offset:-1)
                return compare(.isSameMonth(as: comparison))
            case .isSameMonth(let date):
                return component(.year) == date.component(.year) && component(.month) == date.component(.month)
            case .isThisYear:
                return self.compare(.isSameYear(as: Date()))
            case .isNextYear:
                let comparison = Date().adjust(.year, offset:1)
                return compare(.isSameYear(as: comparison))
            case .isLastYear:
                let comparison = Date().adjust(.year, offset:-1)
                return compare(.isSameYear(as: comparison))
            case .isSameYear(let date):
                return component(.year) == date.component(.year)
            case .isInTheFuture:
                return self.compare(.isLater(than: Date()))
            case .isInThePast:
                return self.compare(.isEarlier(than: Date()))
            case .isEarlier(let date):
                return (self as NSDate).earlierDate(date) == self
            case .isLater(let date):
                return (self as NSDate).laterDate(date) == self
        case .isWeekday:
            return !compare(.isWeekend)
        case .isWeekend:
            let range = Calendar.current.maximumRange(of: Calendar.Component.weekday)!
            return (component(.weekday) == range.lowerBound || component(.weekday) == range.upperBound - range.lowerBound)
        }
        
    }
 
    
    // MARK: - Adjust dates
    
    /// Creates a new date with adjusted components
    
    func adjust(_ component:DateComponentType, offset:Int) -> Date {
        var dateComp = DateComponents()
        switch component {
            case .second:
                dateComp.second = offset
            case .minute:
                dateComp.minute = offset
            case .hour:
                dateComp.hour = offset
            case .day:
                dateComp.day = offset
            case .weekday:
                dateComp.weekday = offset
            case .nthWeekday:
                dateComp.weekdayOrdinal = offset
            case .week:
                dateComp.weekOfYear = offset
            case .month:
                dateComp.month = offset
            case .year:
                dateComp.year = offset
        }
        return Calendar.current.date(byAdding: dateComp, to: self)!
    }
    
    /// Return a new Date object with the new hour, minute and seconds values.
    func adjust(hour: Int?, minute: Int?, second: Int?, day: Int? = nil, month: Int? = nil) -> Date {
        var comp = Date.components(self)
        comp.month = month ?? comp.month
        comp.day = day ?? comp.day
        comp.hour = hour ?? comp.hour
        comp.minute = minute ?? comp.minute
        comp.second = second ?? comp.second
        return Calendar.current.date(from: comp)!
    }
    
    // MARK: - Date for...
    
    func dateFor(_ type:DateForType, calendar:Calendar = Calendar.current) -> Date {
        switch type {
        case .startOfDay:
            return adjust(hour: 0, minute: 0, second: 0)
        case .endOfDay:
            return adjust(hour: 23, minute: 59, second: 59)
        case .startOfWeek:
            return calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        case .endOfWeek:
            let weekStart = self.dateFor(.startOfWeek, calendar: calendar)
            return weekStart.adjust(.day, offset: 6)
        case .startOfMonth:
            return adjust(hour: 0, minute: 0, second: 0, day: 1)
        case .endOfMonth:
            let month = (component(.month) ?? 0) + 1
            return adjust(hour: 0, minute: 0, second: 0, day: 0, month: month)
        case .tomorrow:
            return adjust(.day, offset:1)
        case .yesterday:
            return adjust(.day, offset:-1)
        case .nearestMinute(let nearest):
            let minutes = (component(.minute)! + nearest/2) / nearest * nearest
            return adjust(hour: nil, minute: minutes, second: nil)
        case .nearestHour(let nearest):
            let hours = (component(.hour)! + nearest/2) / nearest * nearest
            return adjust(hour: hours, minute: 0, second: nil)
        case .startOfYear:
            let month = Date().component(.month)!-1
            let day = Date().component(.day)!-1
            return Date()
                .adjust(.month, offset: -(month))
                .adjust(.day, offset: -(day))
                .adjust(hour: 0, minute: 0, second: 0)
        case .endOfYear:
            let month = Date().component(.month)!
            let day = Date().component(.day)!
            return Date()
                .adjust(.month, offset: 12-month)
                .adjust(.day, offset: 31-day)
                .adjust(hour: 23, minute: 59, second: 59)
        }
    }
    
    // MARK: - Time since...
    
    func since(_ date:Date, in component:DateComponentType) -> Int64 {
        switch component {
        case .second:
            return Int64(timeIntervalSince(date))
        case .minute:
            let interval = timeIntervalSince(date)
            return Int64(interval / Date.minuteInSeconds)
        case .hour:
            let interval = timeIntervalSince(date)
            return Int64(interval / Date.hourInSeconds)
        case .day:
            let calendar = Calendar.current
            let end = calendar.ordinality(of: .day, in: .era, for: self)
            let start = calendar.ordinality(of: .day, in: .era, for: date)
            return Int64(end! - start!)
        case .weekday:
            let calendar = Calendar.current
            let end = calendar.ordinality(of: .weekday, in: .era, for: self)
            let start = calendar.ordinality(of: .weekday, in: .era, for: date)
            return Int64(end! - start!)
        case .nthWeekday:
            let calendar = Calendar.current
            let end = calendar.ordinality(of: .weekdayOrdinal, in: .era, for: self)
            let start = calendar.ordinality(of: .weekdayOrdinal, in: .era, for: date)
            return Int64(end! - start!)
        case .week:
            let calendar = Calendar.current
            let end = calendar.ordinality(of: .weekOfYear, in: .era, for: self)
            let start = calendar.ordinality(of: .weekOfYear, in: .era, for: date)
            return Int64(end! - start!)
        case .month:
            let calendar = Calendar.current
            let end = calendar.ordinality(of: .month, in: .era, for: self)
            let start = calendar.ordinality(of: .month, in: .era, for: date)
            return Int64(end! - start!)
        case .year:
            let calendar = Calendar.current
            let end = calendar.ordinality(of: .year, in: .era, for: self)
            let start = calendar.ordinality(of: .year, in: .era, for: date)
            return Int64(end! - start!)
            
        }
    }
    
    
    // MARK: - Extracting components
    
    func component(_ component:DateComponentType) -> Int? {
        let components = Date.components(self)
        switch component {
        case .second:
            return components.second
        case .minute:
            return components.minute
        case .hour:
            return components.hour
        case .day:
            return components.day
        case .weekday:
            return components.weekday
        case .nthWeekday:
            return components.weekdayOrdinal
        case .week:
            return components.weekOfYear
        case .month:
            return components.month
        case .year:
            return components.year
        }
    }
    
    func numberOfDaysInMonth() -> Int {
        let range = Calendar.current.range(of: Calendar.Component.day, in: Calendar.Component.month, for: self)!
        return range.upperBound - range.lowerBound
    }
    
    func firstDayOfWeek() -> Int {
        let distanceToStartOfWeek = Date.dayInSeconds * Double(self.component(.weekday)! - 1)
        let interval: TimeInterval = self.timeIntervalSinceReferenceDate - distanceToStartOfWeek
        return Date(timeIntervalSinceReferenceDate: interval).component(.day)!
    }
    
    func lastDayOfWeek() -> Int {
        let distanceToStartOfWeek = Date.dayInSeconds * Double(self.component(.weekday)! - 1)
        let distanceToEndOfWeek = Date.dayInSeconds * Double(7)
        let interval: TimeInterval = self.timeIntervalSinceReferenceDate - distanceToStartOfWeek + distanceToEndOfWeek
        return Date(timeIntervalSinceReferenceDate: interval).component(.day)!
    }
    
    
    // MARK: - Internal Components
    
    internal static func componentFlags() -> Set<Calendar.Component> { return [Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.weekOfYear, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second, Calendar.Component.weekday, Calendar.Component.weekdayOrdinal, Calendar.Component.weekOfYear] }
    internal static func components(_ fromDate: Date) -> DateComponents {
        return Calendar.current.dateComponents(Date.componentFlags(), from: fromDate)
    }
  
    internal class ConcurrentFormatterCache {
        
        private static let cachedISODateFormattersQueue = DispatchQueue(
            label: "iso-date-formatter-queue",
            attributes: .concurrent
        )
        private static let cachedDateFormattersQueue = DispatchQueue(
            label: "date-formatter-queue",
            attributes: .concurrent
        )
        
        private static let cachedNumberFormatterQueue = DispatchQueue(
            label: "number-formatter-queue",
            attributes: .concurrent
        )
        
        private static var cachedISODateFormatters = [String: ISO8601DateFormatter]()
        private static var cachedDateFormatters = [String: DateFormatter]()
        private static var cachedNumberFormatter = NumberFormatter()
        
        private func register(hashKey: String, formatter: ISO8601DateFormatter) -> Void {
            ConcurrentFormatterCache.cachedISODateFormattersQueue.async(flags: .barrier) {
                ConcurrentFormatterCache.cachedISODateFormatters.updateValue(formatter, forKey: hashKey)
            }
        }

        private func register(hashKey: String, formatter: DateFormatter) -> Void {
            ConcurrentFormatterCache.cachedDateFormattersQueue.async(flags: .barrier) {
                ConcurrentFormatterCache.cachedDateFormatters.updateValue(formatter, forKey: hashKey)
            }
        }
        
        private func retrieve(hashKeyForISO hashKey: String) -> ISO8601DateFormatter? {
            let dateFormatter = ConcurrentFormatterCache.cachedISODateFormattersQueue.sync { () -> ISO8601DateFormatter? in
                guard let result = ConcurrentFormatterCache.cachedISODateFormatters[hashKey] else { return nil }
                
                return result.copy() as? ISO8601DateFormatter
            }
            return dateFormatter
        }

        private func retrieve(hashKey: String) -> DateFormatter? {
            let dateFormatter = ConcurrentFormatterCache.cachedDateFormattersQueue.sync { () -> DateFormatter? in
                guard let result = ConcurrentFormatterCache.cachedDateFormatters[hashKey] else { return nil }
                
                return result.copy() as? DateFormatter
            }
            return dateFormatter
        }
        
        private func retrieve() -> NumberFormatter {
            let numberFormatter = ConcurrentFormatterCache.cachedNumberFormatterQueue.sync { () -> NumberFormatter in
                // Should always be NumberFormatter
                return ConcurrentFormatterCache.cachedNumberFormatter.copy() as! NumberFormatter
            }
            return numberFormatter
        }
        
        public func cachedISOFormatter(_ format: DateFormatType, timeZone: TimeZoneType, locale: Locale) -> ISO8601DateFormatter {
            
            let hashKey = "\(format.stringFormat.hashValue)\(timeZone.timeZone.hashValue)\(locale.hashValue)"
                
            if Date.cachedDateFormatters.retrieve(hashKeyForISO: hashKey) == nil {
                let formatter = ISO8601DateFormatter()
                formatter.timeZone = timeZone.timeZone

                var options: ISO8601DateFormatter.Options = []
                switch format {
                case .isoDate:
                    options = [.withFullDate]
                case .isoYearMonth:
                    options = [.withYear, .withMonth]
                case .isoYear:
                    options = [.withYear, .withFractionalSeconds]
                case .isoDateTimeSec, .isoDateTime:
                    options = [.withInternetDateTime]
                case .isoDateTimeMilliSec:
                    options = [.withInternetDateTime, .withFractionalSeconds]
                default:
                    fatalError("Unimplemented format \(format)")
                }
                formatter.formatOptions = options
                Date.cachedDateFormatters.register(hashKey: hashKey, formatter: formatter)
            }
            return Date.cachedDateFormatters.retrieve(hashKeyForISO: hashKey)!
        }
        
        public func cachedFormatter(_ format: String = DateFormatType.standard.stringFormat,
                                    timeZone: Foundation.TimeZone = Foundation.TimeZone.current,
                                    locale: Locale = Locale.current, isLenient: Bool = true) -> DateFormatter {
            
                let hashKey = "\(format.hashValue)\(timeZone.hashValue)\(locale.hashValue)"
                
                if Date.cachedDateFormatters.retrieve(hashKey: hashKey) == nil {
                    let formatter = DateFormatter()
                    formatter.dateFormat = format
                    formatter.timeZone = timeZone
                    formatter.locale = locale
                    formatter.isLenient = isLenient
                    Date.cachedDateFormatters.register(hashKey: hashKey, formatter: formatter)
                }
            
                return Date.cachedDateFormatters.retrieve(hashKey: hashKey)!
        }
        
        /// Generates a cached formatter based on the provided date style, time style and relative date.
        /// Formatters are cached in a singleton array using hashkeys.
        public func cachedFormatter(_ dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style, doesRelativeDateFormatting: Bool, timeZone: Foundation.TimeZone = Foundation.NSTimeZone.local, locale: Locale = Locale.current, isLenient: Bool = true) -> DateFormatter {
            let hashKey = "\(dateStyle.hashValue)\(timeStyle.hashValue)\(doesRelativeDateFormatting.hashValue)\(timeZone.hashValue)\(locale.hashValue)"
            if Date.cachedDateFormatters.retrieve(hashKey: hashKey) == nil {
                let formatter = DateFormatter()
                formatter.dateStyle = dateStyle
                formatter.timeStyle = timeStyle
                formatter.doesRelativeDateFormatting = doesRelativeDateFormatting
                formatter.timeZone = timeZone
                formatter.locale = locale
                formatter.isLenient = isLenient
                Date.cachedDateFormatters.register(hashKey: hashKey, formatter: formatter)
            }

            return Date.cachedDateFormatters.retrieve(hashKey: hashKey)!
        }
        
        public func cachedNumberFormatter() -> NumberFormatter {
            return Date.cachedDateFormatters.retrieve()
        }
        
    }
    
    /// A cached static array of DateFormatters so that thy are only created once.
    private static var cachedDateFormatters = ConcurrentFormatterCache()
    
    // MARK: - Intervals In Seconds
    internal static let minuteInSeconds:Double = 60
    internal static let hourInSeconds:Double = 3600
    internal static let dayInSeconds:Double = 86400
    internal static let weekInSeconds:Double = 604800
    internal static let yearInSeconds:Double = 31556926
    
}

// MARK: - Enums used
/**
 The string format used for date string conversion.
 
 ````
 case isoYear: i.e. 1997
 case isoYearMonth: i.e. 1997-07
 case isoDate: i.e. 1997-07-16
 case isoDateTime: i.e. 1997-07-16T19:20+01:00
 case isoDateTimeSec: i.e. 1997-07-16T19:20:30+01:00
 case isoDateTimeMilliSec: i.e. 1997-07-16T19:20:30.45+01:00
 case dotNet: i.e. "/Date(1268123281843)/"
 case rss: i.e. "Fri, 09 Sep 2011 15:26:08 +0200"
 case altRSS: i.e. "09 Sep 2011 15:26:08 +0200"
 case httpHeader: i.e. "Tue, 15 Nov 1994 12:45:26 GMT"
 case standard: "EEE MMM dd HH:mm:ss Z yyyy"
 case custom(String): a custom date format string
 ````
 
 */
public enum DateFormatType {
    
    /// The ISO8601 formatted year "yyyy" i.e. 1997
    case isoYear
    
    /// The ISO8601 formatted year and month "yyyy-MM" i.e. 1997-07
    case isoYearMonth
    
    /// The ISO8601 formatted date "yyyy-MM-dd" i.e. 1997-07-16
    case isoDate
    
    /// The ISO8601 formatted date and time "yyyy-MM-dd'T'HH:mmZ" i.e. 1997-07-16T19:20+01:00
    case isoDateTime
    
    /// The ISO8601 formatted date, time and sec "yyyy-MM-dd'T'HH:mm:ssZ" i.e. 1997-07-16T19:20:30+01:00
    case isoDateTimeSec
    
    /// The ISO8601 formatted date, time and millisec "yyyy-MM-dd'T'HH:mm:ss.SSSZ" i.e. 1997-07-16T19:20:30.45+01:00
    case isoDateTimeMilliSec
    
    /// The dotNet formatted date "/Date(%d%d)/" i.e. "/Date(1268123281843)/"
    case dotNet
    
    /// The RSS formatted date "EEE, d MMM yyyy HH:mm:ss ZZZ" i.e. "Fri, 09 Sep 2011 15:26:08 +0200"
    case rss
    
    /// The Alternative RSS formatted date "d MMM yyyy HH:mm:ss ZZZ" i.e. "09 Sep 2011 15:26:08 +0200"
    case altRSS
    
    /// The http header formatted date "EEE, dd MM yyyy HH:mm:ss ZZZ" i.e. "Tue, 15 Nov 1994 12:45:26 GMT"
    case httpHeader
    
    /// A generic standard format date i.e. "EEE MMM dd HH:mm:ss Z yyyy"
    case standard
    
    /// A custom date format string
    case custom(String)
    
    var stringFormat:String {
        switch self {
        case .isoYear: return "yyyy"
        case .isoYearMonth: return "yyyy-MM"
        case .isoDate: return "yyyy-MM-dd"
        case .isoDateTime: return "yyyy-MM-dd'T'HH:mmZ"
        case .isoDateTimeSec: return "yyyy-MM-dd'T'HH:mm:ssZ"
        case .isoDateTimeMilliSec: return "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        case .dotNet: return "/Date(%d%f)/"
        case .rss: return "EEE, d MMM yyyy HH:mm:ss ZZZ"
        case .altRSS: return "d MMM yyyy HH:mm:ss ZZZ"
        case .httpHeader: return "EEE, dd MM yyyy HH:mm:ss ZZZ"
        case .standard: return "EEE MMM dd HH:mm:ss Z yyyy"
        case .custom(let customFormat): return customFormat
        }
    }
}

extension DateFormatType: Equatable {
    public static func ==(lhs: DateFormatType, rhs: DateFormatType) -> Bool {
        switch (lhs, rhs) {
        case (.custom(let lhsString), .custom(let rhsString)):
            return lhsString == rhsString
        default:
            return lhs == rhs
        }
    }
}

/// The time zone to be used for date conversion
public enum TimeZoneType {
    case local, `default`, utc, custom(Int)
    var timeZone:TimeZone {
        switch self {
        case .local: return NSTimeZone.local
        case .default: return NSTimeZone.default
        case .utc: return TimeZone(secondsFromGMT: 0)!
        case let .custom(gmt): return TimeZone(secondsFromGMT: gmt)!
        }
    }
}

// The string keys to modify the strings in relative format
public enum RelativeTimeStringType {
    case nowPast, nowFuture, secondsPast, secondsFuture, oneMinutePast, oneMinuteFuture, minutesPast, minutesFuture, oneHourPast, oneHourFuture, hoursPast, hoursFuture, oneDayPast, oneDayFuture, daysPast, daysFuture, oneWeekPast, oneWeekFuture, weeksPast, weeksFuture, oneMonthPast, oneMonthFuture, monthsPast, monthsFuture, oneYearPast, oneYearFuture, yearsPast, yearsFuture
}

// The type of comparison to do against today's date or with the suplied date.
public enum DateComparisonType {
    
    // Days
    
    /// Checks if date today.
    case isToday
    /// Checks if date is tomorrow.
    case isTomorrow
    /// Checks if date is yesterday.
    case isYesterday
    /// Compares date days
    case isSameDay(as:Date)
    
    // Weeks
    
    /// Checks if date is in this week.
    case isThisWeek
    /// Checks if date is in next week.
    case isNextWeek
    /// Checks if date is in last week.
    case isLastWeek
    /// Compares date weeks
    case isSameWeek(as:Date)
    
    // Months
    
    /// Checks if date is in this month.
    case isThisMonth
    /// Checks if date is in next month.
    case isNextMonth
    /// Checks if date is in last month.
    case isLastMonth
    /// Compares date months
    case isSameMonth(as:Date)
    
    // Years
    
    /// Checks if date is in this year.
    case isThisYear
    /// Checks if date is in next year.
    case isNextYear
    /// Checks if date is in last year.
    case isLastYear
    /// Compare date years
    case isSameYear(as:Date)
    
    // Relative Time
    
    /// Checks if it's a future date
    case isInTheFuture
    /// Checks if the date has passed
    case isInThePast
    /// Checks if earlier than date
    case isEarlier(than:Date)
    /// Checks if later than date
    case isLater(than:Date)
    /// Checks if it's a weekday
    case isWeekday
    /// Checks if it's a weekend
    case isWeekend
    
}

// The date components available to be retrieved or modifed
public enum DateComponentType {
    case second, minute, hour, day, weekday, nthWeekday, week, month, year
}
    

// The type of date that can be used for the dateFor function.
public enum DateForType {
    case startOfDay, endOfDay, startOfWeek, endOfWeek, startOfMonth, endOfMonth, tomorrow, yesterday, nearestMinute(minute:Int), nearestHour(hour:Int), startOfYear, endOfYear
}

// Convenience types for date to string conversion
public enum DateStyleType {
    /// Short style: "2/27/17, 2:22 PM"
    case short
    /// Medium style: "Feb 27, 2017, 2:22:06 PM"
    case medium
    /// Long style: "February 27, 2017 at 2:22:06 PM EST"
    case long
    /// Full style: "Monday, February 27, 2017 at 2:22:06 PM Eastern Standard Time"
    case full
    /// Ordinal day: "27th"
    case ordinalDay
    /// Weekday: "Monday"
    case weekday
    /// Short week day: "Mon"
    case shortWeekday
    /// Very short weekday: "M"
    case veryShortWeekday
    /// Month: "February"
    case month
    /// Short month: "Feb"
    case shortMonth
    /// Very short month: "F"
    case veryShortMonth
}

extension UIViewController {
    
    func simpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
