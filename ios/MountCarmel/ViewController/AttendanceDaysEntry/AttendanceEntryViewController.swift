//
//  AttendanceEntryViewController.swift
//  MountCarmel
//
//  Created by Sandip on 04/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import DropDown
import SDWebImage

class AttendanceEntryViewController: UIViewController {

    @IBOutlet var lblSelectTerm: UILabel!
    @IBOutlet var lblSearch: UILabel!
    @IBOutlet var lblSelectClass: UILabel!
    @IBOutlet var lblTotalStudentVAl: UILabel!
    @IBOutlet var lblTotalStudentTitle: UILabel!
    @IBOutlet var tblStudentList: UITableView!
    @IBOutlet var btnTerm3: UIButton!
    @IBOutlet var btnTerm2: UIButton!
    @IBOutlet var btnTerm1: UIButton!
    @IBOutlet var txtSearch: UITextField!
    @IBOutlet var txtSelectClass: UITextField!
    @IBOutlet weak var navigationView: NavigationBarView!
    var arrClassList = [ClassListWithSectionData]()
    var arrTitle = ["Prabal Singh","Adhya Rangarajan","Akshita Dogra","Viraj Verma","Avijit Rai","TheJangutso Mere"]
    
    var classDropDown = DropDown()
    var selectedClassIndex = -1
    var terms = 1
    private var imgPath = ""
    var arrAttendanceData = [AttendanceDayEntryData]()
    var arrAttendanceDataWithoutfilter = [AttendanceDayEntryData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.lblTitle.text = "Term Attendance"
        navigationView.delegate = self
        setHouseDropDown()
        setInitialView()
        self.txtSearch.delegate = self
        
        self.lblTotalStudentTitle.font = UIFont.setRegularFont(ofSize: 14.0)
        self.lblTotalStudentVAl.font = UIFont.setRegularFont(ofSize: 14.0)
        
        self.lblSelectTerm.font = UIFont.setBoldFont(ofSize: 13.0)
        self.lblSearch.font = UIFont.setRegularFont(ofSize: 14.0)
        self.lblSelectClass.font = UIFont.setRegularFont(ofSize: 14.0)
        btnTerm1.titleLabel?.font = UIFont.setRegularFont(ofSize: 13.0)
        btnTerm2.titleLabel?.font = UIFont.setRegularFont(ofSize: 13.0)
        btnTerm3.titleLabel?.font = UIFont.setRegularFont(ofSize: 13.0)
        
        txtSearch.font = UIFont.setRegularFont(ofSize: 13.0)
        txtSelectClass.font = UIFont.setRegularFont(ofSize: 13.0)
        btnTerm1.isSelected = true
        self.callAPIForClassList { (check) in
            if(check){
                if(self.arrClassList.count > 0){
//                    self.selectedClassIndex = 0
//                    self.txtSelectClass.text = (self.arrClassList[0].standard ?? "") + " " + (self.arrClassList[0].section ?? "")
                    
//                    self.callAPIForGetAttendanceEntry { (check) in
//                        self.tblStudentList.reloadData()
//                    }
                }
            }
        }
        self.lblTotalStudentTitle.text = ""
        self.lblTotalStudentVAl.text = ""
    }
    
    func setInitialView(){
        tblStudentList.register(UINib(nibName: "AttendanceEntryCell", bundle: nil), forCellReuseIdentifier: "AttendanceEntryCell")
    }
    
    //Set DropMenu
    func setHouseDropDown(){
        
        classDropDown.anchorView = txtSelectClass
        classDropDown.direction = .bottom
        classDropDown.textFont = UIFont.setRegularFont(ofSize: 13.0)
        classDropDown.width = txtSelectClass.frame.size.width
        classDropDown.bottomOffset = CGPoint(x: 0, y: 50)
        
    }
    
    func setClassListDropDownData(){
        var strArr = [String]()
        for item in self.arrClassList{
            let name = (item.standard ?? "") + " " + (item.section ?? "")
            strArr.append(name)
        }
        classDropDown.dataSource = strArr
        
        classDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//            self.selectedClassID = self.arrClassList[index].id ?? ""
            self.selectedClassIndex = index
            self.txtSelectClass.text = item
            self.classDropDown.hide()
            self.callAPIForGetAttendanceEntry { (check) in
                self.tblStudentList.reloadData()
            }
        }
        classDropDown.show()
    }
    
    @IBAction func actionSelectClass(_ sender: Any) {
        self.setClassListDropDownData()
    }
    
    //MARK:- Action Event -
    
    @IBAction func btnTerm3Click(_ sender: Any) {
        terms = 3
        btnTerm1.isSelected = false
        btnTerm2.isSelected = false
        btnTerm3.isSelected = true
        self.checkAPICall()
    }
    @IBAction func btnTerm2Click(_ sender: Any) {
        terms = 2
        btnTerm1.isSelected = false
        btnTerm2.isSelected = true
        btnTerm3.isSelected = false
        self.checkAPICall()
    }
    @IBAction func btnTerm1Click(_ sender: Any) {
        terms = 1
        btnTerm1.isSelected = true
        btnTerm2.isSelected = false
        btnTerm3.isSelected = false
        self.checkAPICall()
    }
    
    func checkAPICall(){
        self.view.endEditing(true)
        self.txtSearch.text = ""
        if(txtSelectClass.text!.isEmpty){
            btnTerm1.isSelected = false
            btnTerm2.isSelected = false
            btnTerm3.isSelected = false
            self.toast("Please Select Class")
        }else{
            self.callAPIForGetAttendanceEntry { (check) in
                self.tblStudentList.reloadData()
            }
        }
    }
}

