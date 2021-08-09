//
//  MYScheduleVC.swift
//  HireMile
//
//  Created by mac on 10/07/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SwiftyJSON

struct ScheduleDate {
    let date: String
    var ongoingJobs = [OngoingJobs]()
}

class MYScheduleVC: UIViewController {
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var tblSchedule: UITableView!
    @IBOutlet weak var dropdownButton: UIButton!
    
    var scheduleTimeArray = [ScheduleDate(date: "09:00 AM"),ScheduleDate(date: "10:00 AM"),ScheduleDate(date: "11:00 AM"),ScheduleDate(date: "12:00 PM"),ScheduleDate(date: "01:00 PM"),ScheduleDate(date: "02:00 PM"),ScheduleDate(date: "03:00 PM"),ScheduleDate(date: "04:00 PM"),ScheduleDate(date: "05:00 PM"),ScheduleDate(date: "06:00 PM"),ScheduleDate(date: "07:00 PM"),ScheduleDate(date: "08:00 PM"),ScheduleDate(date: "09:00 PM"),ScheduleDate(date: "10:00 PM")]
    
    let arrName = ["Albert Smith - Wed design","","","Robert Gomez - car Logo","","","","","","","",""]
    
    private var animationFinished = true
    private var currentCalendar: Calendar?
    
    var allOngoingJobs = [OngoingJobs]()
    
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
        calendarView.appearance.dayLabelWeekdaySelectedBackgroundColor = UIColor.mainBlue
        calendarView.appearance.dayLabelPresentWeekdayHighlightedBackgroundColor = UIColor.mainBlue
        calendarView.appearance.dayLabelPresentWeekdaySelectedBackgroundColor = UIColor.mainBlue
        calendarView.appearance.dayLabelWeekdaySelectedBackgroundColor = UIColor.mainBlue
        calendarView.appearance.dayLabelWeekdayHighlightedBackgroundColor = UIColor.mainBlue
        calendarView.appearance.dayLabelPresentWeekdayTextColor = .mainBlue
//        calendarView.appearance.dotMarkerColor = .mainBlue
//        calendarView.
        // Appearance delegate [Unnecessary]
        self.calendarView.calendarAppearanceDelegate = self
        self.calendarView.animatorDelegate = self
        
        // Menu delegate [Required]
        self.menuView.menuViewDelegate = self
        self.calendarView.calendarDelegate = self
        
