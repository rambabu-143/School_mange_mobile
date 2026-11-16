//
//  ClassViewController.swift
//  MountCarmel
//
//  Created by Sandip on 06/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import DropDown

class ClassViewController: UIViewController {

    @IBOutlet var lblSelectDate: UILabel!
    @IBOutlet var lblSelectClass: UILabel!
    @IBOutlet var btnSave: RoundedButton!
    @IBOutlet var txtDate: RoundTextField!
    @IBOutlet var tblStudentList: UITableView!
    @IBOutlet var txtSearch: UITextField!
    @IBOutlet var txtSelectClass: UITextField!
    
    var arrClassWiseList = [WiseListData]()
    
    var arrStudentsList = [HouseReportData]()
    var arrStudentsListWithoutFilter = [HouseReportData]()
    
    var arrClassList = [ClassListWithSectionData]()
    private var imgPath = ""
    
    var selectedClassID : String = ""
    var classDropDown = DropDown()
    var arrSelectedStudentList = [[String:Any]]()
    private var calenderStartDate = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialView()
        self.setClassDropDown()
        self.txtSearch.delegate = self
        self.txtSelectClass.text = APP_DELEGATE.userInfo?.staffId?.classTeacherID?.standard ?? ""
        txtDate.text = CommonFunctions.getDateInString(date: Date(), strDateFormat: DateFormat.DateFormat_DDMMYYYY)
        
        lblSelectClass.font = UIFont.setRegularFont(ofSize: 14.0)
        lblSelectDate.font = UIFont.setRegularFont(ofSize: 14.0)
        
        txtSelectClass.font = UIFont.setRegularFont(ofSize: 13.0)
        txtDate.font = UIFont.setRegularFont(ofSize: 13.0)
        txtSearch.font = UIFont.setRegularFont(ofSize: 13.0)
        
        btnSave.titleLabel?.font = UIFont.setBoldFont(ofSize: 13.0)
        
        self.callAPI()
        self.callAPIStartDate()
    }
    
    func callAPI(){
        self.callAPIForClassList { (check) in
            if(check){
                if(self.arrClassList.count > 0){
//                    self.selectedClassID = self.arrClassList[0]._id ?? ""
//                    self.txtSelectClass.text = (self.arrClassList[0].standard ?? "") + " " + (self.arrClassList[0].section ?? "")
                    
//                    self.callAPIForClassListByID(finished: { (success) in
//                        if(success){
//                            self.tblStudentList.reloadData()
//                        }
//                    })
                }
            }
        }
    }
    
   private func callAPIStartDate(){
       // 1 apr / 30 sept (1st term)
       // 1 oct / 31 march (2nd term)
       let arr = [4,5,6,7,8,9]
       var currentTerm = ""
       let calendar = Calendar.current
       let components = calendar.dateComponents([.month], from: Date())
       if let M = components.month,arr.contains(M){
           currentTerm = "1"
       }else{
           currentTerm = "2"
       }
      
       self.callAPIForStartDate(term: currentTerm) { success,startDate  in
           print(startDate)
           self.calenderStartDate = startDate ?? ""
       }
    }
    
    func setInitialView(){
        tblStudentList.register(UINib(nibName: "WiseClassListCell", bundle: nil), forCellReuseIdentifier: "WiseClassListCell")
    }
    
    func setClassDropDown(){
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
            self.selectedClassID = self.arrClassList[index]._id ?? ""
            self.txtSelectClass.text = item
            self.classDropDown.hide()
            self.callAPIForClassListByID { (success) in
                self.tblStudentList.reloadData()
            }
        }
        classDropDown.show()
    }
    
    @IBAction func actionSelectClass(_ sender: Any) {
        self.setClassListDropDownData()
    }
    
    @IBAction func actionSaveClick(_ sender: Any) {
        
        if(self.arrSelectedStudentList.count > 0){
            if let viewController: ClassPublishAlertViewController = ClassPublishAlertViewController.storyboardInstance.initialize() {
                viewController.modalPresentationStyle = .overCurrentContext
                print(self.arrSelectedStudentList)
                viewController.arrSelectedList = self.arrSelectedStudentList
                viewController.strClass = self.txtSelectClass.text ?? ""
                viewController.doneHandler = { (strMsg) in
                    self.toast(strMsg)
                    self.txtSearch.text = ""
                    self.arrSelectedStudentList.removeAll()
                    self.callAPIForClassListByID(finished: { (success) in
                        if(success){
                            self.tblStudentList.reloadData()
                        }
                    })
                    //self.setHomeScreen()
                }
                self.present(viewController, animated: false, completion: nil)
            }
        }else{
            self.toast("Select atleast one student card with information")
        }
   }
    
    @IBAction func actionSelectData(_ sender: Any) {
        if let viewController: CalenderPopUpViewController = CalenderPopUpViewController.storyboardInstance.initialize() {
            
            viewController.modalPresentationStyle = .overCurrentContext
            viewController.strScreenName = "Wise"
            viewController.wiseCalenderStartDate = calenderStartDate
            viewController.dateHandler = { (strDate) in
                self.txtDate.text = strDate
            }
            self.present(viewController, animated: false, completion: nil)
        }
    }
    
    @IBAction func actionSearchClick(_ sender: Any) {
        
    }
    
    func setHomeScreen() {
        if let viewController: HomeViewController = HomeViewController.storyboardInstance.initialize() {
            let contentViewController = UINavigationController(rootViewController: viewController)
            contentViewController.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
        }
    }
}

