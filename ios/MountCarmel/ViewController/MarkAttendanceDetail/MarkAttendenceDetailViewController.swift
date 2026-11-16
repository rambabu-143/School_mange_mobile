//
//  MarkAttendenceDetailViewController.swift
//  MountCarmel
//
//  Created by Sandip on 07/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

struct SelectedStudentAttendenceModel{
    var studentID:String?
    var firstHalf:Int?
    var secondHalf:Int?
    var reason : String?
    var details : String?
    var information : String?
    var name :String?
    var admission_no :String?
    var profile_pic :String?
    var isSectionChanged: Bool?
    var isWithdrawn: Bool?
}

enum bulkAttendance{
    case allPresent
    case allAbsent
    case carryForward
}

class MarkAttendenceDetailViewController: UIViewController {
    
    @IBOutlet var txtSearch: RoundTextField!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblClassName: UILabel!
    @IBOutlet var tblAttendanceList: UITableView!
    @IBOutlet weak var navigationView: NavigationBarView!
    private var arrSelectedStudent = [SelectedStudentAttendenceModel]()
    private var imgPath = ""
    

    private var selectedBulk : bulkAttendance = .allPresent
    
// Variable Received From Previous Screen
    var strDate = ""
    var standard_id = ""
    var selectedClassList : ClassListWithSectionData?
    var arrStudentsList = [MarkAttendanceListData]()
    var sectionChangedStudentsList = [MarkAttendanceListData]()
    var arrFilterStudentList = [MarkAttendanceListData]()
    var absentInfo = ("", "", "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.lblTitle.text = "Mark Attendance"
        navigationView.delegate = self
        configureTableView()
        self.txtSearch.delegate = self
        lblClassName.font = UIFont.setBoldFont(ofSize: 13.0)
        lblDate.font = UIFont.setBoldFont(ofSize: 13.0)
        self.lblDate.text = strDate
        ApiForAttendance(strDate: strDate)
    }
    
    private func ApiForAttendance(strDate:String){
        let className = (self.selectedClassList?.standard ?? "") + "-" + (self.selectedClassList?.section ?? "")
        self.lblClassName.text = className
        self.callAPIForMarkAttendanceList(strdate: strDate) { (success) in
            if(success){
                 self.lblClassName.text = className + "," + "Total: \(self.arrFilterStudentList.count)"
                
                for model in self.arrFilterStudentList{
                    if let selectedData = model.attendance{
                        if(selectedData.type == "full"){
                            self.arrSelectedStudent.append(SelectedStudentAttendenceModel(studentID: model.id, firstHalf: 1, secondHalf: 1, reason: selectedData.reason, details: selectedData.details, information: selectedData.information, name: model.name, admission_no: model.admission_no, profile_pic: model.profile_pic, isSectionChanged: model.isSectionChanged, isWithdrawn: model.standardSectionId?.section == "W"))
                        }else if(selectedData.type == "first"){
                            self.arrSelectedStudent.append(SelectedStudentAttendenceModel(studentID: model.id, firstHalf: 1, secondHalf: 0, reason: selectedData.reason, details: selectedData.details, information: selectedData.information, name: model.name, admission_no: model.admission_no, profile_pic: model.profile_pic, isSectionChanged: model.isSectionChanged, isWithdrawn: model.standardSectionId?.section == "W"))
                        }else if(selectedData.type == "second"){
                            self.arrSelectedStudent.append(SelectedStudentAttendenceModel(studentID: model.id, firstHalf: 0, secondHalf: 1, reason: selectedData.reason, details: selectedData.details, information: selectedData.information, name: model.name, admission_no: model.admission_no, profile_pic: model.profile_pic, isSectionChanged: model.isSectionChanged, isWithdrawn: model.standardSectionId?.section == "W"))
                        }
                    }
                }
                self.tblAttendanceList.reloadData()
            }
        }
    }
    
    func configureTableView() {
        // Register Cell
        let cellNib = UINib(nibName: String(describing: ClassListCell.self), bundle: nil)
        self.tblAttendanceList.register(cellNib, forCellReuseIdentifier: ClassListCell.cellId)
    }
    
    @IBAction func ShowMenuClick(_ sender: Any) {
        self.ShowMenuBtnClicked()
    }
        
