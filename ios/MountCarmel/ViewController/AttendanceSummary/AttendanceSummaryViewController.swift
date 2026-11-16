//
//  AttendanceSummaryViewController.swift
//  MountCarmel
//
//  Created by Sandip on 08/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class AttendanceSummaryViewController: UIViewController {

    @IBOutlet var btnSearch: UIButton!
    @IBOutlet var lblSelectdate: UILabel!
    @IBOutlet var tblAttendanceList: UITableView!{
        didSet{
            tblAttendanceList.delegate = self
            tblAttendanceList.dataSource = self
        }
    }
    @IBOutlet var txtDate: RoundTextField!
    @IBOutlet weak var navigationView: NavigationBarView!
    var selectedIndex = -1
    
    var arrSummaryData = [AttendanceSummaryData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.lblTitle.text = "Attendance Summary"
        navigationView.delegate = self
       // setInitialView()
        
        lblSelectdate.font = UIFont.setRegularFont(ofSize: 14.0)
        btnSearch.titleLabel?.font = UIFont.setRegularFont(ofSize: 13.0)
        txtDate.font = UIFont.setRegularFont(ofSize: 13.0)
        txtDate.text = CommonFunctions.getDateInString(date: Date(), strDateFormat: DateFormat.DateFormat_DDMMYYYY)
        self.callAPIForAttendanceSummary { (check) in
            if(check){
                self.tblAttendanceList.reloadData()
            }
        }
    }
    
    func setInitialView(){
        tblAttendanceList.register(UINib(nibName: "AttendanceSummaryCell", bundle: nil), forCellReuseIdentifier: "AttendanceSummaryCell")
    }
    //MARK:- Action Event -
    
    @IBAction func actionSearchClick(_ sender: Any) {
        self.selectedIndex = -1
        self.callAPIForAttendanceSummary { (check) in
            if(check){
                self.tblAttendanceList.reloadData()
            }
        }
    }
    
    @IBAction func btnSelectDate(_ sender: Any) {
        if let viewController: CalenderPopUpViewController = CalenderPopUpViewController.storyboardInstance.initialize() {
            
            viewController.modalPresentationStyle = .overCurrentContext
            viewController.strScreenName = "Attendance Summary"
            viewController.dateHandler = { (strDate) in
                self.txtDate.text = strDate
            }
            self.present(viewController, animated: false, completion: nil)
        }
    }
    
}
extension AttendanceSummaryViewController: NavigationBarViewDelegate {
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
extension AttendanceSummaryViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrSummaryData.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionCell = self.tblAttendanceList.dequeueReusableCell(withIdentifier: "cellSection") as? AttendanceSummaryCell2
        
           sectionCell?.imgIcon.image =  self.selectedIndex == section ? #imageLiteral(resourceName: "up") : #imageLiteral(resourceName: "downArrow")
        
           sectionCell?.buttonAction = { selectedCell in
            print(section)
            guard (self.arrSummaryData[section].students?.count ?? 0) != 0 else { return}
             self.selectedIndex = self.selectedIndex == section ? -1 : section
              self.tblAttendanceList.reloadData()
            }
        
       /* if(selectedIndex == section){
            if(sectionCell?.expandedView.isHidden == false){
                sectionCell?.setUpCell(isExpand: false)
                sectionCell?.tblHeight.constant = 0
                sectionCell?.expandedView.isHidden = true
            }else{
                sectionCell?.imgIcon.image = #imageLiteral(resourceName: "up")
                sectionCell?.setUpCell(isExpand: true)
                sectionCell?.expandedView.isHidden = false
            }
            
        }
        else{
            sectionCell?.setUpCell(isExpand: false)
            sectionCell?.tblHeight.constant = 0
            sectionCell?.expandedView.isHidden = true
        }*/
        
        let data = arrSummaryData[section]
        
        let strClass = (data.standard ?? "") + " " + (data.section ?? "")
        let title = " " + "\(data.total_absent ?? 0)"
        if(data.total_absent == 0){
           // let strTitle = "  All Present"
            sectionCell?.lblTitle.text = strClass + "  All Present"
        }else{
            let strTitle = "  absent/" + "\(data.total_student ?? 0)"
            sectionCell?.lblTitle.text = strClass + title + strTitle
        }
        
        if((data.is_attendance_marked ?? false) == true){
            let strDate = CommonFunctions.UTCToLocal(date: data.attendance_marked_at ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_selfAwarenessCombine)
            
            sectionCell?.lblDate.text = strDate
        }else{
           // let strDate = CommonFunctions.UTCToLocal(date: data.created_at ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_Notice)
            
            sectionCell?.lblDate.text = "Attendance Not Marked"
        }
        return sectionCell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedIndex != section {
            return 0
        }
        return arrSummaryData[section].students?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tblAttendanceList.dequeueReusableCell(withIdentifier:  "cellRow") as? AttendanceExpendedCell
        
        let studentData = self.arrSummaryData[indexPath.section].students?[indexPath.row]
        cell?.lblTitle.text = (studentData?.student_id?.admission_no ?? "") + "  -  " + (studentData?.student_id?.name ?? "")
        var type = (studentData?.type ?? "")
        if type == "full"{
            type = "Full Day"
        }else if type == "first"{
            type = "First Half"
        }else{
            type = "Second Half"
        }
        let reason = (studentData?.reason ?? "")
        let details = (studentData?.details ?? "")
        cell?.lblReason.text = type + "  |  " + (reason == "Others" ? details : reason)
                    
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 95.0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
   /* func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }*/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       /* if((self.arrSummaryData[indexPath.section].students?.count ?? 0) != 0){
//            if(selectedIndex != indexPath.row){
//                self.selectedIndex = indexPath.row
//            }
            self.selectedIndex = indexPath.row
            self.tblAttendanceList.reloadData()
        }else{
            self.selectedIndex = -1
            self.tblAttendanceList.reloadData()
        }*/
    }
}
extension AttendanceSummaryViewController{
    func callAPIForAttendanceSummary(finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
        StaffManageMentAPI.GetAttendanceSummary(date: txtDate.text) { (respose, error) in
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
            
            self.arrSummaryData = responseData
            if(self.arrSummaryData.count == 0){
                self.toast("No Records Found.")
            }
            
            finished(true)
        }
    }
}
