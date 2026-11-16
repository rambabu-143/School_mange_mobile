//
//  CalenderPopUpViewController.swift
//  MountCarmel
//
//  Created by Sandip on 15/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import FSCalendar

class CalenderPopUpViewController: UIViewController {
    @IBOutlet var calenderView: FSCalendar!
    var dateHandler:((String) -> ())?
    var objData : WiseDateData?
    var strScreenName = ""
    var wiseCalenderStartDate = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
//        if strScreenName == "EditProfile"{
//            self.calenderView.dataSource = self
//            self.calenderView.delegate = self
//            self.calenderView.placeholderType = .none
//            self.calenderView.reloadData()
//            return
//        }
       
        self.callAPIWiseAllowDates { (success) in
            if(success){
                
                self.calenderView.dataSource = self
                self.calenderView.delegate = self
                self.calenderView.placeholderType = .none
                self.calenderView.reloadData()
            }
        }
       
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionBackClick(_ sender: Any) {
        self.dismiss(animated: false) {
            
        }
    }
    
}
extension CalenderPopUpViewController :FSCalendarDataSource, FSCalendarDelegate{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date)
        let date11 = CommonFunctions.getDateInString(date: date, strDateFormat: DateFormat.DateFormat_DDMMYYYY)
        
        print(date11)
        
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
        
        self.dismiss(animated: false) {
            if(self.dateHandler !=  nil){
                self.dateHandler!(date11)
            }
        }
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
//        if strScreenName == "EditProfile"{
//            return Date()
//        }
        
         let endDate = CommonFunctions.UTCToLocal(date: objData?.end_date ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_yyyyMMddhhmmss)
         let strEDT = CommonFunctions.getStringToDate(Format: DateFormat.DateFormat_yyyyMMddhhmmss, strDate: endDate)
        return strEDT
       // return Date()
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
//        if strScreenName == "EditProfile"{
//            return Calendar.current.date(byAdding: .year, value: -150, to: Date())!
//        }
        var startDate = CommonFunctions.UTCToLocal(date: objData?.start_date ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_yyyyMMddhhmmss)
        
        if strScreenName == "Wise"{
            startDate = CommonFunctions.UTCToLocal(date: wiseCalenderStartDate, fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_yyyyMMddhhmmss)
        }
        
        let strDT = CommonFunctions.getStringToDate(Format: DateFormat.DateFormat_yyyyMMddhhmmss, strDate: startDate)
        
//         let strEDT = CommonFunctions.getStringToDate(Format: DateFormat.DateFormat_yyyyMMddhhmmss, strDate: endDate)
//
//        let days = strEDT.days(from: strDT)
//
//        let curDate = Date().addingTimeInterval(TimeInterval((-24*60*60) * days))
        return strDT
    }
}


extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the amount of nanoseconds from another date
    func nanoseconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.nanosecond], from: date, to: self).nanosecond ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        var result: String = ""
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if seconds(from: date) > 0 { return "\(seconds(from: date))" }
        if days(from: date)    > 0 { result = result + " " + "\(days(from: date)) D" }
        if hours(from: date)   > 0 { result = result + " " + "\(hours(from: date)) H" }
        if minutes(from: date) > 0 { result = result + " " + "\(minutes(from: date)) M" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))" }
        return ""
    }
}
extension CalenderPopUpViewController{
    func callAPIWiseAllowDates(finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
        var URLString = ""
        if(strScreenName == "MarkAttendance"){
             URLString = API_ATTENDANCEDATE
        }else{
             URLString = API_WISEATTENDANCEDATE
        }
        
        WiseManagementAPI.wiseAllowDates(url : URLString) { (respose, error) in
            Loader.hide()
            guard let response = respose else {
                self.toast(error?.localizedDescription ?? "Invalid Response")
                finished(false)
                return
            }
            guard response.status == true else {
                self.toast(response.message ?? "Invalid Response")
                //CommonFunctions.logOutFromAPP()
                finished(false)
                return
            }
            guard let responseData = response.data else {
                self.toast(response.message ?? "Invalid Response")
                finished(false)
                return
            }
            
            self.objData = responseData
            finished(true)
        }
    }
}