    @IBAction func btnMarkAttendanceClick(_ sender: Any) {
        if self.arrSelectedStudent.count != 0 {
            if let viewController: SubmitAttendancePopUp = SubmitAttendancePopUp.storyboardInstance.initialize() {
                
                viewController.modalPresentationStyle = .overCurrentContext
                viewController.imgUrlPath = imgPath
                viewController.selectedClassList = self.selectedClassList
                let className = (self.selectedClassList?.standard ?? "") + "-" + (self.selectedClassList?.section ?? "")
                viewController.classname = className
                
                viewController.arrAbsentStudentsList = self.arrSelectedStudent
                viewController.sectionChangedStudentsList = self.sectionChangedStudentsList
                
                viewController.standard_sectionID = self.standard_id
                viewController.strDate = self.strDate
                viewController.submitHandler = { (params) in
                    if let viewController: AttendanceSubmittedPopUp = AttendanceSubmittedPopUp.storyboardInstance.initialize() {
                        viewController.modalPresentationStyle = .overCurrentContext
                        viewController.strDate = self.strDate
                        let className = (self.selectedClassList?.standard ?? "") + "-" + (self.selectedClassList?.section ?? "")
                        viewController.className = className
                      //viewController.messageText = message
                        viewController.Params = params
                        
                        var fullAbsentCount = 0
                        var halfAbsentCount = 0
                        for obj in self.arrSelectedStudent{
                            if((obj.firstHalf ?? 0) == 1 && (obj.secondHalf ?? 0) == 1){
                                fullAbsentCount = fullAbsentCount + 1
                            }else if((obj.firstHalf ?? 0) == 1 && (obj.secondHalf ?? 0) == 0){
                                halfAbsentCount = halfAbsentCount + 1
                            }else if((obj.firstHalf ?? 0) == 0 && (obj.secondHalf ?? 0) == 1){
                                halfAbsentCount = halfAbsentCount + 1
                            }
                        }
                        let modelq = MarkAttendanceAbsentDataInfo()
                        modelq.fullDay = fullAbsentCount
                        modelq.halfDay = halfAbsentCount
                        modelq.totalStudents = self.arrStudentsList.count
                        viewController.responseValue = modelq
                        viewController.closeHandler = {
                            self.navigationController?.popViewController(animated: false)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                            self.present(viewController, animated: false, completion: nil)
                        }
                    }
                }
                self.present(viewController, animated: true, completion: nil)
            }
        }else{
            self.toast("Mark atleast one student")
        }
        
    }
}

extension MarkAttendenceDetailViewController: NavigationBarViewDelegate {
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

extension MarkAttendenceDetailViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrFilterStudentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue cell
        let cell = tableView.dequeueReusableCell(withIdentifier: ClassListCell.cellId, for: indexPath) as! ClassListCell
        cell.viewController = self
        cell.viewButton.isHidden = false
        cell.lblCount.text = "\(indexPath.row + 1)"
        
        let data = self.arrFilterStudentList[indexPath.row]
            cell.lblName.text = data.name
            cell.lblID.text = data.admission_no
            //studentImageIssue
            let imageURL = imgPath+(data.profile_pic ?? "")
            cell.imgProfile.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "profile-placeholder"), options: [], context: nil)
            if(data.reason != ""){
                cell.txtReason.text = data.reason
            }else{
                cell.txtReason.text = "Select Reason"
            }
        
        if data.standardSectionId?.section == "W" {
            let disabledRed = UIColor(red: 1.0, green: 0.30, blue: 0.30, alpha: 0.2)
            cell.cardView.backgroundColor = disabledRed
        } else if data.isSectionChanged == true {
            let disabledOrange = UIColor(red: 1.0, green: 0.65, blue: 0.30, alpha: 0.2)
            cell.cardView.backgroundColor = disabledOrange
        } else {
            cell.cardView.backgroundColor = UIColor.systemBackground
        }
        
            
            if(data.information != ""){
                cell.txtInformation.text = data.information
            }else{
                cell.txtInformation.text = "Information Received"
            }
            
            if (data.reason ?? "") == "Others"{
                cell.otherReasonView.isHidden = false
            }else{
                cell.otherReasonView.isHidden = true
            }
        
        let model = self.arrSelectedStudent.filter { obj in
            (obj.admission_no ?? "0") == (data.admission_no ?? "0")
        }.first
        
        if (model?.firstHalf ?? 0) == 1{
            cell.btn1.isSelected = true
        }else{
            cell.btn1.isSelected = false
        }
        
        if(model?.secondHalf ?? 0) == 1{
            cell.btn2.isSelected = true
        }else{
            cell.btn2.isSelected = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func btn1Click(cell: ClassListCell){
        if let indexPath = self.tblAttendanceList.indexPath(for: cell){
            let filterModel = self.arrFilterStudentList[indexPath.row]
            if filterModel.standardSectionId?.section == "W" || filterModel.isSectionChanged == true {
                return
            }
            if var M = self.arrSelectedStudent.filter({ obj in (obj.admission_no ?? "0") == (filterModel.admission_no ?? "0")}).first {
                if(M.firstHalf ?? 0) == 1{
                    M.firstHalf = 0
                }else{
                    M.firstHalf = 1
                }
                if let I = self.arrSelectedStudent.firstIndex(where: { obj in (obj.admission_no ?? "0") == (M.admission_no ?? "0")}){
                    if (M.firstHalf ?? 0) == 0 && (M.secondHalf ?? 0) == 0{
                        self.arrSelectedStudent.remove(at: I)
                    }else{
                        self.arrSelectedStudent[I] = M
                    }
                }
               
            }else{
                self.arrSelectedStudent.append(SelectedStudentAttendenceModel(studentID: filterModel.id, firstHalf: 1, secondHalf: 0, reason: filterModel.attendance?.reason, details: filterModel.attendance?.details, information: filterModel.attendance?.information, name: filterModel.name, admission_no: filterModel.admission_no, profile_pic: filterModel.profile_pic,  isSectionChanged: filterModel.isSectionChanged, isWithdrawn: filterModel.standardSectionId?.section == "W"))
            }
            
            self.tblAttendanceList.reloadData()
        }
        
    }
    
    func btn2Click(cell: ClassListCell){
        if let indexPath = self.tblAttendanceList.indexPath(for: cell){
            let filterModel = self.arrFilterStudentList[indexPath.row]
            print(self.arrSelectedStudent)
            if filterModel.standardSectionId?.section == "W" || filterModel.isSectionChanged == true {
                return
            }
            if var M = self.arrSelectedStudent.filter({ obj in (obj.admission_no ?? "0") == (filterModel.admission_no ?? "0")}).first {
                if(M.secondHalf ?? 0) == 1{
                    M.secondHalf = 0
                }else{
                    M.secondHalf = 1
                }
                
                if let I = self.arrSelectedStudent.firstIndex(where: { obj in (obj.admission_no ?? "0") == (M.admission_no ?? "0")}){
                    if (M.firstHalf ?? 0) == 0 && (M.secondHalf ?? 0) == 0{
                        self.arrSelectedStudent.remove(at: I)
                    }else{
                        self.arrSelectedStudent[I] = M
                    }
                }
               
            }else{
                self.arrSelectedStudent.append(SelectedStudentAttendenceModel(studentID: filterModel.id, firstHalf: 0, secondHalf: 1, reason: filterModel.attendance?.reason, details: filterModel.attendance?.details, information: filterModel.attendance?.information, name: filterModel.name, admission_no: filterModel.admission_no, profile_pic: filterModel.profile_pic, isSectionChanged: filterModel.isSectionChanged, isWithdrawn: filterModel.standardSectionId?.section == "W"))
            }
            self.tblAttendanceList.reloadData()
        }
    }
}

