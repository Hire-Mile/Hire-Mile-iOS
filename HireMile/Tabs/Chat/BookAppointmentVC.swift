//
//  BookAppointment.swift
//  HireMile
//
//  Created by mac on 08/07/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import SwiftyJSON
class BookAppointmentVC: UIViewController {
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var colTime: UICollectionView!
    @IBOutlet weak var vwUserDetail: UIView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    var jobStructure: JobStructure!
    
    let arrTime = ["12:00 AM", "12:30 AM", "01:00 AM", "01:30 AM", "02:00 AM", "02:30 AM", "03:00 AM", "03:30 AM", "04:00 AM", "04:30 AM", "05:00 AM", "05:30 AM", "06:00 AM", "06:30 AM", "07:00 AM", "07:30 AM", "08:00 AM", "08:30 AM", "09:00 AM","09:30 AM","10:00 AM","10:30 AM","11:00 AM","11:30 AM","12:00 PM","12:30 PM","01:00 PM","01:30 PM","02:00 PM","02:30 PM","03:00 PM","03:30 PM","04:00 PM","04:30 PM","05:00 PM","05:30 PM","06:00 PM","06:30 PM","07:00 PM","07:30 PM","08:00 PM","08:30 PM","09:00 PM","09:30 PM","10:00 PM","10:30 PM","11:00 PM","11:30 PM"]
    
    var finalTime = [String]()
    
    var selectTime = ""
    
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
        initUIData()
        currentJobData()
        self.colTime.register(UINib(nibName: "colTimeCell", bundle: nil), forCellWithReuseIdentifier: "colTimeCell")
        
        // Appearance delegate [Unnecessary]
        calendarView.appearance.dayLabelWeekdaySelectedBackgroundColor = UIColor.mainBlue
        calendarView.appearance.dayLabelPresentWeekdayHighlightedBackgroundColor = UIColor.mainBlue
        calendarView.appearance.dayLabelPresentWeekdaySelectedBackgroundColor = UIColor.mainBlue
        calendarView.appearance.dayLabelWeekdaySelectedBackgroundColor = UIColor.mainBlue
        calendarView.appearance.dayLabelWeekdayHighlightedBackgroundColor = UIColor.mainBlue
        calendarView.appearance.dayLabelPresentWeekdayTextColor = .mainBlue
        self.calendarView.calendarAppearanceDelegate = self
        self.calendarView.animatorDelegate = self
        
