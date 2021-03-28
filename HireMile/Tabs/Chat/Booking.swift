//
//  Booking.swift
//  HireMile
//
//  Created by JJ Zapata on 3/23/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit
import FSCalendar
import DatePickerDialog

class Booking: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    var dates = [Date]()
    
    var categoryCollectionView : UICollectionView?
    
    var repeatBool = true
    
    var wasSelected = true
    
    var indexSelected = 0
    
    var startTimeSet = false
    
    var startTime = ""
    
    var endTimeSet = false
    
    var endTime = ""
    
    var selectedDate : Date?
    
    var selectedStart : Int?
    
    var selectedEnd : Int?
    
    var typePicker : String?
    
    let timePicker : UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor.white
        return scrollView
    }()
    
    let monthLabel : UILabel = {
        let label = UILabel()
        label.text = "Hey"
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let separaterView0 : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let calendar : FSCalendar = {
        let calendar = FSCalendar()
        calendar.pagingEnabled = true
        calendar.scrollEnabled = true
        calendar.allowsSelection = true
        calendar.allowsMultipleSelection = false
        calendar.appearance.selectionColor = UIColor.mainBlue
        calendar.adjustsBoundingRectWhenChangingMonths = false
        calendar.appearance.titleSelectionColor = UIColor.white
        calendar.appearance.headerTitleAlignment = NSTextAlignment.center
        calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 18)
        calendar.appearance.todayColor = UIColor(red: 3/255, green: 15/255, blue: 65/255, alpha: 1)
        calendar.appearance.headerTitleColor = UIColor(red: 3/255, green: 31/255, blue: 65/255, alpha: 1)
        calendar.appearance.weekdayTextColor = UIColor(red: 3/255, green: 15/255, blue: 65/255, alpha: 1)
        calendar.backgroundColor = UIColor.white
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    
    let separaterView1 : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1)
        return view
    }()
    
    let startTimeView : UIButton = {
        let button = UIButton(type: .system)
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 15
        button.titleLabel?.numberOfLines = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startTimePressed), for: UIControl.Event.touchUpInside)
        button.layer.borderColor = UIColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        return button
    }()
    
    let endTimeView : UIButton = {
        let button = UIButton(type: .system)
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 15
        button.titleLabel?.numberOfLines = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(endTimePressed), for: UIControl.Event.touchUpInside)
        button.layer.borderColor = UIColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        return button
    }()
    
    let separaterView2 : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1)
        return view
    }()
    
    let totalHoursTitleLabel : UILabel = {
        let label = UILabel()
        label.text = "Total Hours"
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let totalHoursLabel : UILabel = {
        let label = UILabel()
        label.text = "0 Hours"
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.right
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let costTitleLabel : UILabel = {
        let label = UILabel()
        label.text = "Total Cost"
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let costLabel : UILabel = {
        let label = UILabel()
        label.text = "$0"
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.right
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let profileImage : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let userNameLabel : UILabel = {
        let label = UILabel()
        label.text = "Name Here"
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let signUpButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Book", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.mainBlue
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 22.5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(bookNowPressed), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        navigationItem.title = "Book an Appointment"
        
        updateViewConstraints()

        // Do any additional setup after loading the view.
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        view.addSubview(scrollView)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: view.frame.width, height: 830)
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        
        scrollView.addSubview(separaterView0)
        separaterView0.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        separaterView0.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        separaterView0.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        separaterView0.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        scrollView.addSubview(calendar)
        calendar.delegate = self
        calendar.dataSource = self
        calendar.topAnchor.constraint(equalTo: separaterView0.bottomAnchor, constant: 5).isActive = true
        calendar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        calendar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        calendar.heightAnchor.constraint(equalToConstant: 350).isActive = true
        
        scrollView.addSubview(separaterView1)
        separaterView1.topAnchor.constraint(equalTo: calendar.bottomAnchor).isActive = true
        separaterView1.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        separaterView1.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        separaterView1.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        scrollView.addSubview(startTimeView)
        let startTimeTitle = NSMutableAttributedString(string: "START TIME", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)])
        if startTimeSet {
            let startTimeSet = NSAttributedString(string: "\n\(startTime)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)])
            startTimeTitle.append(startTimeSet)
        } else {
            let startTimeSet = NSAttributedString(string: "\nNot Set", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)])
            startTimeTitle.append(startTimeSet)
        }
        startTimeView.setAttributedTitle(startTimeTitle, for: .normal)
        startTimeView.topAnchor.constraint(equalTo: separaterView1.bottomAnchor, constant: 42).isActive = true
        startTimeView.widthAnchor.constraint(equalToConstant: (view.frame.size.width - 72) / 2).isActive = true
        startTimeView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        startTimeView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        
        scrollView.addSubview(endTimeView)
        let endTimeTitle = NSMutableAttributedString(string: "END TIME", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)])
        if endTimeSet {
            let endTimeSet = NSAttributedString(string: "\n\(endTime)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)])
            endTimeTitle.append(endTimeSet)
        } else {
            let endTimeSet = NSAttributedString(string: "\nNot Set", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)])
            endTimeTitle.append(endTimeSet)
        }
        endTimeView.setAttributedTitle(endTimeTitle, for: .normal)
        endTimeView.topAnchor.constraint(equalTo: separaterView1.bottomAnchor, constant: 42).isActive = true
        endTimeView.widthAnchor.constraint(equalToConstant: (view.frame.size.width - 72) / 2).isActive = true
        endTimeView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        endTimeView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        
        scrollView.addSubview(separaterView2)
        separaterView2.topAnchor.constraint(equalTo: endTimeView.bottomAnchor, constant: 42).isActive = true
        separaterView2.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        separaterView2.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        separaterView2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        scrollView.addSubview(totalHoursTitleLabel)
        totalHoursTitleLabel.topAnchor.constraint(equalTo: separaterView2.bottomAnchor, constant: 42).isActive = true
        totalHoursTitleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        totalHoursTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        totalHoursTitleLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        scrollView.addSubview(totalHoursLabel)
        totalHoursLabel.topAnchor.constraint(equalTo: separaterView2.bottomAnchor, constant: 42).isActive = true
        totalHoursLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        totalHoursLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        totalHoursLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        scrollView.addSubview(costTitleLabel)
        costTitleLabel.topAnchor.constraint(equalTo: totalHoursLabel.bottomAnchor, constant: 20).isActive = true
        costTitleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        costTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        costTitleLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        scrollView.addSubview(costLabel)
        costLabel.topAnchor.constraint(equalTo: totalHoursLabel.bottomAnchor, constant: 20).isActive = true
        costLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        costLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        costLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        scrollView.addSubview(profileImage)
        profileImage.topAnchor.constraint(equalTo: costTitleLabel.bottomAnchor, constant: 30).isActive = true
        profileImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(userNameLabel)
        userNameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        userNameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 15).isActive = true
        userNameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        userNameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(signUpButton)
        signUpButton.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 50).isActive = true
        signUpButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        signUpButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        view.addSubview(timePicker)
        timePicker.alpha = 0
        timePicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        timePicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        timePicker.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        timePicker.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    @objc func startTimeDiveChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        print(formatter.string(from: sender.date))
        timePicker.removeFromSuperview() // if you want to remove time picker
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("selected date: \(date)")
        self.selectedDate = date
    }
    
    @objc func startTimePressed() {
        typePicker = "startTime"
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) { date in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy"
//                self.textField.text = formatter.string(from: dt)
            }
        }
    }
    
    @objc func endTimePressed() {
        typePicker = "endTime"
//        openTimePicker()
    }
    
    @objc func bookNowPressed() {
        print("boook")
    }

}
