//
//  ParentAttendanceViewController.swift
//  MountCarmel
//
//  Created by Sandip on 10/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import FSCalendar
import SDWebImage
import TTGSnackbar

class ParentAttendanceViewController: UIViewController {
    
  
    @IBOutlet var lblHalfDayTitle: UILabel!
    @IBOutlet var btnHalfDay: RoundedButton!
    @IBOutlet var lblPresentTitle: UILabel!
    @IBOutlet var lblAbsentTitle: UILabel!
    @IBOutlet var lblHoliday: UILabel!
    @IBOutlet var lblGazattedHoliday: UILabel!
    @IBOutlet var imgProfile: RoundedImage!
    @IBOutlet var btnabsent: RoundedButton!
    @IBOutlet var lblPresent: UILabel!
    @IBOutlet weak var navigationView: NavigationBarView!
    @IBOutlet weak var calendar: FSCalendar!
    // first date in the range
    var firstDate: Date?
    // last date in the range
    var lastDate: Date?
    var datesRange: [Date]?
    var objAttendanceData : SubmitAttendanceAPIResponse?
    var arrWorkingDays = [String]()
    var arrHolidays = [String]()
    var arrAbsentDays = [String]()
    var arrHalfDays = [String]()
    var strStartDate = ""
    var strEndDate = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.lblTitle.text = "Attendance"
        navigationView.delegate = self
        
         self.lblAbsentTitle.font = UIFont.setRegularFont(ofSize: 11.0)
         self.lblPresentTitle.font = UIFont.setRegularFont(ofSize: 11.0)
         self.lblHalfDayTitle.font = UIFont.setRegularFont(ofSize: 11.0)
        
        self.lblGazattedHoliday.font = UIFont.setBoldFont(ofSize: 11.0)
        self.lblHoliday.font = UIFont.setBoldFont(ofSize: 11.0)
        
        calendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesSingleUpperCase]
        calendar.allowsMultipleSelection = false
        calendar.delegate = self
        calendar.dataSource = self
        calendar.placeholderType = .none
        
       // calendar.appearance.headerMinimumDissolvedAlpha = 0.0;
        
        calendar.reloadData()
        self.makeAPICall(calendar: calendar)
        
       // let userInfo = APP_DELEGATE.userInfo
        //studentImageIssue
       
        let imageURL = (APP_DELEGATE.loginAPIResponse?.path ?? "") + (APP_DELEGATE.selected_Student?.studentId?.profile_pic ?? "")
        
        self.imgProfile.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "profile-placeholder"), options: [], context: nil)
        
    }
    
    @IBAction func actionDropdownSelectStudent(_ sender: Any) {
        
       
    }
}
extension ParentAttendanceViewController: NavigationBarViewDelegate {
    func onTapDropDown() {
        
    }
   
    
    func onTapMenu() {
        
    }
    