extension MarkAttendenceDetailViewController{
    
    func callAPIForMarkAttendanceList(strdate:String,finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
        print(strdate)
        StaffManageMentAPI.getMarkAttendanceList(standardId: self.selectedClassList?.standard_id?.id ?? "", sectionID: self.selectedClassList?._id, date: strdate ) { (respose, error) in
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
            
            self.arrStudentsList = responseData
            self.sectionChangedStudentsList = responseData.compactMap({ data in
                return (data.isSectionChanged == true || data.id == nil) ? nil : data
            })
            self.arrFilterStudentList = self.arrStudentsList
            self.imgPath = response.path ?? ""
            
            finished(true)
        }
    }
}
extension MarkAttendenceDetailViewController : UITextFieldDelegate{
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        searchData(serchTxt: textField.text ?? "")
    }
   
    func searchData(serchTxt : String){
        self.arrFilterStudentList.removeAll()
        //print(serchTxt)
        if serchTxt.count != 0 {
            for dicData in self.arrStudentsList {
                let isMachingName : String = (dicData.name!) as String
                let range = isMachingName.range(of: serchTxt, options: .caseInsensitive)
                if range != nil {
                    self.arrFilterStudentList.append(dicData)
                }
                
                let isMachingAdmission : String = (dicData.admission_no!) as String
                let range11 = isMachingAdmission.range(of: serchTxt, options: .caseInsensitive)
                if range11 != nil {
                    self.arrFilterStudentList.append(dicData)
                }
            }
        } else {
            self.arrFilterStudentList = self.arrStudentsList
        }
        
        let className = (self.selectedClassList?.standard ?? "") + "-" + (self.selectedClassList?.section ?? "")
        self.lblClassName.text = className + "," + "Total Students: \(self.arrFilterStudentList.count)"
        self.tblAttendanceList.reloadData()
    }
}

extension MarkAttendenceDetailViewController{
    