        // Commit frames' updates
        self.menuView.commitMenuViewUpdate()
        self.calendarView.commitCalendarViewUpdate()
        self.observeOngoingJobs()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    private func observeOngoingJobs() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ongoingJobRef = Database.database().reference().child("Ongoing-Jobs")
        ongoingJobRef
            .queryOrdered(byChild: "bookUid")
            .queryEqual(toValue: uid)
            .observe(.value, with: { snapshot in
                self.allOngoingJobs = [OngoingJobs]()
                if let jobDictionary = snapshot.value as? NSDictionary {
                    for key in jobDictionary.allKeys {
                        if let key = key as? String {
                            if let dic = jobDictionary[key] as? NSDictionary {
                                let json = JSON(dic)
                                let ongoing = OngoingJobs(json: json)
                                self.allOngoingJobs.append(ongoing)
                            }
                        }
                    }
                    if let selectedDate = self.calendarView.presentedDate.convertedDate()?.toString(format: .custom("dd-MM-yy"))  {
                        debugPrint(selectedDate)
                        self.fetchScheduleJob(dateStr: selectedDate)
                    }
                }
                ongoingJobRef
                    .queryOrdered(byChild: "authorId")
                    .queryEqual(toValue: uid)
                    .observeSingleEvent(of: .value, with: { snapshot in
                        if let jobDictionary = snapshot.value as? NSDictionary {
                            for key in jobDictionary.allKeys {
                                if let key = key as? String {
                                    if let dic = jobDictionary[key] as? NSDictionary {
                                        let json = JSON(dic)
                                        let ongoing = OngoingJobs(json: json)
                                        self.allOngoingJobs.append(ongoing)
                                    }
                                }
                            }
                            self.calendarView.contentController.refreshPresentedMonth()
                            if let selectedDate = self.calendarView.presentedDate.convertedDate()?.toString(format: .custom("dd-MM-yy"))  {
                                debugPrint(selectedDate)
                                self.fetchScheduleJob(dateStr: selectedDate)
                            }
                        }
                       
                    })
            })
    }
    
    private func fetchScheduleJob(dateStr: String) {
        let currentDateJobs = self.allOngoingJobs.filter { job in
            return job.scheduleDate == dateStr
        }
        scheduleTimeArray = [ScheduleDate(date: "09:00 AM"),ScheduleDate(date: "10:00 AM"),ScheduleDate(date: "11:00 AM"),ScheduleDate(date: "12:00 PM"),ScheduleDate(date: "01:00 PM"),ScheduleDate(date: "02:00 PM"),ScheduleDate(date: "03:00 PM"),ScheduleDate(date: "04:00 PM"),ScheduleDate(date: "05:00 PM"),ScheduleDate(date: "06:00 PM"),ScheduleDate(date: "07:00 PM"),ScheduleDate(date: "08:00 PM"),ScheduleDate(date: "09:00 PM"),ScheduleDate(date: "10:00 PM")]
        for job in currentDateJobs {
            let date = job.scheduleTime.toDate(withFormat: "hh:mm a")
            if let time = date?.toString(withFormat: "hh:00 a") {
                if let timeIndex = scheduleTimeArray.firstIndex(where: { scheduleDate in
                    return scheduleDate.date == time
                }) {
                    if scheduleTimeArray.indices.contains(timeIndex) {
                        scheduleTimeArray[timeIndex].ongoingJobs.append(job)
                    }
                }
            }
        }
        if((calendarView) != nil) {
            if let cc = calendarView.contentController as? CVCalendarMonthContentViewController {
               cc.refreshPresentedMonth()
            }
        }
        
        if((tblSchedule) != nil) {
            tblSchedule.reloadData()
        }
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return scheduleTimeArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let jobs = scheduleTimeArray[section].ongoingJobs
        return jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyScheduleCell", for: indexPath) as! MyScheduleCell
        cell.lblTime.text = scheduleTimeArray[indexPath.section].date
        cell.lblTime1.text = scheduleTimeArray[indexPath.section].date
        cell.lblName.text = scheduleTimeArray[indexPath.section].date
        
        if indexPath.row == 0 {
            cell.lblTime.isHidden = false
        } else {
            cell.lblTime.isHidden = true
        }
        let ongoingJob = scheduleTimeArray[indexPath.section].ongoingJobs[indexPath.row]
        cell.lblName.text = "  "
        cell.lblAddress.text = ""
        Database.database().reference().child("Jobs").child(ongoingJob.jobId).observeSingleEvent(of: .value, with: { (snapshot) in
            let json = JSON(snapshot.value)
            cell.lblName.text = json["title"].stringValue
            let latitude = json["lat"].doubleValue
            let logitude = json["long"].doubleValue
            CommonUtils.getAddressFromCoordinates(latitude: latitude, logitude: logitude) { address in
                cell.lblAddress.text = address
            }
        })
        cell.vwLeft.isHidden = false
        
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
    
    func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool) {
        if let selectedDate = dayView.date.convertedDate()?.toString(format: .custom("dd-MM-yy"))  {
            debugPrint(selectedDate)
            self.fetchScheduleJob(dateStr: selectedDate)
        }
        
    }
    
//    func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool {
//        if let selectedDate = dayView.date.convertedDate()?.toString(format: .custom("dd-MM-yy"))  {
//            let isContain = self.allOngoingJobs.contains(where: {$0.scheduleDate == selectedDate})
//            return isContain
//        }
//        return false
//    }
}