    func onTapBack() {
        
        if self.navigationController?.viewControllers.count ?? 0 == 1 {
            self.setHomeScreen()
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func onTapNotification() {
        if let viewController: NotificationViewController = NotificationViewController.storyboardInstance.initialize() {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func onTapBadgeCounts() {
        if let viewController: NotificationViewController = NotificationViewController.storyboardInstance.initialize() {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func onTapStory() {
        print(#function)
    }
    
    func onTapAppLogo() {
        let viewcontrollers = self.navigationController?.viewControllers
        var flag = true
        viewcontrollers?.forEach({ (vc) in
            if  let viewController = vc as? HomeViewController {
                flag = false
                self.navigationController!.popToViewController(viewController, animated: true)
            }
        })
        
        if flag {
            self.setHomeScreen()
        }
    }
    
    func setHomeScreen() {
        if let viewController: HomeViewController = HomeViewController.storyboardInstance.initialize() {
            let contentViewController = UINavigationController(rootViewController: viewController)
            contentViewController.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
        }
    }
}
extension ParentAttendanceViewController :FSCalendarDataSource, FSCalendarDelegate,FSCalendarDelegateAppearance{
    
    //    func maximumDate(for calendar: FSCalendar) -> Date {
    //         return Date()
    //    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let strEventDate = CommonFunctions.getDateInString(date: date, strDateFormat: DateFormat.DateFormat_DDMMYYYY)
        if self.arrAbsentDays.contains(strEventDate){
            
            let index = self.arrAbsentDays.firstIndex(where: { (item) -> Bool in
                item == strEventDate
            }) ?? 0
            let obj = self.objAttendanceData?.absent_data?[index].absent?.first(where: { m in
                (m.student_id ?? "") == (APP_DELEGATE.selected_Student?.studentId?.ID ?? "")
            })
            let reason = obj?.reason ?? "" //self.objAttendanceData?.absent_data?[index].absent?[0].reason ?? ""
            let information = obj?.information ?? "" //self.objAttendanceData?.absent_data?[index].absent?[0].information ?? ""
            let message = "Information received : \(information)\nReason : \(reason)"
            let snackbar = TTGSnackbar(message: message, duration: .middle)
            snackbar.backgroundColor = #colorLiteral(red: 1, green: 0.966917336, blue: 0.6342759728, alpha: 1)
            snackbar.messageTextAlign = .center
            snackbar.messageTextColor = UIColor.black
            snackbar.show()
            return
            //self.toast(message)
            //self.calendar.reloadData()
        }
        if self.arrHolidays.contains(strEventDate){
            
            let index = self.objAttendanceData?.data?.firstIndex(where: { (item) -> Bool in
                 let strHolidayDate = CommonFunctions.UTCToLocal(date: item.date ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_DDMMYYYY)
                return strHolidayDate == strEventDate
            }) ?? 0
            
            let message = self.objAttendanceData?.data?[index].remark ?? ""
            if(message != ""){
                let snackbar = TTGSnackbar(message: message, duration: .middle)
                snackbar.backgroundColor = #colorLiteral(red: 1, green: 0.966917336, blue: 0.6342759728, alpha: 1)
                snackbar.messageTextAlign = .center
                snackbar.messageTextColor = UIColor.black
                snackbar.show()
                return
                // self.toast(message)
            }
           
           // self.calendar.reloadData()
        }
        
        // nothing selected:
        //        if firstDate == nil {
        //            firstDate = date
        //            datesRange = [firstDate!]
        //
        //            print("datesRange contains: \(datesRange!)")
        //
        //            return
        //        }
        //
        //        // only first date is selected:
        //        if firstDate != nil && lastDate == nil {
        //            // handle the case of if the last date is less than the first date:
        //            if date <= firstDate! {
        //                calendar.deselect(firstDate!)
        //                firstDate = date
        //                datesRange = [firstDate!]
        //
        //                print("datesRange contains: \(datesRange!)")
        //
        //                return
        //            }
        //
        //            let range = datesRange(from: firstDate!, to: date)
        //
        //            lastDate = range.last
        //
        //            calendar.select(firstDate)
        //            calendar.select(lastDate)
        //            if firstDate != nil && lastDate != nil{
        //
        //
        //            }
        ////            for d in range {
        ////               // calendar.select(d)
        ////            }
        //
        //            datesRange = range
        //
        //            print("datesRange contains: \(datesRange!)")
        //
        //            return
        //        }
        //
        //        // both are selected:
        //        if firstDate != nil && lastDate != nil {
        //            for d in calendar.selectedDates {
        //                calendar.deselect(d)
        //            }
        //
        //            lastDate = nil
        //            firstDate = nil
        //
        //            datesRange = []
        //
        //            print("datesRange contains: \(datesRange!)")
        //        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // both are selected:
        
        // NOTE: the is a REDUANDENT CODE:
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }
            
            lastDate = nil
            firstDate = nil
            
            datesRange = []
            //print("datesRange contains: \(datesRange!)")
        }
    }
    
    func datesRange(from: Date, to: Date) -> [Date] {
        if from > to { return [Date]() }
        var tempDate = from
        var array = [tempDate]
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        return array
    }
    
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance,eventDefaultColorsFor date: Date) -> [UIColor]?
//    {
//        let strEventDate = CommonFunctions.getDateInString(date: date, strDateFormat: DateFormat.DateFormat_DDMMYYYY)
//
//        let arrdata = objAttendanceData?.data?.filter({ (objdata) -> Bool in
//            objdata.status == "HOLIDAY"
//        }) ?? [SubmitAttendanceData]()
//
//        for data in arrdata{
//            let strHolidayDate = CommonFunctions.getDateString(date: data.date ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_DDMMYYYY)
//            if(strEventDate == strHolidayDate){
//                return [APP_BLUE_COLOR]
//            }else{
//                return [UIColor.white]
//            }
//        }
//        return [UIColor.white]
//
//    }
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        self.makeAPICall(calendar: calendar)
        
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
       /* print(Date().startOfMonth())
        
        return Date().endOfMonth()*/
        
        let strDateVal = "31/03/20" + (APP_DELEGATE.userInfo?.years?.last?.yearSession?.components(separatedBy: "-").last ?? "")
        return CommonFunctions.getStringToDate(Format: DateFormat.DateFormat_ddMMYYYY, strDate: strDateVal)
    }
    func minimumDate(for calendar: FSCalendar) -> Date {
        print(Date().startOfMonth())
        //return Date()
        
      /*  let strDateVal = "01/04/" + (APP_DELEGATE.userInfo?.years?[0].yearSession?.components(separatedBy: "-")[0] ?? "")
        
        let date = CommonFunctions.UTCToLocal(date: strDateVal, fromFormat: DateFormat.DateFormat_ddMMYYYY, toFormat: DateFormat.DateFormat_ddMMYYYY)
        let datVal = CommonFunctions.getStringToDate(Format: DateFormat.DateFormat_ddMMYYYY, strDate: date)
       // print("Date : ==== \(self.calendar.today)")
       // guard let dateValue = datVal else { return Date() }
        return CommonFunctions.getStringToDate(Format: DateFormat.DateFormat_ddMMYYYY, strDate: date)
       // let dt = dateFormatter.date(from: "01/04/2020")*/
        
        let strDateVal = "01/04/" + (APP_DELEGATE.userInfo?.years?.last?.yearSession?.components(separatedBy: "-").first ?? "")
        let date = CommonFunctions.UTCToLocal(date: strDateVal, fromFormat: DateFormat.DateFormat_ddMMYYYY, toFormat: DateFormat.DateFormat_ddMMYYYY)
        return CommonFunctions.getStringToDate(Format: DateFormat.DateFormat_ddMMYYYY, strDate: date)
       
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let strEventDate = CommonFunctions.getDateInString(date: date, strDateFormat: DateFormat.DateFormat_DDMMYYYY)
/*
        let weekday = Calendar.current.component(.weekday, from: date)
        if(weekday == 7){
            if self.arrHolidays.contains(strEventDate){
                return #colorLiteral(red: 0.9725490196, green: 0.8392156863, blue: 0.3647058824, alpha: 1)
            }
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        if(weekday == 1){
            if self.arrHolidays.contains(strEventDate){
                return #colorLiteral(red: 0.9725490196, green: 0.8392156863, blue: 0.3647058824, alpha: 1)
            }
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        if self.arrAbsentDays.contains(strEventDate){
            if self.arrHalfDays.contains(strEventDate){
                return #colorLiteral(red: 1, green: 0.5843137255, blue: 0, alpha: 1)
            }else{
                return #colorLiteral(red: 0.9137254902, green: 0.2470588235, blue: 0.2, alpha: 1)
            }

        }
        if self.arrHolidays.contains(strEventDate){
            return #colorLiteral(red: 0.9725490196, green: 0.8392156863, blue: 0.3647058824, alpha: 1)
        }

        if date == self.calendar.today{
            return #colorLiteral(red: 0.2117647059, green: 0.3803921569, blue: 0.6392156863, alpha: 1)
        }
 */
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let strEventDate = CommonFunctions.getDateInString(date: date, strDateFormat: DateFormat.DateFormat_DDMMYYYY)
        
        
        if self.arrAbsentDays.contains(strEventDate) {
            return 1
        }
        if self.arrHolidays.contains(strEventDate) {
            return 1
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        let strEventDate = CommonFunctions.getDateInString(date: date, strDateFormat: DateFormat.DateFormat_DDMMYYYY)
        
        let weekday = Calendar.current.component(.weekday, from: date)
        if(weekday == 7){
            if self.arrHolidays.contains(strEventDate){
                return [#colorLiteral(red: 0.9725490196, green: 0.8392156863, blue: 0.3647058824, alpha: 1)]
            }
            return [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        }
        if(weekday == 1){
            if self.arrHolidays.contains(strEventDate){
                return [#colorLiteral(red: 0.9725490196, green: 0.8392156863, blue: 0.3647058824, alpha: 1)]
            }
            return [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        }
        if self.arrAbsentDays.contains(strEventDate){
            if self.arrHalfDays.contains(strEventDate){
                return [#colorLiteral(red: 1, green: 0.5843137255, blue: 0, alpha: 1)]
            }else{
                return [#colorLiteral(red: 0.9137254902, green: 0.2470588235, blue: 0.2, alpha: 1)]
            }
            
        }
        if self.arrHolidays.contains(strEventDate){
            return [#colorLiteral(red: 0.9725490196, green: 0.8392156863, blue: 0.3647058824, alpha: 1)]
        }
        return [UIColor.white]
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        let strEventDate = CommonFunctions.getDateInString(date: date, strDateFormat: DateFormat.DateFormat_DDMMYYYY)
        
        let weekday = Calendar.current.component(.weekday, from: date)
        if(weekday == 7){
            if self.arrHolidays.contains(strEventDate){
                return [#colorLiteral(red: 0.9725490196, green: 0.8392156863, blue: 0.3647058824, alpha: 1)]
            }
            return [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        }
        if(weekday == 1){
            if self.arrHolidays.contains(strEventDate){
                return [#colorLiteral(red: 0.9725490196, green: 0.8392156863, blue: 0.3647058824, alpha: 1)]
            }
            return [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        }
        if self.arrAbsentDays.contains(strEventDate){
            if self.arrHalfDays.contains(strEventDate){
                return [#colorLiteral(red: 1, green: 0.5843137255, blue: 0, alpha: 1)]
            }else{
                return [#colorLiteral(red: 0.9137254902, green: 0.2470588235, blue: 0.2, alpha: 1)]
            }
            
        }
        if self.arrHolidays.contains(strEventDate){
            return [#colorLiteral(red: 0.9725490196, green: 0.8392156863, blue: 0.3647058824, alpha: 1)]
        }
        return [UIColor.white]
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        
        let strEventDate = CommonFunctions.getDateInString(date: date, strDateFormat: DateFormat.DateFormat_DDMMYYYY)
        
       
        let weekday = Calendar.current.component(.weekday, from: date)
        if(weekday == 7){
            if self.arrHolidays.contains(strEventDate){
                return #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1)
            }
            return #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1)
        }
        if(weekday == 1){
            if self.arrHolidays.contains(strEventDate){
                return #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1)
            }
            return #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1)
        }
        if self.arrAbsentDays.contains(strEventDate){
            return UIColor.black
        }
        if self.arrHolidays.contains(strEventDate){
            return UIColor.black
        }
        if date == self.calendar.today{
             return UIColor.black
        }
        return UIColor.black
    }
    
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
//        let strEventDate = CommonFunctions.getDateInString(date: date, strDateFormat: DateFormat.DateFormat_DDMMYYYY)
//
//        let weekday = Calendar.current.component(.weekday, from: date)
//        if(weekday == 7){
//            if self.arrHolidays.contains(strEventDate){
//                return #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1)
//            }
//            return #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1)
//        }
//        if(weekday == 1){
//            if self.arrHolidays.contains(strEventDate){
//                return #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1)
//            }
//            return #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1)
//        }
//        if self.arrAbsentDays.contains(strEventDate){
//            if self.arrHalfDays.contains(strEventDate){
//                return UIColor.orange
//            }else{
//                return #colorLiteral(red: 0.9137254902, green: 0.2470588235, blue: 0.2, alpha: 1)
//            }
//        }
//        if self.arrHolidays.contains(strEventDate){
//            return UIColor.white
//        }
//        if date == self.calendar.today{
//            return #colorLiteral(red: 0.2117647059, green: 0.3803921569, blue: 0.6392156863, alpha: 1)
//        }
//        return UIColor.white
//    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        
        
        let strEventDate = CommonFunctions.getDateInString(date: date, strDateFormat: DateFormat.DateFormat_DDMMYYYY)
        
        
        
        let weekday = Calendar.current.component(.weekday, from: date)
        if(weekday == 7){
            if self.arrHolidays.contains(strEventDate){
                return #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1)
            }
            return #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1)
        }
        if(weekday == 1){
            if self.arrHolidays.contains(strEventDate){
                return #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1)
            }
            return #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1)
        }
        if self.arrAbsentDays.contains(strEventDate){
            return UIColor.black
        }
        if self.arrHolidays.contains(strEventDate){
            return UIColor.black
        }
        if date == self.calendar.today{
            return UIColor.black
        }
        return UIColor.black
       // return UIColor.black
    }
    
}
extension Date {
    var isWeekend: Bool {
        return NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!.isDateInWeekend(self)
    }
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
   

}
//MARK:- API CALL -
extension ParentAttendanceViewController{
    
    func makeAPICall(calendar : FSCalendar){
        
        
        let calanderDate = Calendar.current.dateComponents([.day, .year, .month], from: Date())
        
        let values = Calendar.current.dateComponents([Calendar.Component.month, Calendar.Component.year], from: self.calendar.currentPage)
        
        let range = Calendar.current.range(of: Calendar.Component.day, in: Calendar.Component.month, for: self.calendar.currentPage)
        //TOTAL_DAYS = range.count
        let month = values.month
        
        // If Month value from FSCalendar is Greater than current month than no need to call api
        
        if (month ?? 0) > (calanderDate.month ?? 0) {
            return
        }
        
        var strMonth = ""
        if(month! >= 10){
            strMonth = "\(month!)"
        }else{
            strMonth = "0\(month!)"
        }
        let startDate = "01-" + "\(strMonth)-" + "\(values.year ?? 2020)"
        let endDate = "\(range!.count)-" + "\(strMonth)-" + "\(values.year ?? 2020)"
        print("startDate == \(startDate)")
        print("endDate == \(endDate)")
        
        strStartDate = startDate
//        if (month ?? 0) == (calanderDate.month ?? 0){
//            let endDateVal = CommonFunctions.getDateInString(date: Date(), strDateFormat: DateFormat.DateFormat_DDMMYYYY)
//            strEndDate = endDateVal
//        }else{
//            strEndDate = endDate
//        }
        strEndDate = endDate
        
        if APP_DELEGATE.userType == LoginType.School
            || APP_DELEGATE.userType == LoginType.Nursery || APP_DELEGATE.userType == LoginType.Parent{
            self.callAPIStudentAttendance { (check, objData) in
                
                self.objAttendanceData = objData
                
                let absent = Int(objData?.absent ?? 0.0)
                let total = objData?.total ?? 0
                self.lblPresent.text = "\(total - absent)"
                
                
                let arrdata = self.objAttendanceData?.data?.filter({ (objdata) -> Bool in
                    objdata.status == "WORKING"
                }) ?? [SubmitAttendanceData]()
                self.arrWorkingDays.removeAll()
                for data in arrdata{
                    let strHolidayDate = CommonFunctions.UTCToLocal(date: data.date ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_DDMMYYYY)
                    self.arrWorkingDays.append(strHolidayDate)
                }
                
                let arrdata11 = self.objAttendanceData?.data?.filter({ (objdata) -> Bool in
                    objdata.status == "HOLIDAY"
                }) ?? [SubmitAttendanceData]()
                self.arrHolidays.removeAll()
                for data in arrdata11{
                    let strHolidayDate = CommonFunctions.UTCToLocal(date: data.date ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_DDMMYYYY)
                    self.arrHolidays.append(strHolidayDate)
                }
                
                let arrFullDay = self.objAttendanceData?.absent_data?.filter({ (objdata) -> Bool in
                    objdata.absent?[0].type == "full"
                    
                }) ?? [Absent_data]()
            
                self.btnabsent.setTitle("\(arrFullDay.count)", for: .normal)
                
                let arrHalf = self.objAttendanceData?.absent_data?.filter({ (objdata) -> Bool in
                    objdata.absent?[0].type == "first" || objdata.absent?[0].type == "second"
                    
                }) ?? [Absent_data]()
                self.arrHalfDays.removeAll()
                for data in arrHalf{
                    let strHolidayDate = CommonFunctions.UTCToLocal(date: data.date ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_DDMMYYYY)
                    self.arrHalfDays.append(strHolidayDate)
                }
                self.btnHalfDay.setTitle("\(self.arrHalfDays.count)", for: .normal)
                
//                self.arrHolidays.removeAll()
//                for data in arrdata11{
//                    let strHolidayDate = CommonFunctions.getDateString(date: data.date ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_DDMMYYYY)
//                    self.arrHolidays.append(strHolidayDate)
//                }
                
                self.arrAbsentDays.removeAll()
                for data in self.objAttendanceData?.absent_data ?? [Absent_data](){
                    let strHolidayDate = CommonFunctions.UTCToLocal(date: data.date ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_DDMMYYYY)
                    self.arrAbsentDays.append(strHolidayDate)
                }
      
                self.calendar.delegate = self
                self.calendar.dataSource = self
                self.calendar.reloadData()
            }
        }
    }
    
    func callAPIStudentAttendance(finished:@escaping(_ success: Bool, _ response: SubmitAttendanceAPIResponse?) -> Void) {
        Loader.show()
        //let s_date =  CommonFunctions.getDateInString(date: firstDate ?? Date(), strDateFormat: DateFormat.DateFormat_DDMMYYYY)
        //let l_date =  CommonFunctions.getDateInString(date: lastDate ?? Date(), strDateFormat: DateFormat.DateFormat_DDMMYYYY)
        
        StaffManageMentAPI.getStudentAttendance(startDate: strStartDate , endDate: strEndDate) { (response, error) in
            Loader.hide()
            guard let response = response else {
                let message = error?.localizedDescription ?? "Invalid Response"
                self.toast(message)
                finished(false, nil)
                return
            }
            guard response.status == true else {
                self.toast(response.message ?? "")
                finished(false, nil)
                return
            }
            if (response.data?.count ?? 0) == 0{
                self.toast("No Attendance data")
                finished(false, nil)
                return
            }
            finished(true, response)
        }
    }
}