extension AttendanceEntryViewController: NavigationBarViewDelegate {
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
extension AttendanceEntryViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrAttendanceData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblStudentList.dequeueReusableCell(withIdentifier: "AttendanceEntryCell", for: indexPath) as? AttendanceEntryCell
        cell?.lblIndex.text = "\(indexPath.row + 1)"
        if let W_date = arrAttendanceData[indexPath.row].date_of_withdrawal{
            cell?.lblName.text = (arrAttendanceData[indexPath.row].name ?? "") + "\n(DOW:\(CommonFunctions.getDateString(date: W_date, fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_Message2)))"
            cell?.lblName.textColor = UIColor.systemRed
            cell?.lblId.textColor =  UIColor.systemRed
        }else{
            cell?.lblName.text = arrAttendanceData[indexPath.row].name ?? ""
            cell?.lblName.textColor = UIColor.black
            cell?.lblId.textColor = UIColor.black
        }
       
        cell?.lblId.text = arrAttendanceData[indexPath.row].admission_no ?? ""
        let data = arrAttendanceData[indexPath.row].attendance_data
     //   cell?.lblTotalPresent.text = " \(data?.total_days ?? 0)" + "/" + "\((data?.total_present ?? 0.0) == 0.0 ? 0 : (data?.total_present ?? 0.0))"
        
        if (data?.total_present ?? 0.0) == 0.0{
            cell?.lblTotalPresent.text = " \(data?.total_days ?? 0) / 0"
        }else{
            let t_P = (data?.total_present ?? 0).removeZerosFromEnd()
            cell?.lblTotalPresent.text = " \(data?.total_days ?? 0) / \(t_P)"
        }
        
        let totalData = ((data?.total_present ?? 0) / Double(data?.total_days ?? Int(0.0)))
        
        let percentage = (100 * totalData)
        
        cell?.lblPercentage.text = String(format: "%.02f", percentage.isNaN ? 0 : percentage ) + " %"
        //studentImageIssue
        
        let imageUrl = self.imgPath+(arrAttendanceData[indexPath.row].profile_pic ?? "")
        cell?.imgProfile.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "profile-placeholder"), options: [], context: nil)
        
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
extension AttendanceEntryViewController{
    func callAPIForClassList(finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
        StaffManageMentAPI.classList() { (respose, error) in
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
            
            self.arrClassList = responseData
            finished(true)
        }
    }
    
    func callAPIForGetAttendanceEntry(finished:@escaping(_ success: Bool) -> Void){
        Loader.show()
        let data = self.arrClassList[selectedClassIndex]
        StaffManageMentAPI.getAttendanceDayEntry(standardId: data.standard_id?.id ?? "", sectionID: data._id, terms: terms, completion:  { (respose, error) in
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
            self.imgPath = response.path ?? ""
            self.arrAttendanceDataWithoutfilter = responseData
            self.arrAttendanceData = self.arrAttendanceDataWithoutfilter
            self.lblTotalStudentTitle.text = "Total :"
            self.lblTotalStudentVAl.text = "\(self.arrAttendanceDataWithoutfilter.count)"
            finished(true)
        })
    }
}

extension AttendanceEntryViewController : UITextFieldDelegate{
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        searchData(serchTxt: textField.text ?? "")
    }
    
    func searchData(serchTxt : String){
        self.arrAttendanceData.removeAll()
        //print(serchTxt)
        if serchTxt.count != 0 {
            for dicData in self.arrAttendanceDataWithoutfilter {
                let isMachingName : String = (dicData.name!) as String
                let range = isMachingName.range(of: serchTxt, options: .caseInsensitive)
                if range != nil {
                    self.arrAttendanceData.append(dicData)
                }
                
                let isMachingAdmission : String = (dicData.admission_no!) as String 
                let range11 = isMachingAdmission.range(of: serchTxt, options: .caseInsensitive)
                if range11 != nil {
                    self.arrAttendanceData.append(dicData)
                }
            }
        } else {
            self.arrAttendanceData = self.arrAttendanceDataWithoutfilter
        }
        
        self.lblTotalStudentTitle.text = "Total :"
       self.lblTotalStudentVAl.text = "\(self.arrAttendanceData.count)"
        self.tblStudentList.reloadData()
    }
}