        // Menu delegate [Required]
        self.menuView.menuViewDelegate = self
        self.calendarView.calendarDelegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Commit frames' updates
        self.menuView.commitMenuViewUpdate()
        self.calendarView.commitCalendarViewUpdate()
    }
    
    func initUIData() {
        self.lblName.text = jobStructure.author.username ?? ""
        if self.jobStructure.typeOfPrice == "Hourly" {
            self.lblPrice.text = "$\(String(jobStructure.price ?? 0)) / Hour"
        } else {
            self.lblPrice.text = "$\(String(jobStructure.price ?? 0))"
        }
        self.lblCategory.text = jobStructure.titleOfPost ?? ""
        self.userProfileImageView.sd_setImage(with: URL(string: jobStructure.author.profileImageView ?? ""), completed: nil)
    }
    
    func currentJobData() {
        let ongoingJobRef = Database.database().reference().child("Ongoing-Jobs")
        ongoingJobRef
            .queryOrdered(byChild: "jobId")
            .queryEqual(toValue: self.jobStructure.postId ?? "")
           .observe( .value, with: {(snapshot) in
                    print(snapshot)
            self.allOngoingJobs = [OngoingJobs]()
            if let jobDictionary = snapshot.value as? NSDictionary {
                for key in jobDictionary.allKeys {
                    if let key = key as? String {
                        if let dic = jobDictionary[key] as? NSDictionary {
                            let json = JSON(dic)
                            let ongoingJob = OngoingJobs(json: json)
                            if(ongoingJob.jobStatus == .Accepted || ongoingJob.jobStatus == .Hired) {
                                self.allOngoingJobs.append(ongoingJob)
                            }
                        }
                    }
                }
            }
            self.filterDateOfAvailableSlots()
        })
    }
    
    func filterDateOfAvailableSlots() {
        if((self.calendarView) == nil) {
            return
        }
        if let selectedDate = self.calendarView.presentedDate.convertedDate()?.toString(format: .custom("dd-MM-yy"))  {
            self.jobStructure.scheduleDate = selectedDate
            self.finalTime = [String]()
            if(jobStructure.author.workingHours.count > 0) {
                if let dayname = self.calendarView.presentedDate.convertedDate()?.toString(format: .custom("EEEE"))  {
                    if let workinghour = jobStructure.author.workingHours.last(where: {$0.day == dayname.lowercased()}) {
                        let hours = workinghour.hours.components(separatedBy: " - ")
                        debugPrint(hours)
                        if let start = hours.first, let end = hours.last, let startDate = start.toDate(withFormat: "hh:mma"), let endDate = end.toDate(withFormat: "hh:mma")  {
                            for time in arrTime {
                                if let newDate = time.toDate(withFormat: "hh:mm a") {
                                    if newDate >= startDate && newDate <= endDate {
                                        if let ongoinJob = self.allOngoingJobs.last(where: {$0.scheduleDate == selectedDate && $0.scheduleTime == time}) {
                                            debugPrint("current job is ongoin \(ongoinJob)")
                                        } else {
                                            self.finalTime.append(time)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                self.finalTime = [String]()
                for time in arrTime {
                    if let ongoinJob = self.allOngoingJobs.last(where: {$0.scheduleDate == selectedDate && $0.scheduleTime == time}) {
                        debugPrint("current job is ongoin \(ongoinJob)")
                    } else {
                        self.finalTime.append(time)
                    }
                }
            }
        }
        if((colTime) != nil) {
            colTime.reloadData()
        }
    }
    
    // MARK: Button Action
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMonthWeekView(sender: UIButton) {
        if sender.isSelected == true {
            sender.isSelected = false
            calendarView.changeMode(.weekView)
            //calendarView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 0)
            calendarView.layer.cornerRadius = 0
            calendarView.dropShadow(color: .clear, offSet: CGSize(width: 0, height: 5))
        } else {
            calendarView.changeMode(.monthView)
            sender.isSelected = true
            calendarView.layer.cornerRadius = 20//roundCorners(corners: [.bottomLeft, .bottomRight], radius: 20)
            calendarView.dropShadow(color: .black,opacity: 0.1, offSet: CGSize(width: 0, height: 5),radius: 5)
        }
    }

    @IBAction func btnloadPrevious(sender: AnyObject) {
        calendarView.loadPreviousView()
    }

    @IBAction func btnloadNext(sender: AnyObject) {
        calendarView.loadNextView()
    }
    
    @IBAction func btnBookHire(_ sender: UIButton) {
        if selectTime != "" {
            guard let uid = Auth.auth().currentUser?.uid,let authorid = self.jobStructure.authorId else {
                return
            }
            if uid == authorid {
                self.simpleAlert(title: "", message: "You can not hire your own job.")
                return
            }
            let ongoingJobRef = Database.database().reference().child("Ongoing-Jobs")
            ongoingJobRef
                .queryOrdered(byChild: "jobId")
                .queryEqual(toValue: self.jobStructure.postId ?? "")
               .observeSingleEvent(of: .value, with: {(snapshot) in
                        print(snapshot)
                if let jobDictionary = snapshot.value as? NSDictionary {
                    for key in jobDictionary.allKeys {
                        if let key = key as? String {
                            if let dic = jobDictionary[key] as? NSDictionary {
                                let json = JSON(dic)
                                let ongoingJob = OngoingJobs(json: json)
                                if (ongoingJob.bookUid == uid && ongoingJob.jobStatus != .Declined && ongoingJob.jobStatus != .DeclinePayment) {
                                    if ongoingJob.jobStatus.rawValue < JobStatus.Completed.rawValue {
                                        self.simpleAlert(title: "", message: "You already ongoing this job:  \(self.jobStructure.titleOfPost ?? "")")
                                        return
                                    }
                                }
                            }
                        }
                    }
                }
                let jobsReference = Database.database().reference().child("Ongoing-Jobs")
                let timestamp = Int(Date().timeIntervalSince1970)
                let infoToAdd : Dictionary<String, Any> = [
                    "jobId" : self.jobStructure.postId ?? "",
                    "bookUid": uid,
                    "job-status" : JobStatus.Hired.rawValue,
                    "running-time" : timestamp,
                    "scheduleDate": self.jobStructure.scheduleDate ?? "",
                    "scheduleTime": self.jobStructure.scheduleTime ?? "",
                    "authorId": self.jobStructure.authorId ?? "",
                    "price": self.jobStructure.price ?? 0,
                    "typeOfPrice": self.jobStructure.typeOfPrice ?? "",
                    "time": timestamp
                ]
                debugPrint(infoToAdd)
                jobsReference.childByAutoId().setValue(infoToAdd)
                let ref = Database.database().reference().child("Users").child(authorid)
                ref.observeSingleEvent(of: .value) { snapshot in
                    guard let dictionary = snapshot.value as? [String : AnyObject] else {
                        return
                    }
                    debugPrint(dictionary)
                    let user = UserChat(dictionary: dictionary)
                    user.id = snapshot.key
                    self.sendMessageWithProperties(["text":"\(user.name ?? "") hire you"], toId: user.id ?? "")
                    self.showChatControllerForUser(user)
                    if let token : String = (dictionary["fcmToken"] as? String) {
                        let sender = PushNotificationSender()
                        sender.sendPushNotificationHire(to: token, title: "Congrats! 🎉", body: "\(user.name ?? "") hire you", page: true, senderId: Auth.auth().currentUser!.uid, recipient: authorid)
                        
                    }
                }
            })
        }
    }
    
    private func sendMessageWithProperties(_ properties: [String: Any], toId: String) {
        let ref = Database.database().reference().child("Messages")
        let childRef = ref.childByAutoId()
        let toId = toId
        let fromId = Auth.auth().currentUser!.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        var values : [String : Any] = ["toId": toId, "fromId": fromId, "timestamp": timestamp, "first-time" : false, "service-provider" : "??", "text-id" : childRef.key ?? "", "hasViewed" : false] as [String : Any]
        
        // append properties
        properties.forEach({values[$0] = $1})
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error ?? "")
                return
            }
            
            guard let messageId = childRef.key else { return }
            
            let userMessagesRef = Database.database().reference().child("User-Messages").child(fromId).child(toId).child(messageId)
            userMessagesRef.setValue(1)
            
            let recipientUserMessagesRef = Database.database().reference().child("User-Messages").child(toId).child(fromId).child(messageId)
            recipientUserMessagesRef.setValue(1)
            
            
            Database.database().reference().child("Users").child(toId).child("fcmToken").observe(.value) { (snapshot) in
                let token : String = (snapshot.value as? String)!
                let sender = PushNotificationSender()
                Database.database().reference().child("Users").child(fromId).child("name").observe(.value) { (snapshot) in
                    let name : String = (snapshot.value as? String)!
                    sender.sendPushNotification(to: token, title: "Chat Notification", body: "New message from \(name)", page: false, senderId: Auth.auth().currentUser!.uid, recipient: toId)

                }
            }
        }
    }
    
    func showChatControllerForUser(_ user: UserChat) {
        if let VC = CommonUtils.getStoryboardVC(StoryBoard.Chat.rawValue, vcIdetifier: ChatVC.className) as? ChatVC {
             VC.hidesBottomBarWhenPushed = true
            VC.userOther = user
             self.navigationController?.pushViewController(VC,  animated: true)
         }
    }
}


extension BookAppointmentVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return finalTime.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colTimeCell", for: indexPath) as! colTimeCell
        
        cell.lblTitle.text = finalTime[indexPath.item]
        if selectTime == finalTime[indexPath.row] {
            cell.vwBG.backgroundColor = UIColor(named: "cellBGColor")
            cell.vwBG.layer.borderColor = UIColor.mainBlue.cgColor
            cell.lblTitle.font = UIFont(name: "Lato-Bold", size:  16.0)!
        }else{
            cell.vwBG.backgroundColor = UIColor.white
            cell.vwBG.layer.borderColor = UIColor(named:"LightGray")?.cgColor
            cell.lblTitle.font = UIFont(name: "Lato-Medium", size:  16.0)!
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectTime = finalTime[indexPath.row]
        lblTime.text = selectTime
        jobStructure.scheduleTime = selectTime
        colTime.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let vwWidth = (colTime.frame.size.width - 40)
            //arrTime[indexPath.row].width(withConstrainedHeight: 40, font: UIFont(name: "Lato-Medium", size:  14.0)!)
        return CGSize(width: vwWidth / 3, height: 51)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 22
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

// MARK: - CVCalendarViewDelegate & CVCalendarMenuViewDelegate

extension BookAppointmentVC: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
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
        filterDateOfAvailableSlots()
    }
    
}
