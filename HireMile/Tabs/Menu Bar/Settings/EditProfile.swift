//
//  EditProfile.swift
//  HireMile
//
//  Created by JJ Zapata on 11/20/20.
//  Copyright © 2020 Jorge Zapata. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import PhoneNumberKit
import MBProgressHUD

class EditProfile: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let imagePicker = UIImagePickerController()
    
    var imageHasBeenChanged = false
    
    var mondayOn = false
    
    var tuesdayOn = false
    
    var wednesdayOn = false
    
    var thursdayOn = false
    
    var fridayOn = false
    
    var saturdayOn = false
    
    var sundayOn = false
    
    var format = false
    
    var labelToChange : UILabel?
    
    var start : String = "12:00AM"
    
    var end : String = "12:00AM"
    
    var hours : WorkingHoursStructure? {
        didSet {
            if hours!.monday != "Not Set" {
                mondayOn = true
                checkMonday()
            } else {
                mondayOn = false
                checkMonday()
            }
            if hours!.tuesday != "Not Set" {
                tuesdayOn = true
                checkTuesday()
            } else {
                tuesdayOn = false
                checkTuesday()
            }
            if hours!.wednesday != "Not Set" {
                wednesdayOn = true
                checkWednesday()
            } else {
                wednesdayOn = false
                checkWednesday()
            }
            if hours!.thursday != "Not Set" {
                thursdayOn = true
                checkThursday()
            } else {
                thursdayOn = false
                checkThursday()
            }
            if hours!.friday != "Not Set" {
                fridayOn = true
                checkFriday()
            } else {
                fridayOn = false
                checkFriday()
            }
            if hours!.saturday != "Not Set" {
                saturdayOn = true
                checkSaturday()
            } else {
                saturdayOn = false
                checkSaturday()
            }
            if hours!.sunday != "Not Set" {
                sundayOn = true
                checkSunday()
            } else {
                sundayOn = false
                checkSunday()
            }
        }
    }
    
    let data = [
        ["12:00AM", "12:10AM", "12:20AM", "12:30AM", "12:40AM", "12:50AM", "1:00AM", "1:10AM", "1:20AM", "1:30AM", "1:40AM", "1:50AM", "2:00AM", "2:10AM", "2:20AM", "2:30AM", "2:40AM", "2:50AM", "3:00AM", "3:10AM", "3:20AM", "3:30AM", "3:40AM", "3:50AM", "4:00AM", "4:10AM", "4:20AM", "4:30AM", "4:40AM", "4:50AM", "5:00AM", "5:10AM", "5:20AM", "5:30AM", "5:40AM", "5:50AM", "6:00AM", "6:10AM", "6:20AM", "6:30AM", "6:40AM", "6:50AM", "7:00AM", "7:10AM", "7:20AM", "7:30AM", "7:40AM", "7:50AM", "8:00AM", "8:10AM", "8:20AM", "8:30AM", "8:40AM", "8:50AM", "9:00AM", "9:10AM", "9:20AM", "9:30AM", "9:40AM", "9:50AM", "10:00AM", "10:10AM", "10:20AM", "10:30AM", "10:40AM", "10:50AM", "11:00AM", "11:10AM", "11:20AM", "11:30AM", "11:40AM", "11:50AM", "12:00PM", "12:10PM", "12:20PM", "12:30PM", "12:40PM", "12:50PM", "1:00PM", "1:10PM", "1:20PM", "1:30PM", "1:40PM", "1:50PM", "2:00PM", "2:10PM", "2:20PM", "2:30PM", "2:40PM", "2:50PM", "3:00PM", "3:10PM", "3:20PM", "3:30PM", "3:40PM", "3:50PM", "4:00PM", "4:10PM", "4:20PM", "4:30PM", "4:40PM", "4:50PM", "5:00PM", "5:10PM", "5:20PM", "5:30PM", "5:40PM", "5:50PM", "6:00PM", "6:10PM", "6:20PM", "6:30PM", "6:40PM", "6:50PM", "7:00PM", "7:10PM", "7:20PM", "7:30PM", "7:40PM", "7:50PM", "8:00PM", "8:10PM", "8:20PM", "8:30PM", "8:40PM", "8:50PM", "9:00PM", "9:10PM", "9:20PM", "9:30PM", "9:40PM", "9:50PM", "10:00PM", "10:10PM", "10:20PM", "10:30PM", "10:40PM", "10:50PM", "11:00PM", "11:10PM", "11:20PM", "11:30PM", "11:40PM", "11:50PM"],
        ["12:00AM", "12:10AM", "12:20AM", "12:30AM", "12:40AM", "12:50AM", "1:00AM", "1:10AM", "1:20AM", "1:30AM", "1:40AM", "1:50AM", "2:00AM", "2:10AM", "2:20AM", "2:30AM", "2:40AM", "2:50AM", "3:00AM", "3:10AM", "3:20AM", "3:30AM", "3:40AM", "3:50AM", "4:00AM", "4:10AM", "4:20AM", "4:30AM", "4:40AM", "4:50AM", "5:00AM", "5:10AM", "5:20AM", "5:30AM", "5:40AM", "5:50AM", "6:00AM", "6:10AM", "6:20AM", "6:30AM", "6:40AM", "6:50AM", "7:00AM", "7:10AM", "7:20AM", "7:30AM", "7:40AM", "7:50AM", "8:00AM", "8:10AM", "8:20AM", "8:30AM", "8:40AM", "8:50AM", "9:00AM", "9:10AM", "9:20AM", "9:30AM", "9:40AM", "9:50AM", "10:00AM", "10:10AM", "10:20AM", "10:30AM", "10:40AM", "10:50AM", "11:00AM", "11:10AM", "11:20AM", "11:30AM", "11:40AM", "11:50AM", "12:00PM", "12:10PM", "12:20PM", "12:30PM", "12:40PM", "12:50PM", "1:00PM", "1:10PM", "1:20PM", "1:30PM", "1:40PM", "1:50PM", "2:00PM", "2:10PM", "2:20PM", "2:30PM", "2:40PM", "2:50PM", "3:00PM", "3:10PM", "3:20PM", "3:30PM", "3:40PM", "3:50PM", "4:00PM", "4:10PM", "4:20PM", "4:30PM", "4:40PM", "4:50PM", "5:00PM", "5:10PM", "5:20PM", "5:30PM", "5:40PM", "5:50PM", "6:00PM", "6:10PM", "6:20PM", "6:30PM", "6:40PM", "6:50PM", "7:00PM", "7:10PM", "7:20PM", "7:30PM", "7:40PM", "7:50PM", "8:00PM", "8:10PM", "8:20PM", "8:30PM", "8:40PM", "8:50PM", "9:00PM", "9:10PM", "9:20PM", "9:30PM", "9:40PM", "9:50PM", "10:00PM", "10:10PM", "10:20PM", "10:30PM", "10:40PM", "10:50PM", "11:00PM", "11:10PM", "11:20PM", "11:30PM", "11:40PM", "11:50PM"],
    ]
    
    let inputPopupHeight : CGFloat = 495
    
    let blackView = UIView()
    
    let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor.white
        return scrollView
    }()
    
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
//        imageView.image = UIImage(named: "onboarding3")
        imageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let basicLabel : UILabel = {
        let label = UILabel()
        label.text = "General Information"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 1
        return label
    }()
    
    let changeImageButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.mainBlue
        button.tintColor = UIColor.white
        button.layer.cornerRadius = 20
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(openImgePicker), for: .touchUpInside)
        return button
    }()
    
    let basicView1 : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let previewLabel1 : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Full Name"
        label.textColor = UIColor.lightGray
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let label1 : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Full Name"
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let sideMenuArrow1 : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.right")
        iv.tintColor = UIColor.lightGray
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let button1 : UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(button1Tap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let basicView2 : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let previewLabel2 : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Email"
        label.textColor = UIColor.lightGray
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let label2 : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Email"
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let sideMenuArrow2 : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.right")
        iv.tintColor = UIColor.lightGray
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let button2 : UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(button2Tap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let basicView3 : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let previewLabel3 : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Description"
        label.textColor = UIColor.lightGray
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let label3: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Description"
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let sideMenuArrow3 : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.right")
        iv.tintColor = UIColor.lightGray
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let button3 : UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(button3Tap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let basicView4 : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let previewLabel4 : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Phone Number"
        label.textColor = UIColor.lightGray
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let label4: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Phone Number"
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let sideMenuArrow4 : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.right")
        iv.tintColor = UIColor.lightGray
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let button4 : UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(button4Tap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
//
//    let basicView5 : UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    let previewLabel5 : UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "Zipcode"
//        label.textColor = UIColor.lightGray
//        label.textAlignment = NSTextAlignment.left
//        label.font = UIFont.systemFont(ofSize: 12)
//        return label
//    }()
//
//    let label5 : UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "Zipcode"
//        label.textColor = UIColor.black
//        label.textAlignment = NSTextAlignment.left
//        label.font = UIFont.systemFont(ofSize: 16)
//        return label
//    }()
//
//    let sideMenuArrow5 : UIImageView = {
//        let iv = UIImageView()
//        iv.image = UIImage(systemName: "chevron.right")
//        iv.tintColor = UIColor.lightGray
//        iv.translatesAutoresizingMaskIntoConstraints = false
//        iv.contentMode = .scaleAspectFit
//        return iv
//    }()
//
//    let button5 : UIButton = {
//        let button = UIButton()
//        button.addTarget(self, action: #selector(button5Tap), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    let basicView6 : UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    let previewLabel6 : UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "Date of Birth"
//        label.textColor = UIColor.lightGray
//        label.textAlignment = NSTextAlignment.left
//        label.font = UIFont.systemFont(ofSize: 12)
//        return label
//    }()
//
//    let label6: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "Date of Birth"
//        label.textColor = UIColor.black
//        label.textAlignment = NSTextAlignment.left
//        label.font = UIFont.systemFont(ofSize: 16)
//        return label
//    }()
//
//    let sideMenuArrow6 : UIImageView = {
//        let iv = UIImageView()
//        iv.image = UIImage(systemName: "chevron.right")
//        iv.tintColor = UIColor.lightGray
//        iv.translatesAutoresizingMaskIntoConstraints = false
//        iv.contentMode = .scaleAspectFit
//        return iv
//    }()
//
//    let button6 : UIButton = {
//        let button = UIButton()
//        button.addTarget(self, action: #selector(button6Tap), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
    let workLabel : UILabel = {
        let label = UILabel()
        label.text = "Working Hours"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 1
        return label
    }()
    
    let workhours : UIView = {
        let tableview = UIView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    let mondayView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let mondayPlusIcon : UIButton = {
        let imageView = UIButton()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setImage(UIImage(systemName: "plus"), for: .normal)
        imageView.tintColor = UIColor(red: 171/255, green: 169/255, blue: 169/255, alpha: 1)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.addTarget(self, action: #selector(mondayTapped), for: .touchUpInside)
        return imageView
    }()
    
    let mondayBottomView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1)
        view.alpha = 0.24
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let mondayCheckBox : CheckBox = {
        let checkbox = CheckBox()
        checkbox.style = .tick
        checkbox.addTarget(self, action: #selector(onMondayCheck(_:)), for: .valueChanged)
        checkbox.borderStyle = .roundedSquare(radius: 3)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        return checkbox
    }()
    
    let mondayTitle : UILabel = {
        let label = UILabel()
        label.text = "Monday"
        label.textColor = UIColor.unselectedColor
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let mondayHours : UILabel = {
        let label = UILabel()
        label.text = "9:00AM - 5:00PM"
        label.textColor = UIColor.unselectedColor
        label.textAlignment = NSTextAlignment.right
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tuesdayView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let tuesdayPlusIcon : UIButton = {
        let imageView = UIButton()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setImage(UIImage(systemName: "plus"), for: .normal)
        imageView.tintColor = UIColor(red: 171/255, green: 169/255, blue: 169/255, alpha: 1)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.addTarget(self, action: #selector(tuesdayTapped), for: .touchUpInside)
        return imageView
    }()
    
    let tuesdayBottomView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1)
        view.alpha = 0.24
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let tuesdayCheckBox : CheckBox = {
        let checkbox = CheckBox()
        checkbox.style = .tick
        checkbox.addTarget(self, action: #selector(onTuesdayCheck(_:)), for: .valueChanged)
        checkbox.borderStyle = .roundedSquare(radius: 3)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        return checkbox
    }()
    
    let tuesdayTitle : UILabel = {
        let label = UILabel()
        label.text = "Tuesday"
        label.textColor = UIColor.unselectedColor
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tuesdayHours : UILabel = {
        let label = UILabel()
        label.text = "9:00AM - 5:00PM"
        label.textColor = UIColor.unselectedColor
        label.textAlignment = NSTextAlignment.right
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let wednesdayView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let wednesdayPlusIcon : UIButton = {
        let imageView = UIButton()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setImage(UIImage(systemName: "plus"), for: .normal)
        imageView.tintColor = UIColor(red: 171/255, green: 169/255, blue: 169/255, alpha: 1)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.addTarget(self, action: #selector(wednesdayTapped), for: .touchUpInside)
        return imageView
    }()
    
    let wednesdayBottomView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1)
        view.alpha = 0.24
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let wednesdayCheckBox : CheckBox = {
        let checkbox = CheckBox()
        checkbox.style = .tick
        checkbox.addTarget(self, action: #selector(onWednesdayCheck(_:)), for: .valueChanged)
        checkbox.borderStyle = .roundedSquare(radius: 3)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        return checkbox
    }()
    
    let wednesdayTitle : UILabel = {
        let label = UILabel()
        label.text = "Wednesday"
        label.textColor = UIColor.unselectedColor
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let wednesdayHours : UILabel = {
        let label = UILabel()
        label.text = "9:00AM - 5:00PM"
        label.textColor = UIColor.unselectedColor
        label.textAlignment = NSTextAlignment.right
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let thursdayView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let thursdayPlusIcon : UIButton = {
        let imageView = UIButton()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setImage(UIImage(systemName: "plus"), for: .normal)
        imageView.tintColor = UIColor(red: 171/255, green: 169/255, blue: 169/255, alpha: 1)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.addTarget(self, action: #selector(thursdayTapped), for: .touchUpInside)
        return imageView
    }()
    
    let thursdayBottomView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1)
        view.alpha = 0.24
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let thursdayCheckBox : CheckBox = {
        let checkbox = CheckBox()
        checkbox.style = .tick
        checkbox.addTarget(self, action: #selector(onThursdayCheck(_:)), for: .valueChanged)
        checkbox.borderStyle = .roundedSquare(radius: 3)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        return checkbox
    }()
    
    let thursdayTitle : UILabel = {
        let label = UILabel()
        label.text = "Thursday"
        label.textColor = UIColor.unselectedColor
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let thursdayHours : UILabel = {
        let label = UILabel()
        label.text = "9:00AM - 5:00PM"
        label.textColor = UIColor.unselectedColor
        label.textAlignment = NSTextAlignment.right
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let fridayView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let fridayPlusIcon : UIButton = {
        let imageView = UIButton()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setImage(UIImage(systemName: "plus"), for: .normal)
        imageView.tintColor = UIColor(red: 171/255, green: 169/255, blue: 169/255, alpha: 1)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.addTarget(self, action: #selector(fridayTapped), for: .touchUpInside)
        return imageView
    }()
    
    let fridayBottomView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1)
        view.alpha = 0.24
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let fridayCheckBox : CheckBox = {
        let checkbox = CheckBox()
        checkbox.style = .tick
        checkbox.addTarget(self, action: #selector(onFridayCheck(_:)), for: .valueChanged)
        checkbox.borderStyle = .roundedSquare(radius: 3)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        return checkbox
    }()
    
    let fridayTitle : UILabel = {
        let label = UILabel()
        label.text = "Friday"
        label.textColor = UIColor.unselectedColor
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let fridayHours : UILabel = {
        let label = UILabel()
        label.text = "9:00AM - 5:00PM"
        label.textColor = UIColor.unselectedColor
        label.textAlignment = NSTextAlignment.right
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let saturdayView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let saturdayPlusIcon : UIButton = {
        let imageView = UIButton()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setImage(UIImage(systemName: "plus"), for: .normal)
        imageView.tintColor = UIColor(red: 171/255, green: 169/255, blue: 169/255, alpha: 1)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.addTarget(self, action: #selector(saturdayTapped), for: .touchUpInside)
        return imageView
    }()
    
    let saturdayBottomView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1)
        view.alpha = 0.24
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let saturdayCheckBox : CheckBox = {
        let checkbox = CheckBox()
        checkbox.style = .tick
        checkbox.addTarget(self, action: #selector(onSaturdayCheck(_:)), for: .valueChanged)
        checkbox.borderStyle = .roundedSquare(radius: 3)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        return checkbox
    }()
    
    let saturdayTitle : UILabel = {
        let label = UILabel()
        label.text = "Saturday"
        label.textColor = UIColor.unselectedColor
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let saturdayHours : UILabel = {
        let label = UILabel()
        label.text = "9:00AM - 5:00PM"
        label.textColor = UIColor.unselectedColor
        label.textAlignment = NSTextAlignment.right
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sundayView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let sundayPlusIcon : UIButton = {
        let imageView = UIButton()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setImage(UIImage(systemName: "plus"), for: .normal)
        imageView.tintColor = UIColor(red: 171/255, green: 169/255, blue: 169/255, alpha: 1)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.addTarget(self, action: #selector(sundayTapped), for: .touchUpInside)
        return imageView
    }()
    
    let sundayBottomView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1)
        view.alpha = 0.24
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let sundayCheckBox : CheckBox = {
        let checkbox = CheckBox()
        checkbox.style = .tick
        checkbox.addTarget(self, action: #selector(onSundayCheck(_:)), for: .valueChanged)
        checkbox.borderStyle = .roundedSquare(radius: 3)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        return checkbox
    }()
    
    let sundayTitle : UILabel = {
        let label = UILabel()
        label.text = "Sunday"
        label.textColor = UIColor.unselectedColor
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sundayHours : UILabel = {
        let label = UILabel()
        label.text = "9:00AM - 5:00PM"
        label.textColor = UIColor.unselectedColor
        label.textAlignment = NSTextAlignment.right
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let socialLabel : UILabel = {
        let label = UILabel()
        label.text = "Social Media"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 1
        return label
    }()
    
    let instagramView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let instagramTitleLabel : UILabel = {
        let label = UILabel()
        label.text = "Instagram"
        label.textColor = UIColor.boldSelectedColor
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let instagramChevron1 : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.right")
        iv.tintColor = UIColor.lightGray
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let instagramLabel : UILabel = {
        let label = UILabel()
        label.text = "username"
        label.textColor = UIColor.systemBlue
        label.textAlignment = NSTextAlignment.right
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let instagramButton : UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(instagramTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let facebookView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let facebookTitleLabel : UILabel = {
        let label = UILabel()
        label.text = "Facebook"
        label.textColor = UIColor.boldSelectedColor
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let facebookChevron1 : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.right")
        iv.tintColor = UIColor.lightGray
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let facebookLabel : UILabel = {
        let label = UILabel()
        label.text = "username"
        label.textColor = UIColor.systemBlue
        label.textAlignment = NSTextAlignment.right
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let facebookButton : UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(facebookTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let filterView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 30
        return view
    }()
    
    let exitButton : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.imageView?.tintColor = UIColor.black
        button.tintColor = UIColor.black
        return button
    }()
    
    let titleInputPopup : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "hi"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.black
        return label
    }()
    
    let inputTextField : UITextField = {
        let textfield = UITextField()
        textfield.tintColor = UIColor.mainBlue
        textfield.borderStyle = .roundedRect
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    let loginButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.mainBlue
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 22.5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let saveButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.mainBlue
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 22.5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cancelButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.mainBlue.cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 22.5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let datePicker : UIPickerView = {
        let datepicker = UIPickerView()
        datepicker.translatesAutoresizingMaskIntoConstraints = false
        datepicker.tintColor = UIColor.red
        return datepicker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Functions to throw
        addConstraints()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Functions to throw
        basicSetup()
        
        // image
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("profile-image").observe(.value) { (snapshot) in
            let profileImageString : String = (snapshot.value as? String)!
            if profileImageString == "not-yet-selected" {
                self.profileImageView.image = UIImage(systemName: "person.circle.fill")
                self.profileImageView.tintColor = UIColor.lightGray
                self.profileImageView.contentMode = .scaleAspectFill
            } else {
                self.profileImageView.loadImageUsingCacheWithUrlString(profileImageString)
                self.profileImageView.tintColor = UIColor.lightGray
                self.profileImageView.contentMode = .scaleAspectFill
            }
        }
    }

    func addConstraints() {
        
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 1200)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        
        scrollView.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 15).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        scrollView.addSubview(changeImageButton)
        changeImageButton.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 60).isActive = true
        changeImageButton.leftAnchor.constraint(equalTo: profileImageView.leftAnchor, constant: 60).isActive = true
        changeImageButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        changeImageButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(basicLabel)
        basicLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 25).isActive = true
        basicLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        basicLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        basicLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(basicView1)
        basicView1.topAnchor.constraint(equalTo: basicLabel.bottomAnchor, constant: 5).isActive = true
        basicView1.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        basicView1.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        basicView1.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        basicView1.addSubview(previewLabel1)
        previewLabel1.topAnchor.constraint(equalTo: basicView1.topAnchor, constant: 2).isActive = true
        previewLabel1.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        previewLabel1.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        previewLabel1.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        basicView1.addSubview(label1)
        label1.topAnchor.constraint(equalTo: previewLabel1.bottomAnchor).isActive = true
        label1.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        label1.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        label1.bottomAnchor.constraint(equalTo: basicView1.bottomAnchor).isActive = true
        
        basicView1.addSubview(sideMenuArrow1)
        sideMenuArrow1.rightAnchor.constraint(equalTo: basicView1.rightAnchor, constant: -10).isActive = true
        sideMenuArrow1.centerYAnchor.constraint(equalTo: basicView1.centerYAnchor).isActive = true
        sideMenuArrow1.widthAnchor.constraint(equalToConstant: 20).isActive = true
        sideMenuArrow1.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        basicView1.addSubview(button1)
        button1.topAnchor.constraint(equalTo: basicView1.topAnchor).isActive = true
        button1.leftAnchor.constraint(equalTo: basicView1.leftAnchor).isActive = true
        button1.rightAnchor.constraint(equalTo: basicView1.rightAnchor).isActive = true
        button1.bottomAnchor.constraint(equalTo: basicView1.bottomAnchor).isActive = true
        
        scrollView.addSubview(basicView2)
        basicView2.topAnchor.constraint(equalTo: basicView1.bottomAnchor, constant: 10).isActive = true
        basicView2.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        basicView2.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        basicView2.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        basicView2.addSubview(previewLabel2)
        previewLabel2.topAnchor.constraint(equalTo: basicView2.topAnchor, constant: 2).isActive = true
        previewLabel2.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        previewLabel2.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        previewLabel2.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        basicView2.addSubview(label2)
        label2.topAnchor.constraint(equalTo: previewLabel2.bottomAnchor).isActive = true
        label2.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        label2.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        label2.bottomAnchor.constraint(equalTo: basicView2.bottomAnchor).isActive = true
        
        basicView2.addSubview(sideMenuArrow2)
        sideMenuArrow2.rightAnchor.constraint(equalTo: basicView2.rightAnchor, constant: -10).isActive = true
        sideMenuArrow2.centerYAnchor.constraint(equalTo: basicView2.centerYAnchor).isActive = true
        sideMenuArrow2.widthAnchor.constraint(equalToConstant: 20).isActive = true
        sideMenuArrow2.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        basicView2.addSubview(button2)
        button2.topAnchor.constraint(equalTo: basicView2.topAnchor).isActive = true
        button2.leftAnchor.constraint(equalTo: basicView2.leftAnchor).isActive = true
        button2.rightAnchor.constraint(equalTo: basicView2.rightAnchor).isActive = true
        button2.bottomAnchor.constraint(equalTo: basicView2.bottomAnchor).isActive = true
        
        scrollView.addSubview(basicView3)
        basicView3.topAnchor.constraint(equalTo: basicView2.bottomAnchor, constant: 10).isActive = true
        basicView3.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        basicView3.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        basicView3.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        basicView3.addSubview(previewLabel3)
        previewLabel3.topAnchor.constraint(equalTo: basicView3.topAnchor, constant: 2).isActive = true
        previewLabel3.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        previewLabel3.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        previewLabel3.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        basicView3.addSubview(label3)
        label3.topAnchor.constraint(equalTo: previewLabel3.bottomAnchor).isActive = true
        label3.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        label3.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        label3.bottomAnchor.constraint(equalTo: basicView3.bottomAnchor).isActive = true
        
        basicView3.addSubview(sideMenuArrow3)
        sideMenuArrow3.rightAnchor.constraint(equalTo: basicView3.rightAnchor, constant: -10).isActive = true
        sideMenuArrow3.centerYAnchor.constraint(equalTo: basicView3.centerYAnchor).isActive = true
        sideMenuArrow3.widthAnchor.constraint(equalToConstant: 20).isActive = true
        sideMenuArrow3.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        basicView3.addSubview(button3)
        button3.topAnchor.constraint(equalTo: basicView3.topAnchor).isActive = true
        button3.leftAnchor.constraint(equalTo: basicView3.leftAnchor).isActive = true
        button3.rightAnchor.constraint(equalTo: basicView3.rightAnchor).isActive = true
        button3.bottomAnchor.constraint(equalTo: basicView3.bottomAnchor).isActive = true
        
        scrollView.addSubview(basicView4)
        basicView4.topAnchor.constraint(equalTo: basicView3.bottomAnchor, constant: 10).isActive = true
        basicView4.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        basicView4.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        basicView4.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        basicView4.addSubview(previewLabel4)
        previewLabel4.topAnchor.constraint(equalTo: basicView4.topAnchor, constant: 2).isActive = true
        previewLabel4.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        previewLabel4.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        previewLabel4.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        basicView4.addSubview(label4)
        label4.topAnchor.constraint(equalTo: previewLabel4.bottomAnchor).isActive = true
        label4.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        label4.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        label4.bottomAnchor.constraint(equalTo: basicView4.bottomAnchor).isActive = true
        
        basicView4.addSubview(sideMenuArrow4)
        sideMenuArrow4.rightAnchor.constraint(equalTo: basicView4.rightAnchor, constant: -10).isActive = true
        sideMenuArrow4.centerYAnchor.constraint(equalTo: basicView4.centerYAnchor).isActive = true
        sideMenuArrow4.widthAnchor.constraint(equalToConstant: 20).isActive = true
        sideMenuArrow4.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        basicView4.addSubview(button4)
        button4.topAnchor.constraint(equalTo: basicView4.topAnchor).isActive = true
        button4.leftAnchor.constraint(equalTo: basicView4.leftAnchor).isActive = true
        button4.rightAnchor.constraint(equalTo: basicView4.rightAnchor).isActive = true
        button4.bottomAnchor.constraint(equalTo: basicView4.bottomAnchor).isActive = true
        
//        scrollView.addSubview(basicView5)
//        basicView5.topAnchor.constraint(equalTo: basicView4.bottomAnchor, constant: 10).isActive = true
//        basicView5.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
//        basicView5.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
//        basicView5.heightAnchor.constraint(equalToConstant: 48).isActive = true
//
//        basicView5.addSubview(previewLabel5)
//        previewLabel5.topAnchor.constraint(equalTo: basicView5.topAnchor, constant: 2).isActive = true
//        previewLabel5.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
//        previewLabel5.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
//        previewLabel5.heightAnchor.constraint(equalToConstant: 20).isActive = true
//
//        basicView5.addSubview(label5)
//        label5.topAnchor.constraint(equalTo: previewLabel5.bottomAnchor).isActive = true
//        label5.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
//        label5.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
//        label5.bottomAnchor.constraint(equalTo: basicView5.bottomAnchor).isActive = true
//
//        basicView5.addSubview(sideMenuArrow5)
//        sideMenuArrow5.rightAnchor.constraint(equalTo: basicView5.rightAnchor, constant: -10).isActive = true
//        sideMenuArrow5.centerYAnchor.constraint(equalTo: basicView5.centerYAnchor).isActive = true
//        sideMenuArrow5.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        sideMenuArrow5.heightAnchor.constraint(equalToConstant: 20).isActive = true
//
//        basicView5.addSubview(button5)
//        button5.topAnchor.constraint(equalTo: basicView5.topAnchor).isActive = true
//        button5.leftAnchor.constraint(equalTo: basicView5.leftAnchor).isActive = true
//        button5.rightAnchor.constraint(equalTo: basicView5.rightAnchor).isActive = true
//        button5.bottomAnchor.constraint(equalTo: basicView5.bottomAnchor).isActive = true
//
//        scrollView.addSubview(basicView6)
//        basicView6.topAnchor.constraint(equalTo: basicView5.bottomAnchor, constant: 10).isActive = true
//        basicView6.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
//        basicView6.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
//        basicView6.heightAnchor.constraint(equalToConstant: 48).isActive = true
//
//        basicView6.addSubview(previewLabel6)
//        previewLabel6.topAnchor.constraint(equalTo: basicView6.topAnchor, constant: 2).isActive = true
//        previewLabel6.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
//        previewLabel6.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
//        previewLabel6.heightAnchor.constraint(equalToConstant: 20).isActive = true
//
//        basicView6.addSubview(label6)
//        label6.topAnchor.constraint(equalTo: previewLabel6.bottomAnchor).isActive = true
//        label6.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
//        label6.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
//        label6.bottomAnchor.constraint(equalTo: basicView6.bottomAnchor).isActive = true
//
//        basicView6.addSubview(sideMenuArrow6)
//        sideMenuArrow6.rightAnchor.constraint(equalTo: basicView6.rightAnchor, constant: -10).isActive = true
//        sideMenuArrow6.centerYAnchor.constraint(equalTo: basicView6.centerYAnchor).isActive = true
//        sideMenuArrow6.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        sideMenuArrow6.heightAnchor.constraint(equalToConstant: 20).isActive = true
//
//        basicView6.addSubview(button6)
//        button6.topAnchor.constraint(equalTo: basicView6.topAnchor).isActive = true
//        button6.leftAnchor.constraint(equalTo: basicView6.leftAnchor).isActive = true
//        button6.rightAnchor.constraint(equalTo: basicView6.rightAnchor).isActive = true
//        button6.bottomAnchor.constraint(equalTo: basicView6.bottomAnchor).isActive = true
        
        scrollView.addSubview(workLabel)
        workLabel.topAnchor.constraint(equalTo: basicView4.bottomAnchor, constant: 25).isActive = true
        workLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        workLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        workLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(workhours)
        workhours.topAnchor.constraint(equalTo: workLabel.bottomAnchor, constant: 5).isActive = true
        workhours.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        workhours.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        workhours.heightAnchor.constraint(equalToConstant: 340).isActive = true
        
        workhours.addSubview(mondayView)
        mondayView.topAnchor.constraint(equalTo: workhours.topAnchor).isActive = true
        mondayView.leftAnchor.constraint(equalTo: workhours.leftAnchor).isActive = true
        mondayView.rightAnchor.constraint(equalTo: workhours.rightAnchor).isActive = true
        mondayView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        mondayView.addSubview(mondayPlusIcon)
        mondayPlusIcon.centerYAnchor.constraint(equalTo: mondayView.centerYAnchor).isActive = true
        mondayPlusIcon.widthAnchor.constraint(equalToConstant: 16).isActive = true
        mondayPlusIcon.heightAnchor.constraint(equalToConstant: 16).isActive = true
        mondayPlusIcon.rightAnchor.constraint(equalTo: mondayView.rightAnchor).isActive = true
        
        mondayView.addSubview(mondayBottomView)
        mondayBottomView.bottomAnchor.constraint(equalTo: mondayView.bottomAnchor).isActive = true
        mondayBottomView.rightAnchor.constraint(equalTo: mondayView.rightAnchor).isActive = true
        mondayBottomView.leftAnchor.constraint(equalTo: mondayView.leftAnchor).isActive = true
        mondayBottomView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        mondayView.addSubview(mondayCheckBox)
        mondayCheckBox.centerYAnchor.constraint(equalTo: mondayView.centerYAnchor).isActive = true
        mondayCheckBox.widthAnchor.constraint(equalToConstant: 16).isActive = true
        mondayCheckBox.heightAnchor.constraint(equalToConstant: 16).isActive = true
        mondayCheckBox.leftAnchor.constraint(equalTo: mondayView.leftAnchor).isActive = true
        
        mondayView.addSubview(mondayTitle)
        mondayTitle.topAnchor.constraint(equalTo: mondayView.topAnchor).isActive = true
        mondayTitle.bottomAnchor.constraint(equalTo: mondayView.bottomAnchor).isActive = true
        mondayTitle.leftAnchor.constraint(equalTo: mondayCheckBox.rightAnchor, constant: 12).isActive = true
        mondayTitle.widthAnchor.constraint(equalToConstant: 85).isActive = true
        
        mondayView.addSubview(mondayHours)
        mondayHours.topAnchor.constraint(equalTo: mondayView.topAnchor).isActive = true
        mondayHours.bottomAnchor.constraint(equalTo: mondayView.bottomAnchor).isActive = true
        mondayHours.leftAnchor.constraint(equalTo: mondayTitle.rightAnchor, constant: 12).isActive = true
        mondayHours.rightAnchor.constraint(equalTo: mondayPlusIcon.leftAnchor, constant: -12).isActive = true
        
        workhours.addSubview(tuesdayView)
        tuesdayView.topAnchor.constraint(equalTo: mondayView.bottomAnchor).isActive = true
        tuesdayView.leftAnchor.constraint(equalTo: workhours.leftAnchor).isActive = true
        tuesdayView.rightAnchor.constraint(equalTo: workhours.rightAnchor).isActive = true
        tuesdayView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        tuesdayView.addSubview(tuesdayPlusIcon)
        tuesdayPlusIcon.centerYAnchor.constraint(equalTo: tuesdayView.centerYAnchor).isActive = true
        tuesdayPlusIcon.widthAnchor.constraint(equalToConstant: 16).isActive = true
        tuesdayPlusIcon.heightAnchor.constraint(equalToConstant: 16).isActive = true
        tuesdayPlusIcon.rightAnchor.constraint(equalTo: tuesdayView.rightAnchor).isActive = true
        
        tuesdayView.addSubview(tuesdayBottomView)
        tuesdayBottomView.bottomAnchor.constraint(equalTo: tuesdayView.bottomAnchor).isActive = true
        tuesdayBottomView.rightAnchor.constraint(equalTo: tuesdayView.rightAnchor).isActive = true
        tuesdayBottomView.leftAnchor.constraint(equalTo: tuesdayView.leftAnchor).isActive = true
        tuesdayBottomView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        tuesdayView.addSubview(tuesdayCheckBox)
        tuesdayCheckBox.centerYAnchor.constraint(equalTo: tuesdayView.centerYAnchor).isActive = true
        tuesdayCheckBox.widthAnchor.constraint(equalToConstant: 16).isActive = true
        tuesdayCheckBox.heightAnchor.constraint(equalToConstant: 16).isActive = true
        tuesdayCheckBox.leftAnchor.constraint(equalTo: tuesdayView.leftAnchor).isActive = true
        
        tuesdayView.addSubview(tuesdayTitle)
        tuesdayTitle.topAnchor.constraint(equalTo: tuesdayView.topAnchor).isActive = true
        tuesdayTitle.bottomAnchor.constraint(equalTo: tuesdayView.bottomAnchor).isActive = true
        tuesdayTitle.leftAnchor.constraint(equalTo: tuesdayCheckBox.rightAnchor, constant: 12).isActive = true
        tuesdayTitle.widthAnchor.constraint(equalToConstant: 85).isActive = true
        
        tuesdayView.addSubview(tuesdayHours)
        tuesdayHours.topAnchor.constraint(equalTo: tuesdayView.topAnchor).isActive = true
        tuesdayHours.bottomAnchor.constraint(equalTo: tuesdayView.bottomAnchor).isActive = true
        tuesdayHours.leftAnchor.constraint(equalTo: tuesdayTitle.rightAnchor, constant: 12).isActive = true
        tuesdayHours.rightAnchor.constraint(equalTo: tuesdayPlusIcon.leftAnchor, constant: -12).isActive = true
        
        workhours.addSubview(wednesdayView)
        wednesdayView.topAnchor.constraint(equalTo: tuesdayView.bottomAnchor).isActive = true
        wednesdayView.leftAnchor.constraint(equalTo: workhours.leftAnchor).isActive = true
        wednesdayView.rightAnchor.constraint(equalTo: workhours.rightAnchor).isActive = true
        wednesdayView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        wednesdayView.addSubview(wednesdayPlusIcon)
        wednesdayPlusIcon.centerYAnchor.constraint(equalTo: wednesdayView.centerYAnchor).isActive = true
        wednesdayPlusIcon.widthAnchor.constraint(equalToConstant: 16).isActive = true
        wednesdayPlusIcon.heightAnchor.constraint(equalToConstant: 16).isActive = true
        wednesdayPlusIcon.rightAnchor.constraint(equalTo: wednesdayView.rightAnchor).isActive = true
        
        wednesdayView.addSubview(wednesdayBottomView)
        wednesdayBottomView.bottomAnchor.constraint(equalTo: wednesdayView.bottomAnchor).isActive = true
        wednesdayBottomView.rightAnchor.constraint(equalTo: wednesdayView.rightAnchor).isActive = true
        wednesdayBottomView.leftAnchor.constraint(equalTo: wednesdayView.leftAnchor).isActive = true
        wednesdayBottomView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        wednesdayView.addSubview(wednesdayCheckBox)
        wednesdayCheckBox.centerYAnchor.constraint(equalTo: wednesdayView.centerYAnchor).isActive = true
        wednesdayCheckBox.widthAnchor.constraint(equalToConstant: 16).isActive = true
        wednesdayCheckBox.heightAnchor.constraint(equalToConstant: 16).isActive = true
        wednesdayCheckBox.leftAnchor.constraint(equalTo: wednesdayView.leftAnchor).isActive = true
        
        wednesdayView.addSubview(wednesdayTitle)
        wednesdayTitle.topAnchor.constraint(equalTo: wednesdayView.topAnchor).isActive = true
        wednesdayTitle.bottomAnchor.constraint(equalTo: wednesdayView.bottomAnchor).isActive = true
        wednesdayTitle.leftAnchor.constraint(equalTo: wednesdayCheckBox.rightAnchor, constant: 12).isActive = true
        wednesdayTitle.widthAnchor.constraint(equalToConstant: 85).isActive = true
        
        wednesdayView.addSubview(wednesdayHours)
        wednesdayHours.topAnchor.constraint(equalTo: wednesdayView.topAnchor).isActive = true
        wednesdayHours.bottomAnchor.constraint(equalTo: wednesdayView.bottomAnchor).isActive = true
        wednesdayHours.leftAnchor.constraint(equalTo: wednesdayTitle.rightAnchor, constant: 12).isActive = true
        wednesdayHours.rightAnchor.constraint(equalTo: wednesdayPlusIcon.leftAnchor, constant: -12).isActive = true
        
        workhours.addSubview(thursdayView)
        thursdayView.topAnchor.constraint(equalTo: wednesdayView.bottomAnchor).isActive = true
        thursdayView.leftAnchor.constraint(equalTo: workhours.leftAnchor).isActive = true
        thursdayView.rightAnchor.constraint(equalTo: workhours.rightAnchor).isActive = true
        thursdayView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        thursdayView.addSubview(thursdayPlusIcon)
        thursdayPlusIcon.centerYAnchor.constraint(equalTo: thursdayView.centerYAnchor).isActive = true
        thursdayPlusIcon.widthAnchor.constraint(equalToConstant: 16).isActive = true
        thursdayPlusIcon.heightAnchor.constraint(equalToConstant: 16).isActive = true
        thursdayPlusIcon.rightAnchor.constraint(equalTo: thursdayView.rightAnchor).isActive = true
        
        thursdayView.addSubview(thursdayBottomView)
        thursdayBottomView.bottomAnchor.constraint(equalTo: thursdayView.bottomAnchor).isActive = true
        thursdayBottomView.rightAnchor.constraint(equalTo: thursdayView.rightAnchor).isActive = true
        thursdayBottomView.leftAnchor.constraint(equalTo: thursdayView.leftAnchor).isActive = true
        thursdayBottomView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        thursdayView.addSubview(thursdayCheckBox)
        thursdayCheckBox.centerYAnchor.constraint(equalTo: thursdayView.centerYAnchor).isActive = true
        thursdayCheckBox.widthAnchor.constraint(equalToConstant: 16).isActive = true
        thursdayCheckBox.heightAnchor.constraint(equalToConstant: 16).isActive = true
        thursdayCheckBox.leftAnchor.constraint(equalTo: thursdayView.leftAnchor).isActive = true
        
        thursdayView.addSubview(thursdayTitle)
        thursdayTitle.topAnchor.constraint(equalTo: thursdayView.topAnchor).isActive = true
        thursdayTitle.bottomAnchor.constraint(equalTo: thursdayView.bottomAnchor).isActive = true
        thursdayTitle.leftAnchor.constraint(equalTo: thursdayCheckBox.rightAnchor, constant: 12).isActive = true
        thursdayTitle.widthAnchor.constraint(equalToConstant: 85).isActive = true
        
        thursdayView.addSubview(thursdayHours)
        thursdayHours.topAnchor.constraint(equalTo: thursdayView.topAnchor).isActive = true
        thursdayHours.bottomAnchor.constraint(equalTo: thursdayView.bottomAnchor).isActive = true
        thursdayHours.leftAnchor.constraint(equalTo: thursdayTitle.rightAnchor, constant: 12).isActive = true
        thursdayHours.rightAnchor.constraint(equalTo: thursdayPlusIcon.leftAnchor, constant: -12).isActive = true
        
        workhours.addSubview(fridayView)
        fridayView.topAnchor.constraint(equalTo: thursdayView.bottomAnchor).isActive = true
        fridayView.leftAnchor.constraint(equalTo: workhours.leftAnchor).isActive = true
        fridayView.rightAnchor.constraint(equalTo: workhours.rightAnchor).isActive = true
        fridayView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        fridayView.addSubview(fridayPlusIcon)
        fridayPlusIcon.centerYAnchor.constraint(equalTo: fridayView.centerYAnchor).isActive = true
        fridayPlusIcon.widthAnchor.constraint(equalToConstant: 16).isActive = true
        fridayPlusIcon.heightAnchor.constraint(equalToConstant: 16).isActive = true
        fridayPlusIcon.rightAnchor.constraint(equalTo: fridayView.rightAnchor).isActive = true
        
        fridayView.addSubview(fridayBottomView)
        fridayBottomView.bottomAnchor.constraint(equalTo: fridayView.bottomAnchor).isActive = true
        fridayBottomView.rightAnchor.constraint(equalTo: fridayView.rightAnchor).isActive = true
        fridayBottomView.leftAnchor.constraint(equalTo: fridayView.leftAnchor).isActive = true
        fridayBottomView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        fridayView.addSubview(fridayCheckBox)
        fridayCheckBox.centerYAnchor.constraint(equalTo: fridayView.centerYAnchor).isActive = true
        fridayCheckBox.widthAnchor.constraint(equalToConstant: 16).isActive = true
        fridayCheckBox.heightAnchor.constraint(equalToConstant: 16).isActive = true
        fridayCheckBox.leftAnchor.constraint(equalTo: fridayView.leftAnchor).isActive = true
        
        fridayView.addSubview(fridayTitle)
        fridayTitle.topAnchor.constraint(equalTo: fridayView.topAnchor).isActive = true
        fridayTitle.bottomAnchor.constraint(equalTo: fridayView.bottomAnchor).isActive = true
        fridayTitle.leftAnchor.constraint(equalTo: fridayCheckBox.rightAnchor, constant: 12).isActive = true
        fridayTitle.widthAnchor.constraint(equalToConstant: 85).isActive = true
        
        fridayView.addSubview(fridayHours)
        fridayHours.topAnchor.constraint(equalTo: fridayView.topAnchor).isActive = true
        fridayHours.bottomAnchor.constraint(equalTo: fridayView.bottomAnchor).isActive = true
        fridayHours.leftAnchor.constraint(equalTo: fridayTitle.rightAnchor, constant: 12).isActive = true
        fridayHours.rightAnchor.constraint(equalTo: fridayPlusIcon.leftAnchor, constant: -12).isActive = true
        
        workhours.addSubview(saturdayView)
        saturdayView.topAnchor.constraint(equalTo: fridayView.bottomAnchor).isActive = true
        saturdayView.leftAnchor.constraint(equalTo: workhours.leftAnchor).isActive = true
        saturdayView.rightAnchor.constraint(equalTo: workhours.rightAnchor).isActive = true
        saturdayView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        saturdayView.addSubview(saturdayPlusIcon)
        saturdayPlusIcon.centerYAnchor.constraint(equalTo: saturdayView.centerYAnchor).isActive = true
        saturdayPlusIcon.widthAnchor.constraint(equalToConstant: 16).isActive = true
        saturdayPlusIcon.heightAnchor.constraint(equalToConstant: 16).isActive = true
        saturdayPlusIcon.rightAnchor.constraint(equalTo: saturdayView.rightAnchor).isActive = true
        
        saturdayView.addSubview(saturdayBottomView)
        saturdayBottomView.bottomAnchor.constraint(equalTo: saturdayView.bottomAnchor).isActive = true
        saturdayBottomView.rightAnchor.constraint(equalTo: saturdayView.rightAnchor).isActive = true
        saturdayBottomView.leftAnchor.constraint(equalTo: saturdayView.leftAnchor).isActive = true
        saturdayBottomView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        saturdayView.addSubview(saturdayCheckBox)
        saturdayCheckBox.centerYAnchor.constraint(equalTo: saturdayView.centerYAnchor).isActive = true
        saturdayCheckBox.widthAnchor.constraint(equalToConstant: 16).isActive = true
        saturdayCheckBox.heightAnchor.constraint(equalToConstant: 16).isActive = true
        saturdayCheckBox.leftAnchor.constraint(equalTo: saturdayView.leftAnchor).isActive = true
        
        saturdayView.addSubview(saturdayTitle)
        saturdayTitle.topAnchor.constraint(equalTo: saturdayView.topAnchor).isActive = true
        saturdayTitle.bottomAnchor.constraint(equalTo: saturdayView.bottomAnchor).isActive = true
        saturdayTitle.leftAnchor.constraint(equalTo: fridayCheckBox.rightAnchor, constant: 12).isActive = true
        saturdayTitle.widthAnchor.constraint(equalToConstant: 85).isActive = true
        
        saturdayView.addSubview(saturdayHours)
        saturdayHours.topAnchor.constraint(equalTo: saturdayView.topAnchor).isActive = true
        saturdayHours.bottomAnchor.constraint(equalTo: saturdayView.bottomAnchor).isActive = true
        saturdayHours.leftAnchor.constraint(equalTo: saturdayTitle.rightAnchor, constant: 12).isActive = true
        saturdayHours.rightAnchor.constraint(equalTo: saturdayPlusIcon.leftAnchor, constant: -12).isActive = true
        
        workhours.addSubview(sundayView)
        sundayView.topAnchor.constraint(equalTo: saturdayView.bottomAnchor).isActive = true
        sundayView.leftAnchor.constraint(equalTo: workhours.leftAnchor).isActive = true
        sundayView.rightAnchor.constraint(equalTo: workhours.rightAnchor).isActive = true
        sundayView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        sundayView.addSubview(sundayPlusIcon)
        sundayPlusIcon.centerYAnchor.constraint(equalTo: sundayView.centerYAnchor).isActive = true
        sundayPlusIcon.widthAnchor.constraint(equalToConstant: 16).isActive = true
        sundayPlusIcon.heightAnchor.constraint(equalToConstant: 16).isActive = true
        sundayPlusIcon.rightAnchor.constraint(equalTo: sundayView.rightAnchor).isActive = true
        
        sundayView.addSubview(sundayBottomView)
        sundayBottomView.bottomAnchor.constraint(equalTo: sundayView.bottomAnchor).isActive = true
        sundayBottomView.rightAnchor.constraint(equalTo: sundayView.rightAnchor).isActive = true
        sundayBottomView.leftAnchor.constraint(equalTo: sundayView.leftAnchor).isActive = true
        sundayBottomView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        sundayView.addSubview(sundayCheckBox)
        sundayCheckBox.centerYAnchor.constraint(equalTo: sundayView.centerYAnchor).isActive = true
        sundayCheckBox.widthAnchor.constraint(equalToConstant: 16).isActive = true
        sundayCheckBox.heightAnchor.constraint(equalToConstant: 16).isActive = true
        sundayCheckBox.leftAnchor.constraint(equalTo: sundayView.leftAnchor).isActive = true
        
        sundayView.addSubview(sundayTitle)
        sundayTitle.topAnchor.constraint(equalTo: sundayView.topAnchor).isActive = true
        sundayTitle.bottomAnchor.constraint(equalTo: sundayView.bottomAnchor).isActive = true
        sundayTitle.leftAnchor.constraint(equalTo: sundayCheckBox.rightAnchor, constant: 12).isActive = true
        sundayTitle.widthAnchor.constraint(equalToConstant: 85).isActive = true
        
        sundayView.addSubview(sundayHours)
        sundayHours.topAnchor.constraint(equalTo: sundayView.topAnchor).isActive = true
        sundayHours.bottomAnchor.constraint(equalTo: sundayView.bottomAnchor).isActive = true
        sundayHours.leftAnchor.constraint(equalTo: sundayTitle.rightAnchor, constant: 12).isActive = true
        sundayHours.rightAnchor.constraint(equalTo: sundayPlusIcon.leftAnchor, constant: -12).isActive = true
        
        scrollView.addSubview(socialLabel)
        socialLabel.topAnchor.constraint(equalTo: sundayView.bottomAnchor, constant: 25).isActive = true
        socialLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        socialLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        socialLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(instagramView)
        instagramView.topAnchor.constraint(equalTo: socialLabel.bottomAnchor, constant: 20).isActive = true
        instagramView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        instagramView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        instagramView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        instagramView.addSubview(instagramTitleLabel)
        instagramTitleLabel.centerYAnchor.constraint(equalTo: instagramView.centerYAnchor).isActive = true
        instagramTitleLabel.leftAnchor.constraint(equalTo: instagramView.leftAnchor).isActive = true
        instagramTitleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        instagramTitleLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        instagramView.addSubview(instagramChevron1)
        instagramChevron1.rightAnchor.constraint(equalTo: instagramView.rightAnchor).isActive = true
        instagramChevron1.centerYAnchor.constraint(equalTo: instagramView.centerYAnchor).isActive = true
        instagramChevron1.widthAnchor.constraint(equalToConstant: 20).isActive = true
        instagramChevron1.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        instagramView.addSubview(instagramLabel)
        instagramLabel.centerYAnchor.constraint(equalTo: instagramView.centerYAnchor).isActive = true
        instagramLabel.rightAnchor.constraint(equalTo: instagramChevron1.leftAnchor, constant: -12).isActive = true
        instagramLabel.leftAnchor.constraint(equalTo: instagramTitleLabel.rightAnchor, constant: 12).isActive = true
        instagramLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        instagramView.addSubview(instagramButton)
        instagramButton.topAnchor.constraint(equalTo: instagramView.topAnchor).isActive = true
        instagramButton.leftAnchor.constraint(equalTo: instagramView.leftAnchor).isActive = true
        instagramButton.rightAnchor.constraint(equalTo: instagramView.rightAnchor).isActive = true
        instagramButton.bottomAnchor.constraint(equalTo: instagramView.bottomAnchor).isActive = true
        
        scrollView.addSubview(facebookView)
        facebookView.topAnchor.constraint(equalTo: instagramView.bottomAnchor).isActive = true
        facebookView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        facebookView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        facebookView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        facebookView.addSubview(facebookTitleLabel)
        facebookTitleLabel.centerYAnchor.constraint(equalTo: facebookView.centerYAnchor).isActive = true
        facebookTitleLabel.leftAnchor.constraint(equalTo: facebookView.leftAnchor).isActive = true
        facebookTitleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        facebookTitleLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        facebookView.addSubview(facebookChevron1)
        facebookChevron1.rightAnchor.constraint(equalTo: facebookView.rightAnchor).isActive = true
        facebookChevron1.centerYAnchor.constraint(equalTo: facebookView.centerYAnchor).isActive = true
        facebookChevron1.widthAnchor.constraint(equalToConstant: 20).isActive = true
        facebookChevron1.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        facebookView.addSubview(facebookLabel)
        facebookLabel.centerYAnchor.constraint(equalTo: facebookView.centerYAnchor).isActive = true
        facebookLabel.rightAnchor.constraint(equalTo: facebookChevron1.leftAnchor, constant: -12).isActive = true
        facebookLabel.leftAnchor.constraint(equalTo: facebookTitleLabel.rightAnchor, constant: 12).isActive = true
        facebookLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        facebookView.addSubview(facebookButton)
        facebookButton.topAnchor.constraint(equalTo: facebookView.topAnchor).isActive = true
        facebookButton.leftAnchor.constraint(equalTo: facebookView.leftAnchor).isActive = true
        facebookButton.rightAnchor.constraint(equalTo: facebookView.rightAnchor).isActive = true
        facebookButton.bottomAnchor.constraint(equalTo: facebookView.bottomAnchor).isActive = true
        
        backend()
    }
    
    func backend() {
        checkGeneral()
        checkHours()
        checkSocialMedia()
    }
    
    func checkSocialMedia() {
        findSocialAccounts(withUid: Auth.auth().currentUser!.uid)
    }
    
    func checkHours() {
        self.findWorkHours(withUid: Auth.auth().currentUser!.uid)
    }
    
    func checkGeneral() {
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("name").observe(DataEventType.value) { (name) in
            if let name = name.value as? String {
                self.label1.text = name
            } else {
                self.label1.text = "Not Set"
            }
        }
        
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("email").observe(DataEventType.value) { (email) in
            if let email = email.value as? String {
                self.label2.text = email
            } else {
                self.label2.text = "Not Set"
            }
        }
        
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("description").observe(DataEventType.value) { (description) in
            if let description = description.value as? String {
                self.label3.text = description
            } else {
                self.label3.text = "Not Set"
            }
        }
        
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("phonenumber").observe(DataEventType.value) { (phonenum) in
            if let phonenum = phonenum.value as? String {
                let phoneNumberKit = PhoneNumberKit()
                do {
                    let phoneNumber = try phoneNumberKit.parse(phonenum)
                    self.label4.text = phoneNumberKit.format(phoneNumber, toType: PhoneNumberFormat.international)
                } catch {
                    self.label4.text = "Not Set"
                }
            } else {
                self.label4.text = "Not Set"
            }
        }
        
//        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("zipcode").observe(DataEventType.value) { (zipcode) in
//            if let zipcode = zipcode.value as? Int {
//                self.label5.text = String(zipcode)
//            } else {
//                self.label5.text = "Not Set"
//            }
//        }
//
//        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("dob").observe(DataEventType.value) { (dob) in
//            if let dob = dob.value as? String {
//                self.label6.text = dob
//            } else {
//                self.label6.text = "Not Set"
//            }
//        }
    }

    @objc func updatePressed() {
        saveData()
    }
    
    private func saveData() {
        MBProgressHUD.showAdded(to: view, animated: true)
        uploadImage()
        uploadGeneralInformation()
        uploadWorkHours()
        uploadSocialMedia()
        MBProgressHUD.hide(for: view, animated: true)
        completionAlert()
    }
    
    private func uploadImage() {
        if imageHasBeenChanged {
            guard let imageData = profileImageView.image?.jpegData(compressionQuality: 0.8) else { return }
            let storageRef = Storage.storage().reference()
            let storageProfileRef = storageRef.child("Profile").child("\(Auth.auth().currentUser!.uid)").child("ProfileImage")
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            storageProfileRef.putData(imageData, metadata: metadata) { (storageMetadata, putDataError) in
                if putDataError == nil && storageMetadata != nil {
                    storageProfileRef.downloadURL { (url, downloadUrlError) in
                        if let metaImageUrl = url?.absoluteString {
                            Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("profile-image").setValue(metaImageUrl, withCompletionBlock: { (addInfoError, result) in
                                if addInfoError == nil {
                                    print("uploaded successfully")
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    private func uploadGeneralInformation() {
        setFullName()
        setEmail()
        setDescription()
        setPhoneNumber()
//        setZipcode()
//        setDateOfBirth()
    }
    
    private func setFullName() {
        if label1.text != "Not Set" && label1.text != nil {
            uploadData(withChildName: "name", withValue: label1.text!, withIntValue: 0, wiithExtraChild: "")
        }
    }
    
    private func setEmail() {
        if label2.text != "Not Set" && label2.text != nil {
            uploadData(withChildName: "email", withValue: label2.text!, withIntValue: 0, wiithExtraChild: "")
        }
    }
    
    private func setDescription() {
        if label3.text != "Not Set" && label3.text != nil {
            uploadData(withChildName: "description", withValue: label3.text!, withIntValue: 0, wiithExtraChild: "")
        }
    }
    
    private func setPhoneNumber() {
        if label4.text != "Not Set" && label4.text != nil {
            let phoneNumberKit = PhoneNumberKit()
            do {
                let phoneNumber = try phoneNumberKit.parse(label4.text!)
                uploadData(withChildName: "phonenumber", withValue: phoneNumberKit.format(phoneNumber, toType: PhoneNumberFormat.e164), withIntValue: 0, wiithExtraChild: "")
            } catch {
                print("could not upload a valid e164 value")
            }
        }
    }
    
//    private func setZipcode() {
//        if label5.text != "Not Set" && label5.text != nil {
//            uploadData(withChildName: "zipcode", withValue: "", withIntValue: Int(label5.text!)!, wiithExtraChild: "")
//        }
//    }
//
//    private func setDateOfBirth() {
//        if label6.text != "Not Set" && label6.text != nil {
//            uploadData(withChildName: "dob", withValue: label6.text!, withIntValue: 0, wiithExtraChild: "")
//        }
//    }
    
    private func uploadSocialMedia() {
        setInstagram()
        setFacebook()
    }
    
    private func setInstagram() {
        if instagramLabel.text != "Not Set" && instagramLabel.text != nil {
            uploadData(withChildName: "instagram", withValue: instagramLabel.text!, withIntValue: 0, wiithExtraChild: "social")
        }
    }
    
    private func setFacebook() {
        if facebookLabel.text != "Not Set" && facebookLabel.text != nil {
            uploadData(withChildName: "facebook", withValue: facebookLabel.text!, withIntValue: 0, wiithExtraChild: "social")
        }
    }
    
    private func uploadWorkHours() {
        setMonday()
        setTuesday()
        setWednesday()
        setThursday()
        setFriday()
        setSaturday()
        setSunday()
    }
    
    private func setMonday() {
        if mondayCheckBox.isChecked {
            if let hours = mondayHours.text {
                uploadHours(withChild: "monday", withValue: hours)
            }
        } else {
            removeHours(withChild: "monday")
        }
    }
    
    private func setTuesday() {
        if tuesdayCheckBox.isChecked {
            if let hours = tuesdayHours.text {
                uploadHours(withChild: "tuesday", withValue: hours)
            }
        } else {
            removeHours(withChild: "tuesday")
        }
    }
    
    private func setWednesday() {
        if wednesdayCheckBox.isChecked {
            if let hours = wednesdayHours.text {
                uploadHours(withChild: "wednesday", withValue: hours)
            }
        } else {
            removeHours(withChild: "wednesday")
        }
    }
    
    private func setThursday() {
        if thursdayCheckBox.isChecked {
            if let hours = thursdayHours.text {
                uploadHours(withChild: "thursday", withValue: hours)
            }
        } else {
            removeHours(withChild: "thursday")
        }
    }
    
    private func setFriday() {
        if fridayCheckBox.isChecked {
            if let hours = fridayHours.text {
                uploadHours(withChild: "friday", withValue: hours)
            }
        } else {
            removeHours(withChild: "friday")
        }
    }
    
    private func setSaturday() {
        if saturdayCheckBox.isChecked {
            if let hours = saturdayHours.text {
                uploadHours(withChild: "saturday", withValue: hours)
            }
        } else {
            removeHours(withChild: "saturday")
        }
    }
    
    private func setSunday() {
        if sundayCheckBox.isChecked {
            if let hours = sundayHours.text {
                uploadHours(withChild: "sunday", withValue: hours)
            }
        } else {
            removeHours(withChild: "sunday")
        }
    }
    
    private func uploadData(withChildName child: String, withValue value: String, withIntValue intValue: Int, wiithExtraChild extraChild: String) {
        if intValue != 0 {
            Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child(child).setValue(intValue)
        }
        if value != "" {
            Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child(child).setValue(value)
        }
        if extraChild != "" {
            Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child(extraChild).child(child).setValue(value)
        }
    }
    
    private func uploadHours(withChild child: String, withValue value: String) {
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("work-hours").child(child).setValue(value)
    }
    
    private func removeHours(withChild child: String) {
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("work-hours").child(child).removeValue()
    }
    
    private func completionAlert() {
        let alert = UIAlertController(title: "Complete", message: "Your profile has been updated!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func openImgePicker() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func onMondayCheck(_ sender: CheckBox) {
        mondayOn.toggle()
        checkMonday()
    }
    
    @objc func onTuesdayCheck(_ sender: CheckBox) {
        tuesdayOn.toggle()
        checkTuesday()
    }
    
    @objc func onWednesdayCheck(_ sender: CheckBox) {
        wednesdayOn.toggle()
        checkWednesday()
    }
    
    @objc func onThursdayCheck(_ sender: CheckBox) {
        thursdayOn.toggle()
        checkThursday()
    }
    
    @objc func onFridayCheck(_ sender: CheckBox) {
        fridayOn.toggle()
        checkFriday()
    }
    
    @objc func onSaturdayCheck(_ sender: CheckBox) {
        saturdayOn.toggle()
        checkSaturday()
    }
    
    @objc func onSundayCheck(_ sender: CheckBox) {
        sundayOn.toggle()
        checkSunday()
    }
    
    func checkMonday() {
        if mondayOn {
//            if let monday = hours?.monday {
//                if monday != "Not Set" {
//                    mondayHours.text = monday
//                }
//            }
            mondayCheckBox.isChecked = true
            mondayTitle.textColor = UIColor.selectedColor
            mondayHours.textColor = UIColor.boldSelectedColor
        } else {
            mondayCheckBox.isChecked = false
            mondayTitle.textColor = UIColor.unselectedColor
            mondayHours.textColor = UIColor.unselectedColor
        }
    }
    
    func checkTuesday() {
        if tuesdayOn {
//            if let tuesday = hours?.tuesday {
//                if tuesday != "Not Set" {
//                    tuesdayHours.text = tuesday
//                }
//            }
            tuesdayCheckBox.isChecked = true
            tuesdayTitle.textColor = UIColor.selectedColor
            tuesdayHours.textColor = UIColor.boldSelectedColor
        } else {
            tuesdayCheckBox.isChecked = false
            tuesdayTitle.textColor = UIColor.unselectedColor
            tuesdayHours.textColor = UIColor.unselectedColor
        }
    }
    
    func checkWednesday() {
        if wednesdayOn {
//            if let wednesday = hours?.wednesday {
//                if wednesday != "Not Set" {
//                    wednesdayHours.text = wednesday
//                }
//            }
            wednesdayCheckBox.isChecked = true
            wednesdayTitle.textColor = UIColor.selectedColor
            wednesdayHours.textColor = UIColor.boldSelectedColor
        } else {
            wednesdayCheckBox.isChecked = false
            wednesdayTitle.textColor = UIColor.unselectedColor
            wednesdayHours.textColor = UIColor.unselectedColor
        }
    }
    
    func checkThursday() {
        if thursdayOn {
//            if let thursday = hours?.thursday {
//                if thursday != "Not Set" {
//                    thursdayHours.text = thursday
//                }
//            }
            thursdayCheckBox.isChecked = true
            thursdayTitle.textColor = UIColor.selectedColor
            thursdayHours.textColor = UIColor.boldSelectedColor
        } else {
            thursdayCheckBox.isChecked = false
            thursdayTitle.textColor = UIColor.unselectedColor
            thursdayHours.textColor = UIColor.unselectedColor
        }
    }
    
    func checkFriday() {
        if fridayOn {
//            if let friday = hours?.friday {
//                if friday != "Not Set" {
//                    fridayHours.text = friday
//                }
//            }
            fridayCheckBox.isChecked = true
            fridayTitle.textColor = UIColor.selectedColor
            fridayHours.textColor = UIColor.boldSelectedColor
        } else {
            fridayCheckBox.isChecked = false
            fridayTitle.textColor = UIColor.unselectedColor
            fridayHours.textColor = UIColor.unselectedColor
        }
    }
    
    func checkSaturday() {
        if saturdayOn {
//            if let saturday = hours?.saturday {
//                if saturday != "Not Set" {
//                    saturdayHours.text = saturday
//                }
//            }
            saturdayCheckBox.isChecked = true
            saturdayTitle.textColor = UIColor.selectedColor
            saturdayHours.textColor = UIColor.boldSelectedColor
        } else {
            saturdayCheckBox.isChecked = false
            saturdayTitle.textColor = UIColor.unselectedColor
            saturdayHours.textColor = UIColor.unselectedColor
        }
    }
    
    func checkSunday() {
        if sundayOn {
//            if let sunday = hours?.sunday {
//                if sunday != "Not Set" {
//                    sundayHours.text = sunday
//                }
//            }
            sundayCheckBox.isChecked = true
            sundayTitle.textColor = UIColor.selectedColor
            sundayHours.textColor = UIColor.boldSelectedColor
        } else {
            sundayCheckBox.isChecked = false
            sundayTitle.textColor = UIColor.unselectedColor
            sundayHours.textColor = UIColor.unselectedColor
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            profileImageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage{
            profileImageView.image = originalImage
        }
        imageHasBeenChanged = true
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editProfileHours", for: indexPath) as! WorkHourEditCell
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hi")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            start = data[component][row]
        case 1:
            end = data[component][row]
        default:
            break
        }
    }
    
    func basicSetup() {
        let doneButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(updatePressed))
        doneButton.tintColor = UIColor.mainBlue
        
        view.backgroundColor = UIColor.white
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.barTintColor = UIColor.white
        title = "Edit Profile"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func findWorkHours(withUid uid: String) {
        Database.database().reference().child("Users").child(uid).child("work-hours").observe(.value) { (descriptionSnap) in
            if let value = descriptionSnap.value as? [String : Any] {
                let hours = WorkingHoursStructure()
                hours.monday = value["monday"] as? String ?? "Not Set"
                hours.tuesday = value["tuesday"] as? String ?? "Not Set"
                hours.wednesday = value["wednesday"] as? String ?? "Not Set"
                hours.thursday = value["thursday"] as? String ?? "Not Set"
                hours.friday = value["friday"] as? String ?? "Not Set"
                hours.saturday = value["saturday"] as? String ?? "Not Set"
                hours.sunday = value["sunday"] as? String ?? "Not Set"
                self.hours = hours
            } else {
                let hours = WorkingHoursStructure()
                hours.monday = "Not Set"
                hours.tuesday = "Not Set"
                hours.wednesday = "Not Set"
                hours.thursday = "Not Set"
                hours.friday = "Not Set"
                hours.saturday = "Not Set"
                hours.sunday = "Not Set"
                self.hours = hours
            }
        }
    }
    
    private func findSocialAccounts(withUid uid: String) {
        Database.database().reference().child("Users").child(uid).child("social").child("instagram").observe(.value) { (instagramSnap) in
            if let instagram = instagramSnap.value as? String {
                // we have intagram
                self.instagramLabel.text = instagram
            } else {
                self.instagramLabel.text = "Not Set"
                // no instagram
            }
        }
        
        Database.database().reference().child("Users").child(uid).child("social").child("facebook").observe(.value) { (instagramSnap) in
            if let instagram = instagramSnap.value as? String {
                // we have intagram
                self.facebookLabel.text = instagram
            } else {
                self.facebookLabel.text = "Not Set"
                // no instagram
            }
        }
    }
    
    private func showInputPopUp(withTitle title: String, keyboardType: UIKeyboardType, placeholder: String, labelToChange label: UILabel, capitalization: UITextAutocapitalizationType, autocorrect: UITextAutocorrectionType, phoneformat: Bool, isDatePicker: Bool) {
        if let window = UIApplication.shared.keyWindow {
            
            removeFromSuperView()
            
            blackView.translatesAutoresizingMaskIntoConstraints = false
            blackView.backgroundColor = UIColor.black
            blackView.alpha = 0.0
            blackView.frame = window.frame
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideInputPopup)))
            window.addSubview(blackView)
            window.addSubview(filterView)
            let y = window.frame.height - inputPopupHeight
            filterView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: inputPopupHeight)
            
            inputTextField.placeholder = placeholder
            inputTextField.autocapitalizationType = capitalization
            inputTextField.keyboardType = keyboardType
            inputTextField.autocorrectionType = autocorrect
            
            if phoneformat {
                self.format = true
            } else {
                self.format = false
            }
            
            if isDatePicker {
                self.inputTextField.inputAccessoryView?.isHidden = false
                self.inputTextField.setInputViewDatePickerForSignUp(target: self, selector: #selector(donePressed))
            } else {
                self.inputTextField.inputAccessoryView?.isHidden = true
            }
            
            titleInputPopup.text = title
            
            UIView.animate(withDuration: 0.5) {
                self.blackView.alpha = 0.5
                self.filterView.frame = CGRect(x: 0, y: y, width: self.filterView.frame.width, height: self.filterView.frame.height)
            } completion: { (true) in
                self.setupInputView()
            }
        }
    }
    
    private func showDatePopUp(withTitle title: String, dayOfWeek day: String) {
        if let window = UIApplication.shared.keyWindow {
            
            // remove objects from superview
            removeFromSuperView()
            
            // setup external view stuff
            blackView.translatesAutoresizingMaskIntoConstraints = false
            blackView.backgroundColor = UIColor.black
            blackView.alpha = 0.0
            blackView.frame = window.frame
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideInputPopup)))
            window.addSubview(blackView)
            window.addSubview(filterView)
            let y = window.frame.height - inputPopupHeight
            filterView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: inputPopupHeight)
            
            // setup ui from function throwers
            titleInputPopup.text = title
            
            UIView.animate(withDuration: 0.5) {
                self.blackView.alpha = 0.5
                self.filterView.frame = CGRect(x: 0, y: y, width: self.filterView.frame.width, height: self.filterView.frame.height)
            } completion: { (true) in
                self.setupDateView()
            }
        }
    }
    
    func setupDateView() {
        filterView.addSubview(exitButton)
        exitButton.addTarget(self, action: #selector(hideInputPopup), for: .touchUpInside)
        exitButton.rightAnchor.constraint(equalTo: filterView.rightAnchor, constant: -16).isActive = true
        exitButton.topAnchor.constraint(equalTo: filterView.topAnchor, constant: 16).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        filterView.addSubview(titleInputPopup)
        titleInputPopup.topAnchor.constraint(equalTo: exitButton.bottomAnchor).isActive = true
        titleInputPopup.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        titleInputPopup.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        titleInputPopup.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        filterView.addSubview(cancelButton)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -44).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        filterView.addSubview(saveButton)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        saveButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        saveButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -28).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        filterView.addSubview(datePicker)
        datePicker.delegate = self
        datePicker.dataSource = self
        datePicker.topAnchor.constraint(equalTo: titleInputPopup.bottomAnchor, constant: 15).isActive = true
        datePicker.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        datePicker.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: 15).isActive = true
    }
    
    func setupInputView() {
        
        exitButton.addTarget(self, action: #selector(hideInputPopup), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(mainButtonPressed), for: .touchUpInside)
        
        filterView.addSubview(exitButton)
        exitButton.rightAnchor.constraint(equalTo: filterView.rightAnchor, constant: -16).isActive = true
        exitButton.topAnchor.constraint(equalTo: filterView.topAnchor, constant: 16).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        filterView.addSubview(titleInputPopup)
        titleInputPopup.topAnchor.constraint(equalTo: exitButton.bottomAnchor).isActive = true
        titleInputPopup.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        titleInputPopup.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        titleInputPopup.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        filterView.addSubview(inputTextField)
        inputTextField.delegate = self
        inputTextField.topAnchor.constraint(equalTo: titleInputPopup.bottomAnchor, constant: 15).isActive = true
        inputTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        inputTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        inputTextField.becomeFirstResponder()

        filterView.addSubview(loginButton)
        loginButton.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 15).isActive = true
        loginButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        loginButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    @objc func mainButtonPressed() {
        if inputTextField.text != "" {
            labelToChange?.text = inputTextField.text
            hideInputPopup()
        }
    }
    
    @objc func cancelTapped() {
        removeFromSuperView()
        hideInputPopup()
    }
    
    @objc func saveTapped() {
        // other stuff
        labelToChange?.text = "\(start) - \(end)"
        removeFromSuperView()
        hideInputPopup()
    }
    
    func removeFromSuperView() {
        cancelButton.removeFromSuperview()
        saveButton.removeFromSuperview()
        datePicker.removeFromSuperview()
        titleInputPopup.removeFromSuperview()
        inputTextField.removeFromSuperview()
        loginButton.removeFromSuperview()
    }
    
    @objc func hideInputPopup() {
        inputTextField.resignFirstResponder()
        removeFromSuperView()
        inputTextField.text = nil
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0.0
            if let window = UIApplication.shared.keyWindow {
                self.filterView.frame = CGRect(x: 0, y: window.frame.height, width: self.filterView.frame.width, height: self.filterView.frame.height)
            }
        }
    }
    
    @objc func donePressed() {
        if let datePicker = self.inputTextField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            inputTextField.text = dateFormatter.string(from: datePicker.date)
        }
    }
    
    @objc func button1Tap() {
        labelToChange = label1
        showInputPopUp(withTitle: "Full Name", keyboardType: .default, placeholder: "Write Your Full Name", labelToChange: label1, capitalization: .words, autocorrect: .no, phoneformat: false, isDatePicker: false)
    }
    
    @objc func button2Tap() {
        labelToChange = label2
        showInputPopUp(withTitle: "Email", keyboardType: .emailAddress, placeholder: "Enter Your Email", labelToChange: label2, capitalization: .none, autocorrect: .no, phoneformat: false, isDatePicker: false)
    }
    
    @objc func button3Tap() {
        labelToChange = label3
        showInputPopUp(withTitle: "Description", keyboardType: .default, placeholder: "Write a Description", labelToChange: label3, capitalization: .sentences, autocorrect: .no, phoneformat: false, isDatePicker: false)
    }
    
    @objc func button4Tap() {
        labelToChange = label4
        showInputPopUp(withTitle: "Phone Number", keyboardType: .phonePad, placeholder: "Enter your Phone Number", labelToChange: label4, capitalization: .sentences, autocorrect: .no, phoneformat: true, isDatePicker: false)
    }
    
//    @objc func button5Tap() {
//        labelToChange = label5
//        showInputPopUp(withTitle: "Zipcode", keyboardType: .phonePad, placeholder: "Enter your Zipcode", labelToChange: label5, capitalization: .none, autocorrect: .no, phoneformat: false, isDatePicker: false)
//    }
//
//    @objc func button6Tap() {
//        labelToChange = label6
//        showInputPopUp(withTitle: "Date of Birth", keyboardType: .default, placeholder: "Enter your date of birth", labelToChange: label6, capitalization: .none, autocorrect: .no, phoneformat: false, isDatePicker: true)
//    }
    
    @objc func instagramTapped() {
        labelToChange = instagramLabel
        showInputPopUp(withTitle: "Instagram Account", keyboardType: .default, placeholder: "Your Instagram Account", labelToChange: instagramLabel, capitalization: .none, autocorrect: .no, phoneformat: false, isDatePicker: false)
    }
    
    @objc func facebookTapped() {
        labelToChange = facebookLabel
        showInputPopUp(withTitle: "Facebook Username", keyboardType: .default, placeholder: "Your Facebook Username", labelToChange: facebookLabel, capitalization: .none, autocorrect: .no, phoneformat: false, isDatePicker: false)
    }
    
    @objc func mondayTapped() {
        labelToChange = mondayHours
        showDatePopUp(withTitle: "Monday Hours", dayOfWeek: "Monday")
    }
    
    @objc func tuesdayTapped() {
        labelToChange = tuesdayHours
        showDatePopUp(withTitle: "Tuesday Hours", dayOfWeek: "Tuesday")
    }
    
    @objc func wednesdayTapped() {
        labelToChange = wednesdayHours
        showDatePopUp(withTitle: "Wednesday Hours", dayOfWeek: "Wednesday")
    }
    
    @objc func thursdayTapped() {
        labelToChange = thursdayHours
        showDatePopUp(withTitle: "Thursday Hours", dayOfWeek: "Thursday")
    }
    
    @objc func fridayTapped() {
        labelToChange = fridayHours
        showDatePopUp(withTitle: "Friday Hours", dayOfWeek: "Friday")
    }
    
    @objc func saturdayTapped() {
        labelToChange = saturdayHours
        showDatePopUp(withTitle: "Saturday Hours", dayOfWeek: "Saturday")
    }
    
    @objc func sundayTapped() {
        labelToChange = sundayHours
        showDatePopUp(withTitle: "Sunday Hours", dayOfWeek: "Sunday")
    }
    
    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == inputTextField && self.format == true{
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = format(with: "+X (XXX) XXX-XXXX", phone: newString)
            return false
        }
        return true
    }
}
