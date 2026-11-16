//
//  SchoolCalendarViewController.swift
//  MountCarmel
//
//  Created by Niraj on 06/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import FSCalendar
import TTGSnackbar

class SchoolCalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {

    @IBOutlet weak var navigationView: NavigationBarView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()


    let borderDefaultColors = ["2015/10/08": UIColor.purple, "2015/10/17": #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), "2015/10/21": #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), "2015/10/25": UIColor.purple]
    var datesWithEvent = ["2015-10-03", "2015-10-06", "2015-10-12", "2015-10-25"]
    var arrHolidays = [SubmitAttendanceData]()
    var arrEvents = [Events]()
    var arrMonthwiseEvents = [Events]()
    var arrMonthwiseHolidays = [SubmitAttendanceData]()
    var arrHolidayDates = [String]()
    var arrEventsDates = [String]()
    var isEventClick = false
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.lblTitle.text = "School Calendar"
        navigationView.delegate = self
        
        self.setupCalander()
        self.configureTableView()
    }
        
    func configureTableView() {
        
        // Register Cell
        let cellNib = UINib(nibName: String(describing: SchoolCalendarCell.self), bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: SchoolCalendarCell.cellId)
            
            // Automatic row dimension
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 67
        
        if APP_DELEGATE.userType == LoginType.Nursery {
            self.tableView.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.7607843137, blue: 0.8274509804, alpha: 1)
        }
        calendarAPICall()
    }
    
    func calendarAPICall(){
        self.callAPISchoolCalendar { (check, objResponse) in
            if(check){
                self.arrHolidays = objResponse?.holidays ?? [SubmitAttendanceData]()
                self.arrEvents = objResponse?.events ?? [Events]()
                
                self.arrHolidayDates.removeAll()
                for data in self.arrHolidays{
                    let strHolidayDate = CommonFunctions.UTCToLocal(date: data.date ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_DDMMYYYY)
                    self.arrHolidayDates.append(strHolidayDate)
                }
                
                self.arrEventsDates.removeAll()
                for data in self.arrEvents{
                    let strStartDate = CommonFunctions.UTCToLocal(date: data.start_date ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_DDMMYYYY)
                    let strEndDate = CommonFunctions.UTCToLocal(date: data.end_date ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_DDMMYYYY)
                    
                    let datesArr = Date.dates(from: CommonFunctions.getStringToDate(Format: DateFormat.DateFormat_DDMMYYYY, strDate: strStartDate), to: CommonFunctions.getStringToDate(Format: DateFormat.DateFormat_DDMMYYYY, strDate: strEndDate))
                    
                    for dateVal in datesArr{
                        let strDate = CommonFunctions.getDateInString(date: dateVal, strDateFormat: DateFormat.DateFormat_DDMMYYYY)
                        print(strDate)
                        self.arrEventsDates.append(strDate)
                        // let strEndDate = CommonFunctions.UTCToLocal(date: dateVal, fromFormat: DateFormat.DateFormate_Calender, toFormat: DateFormat.DateFormat_DDMMYYYY)
                    }
                   // print(datesArr)
                    
                }
                
                self.calendar.reloadData()
                let values = Calendar.current.dateComponents([Calendar.Component.month, Calendar.Component.year], from: self.calendar.currentPage)
                
                let month = values.month
                self.arrMonthwiseHolidays.removeAll()
                self.arrMonthwiseHolidays = self.arrHolidays.filter({ (objData) -> Bool in
                    let date = CommonFunctions.UTCToLocal(date: objData.date ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_MM)
                    // print(Int(date))
                    return month == Int(date)
                })
                
                self.arrMonthwiseEvents.removeAll()
                self.arrMonthwiseEvents = self.arrEvents.filter({ (objData) -> Bool in
                    let date = CommonFunctions.UTCToLocal(date: objData.start_date ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_MM)
                    // print(Int(date))
                    return month == Int(date)
                })
                
               // self.tableView.reloadData()
            }
        }
    }
    
    func setupCalander() {
       
        calendar.allowsMultipleSelection = false
       // calendar.swipeToChooseGesture.isEnabled = true
        calendar.backgroundColor = UIColor.white
        calendar.placeholderType = .none
        
        calendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesSingleUpperCase]
        calendar.dataSource = self
        calendar.delegate = self
        calendar.reloadData()
       // calendar.select(self.dateFormatter1.date(from: "2015/10/03"))
    }
    
    @objc func todayItemClicked(sender: AnyObject) {
           self.calendar.setCurrentPage(Date(), animated: false)
       }
       
       func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
           let strEventDate = CommonFunctions.getDateInString(date: date, strDateFormat: DateFormat.DateFormat_DDMMYYYY)
        
        
        if self.arrEventsDates.contains(strEventDate) {
            return 1
        }
        if self.arrHolidayDates.contains(strEventDate) {
            return 1
        }
           return 0
       }
       
       func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        let strEventDate = CommonFunctions.getDateInString(date: date, strDateFormat: DateFormat.DateFormat_DDMMYYYY)
        
        if self.arrEventsDates.contains(strEventDate) {
            return [#colorLiteral(red: 0.6941176471, green: 0.3411764706, blue: 0.8705882353, alpha: 1)]
        }
        if self.arrHolidayDates.contains(strEventDate) {
            return [#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)]
        }
           return nil
       }
       
//       func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
//           return appearance.selectionColor
//       }
       
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
           return nil
       }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        print(Date().startOfMonth())
        let strDateVal = "31/03/20" + (APP_DELEGATE.userInfo?.years?.last?.yearSession?.components(separatedBy: "-").last ?? "")
        return CommonFunctions.getStringToDate(Format: DateFormat.DateFormat_ddMMYYYY, strDate: strDateVal)
       // return Date().endOfMonth()
    }
    func minimumDate(for calendar: FSCalendar) -> Date {
        print(Date().startOfMonth())
        
        let strDateVal = "01/04/" + (APP_DELEGATE.userInfo?.years?.last?.yearSession?.components(separatedBy: "-").first ?? "")
        let date = CommonFunctions.UTCToLocal(date: strDateVal, fromFormat: DateFormat.DateFormat_ddMMYYYY, toFormat: DateFormat.DateFormat_ddMMYYYY)
        return CommonFunctions.getStringToDate(Format: DateFormat.DateFormat_ddMMYYYY, strDate: date)
        
    }
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        let values = Calendar.current.dateComponents([Calendar.Component.month, Calendar.Component.year], from: self.calendar.currentPage)
        
        let month = values.month
        self.arrMonthwiseHolidays.removeAll()
        self.arrMonthwiseHolidays = self.arrHolidays.filter({ (objData) -> Bool in
            let date = CommonFunctions.UTCToLocal(date: objData.date ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_MM)
           // print(Int(date))
            return month == Int(date)
        })
        
        self.arrMonthwiseEvents.removeAll()
        self.arrMonthwiseEvents = self.arrEvents.filter({ (objData) -> Bool in
            let date = CommonFunctions.UTCToLocal(date: objData.start_date ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_MM)
            // print(Int(date))
            return month == Int(date)
        })
       // self.tableView.reloadData()
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let strEventDate = CommonFunctions.getDateInString(date: date, strDateFormat: DateFormat.DateFormat_DDMMYYYY)
        
        for data in self.arrHolidays{
            let strHolidayDate = CommonFunctions.UTCToLocal(date: data.date ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_DDMMYYYY)
            
            if strHolidayDate == strEventDate{
                
                let message = data.remark ?? ""
                
                let snackbar = TTGSnackbar(message: message, duration: .middle)
                snackbar.backgroundColor = #colorLiteral(red: 1, green: 0.966917336, blue: 0.6342759728, alpha: 1)
                snackbar.messageTextAlign = .center
                snackbar.messageTextColor = UIColor.black
                snackbar.show()
                //self.calendar.reloadData()
                return
            }
        }
        
        for data in self.arrEvents{
            let strStartDate = CommonFunctions.UTCToLocal(date: data.start_date ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_DDMMYYYY)
            let strEndDate = CommonFunctions.UTCToLocal(date: data.end_date ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_DDMMYYYY)
            
            let datesArr = Date.dates(from: CommonFunctions.getStringToDate(Format: DateFormat.DateFormat_DDMMYYYY, strDate: strStartDate), to: CommonFunctions.getStringToDate(Format: DateFormat.DateFormat_DDMMYYYY, strDate: strEndDate))
            
            for dateVal in datesArr{
                let strDate = CommonFunctions.getDateInString(date: dateVal, strDateFormat: DateFormat.DateFormat_DDMMYYYY)
                if strDate == strEventDate{
                   // let message = (data.title ?? "") == "" ? (data.remark ?? "") : (data.title ?? "")
                    var message = ""
                    if data.location != ""{
                        message = "\(data.title ?? "") | \(data.location ?? "") | \(data.remark ?? "")"
                    }else{
                        message = "\(data.title ?? "") | \(data.remark ?? "")"
                    }
                    let snackbar = TTGSnackbar(message: message, duration: .middle)
                    snackbar.backgroundColor = #colorLiteral(red: 0.6941176471, green: 0.3411764706, blue: 0.8705882353, alpha: 1)
                    snackbar.messageTextAlign = .center
                    snackbar.messageTextColor = UIColor.black
                    snackbar.show()
                    //self.calendar.reloadData()
                    return
                }
                
            }
            // print(datesArr)
            
        }
        
    }
       func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
       
        return nil
       }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        
        let strEventDate = CommonFunctions.getDateInString(date: date, strDateFormat: DateFormat.DateFormat_DDMMYYYY)
        
        for data in self.arrHolidays{
            let strHolidayDate = CommonFunctions.UTCToLocal(date: data.date ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_DDMMYYYY)
            
            if strHolidayDate == strEventDate{
                return [#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)]
            }
        }
        
        for data in self.arrEvents{
            let strStartDate = CommonFunctions.UTCToLocal(date: data.start_date ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_DDMMYYYY)
            let strEndDate = CommonFunctions.UTCToLocal(date: data.end_date ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_DDMMYYYY)
            
            let datesArr = Date.dates(from: CommonFunctions.getStringToDate(Format: DateFormat.DateFormat_DDMMYYYY, strDate: strStartDate), to: CommonFunctions.getStringToDate(Format: DateFormat.DateFormat_DDMMYYYY, strDate: strEndDate))
            
            for dateVal in datesArr{
                let strDate = CommonFunctions.getDateInString(date: dateVal, strDateFormat: DateFormat.DateFormat_DDMMYYYY)
                if strDate == strEventDate{
                    return [#colorLiteral(red: 0.6941176471, green: 0.3411764706, blue: 0.8705882353, alpha: 1)]
                }
                
            }
        }
        return [ #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
    }
    
    //MARK:- ACTION EVENT -
    @IBAction func actionHolidayClick(_ sender: Any) {
        isEventClick = false
      //  self.tableView.reloadData()
    }
    
    @IBAction func actionEventClick(_ sender: Any) {
        isEventClick = true
       // self.tableView.reloadData()
    }
}

extension SchoolCalendarViewController: NavigationBarViewDelegate {
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
    func onTapStory() {
        print(#function)
    }
    func setHomeScreen() {
        if let viewController: HomeViewController = HomeViewController.storyboardInstance.initialize() {
            let contentViewController = UINavigationController(rootViewController: viewController)
            contentViewController.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
        }
    }
}

extension SchoolCalendarViewController: UITableViewDelegate {
    
}

extension SchoolCalendarViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isEventClick ? self.arrMonthwiseEvents.count : self.arrMonthwiseHolidays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue cell
        let cell = tableView.dequeueReusableCell(withIdentifier: SchoolCalendarCell.cellId, for: indexPath) as! SchoolCalendarCell
        
        if(isEventClick){
            let strDate = CommonFunctions.UTCToLocal(date: self.arrMonthwiseEvents[indexPath.row].start_date ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_DDMMYYYY)
            let strEndDate = CommonFunctions.UTCToLocal(date: self.arrMonthwiseEvents[indexPath.row].end_date ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_DDMMYYYY)
            cell.lblDate.text = strDate + " - " + strEndDate
            
            
            //       let datevar = CommonFunctions.getStringToDate(Format: DateFormat.DateFormat_ddMMYYYY, strDate: cell.lblDate.text ?? "")
            //        let monthInt = Calendar.current.component(.month, from: datevar)
            //        print(monthInt)// 4
            cell.lblTitle.text = self.arrMonthwiseEvents[indexPath.row].remark ?? ""
        }else{
            cell.lblDate.text = CommonFunctions.UTCToLocal(date: self.arrMonthwiseHolidays[indexPath.row].date ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_DDMMYYYY)
            
            
            //       let datevar = CommonFunctions.getStringToDate(Format: DateFormat.DateFormat_ddMMYYYY, strDate: cell.lblDate.text ?? "")
            //        let monthInt = Calendar.current.component(.month, from: datevar)
            //        print(monthInt)// 4
            cell.lblTitle.text = self.arrMonthwiseHolidays[indexPath.row].remark ?? ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
//MARK:- API CALL -

extension SchoolCalendarViewController {
    func callAPISchoolCalendar(finished:@escaping(_ success: Bool, _ response: SchoolCalanderAPIResponse?) -> Void) {
        Loader.show()
  
        StaffManageMentAPI.getSchoolCalendar { (response, error) in
            Loader.hide()
            guard let responseData = response else {
                self.toast(error?.localizedDescription ?? "Invalid Response")
                finished(false, nil)
                return
            }
            guard responseData.status == true else {
                self.toast(responseData.message ?? "No responce")
                finished(false, nil)
                return
            }
            
            if (responseData.events?.count ?? 0) == 0 && (responseData.holidays?.count ?? 0) == 0 {
                self.toast("No Events and Holidays data found")
                return
            }
                       
            finished(true, responseData)
        }
    }
}
extension Date {
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
}