extension ClassViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrStudentsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblStudentList.dequeueReusableCell(withIdentifier: "WiseClassListCell", for: indexPath) as? WiseClassListCell
        cell?.viewController = self
        cell?.lblIndex.text = "\(indexPath.row + 1)"

        cell?.setUpCell(data: self.arrStudentsList[indexPath.row], path: imgPath)
        cell?.viewLine.isHidden = true
        cell?.lblReason.isHidden = true
        cell?.lblStaticFor.isHidden = true
        
        cell?.btn1.isSelected = false
        cell?.btn2.isSelected = false
        cell?.btn3.isSelected = false
        cell?.btn4.isSelected = false

        if(self.arrSelectedStudentList.count > 0){
            for i in 0..<self.arrSelectedStudentList.count{
                if(self.arrSelectedStudentList[i]["student_id"] as? String == self.arrStudentsList[indexPath.row].id){
                    if(self.arrSelectedStudentList[i]["worthy"] as? Int == 1){
//                        cell?.btn1.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//                        cell?.btn1.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                        cell?.btn1.isSelected = true
                        
                        cell?.viewLine.isHidden = false
                        cell?.lblReason.isHidden = false
                        cell?.lblStaticFor.isHidden = false
                        cell?.lblReason.text = self.arrSelectedStudentList[i]["reason"] as? String
                    }
                    
                    else if(self.arrSelectedStudentList[i]["intellect"] as? Int == 1){
                         cell?.btn2.isSelected = true
//                        cell?.btn2.backgroundColor = #colorLiteral(red: 0.2117647059, green: 0.3803921569, blue: 0.6392156863, alpha: 1)
//                        cell?.btn2.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                        
                        cell?.viewLine.isHidden = false
                        cell?.lblReason.isHidden = false
                        cell?.lblStaticFor.isHidden = false
                        cell?.lblReason.text = self.arrSelectedStudentList[i]["reason"] as? String
                    }
                    else if(self.arrSelectedStudentList[i]["stature"] as? Int == 1){
                                      
                        cell?.btn3.isSelected = true
//                        cell?.btn3.backgroundColor = #colorLiteral(red: 0.9620772004, green: 0.6563818455, blue: 0.2461998165, alpha: 1)
//                        cell?.btn3.setTitleColor( #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                        
                        cell?.viewLine.isHidden = false
                        cell?.lblReason.isHidden = false
                        cell?.lblStaticFor.isHidden = false
                        cell?.lblReason.text = self.arrSelectedStudentList[i]["reason"] as? String
                    }
                    else if(self.arrSelectedStudentList[i]["emotion"] as? Int == 1){
                        
                        cell?.btn4.isSelected = true
//                        cell?.btn4.backgroundColor = #colorLiteral(red: 0.2901960784, green: 0.6039215686, blue: 0.4588235294, alpha: 1)
//                        cell?.btn4.setTitleColor( #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                        
                        cell?.viewLine.isHidden = false
                        cell?.lblReason.isHidden = false
                        cell?.lblStaticFor.isHidden = false
                        cell?.lblReason.text = self.arrSelectedStudentList[i]["reason"] as? String
                    }
                }
            }
           
        }
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func btn1Click(title : String , cell : WiseClassListCell){
        if let indexPath = self.tblStudentList.indexPath(for: cell){
            if let viewController: PopUpViewController = PopUpViewController.storyboardInstance.initialize() {
                
                viewController.modalPresentationStyle = .overCurrentContext
                viewController.strTitle = title
                viewController.doneHandler = { (strDesc) in
                    if(strDesc != ""){
                        //Change Colors
                        
                    }else{
                        cell.viewLine.isHidden = true
                        cell.lblReason.isHidden = true
                        cell.lblStaticFor.isHidden = true
            
                    }
                    
                    let dict = WiseClassRequestParam(wise_date: self.txtDate.text ?? "", worthy: 1, student_id: self.arrStudentsList[indexPath.row].id, intellect: 0, reason: strDesc, stature: 0, emotion: 0,admission_no :self.arrStudentsList[indexPath.row].admission_no ?? "")
                    
                    if let index = self.arrSelectedStudentList.firstIndex(where: {$0["student_id"] as? String == self.arrStudentsList[indexPath.row].id}) {
                        //self.arrSelectedStudentList[index] = dict.dictionary
                        self.arrSelectedStudentList.remove(at: index)
                    }
                    self.arrSelectedStudentList.append(dict.dictionary)
                    self.tblStudentList.reloadData()
                    
                }
                self.present(viewController, animated: true, completion: nil)
            }
        }

    }
    
    func btn2Click(title : String , cell : WiseClassListCell){
        if let indexPath = self.tblStudentList.indexPath(for: cell){
            
        if let viewController: PopUpViewController = PopUpViewController.storyboardInstance.initialize() {
           
            viewController.modalPresentationStyle = .overCurrentContext
            viewController.strTitle = title
            viewController.doneHandler = { (strDesc) in
                if(strDesc != ""){
                   
                }else{
                    cell.viewLine.isHidden = true
                    cell.lblReason.isHidden = true
                    cell.lblStaticFor.isHidden = true
                    self.tblStudentList.reloadData()
                }
                let dict = WiseClassRequestParam(wise_date: self.txtDate.text ?? "", worthy: 0, student_id: self.arrStudentsList[indexPath.row].id, intellect: 1, reason: strDesc, stature: 0, emotion: 0,admission_no :self.arrStudentsList[indexPath.row].admission_no ?? "")
                if let index = self.arrSelectedStudentList.firstIndex(where: {$0["student_id"] as? String == self.arrStudentsList[indexPath.row].id}) {
                    //self.arrSelectedStudentList[index] = dict.dictionary
                    self.arrSelectedStudentList.remove(at: index)
                }
              self.arrSelectedStudentList.append(dict.dictionary)
                self.tblStudentList.reloadData()
                
            }
            self.present(viewController, animated: true, completion: nil)
        }
      }
    }
    
    func btn3Click(title : String , cell : WiseClassListCell){
       if let indexPath = self.tblStudentList.indexPath(for: cell){
        if let viewController: PopUpViewController = PopUpViewController.storyboardInstance.initialize() {
            
            viewController.modalPresentationStyle = .overCurrentContext
            viewController.strTitle = title
            viewController.doneHandler = { (strDesc) in
                if(strDesc != ""){
                   
                }else{
                    cell.viewLine.isHidden = true
                    cell.lblReason.isHidden = true
                    cell.lblStaticFor.isHidden = true
                    
                }
                let dict = WiseClassRequestParam(wise_date: self.txtDate.text ?? "", worthy: 0, student_id: self.arrStudentsList[indexPath.row].id, intellect: 0, reason: strDesc, stature: 1, emotion: 0,admission_no :self.arrStudentsList[indexPath.row].admission_no ?? "")
                
                if let index = self.arrSelectedStudentList.firstIndex(where: {$0["student_id"] as? String == self.arrStudentsList[indexPath.row].id}) {
                    //self.arrSelectedStudentList[index] = dict.dictionary
                    self.arrSelectedStudentList.remove(at: index)
                }
                self.arrSelectedStudentList.append(dict.dictionary)
                self.tblStudentList.reloadData()
                
            }
            self.present(viewController, animated: true, completion: nil)
        }
      }
    }
    
    func btn4Click(title : String , cell : WiseClassListCell){
        if let indexPath = self.tblStudentList.indexPath(for: cell){
            
        if let viewController: PopUpViewController = PopUpViewController.storyboardInstance.initialize() {
            
            viewController.modalPresentationStyle = .overCurrentContext
            viewController.strTitle = title
            viewController.doneHandler = { (strDesc) in
                if(strDesc != ""){
                    
                   
                }else{
                    cell.viewLine.isHidden = true
                    cell.lblReason.isHidden = true
                    cell.lblStaticFor.isHidden = true
                    
                }
                let dict = WiseClassRequestParam(wise_date: self.txtDate.text ?? "", worthy: 0, student_id: self.arrStudentsList[indexPath.row].id, intellect: 0, reason: strDesc, stature: 0, emotion: 1,admission_no :self.arrStudentsList[indexPath.row].admission_no ?? "")
               
                
                if let index = self.arrSelectedStudentList.firstIndex(where: {$0["student_id"] as? String == self.arrStudentsList[indexPath.row].id}) {
                    //self.arrSelectedStudentList[index] = dict.dictionary
                    self.arrSelectedStudentList.remove(at: index)
                }
            self.arrSelectedStudentList.append(dict.dictionary)
                self.tblStudentList.reloadData()
            }
            self.present(viewController, animated: true, completion: nil)
        }
            
       }
    }
    
    func getDate() -> String{
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateString = dateFormatter.string(from: date)
        print(dateString)
        return dateString
    }
}