    private func ShowMenuBtnClicked(){
        let alertVC = UIAlertController(title: "Please select one option", message: nil, preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: "Mark All Present", style: .default, handler: { _ in
            self.selectedBulk = .allPresent
            self.ShowAlertForBulk()
        }))
        alertVC.addAction(UIAlertAction(title: "Mark All Absent", style: .default, handler: { _ in
            self.selectedBulk = .allAbsent
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BulkAdsentDetailsViewController") as! BulkAdsentDetailsViewController
            vc.modalPresentationStyle = .overCurrentContext
            vc.selectedBulk = self.selectedBulk
            vc.submitHandler = { (txtreason,txtotherdetail,txtinfo,_) in
               // print(txtreason,txtotherdetail,txtinfo)
                self.absentInfo.0 = txtreason!
                self.absentInfo.1 = txtotherdetail!
                self.absentInfo.2 = txtinfo!
                print(self.absentInfo)
                self.ShowAlertForBulk()
            }
            self.present(vc, animated: false, completion: nil)
        }))
        alertVC.addAction(UIAlertAction(title: "Carry Forward", style: .default, handler: { _ in
            self.selectedBulk = .carryForward
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BulkAdsentDetailsViewController") as! BulkAdsentDetailsViewController
            vc.modalPresentationStyle = .overCurrentContext
            vc.selectedBulk = self.selectedBulk
            vc.submitHandler = { (_,_,_,txtdate) in
                if self.selectedBulk == .carryForward{
                    print(txtdate!)
                    self.ApiForAttendance(strDate: txtdate!)
                    return
                }
                self.ShowAlertForBulk()
            }
            self.present(vc, animated: false, completion: nil)
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { _ in }))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    private func ShowAlertForBulk(absentInfo:(String,String,String)? = nil){
            let attrs1 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16.0, weight: .regular), NSAttributedString.Key.foregroundColor : UIColor.black]
            let attrs2 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18.0, weight: .bold), NSAttributedString.Key.foregroundColor : selectedBulk == .allPresent ? UIColor.systemBlue : UIColor.systemRed]
            
              let attributedString1 = NSMutableAttributedString(string:"You have marked All the students as ", attributes:attrs1)
            
        let attributedString2 = NSMutableAttributedString(string:selectedBulk == .allPresent ? "Present." : "Absent.", attributes:attrs2)
            
               let attributedString3 = NSMutableAttributedString(string:"\nDo you wish to continue?", attributes:attrs1)
            
               attributedString1.append(attributedString2)
               attributedString1.append(attributedString3)
        
        let attrsTitle = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 22.0), NSAttributedString.Key.foregroundColor : UIColor.black]
       let attributedStringTitle = NSMutableAttributedString(string:"Heads up!\n", attributes:attrsTitle)
        
        let alert : UIAlertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        alert.setValue(attributedStringTitle, forKey: "attributedTitle")
        alert.setValue(attributedString1, forKey: "attributedMessage")
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            self.apiMarkBulkAttendence()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { _ in }))
        self.present(alert, animated: true, completion: nil)
    }
        
private func apiMarkBulkAttendence(absentInfo:(String,String,String)? = nil) {
        
   Loader.show()
    guard let param = paramForAbsentPresentAll() else{
        return
    }
  MarkAttendanceManagemnetAPI.submitAttendance(body:param ) { (respose, error) in
      Loader.hide()
    guard let response = respose else {
        self.toast(error?.localizedDescription ?? "Invalid Response")
       /// finished(false,"Invalid Response")
        return
    }

   guard response.status == true else {
       self.toast(response.message ?? "Invalid Response")
     /// finished(false,"Invalid Response")
      return
  }
      ///finished(true,response.message ?? "")
      
      self.navigationController?.popViewController(animated: false)
      self.toast(response.message ?? "Attendance marked successfully.")
 }
    
}
    
    private func paramForAbsentPresentAll()->[String:Any]?{
        if selectedBulk == .allPresent{
            let dictParam = SubmitAttendanceRequest(standard_section_id: selectedClassList?._id, date: strDate, standard_id: selectedClassList?.standard_id?.id ?? "")
            
            var param = dictParam.dictionary
            param["students"] = []
            param["allstudent"] = sectionChangedStudentsList.map({ studentData in
                ["student_id": studentData.id]
            })
            param["no_of_student"] = sectionChangedStudentsList.count
            print(param)
            return param
        }
        
        var arrAbsentList = [[String:Any]]()
        let type = "full"
        let ansentVal = 1.0
        
        for M in self.arrStudentsList{
            
            let dict =  SubmitAttendanceRequestStudents(value: ansentVal,
                                                        student_id:  M.id,
                                                        type: type,
                                                        reason: absentInfo.0,
                                                        details: absentInfo.1,
                                                        information: absentInfo.2)
            
            arrAbsentList.append(dict.dictionary)
        }
        
        let dictParam = SubmitAttendanceRequest(standard_section_id: selectedClassList?._id, date: strDate, standard_id: selectedClassList?.standard_id?.id ?? "")
        
        var param = dictParam.dictionary
        param["students"] = arrAbsentList
        param["allstudent"] = sectionChangedStudentsList.map({ studentData in
            ["student_id": studentData.id]
        })
        param["no_of_student"] = sectionChangedStudentsList.count
        print(param)
        return param
    }
    
}
