//
//  BookAppointment.swift
//  HireMile
//
//  Created by mac on 08/07/21.
//  Copyright © 2021 Jorge Zapata. All rights reserved.
//

import UIKit

class BookAppointmentVC: UIViewController {
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var colTime: UICollectionView!
    @IBOutlet weak var colDate: UICollectionView!
    @IBOutlet weak var vwUserDetail: UIView!
    
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    
    let arrTime = ["09:30 AM","10:00 AM","10:30 AM","11:00 AM","11:30 AM","12:00 AM","12:30 AM","01:00 PM","01:30 PM","02:00 PM","02:30 PM","03:00 PM","03:30 PM","04:00 PM","04:30 PM","05:00 PM","05:30 PM","06:00 PM","06:30 PM","07:00 PM","07:30 PM","08:00 PM","08:30 PM","09:00 PM","09:30 PM","10:00 PM","10:30 PM"]
    
    var selectTime = ""
    
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
        self.colTime.register(UINib(nibName: "colTimeCell", bundle: nil), forCellWithReuseIdentifier: "colTimeCell")
        
        // Appearance delegate [Unnecessary]
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
        self.navigationController?.pushViewController(Chat(), animated: true)
          /*if let VC = CommonUtils.getStoryboardVC(StoryBoard.Chat.rawValue, vcIdetifier: ChatVC.className) as? ChatVC {
               VC.hidesBottomBarWhenPushed = true
              VC.user = user
               self.navigationController?.pushViewController(VC,  animated: true)
           }*/
    }
}


extension BookAppointmentVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTime.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colTimeCell", for: indexPath) as! colTimeCell
        
        cell.lblTitle.text = arrTime[indexPath.item]
        if selectTime == arrTime[indexPath.row] {
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
        selectTime = arrTime[indexPath.row]
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
    
}