extension ClassViewController {
    func callAPIForClassList(finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
        StaffManageMentAPI.classList() { (respose, error) in
            Loader.hide()
            guard let response = respose else {
                self.toast(error?.localizedDescription ?? "Invalid Response")
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
    
    func callAPIForStartDate(term:String,finished:@escaping(_ success: Bool,_ startDate:String?) -> Void) {
        Loader.show()
        StaffManageMentAPI.GetStartDate(term: term) { (respose, error) in
            Loader.hide()
            guard let response = respose else {
                self.toast(error?.localizedDescription ?? "Invalid Response")
                finished(false,nil)
                return
            }
            
            guard let responseData = response.data else {
                self.toast(response.message ?? "Invalid Response")
                finished(false,nil)
                return
            }
            print(responseData)
            finished(true,responseData.start_date)
        }
       
    }
    
    func callAPIForClassWiseList(finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
        
        
        let dtForm : DateFormatter = DateFormatter()
        dtForm.dateFormat = "yyyy"
       // let strStart : String = "20-01-2019"
       // let strEnd : String = "31-03-2020"
        let strStart : String = "20-01-2021"
         let strEnd : String = "31-03-2022"

        //WiseManagementAPI.classWise
        WiseManagementAPI.studentWise(scanedID: self.selectedClassID, startDate: strStart, endDate: strEnd) { (response, error) in
            Loader.hide()
            guard let response = response else {
                self.toast(error?.localizedDescription ?? "Invalid Response")
                finished(false)
                return
            }
            
            guard let responseData = response.data else {
                self.toast(response.message ?? "Invalid Response")
                finished(false)
                return
            }
            
            self.arrClassWiseList = responseData
            finished(true)
        }
    }
    
    func callAPIForClassListByID(finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
       // self.selectedClassID = "5e805e7fba400d5f03d1d874"
        StaffManageMentAPI.classWiseListByID(classID: self.selectedClassID) { (respose, error) in
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
            self.arrStudentsListWithoutFilter = responseData
            self.arrStudentsList = self.arrStudentsListWithoutFilter
            if(self.arrStudentsList.count == 0){
                self.btnSave.isUserInteractionEnabled = false
                self.toast("No students found")
            }else{
                self.btnSave.isUserInteractionEnabled = true
            }
            finished(true)
        }
    }
}
extension ClassViewController : UITextFieldDelegate{
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        searchData(serchTxt: textField.text ?? "")
    }
    
    func searchData(serchTxt : String){
        self.arrStudentsList.removeAll()
        //print(serchTxt)
        if serchTxt.count != 0 {
            for dicData in self.arrStudentsListWithoutFilter {
                let isMachingName : String = (dicData.name!) as String
                let range = isMachingName.range(of: serchTxt, options: .caseInsensitive)
                if range != nil {
                    self.arrStudentsList.append(dicData)
                }
                
                let isMachingAdmission : String = (dicData.admission_no!) as String
                let range11 = isMachingAdmission.range(of: serchTxt, options: .caseInsensitive)
                if range11 != nil {
                    self.arrStudentsList.append(dicData)
                }
            }
        } else {
            self.arrStudentsList = self.arrStudentsListWithoutFilter
        }
        
//        let className = (self.selectedClassList?.standard ?? "") + "-" + (self.selectedClassList?.section ?? "")
//        self.lblClassName.text = className + "," + "Total Students: \(self.arrFilterStudentList.count)"
        
        self.tblStudentList.reloadData()
    }
}

