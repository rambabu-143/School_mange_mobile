//
//  SubmitAttendancePopUp.swift
//  MountCarmel
//
//  Created by Sandip on 07/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import DropDown

class SubmitAttendancePopUp: UIViewController {

    @IBOutlet var lblTotalStudent: UILabel!
    @IBOutlet var btnSubmit: RoundedButton!
    @IBOutlet var tblView: UITableView!
   // var submitHandler : ((MarkAttendanceAbsentDataInfo, String) -> ())?
    var submitHandler : (([String:Any]) -> ())?
    var absentdataModel = MarkAttendanceAbsentDataInfo()
    
    @IBOutlet var lblCount: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var btnClassName: RoundedButton!
    var dict : SubmitAttendanceRequest?
    var arrReasonList = [ReasonAPIData]()
    var classDropDown = DropDown()
    var selectedClassList : ClassListWithSectionData?
    // Variable Get From Previous Screen
    var classname : String?
    var strDate = ""
    var standard_sectionID = ""
//    var arrAbsentStudentsList = [HouseReportData]()
    var arrAbsentStudentsList = [SelectedStudentAttendenceModel]()
    var sectionChangedStudentsList: [MarkAttendanceListData]? = nil
    var imgUrlPath = ""
   // var responseValue : SubmitAttendanceAPIResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        configureTableView()
        self.btnClassName.titleLabel?.font = UIFont.setRegularFont(ofSize: 13.0)
         self.btnSubmit.titleLabel?.font = UIFont.setRegularFont(ofSize: 13.0)
         lblDate.font = UIFont.setRegularFont(ofSize: 13.0)
        
        lblCount.font = UIFont.setBoldFont(ofSize: 13.0)
        lblTotalStudent.font = UIFont.setBoldFont(ofSize: 13.0)
    
        self.btnClassName.setTitle(classname, for: .normal)
        self.lblDate.text = strDate
        self.lblCount.text = "\(self.arrAbsentStudentsList.count)"
        
        print(arrAbsentStudentsList)
        
