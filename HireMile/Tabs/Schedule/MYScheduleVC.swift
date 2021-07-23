//
//  MYScheduleVC.swift
//  HireMile
//
//  Created by mac on 10/07/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit

class MYScheduleVC: UIViewController {
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var tblSchedule: UITableView!
    @IBOutlet weak var dropdownButton: UIButton!
    
    let arrTime = ["10:00 AM","11:00 AM","12:00 AM","01:00 PM","02:00 PM","03:00 PM","04:00 PM","05:00 PM","06:00 PM","07:00 PM","08:00 PM","09:00 PM"]
    
    let arrName = ["Albert Smith - Wed design","","","Robert Gomez - car Logo","","","","","","","",""]
    
    private var animationFinished = true
    private var currentCalendar: Calendar?
    
    override func awakeFromNib() {
        let timeZoneBias = 480 // (UTC+08:00)
        currentCalendar = Calendar(identifier: .gregorian)
        currentCalendar?.locale = Locale(identifier: "fr_FR")
        if let timeZone = TimeZone(secondsFromGMT: -timeZoneBias * 60) {
            currentCalendar?.timeZone = timeZone
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblSchedule.register(UINib(nibName: "MyScheduleCell", bundle: nil), forCellReuseIdentifier: "MyScheduleCell")
    
        // Appearance delegate [Unnecessary]
        self.calendarView.calendarAppearanceDelegate = self
        self.calendarView.animatorDelegate = self
        
        // Menu delegate [Required]
        self.menuView.menuViewDelegate = self
        self.calendarView.calendarDelegate = self
        
        // Commit frames' updates
        self.menuView.commitMenuViewUpdate()
        self.calendarView.commitCalendarViewUpdate()
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    // MARK: Button Action
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnloadPrevious(sender: AnyObject) {
        calendarView.loadPreviousView()
    }

    @IBAction func btnloadNext(sender: AnyObject) {
        calendarView.loadNextView()
    }
    
    @IBAction func btnDropDownAction(_ sender: UIButton) {
        if sender.isSelected == true {
            sender.isSelected = false
            calendarView.changeMode(.weekView)
        } else {
            calendarView.changeMode(.monthView)
            sender.isSelected = true
            calendarView.layer.cornerRadius = 20
        }
    }
    
}

extension MYScheduleVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrTime.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyScheduleCell", for: indexPath) as! MyScheduleCell
        cell.lblTime.text = arrTime[indexPath.row]
        cell.lblTime1.text = arrTime[indexPath.row]
        cell.lblName.text = arrTime[indexPath.row]
        if "" != arrName[indexPath.row] {
            cell.vwLeft.isHidden = false
            cell.lblName.text = arrName[indexPath.row]
        }else{
            cell.vwLeft.isHidden = true
        }
        
        cell.btnMore.addAction(for: .touchUpInside) {
            print("Hello, Closure!")
        }
       return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
}


// MARK: - CVCalendarViewDelegate & CVCalendarMenuViewDelegate

extension MYScheduleVC: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    func presentationMode() -> CalendarMode { return .weekView }
    
    func firstWeekday() -> Weekday { return .monday }
    
    func presentedDateUpdated(_ date: CVDate) {
        print("date.day", date.day)
        if lblMonth.text != date.globalDescription && self.animationFinished {
                let updatedMonthLabel = UILabel()
                updatedMonthLabel.textColor = lblMonth.textColor
                updatedMonthLabel.font = lblMonth.font
                updatedMonthLabel.textAlignment = .center
                updatedMonthLabel.text = date.globalDescription
                updatedMonthLabel.sizeToFit()
                updatedMonthLabel.alpha = 0
                updatedMonthLabel.center = self.lblMonth.center
                
                let offset = CGFloat(48)
                updatedMonthLabel.transform = CGAffineTransform(translationX: 0, y: offset)
                updatedMonthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
                
                
                UIView.animate(withDuration: 0.35, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                    self.animationFinished = false
                    self.lblMonth.transform = CGAffineTransform(translationX: 0, y: -offset)
                    self.lblMonth.transform = CGAffineTransform(scaleX: 1, y: 0.1)
                    self.lblMonth.alpha = 0
                    
                    updatedMonthLabel.alpha = 1
                    updatedMonthLabel.transform = CGAffineTransform.identity
                    
                }) { _ in
                    
                    self.animationFinished = true
                    self.lblMonth.frame = updatedMonthLabel.frame
                    self.lblMonth.text = updatedMonthLabel.text
                    self.lblMonth.transform = CGAffineTransform.identity
                    self.lblMonth.alpha = 1
                    updatedMonthLabel.removeFromSuperview()
                }
                
                self.view.insertSubview(updatedMonthLabel, aboveSubview: self.lblMonth)
            }
        
    }
    // MARK: Optional methods
    func dayOfWeekTextColor() -> UIColor { return .black }
    
    
    func weekdaySymbolType() -> WeekdaySymbolType {
        return .veryShort
    }
    
    func dayOfWeekFont() -> UIFont {
        return  UIFont.init(name: "Lato-Regular", size: 14)!
    }
    
    
}