        self.callAPIForReasonList { (success) in
            self.tblView.reloadData()
        }
        
    }
    
    func configureTableView() {
        // Register Cell
        let cellNib = UINib(nibName: String(describing: ClassListCell.self), bundle: nil)
        self.tblView.register(cellNib, forCellReuseIdentifier: ClassListCell.cellId)
    }
    
    @IBAction func btnCloseClick(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnSubmitAttendanceClick(_ sender: Any) {
        self.view.endEditing(true)
        
        for obj in self.arrAbsentStudentsList{
            if (obj.information ?? "") == ""{
                self.toast("Please update 'Information Received' for all students marked absent")
                return
            }
        }
        
        var arrAbsentList = [[String:Any]]()
        var type = ""
        var ansentVal = 0.0
       
       // let information = "Application letter"
        var fullAbsentCount = 0
        var halfAbsentCount = 0
        for M in self.arrAbsentStudentsList{
            
            if (M.firstHalf ?? 0) == 1 && (M.secondHalf ?? 0) == 1{
                type = "full"
                ansentVal = 1
                fullAbsentCount = fullAbsentCount + 1
                
            }else if (M.firstHalf ?? 0) == 1 && (M.secondHalf ?? 0) == 0{
                type = "first"
                ansentVal = 0.5
                halfAbsentCount = halfAbsentCount + 1
            }else if (M.firstHalf ?? 0) == 0 && (M.secondHalf ?? 0) == 1{
                type = "second"
                ansentVal = 0.5
                halfAbsentCount = halfAbsentCount + 1
            }
            
//            let dict = SubmitAttendanceRequest(standard_section_id: standard_sectionID, attendance_date: self.strDate, student_id: self.arrAbsentStudentsList[i].id, type: type, reason: self.arrAbsentStudentsList[i].reason, information: self.arrAbsentStudentsList[i].information)
            
            let dict = SubmitAttendanceRequestStudents(value: ansentVal,
                                            student_id: M.studentID,
                                            type: type,
                                            reason: M.reason,
                                            details: M.details,
                                            information: M.information)
            
            arrAbsentList.append(dict.dictionary)
        }
        
        let dictParam = SubmitAttendanceRequest(standard_section_id: selectedClassList?._id, date: strDate, standard_id: selectedClassList?.standard_id?.id ?? "")
        
        var param = dictParam.dictionary
        param["students"] = arrAbsentList
        param["allstudent"] = sectionChangedStudentsList?.map({ studentData in
            ["student_id": studentData.id]
        })
        param["no_of_student"] = sectionChangedStudentsList?.count
        print(param)
        
        if(self.submitHandler != nil){
            self.submitHandler!(param)
            self.dismiss(animated: false, completion: nil)
        }
        
    }
    
}
extension SubmitAttendancePopUp: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrAbsentStudentsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue cell
        let cell = tableView.dequeueReusableCell(withIdentifier: ClassListCell.cellId, for: indexPath) as! ClassListCell
        cell.viewController2 = self
        cell.viewButton.isHidden = false
        cell.viewBottom.isHidden = false
        cell.lblCount.text = "\(indexPath.row + 1)"
        cell.btn1.isSelected = false
        cell.btn2.isSelected = false
        cell.otherReasonTextField.tag = indexPath.row
        cell.otherReasonTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)

        let absentStudentData = self.arrAbsentStudentsList[indexPath.row]
        cell.setUpCell(data: absentStudentData, path: imgUrlPath)
        
        
        if absentStudentData.isWithdrawn == true {
            let disabledRed = UIColor(red: 1.0, green: 0.30, blue: 0.30, alpha: 0.2)
            cell.cardView.backgroundColor = disabledRed
            cell.container.backgroundColor = disabledRed
            cell.viewBottom.backgroundColor = disabledRed
            cell.btnReason.isEnabled = false
            cell.txtReason.isEnabled = false
            cell.txtReason.alpha = CGFloat(0.4)
            cell.btnInformation.isEnabled = false
            cell.txtInformation.isEnabled = false
            cell.txtInformation.alpha = CGFloat(0.4)
        } else if absentStudentData.isSectionChanged == true {
            let disabledOrange = UIColor(red: 1.0, green: 0.65, blue: 0.30, alpha: 0.2)
            cell.cardView.backgroundColor = disabledOrange
            cell.container.backgroundColor = disabledOrange
            cell.viewBottom.backgroundColor = disabledOrange
            cell.btnReason.isEnabled = false
            cell.txtReason.isEnabled = false
            cell.txtReason.alpha = CGFloat(0.4)
            cell.btnInformation.isEnabled = false
            cell.txtInformation.isEnabled = false
            cell.txtInformation.alpha = CGFloat(0.4)
        } else {
            cell.cardView.backgroundColor = UIColor.systemBackground
            cell.container.backgroundColor = UIColor.systemBackground
            cell.viewBottom.backgroundColor = UIColor.systemBackground
            cell.btnReason.isEnabled = true
            cell.txtReason.isEnabled = true
            cell.txtReason.alpha = CGFloat(1.0)
            cell.btnInformation.isEnabled = true
            cell.txtInformation.isEnabled = true
            cell.txtInformation.alpha = CGFloat(1.0)
        }
        
        if(self.arrAbsentStudentsList[indexPath.row].firstHalf ?? 0) == 1{
            cell.btn1.isSelected = true
        }
        
        if(self.arrAbsentStudentsList[indexPath.row].secondHalf ?? 0) == 1{
            cell.btn2.isSelected = true
        }
        
        return cell
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.arrAbsentStudentsList[textField.tag].details = textField.text!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func btn1Click(cell: ClassListCell){
      /*  if let indexPath = self.tblView.indexPath(for: cell){
            if(self.selectedArr1[indexPath.row] == 1){
                self.selectedArr1[indexPath.row] = 0
            }else{
                self.selectedArr1[indexPath.row] = 1
            }
            self.tblView.reloadData()
        }*/
    }
    
    func btn2Click(cell: ClassListCell){
      /*  if let indexPath = self.tblView.indexPath(for: cell){
            if(self.selectedArr2[indexPath.row] == 1){
                self.selectedArr2[indexPath.row] = 0
            }else{
                self.selectedArr2[indexPath.row] = 1
            }
            self.tblView.reloadData()
        }*/
    }
    
    func selectInformation(cell: ClassListCell){
        if let indexPath = self.tblView.indexPath(for: cell){
            let text = cell.txtInformation.text ?? ""
            //print(text)
            self.arrAbsentStudentsList[indexPath.row].information = text
        }
    }
    
    func selectReasonData(cell: ClassListCell){
        if let indexPath = self.tblView.indexPath(for: cell){
            //classDropDown = DropDown()
            classDropDown.anchorView = cell.btnReason
            classDropDown.direction = .bottom
            classDropDown.textFont = UIFont.setRegularFont(ofSize: 13.0)
            classDropDown.width = self.tblView.frame.size.width/2
            classDropDown.bottomOffset = CGPoint(x: 0, y: 50)
            
            var strArr = [String]()
            for item in self.arrReasonList{
                strArr.append(item.reason!)
            }
                    classDropDown.dataSource = strArr
            
                    classDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                        
                        // print("Selected item: \(item) at index: \(index)")
                        self.arrAbsentStudentsList[indexPath.row].reason = item
                        cell.txtReason.text = item
                        self.tblView.reloadRows(at: [indexPath], with: .none)
                        self.classDropDown.hide()
                    }
                    classDropDown.show()
        }
    }
    
    func selectInformationData(cell: ClassListCell){
        if let indexPath = self.tblView.indexPath(for: cell){
            //classDropDown = DropDown()
            classDropDown.anchorView = cell.btnInformation
            classDropDown.direction = .bottom
            classDropDown.textFont = UIFont.setRegularFont(ofSize: 13.0)
            classDropDown.width = self.tblView.frame.size.width
            classDropDown.bottomOffset = CGPoint(x: 0, y: 0)
            
            var strArr = [String]()
            strArr.append("Information Received")
            strArr.append("YES")
            strArr.append("NO")
            
            classDropDown.dataSource = strArr
            
            classDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                if item != "Information Received"{
                    self.arrAbsentStudentsList[indexPath.row].information = item
                    cell.txtInformation.text = item
                    self.tblView.reloadRows(at: [indexPath], with: .none)
                }
                self.classDropDown.hide()
            }
            classDropDown.show()
        }
    }
}
extension SubmitAttendancePopUp{
    
    func callAPIForReasonList(finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
        MarkAttendanceManagemnetAPI.getAttendanceReason() { (respose, error) in
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
            // ADDING CUSTOM REASON
            let tempDict = [
                "_id" : "5f09603d02015b0a53946fb225",
                "created_at" : "2020-07-11T09:08:36.853Z",
                "reason" : "Select Reason",
                "updated_at" : "2020-07-11T09:08:36.854Z" ]
            let data = try! JSONSerialization.data(withJSONObject: tempDict, options: [])
            let model = try! JSONDecoder().decode(ReasonAPIData.self, from: data)
            self.arrReasonList.append(model)

            for M in responseData{
                self.arrReasonList.append(M)
            }
            //self.arrReasonList = responseData
            finished(true)
        }
    }
}
