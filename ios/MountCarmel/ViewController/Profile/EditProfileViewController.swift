//
//  EditProfileViewController.swift
//  MountCarmel
//
//  Created by Mandeep Singh on 31/08/22.
//  Copyright © 2022 InventionHill. All rights reserved.
//

import UIKit
import DTTextField
import DropDown

class EditProfileViewController: UIViewController {
    @IBOutlet weak var navigationView: NavigationBarView!
    @IBOutlet weak var tblView: UITableView!{
        didSet{
            tblView.delegate = self
            tblView.dataSource = self
    }}
    @IBOutlet weak var GENERAL_txtDateBirth: DTTextField!
    @IBOutlet weak var GENERAL_txtMobileNo: DTTextField!
    @IBOutlet weak var GENERAL_txtLocalAddress: DTTextField!
    @IBOutlet weak var GENERAL_txtCity: DTTextField!
    @IBOutlet weak var GENERAL_txtPin: DTTextField!
    @IBOutlet weak var SOS_txtName: DTTextField!
    @IBOutlet weak var SOS_txtMobileNo: DTTextField!
    @IBOutlet weak var SCHOOL_txtDateOfJoining: DTTextField!
    @IBOutlet weak var SCHOOL_txtQualification: DTTextField!
    @IBOutlet weak var SCHOOL_txtDepartment: DTTextField!
    @IBOutlet weak var SCHOOL_txtStaffRoom: DTTextField!
    @IBOutlet weak var PERSONAL_txtSpouseName: DTTextField!
    @IBOutlet weak var PERSONAL_txtAnniversary: DTTextField!
    @IBOutlet weak var PERSONAL_txtChildInMCS: DTTextField!
    @IBOutlet weak var PERSONAL_txtAdmissionNo: DTTextField!
    
    private var arrAllDepartment = [DepartmentModel]()
    private var arrAllCity = [CityModel]()
    private var arrAllStaffRoom = [StaffRoomModel]()
    private var arrStudents : [EditStudentDataModel] = [] {
        didSet{
            self.tblView.reloadData()
            self.PERSONAL_txtAdmissionNo.text = ""
        }
    }
    
    private var selectedDepartment :  DepartmentModel?{
        didSet{
            self.SCHOOL_txtDepartment.text = selectedDepartment?.name ?? ""
        }
    }
    private var selectedStaffRoom :  StaffRoomModel?{
        didSet{
            self.SCHOOL_txtStaffRoom.text = selectedStaffRoom?.room_no ?? ""
        }
    }
    private var commonDropDown = DropDown()
    
    private var datePicker = UIDatePicker()
    private var selectedDateTextfield = UITextField()
    var objStaffProfileData : LoginAPIStaffId_Separate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.lblTitle.text = "Edit Profile"
        navigationView.delegate = self
        
        datePicker.maximumDate = Date()
        datePicker.datePickerMode = .date
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        }else if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        self.hitInitialApis()
        self.setAlreadySavedData()
    }
    
    private func setAlreadySavedData(){
        GENERAL_txtDateBirth.borderWidth = 1.5
        GENERAL_txtMobileNo.borderWidth = 1.5
        GENERAL_txtLocalAddress.borderWidth = 1.5
        GENERAL_txtCity.borderWidth = 1.5
        GENERAL_txtPin.borderWidth = 1.5
        SOS_txtName.borderWidth = 1.5
        SOS_txtMobileNo.borderWidth = 1.5
        SCHOOL_txtDateOfJoining.borderWidth = 1.5
        SCHOOL_txtQualification.borderWidth = 1.5
        SCHOOL_txtDepartment.borderWidth = 1.5
        SCHOOL_txtStaffRoom.borderWidth = 1.5
        PERSONAL_txtSpouseName.borderWidth = 1.5
        PERSONAL_txtAnniversary.borderWidth = 1.5
        PERSONAL_txtChildInMCS.borderWidth = 1.5
        PERSONAL_txtAdmissionNo.borderWidth = 1.5
        
        GENERAL_txtDateBirth.delegate = self
        GENERAL_txtCity.delegate = self
        SCHOOL_txtDateOfJoining.delegate = self
        SCHOOL_txtDepartment.delegate = self
        SCHOOL_txtStaffRoom.delegate = self
        PERSONAL_txtAnniversary.delegate = self
        PERSONAL_txtChildInMCS.delegate = self
        
        GENERAL_txtDateBirth.text = CommonFunctions.getDateString(date: (objStaffProfileData?.dateOfBirth ?? ""), fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_DDMMYYYY)
        GENERAL_txtMobileNo.text = objStaffProfileData?.mobile
        GENERAL_txtLocalAddress.text = objStaffProfileData?.address?.localAddress ?? ""
        GENERAL_txtCity.text = objStaffProfileData?.address?.city ?? ""
        GENERAL_txtPin.text = objStaffProfileData?.address?.pincode ?? ""
        
        SOS_txtName.text = objStaffProfileData?.emergency_name ?? ""
        SOS_txtMobileNo.text = objStaffProfileData?.emergency_mobile ?? ""
        
        SCHOOL_txtDateOfJoining.text = CommonFunctions.getDateString(date: (objStaffProfileData?.dateOfJoining ?? ""), fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_DDMMYYYY)
        SCHOOL_txtQualification.text = objStaffProfileData?.qualification ?? ""
        //SCHOOL_txtDepartment.text = objStaffProfileData?.departmentId?.name ?? ""
        //SCHOOL_txtStaffRoom.text = objStaffProfileData?.staffroomId?.roomNo ?? ""
        selectedDepartment = DepartmentModel(_id: objStaffProfileData?.departmentId?.id ?? "", name: objStaffProfileData?.departmentId?.name ?? "")
        selectedStaffRoom = StaffRoomModel(_id: objStaffProfileData?.staffroomId?.ID ?? "", room_no: objStaffProfileData?.staffroomId?.roomNo ?? "")
        
        PERSONAL_txtSpouseName.text = objStaffProfileData?.spousename ?? ""
        PERSONAL_txtAnniversary.text = CommonFunctions.getDateString(date: (objStaffProfileData?.dateofanniversary ?? ""), fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_DDMMYYYY)
        
        
         
        self.arrStudents.removeAll()
        for obj in objStaffProfileData?.students ?? []{
            self.arrStudents.append(EditStudentDataModel(name: obj.student_id?.name ?? "", admission_no: obj.student_id?.admission_no ?? "", student_id: obj.student_id?._id ?? ""))
        }
        
        PERSONAL_txtChildInMCS.text = (objStaffProfileData?.students?.count ?? 0) == 0 ? "No" : "Yes"
   
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        if PERSONAL_txtAdmissionNo.text! == ""{
            PERSONAL_txtAdmissionNo.borderColor = .systemRed
            return
        } //21114487
        self.callAPI_CheckAdmissionNumber { success, response in
            guard success else { return }
            var arrAddedStudentsAd_No = [String]()
            for obj in self.arrStudents{
                arrAddedStudentsAd_No.append(obj.admission_no)
            }
            print(arrAddedStudentsAd_No)
            guard let dataa = response.data else {return}
            if !arrAddedStudentsAd_No.contains((dataa.admission_no ?? "")){
                self.arrStudents.append(EditStudentDataModel(name:dataa.name ?? "", admission_no: dataa.admission_no ?? "", student_id: dataa._id ?? ""))
                arrAddedStudentsAd_No.append(dataa.admission_no ?? "")
            }else{
                self.toast("Child Already Exist")
                self.PERSONAL_txtAdmissionNo.text = ""
            }
            print(arrAddedStudentsAd_No)
            
            guard let arrSiblings = dataa.siblings else {return}
            
            for m in arrSiblings{
                if !arrAddedStudentsAd_No.contains((m.sibling_id?.admission_no ?? "")){
                    self.arrStudents.append(EditStudentDataModel(name:m.sibling_id?.name ?? "", admission_no: m.sibling_id?.admission_no ?? "", student_id: m.sibling_id?._id ?? ""))
                    arrAddedStudentsAd_No.append(dataa.admission_no ?? "")
                }
            }
        }
    }
    
    @IBAction func btnUpdate(_ sender: Any) {
        if !self.CheckFieldsAreNotEmpty(){return}
        
        self.callAPIPutStaffDetails { success, response in
            guard success else {
                self.toast(response?.message ?? "Invalid Response")
                return
            }
            self.toast(response?.message ?? "Invalid Response")
          let previousVC = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 2] as? ProfileViewController
            previousVC?.setUpInitialData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func btnClearAnniversary(_ sender: Any) {
        self.PERSONAL_txtAnniversary.text = ""
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension EditProfileViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.arrStudents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "cellid") as! staffTblCell
        
            cell.lblStudentsNameAddmission.text = "\(indexPath.row + 1). \(self.arrStudents[indexPath.row].name) (\(self.arrStudents[indexPath.row].admission_no))"
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        36.0
    }
    
}

extension EditProfileViewController:UITextFieldDelegate{

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
    switch textField{
        case GENERAL_txtCity, SCHOOL_txtDepartment, SCHOOL_txtStaffRoom, PERSONAL_txtChildInMCS:
        
            commonDropDown.anchorView = textField
            commonDropDown.direction = .bottom
            commonDropDown.textFont = UIFont.setRegularFont(ofSize: 13.0)
            commonDropDown.width = self.tblView.frame.size.width/1.4
            commonDropDown.bottomOffset = CGPoint(x: 0, y: 50)
            commonDropDown.dataSource = dropDownData(txtfld: textField)
            
            commonDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                // print("Selected item: \(item) at index: \(index)")
                textField.text = item
                if textField == SCHOOL_txtDepartment{
                    selectedDepartment = arrAllDepartment[index]
                }else if textField == SCHOOL_txtStaffRoom{
                    selectedStaffRoom = arrAllStaffRoom[index]
                }
                self.commonDropDown.hide()
            }
            commonDropDown.show()
            
            return false
            
        case GENERAL_txtDateBirth, SCHOOL_txtDateOfJoining, PERSONAL_txtAnniversary:
        
            textField.inputView = datePicker
            self.selectedDateTextfield = textField
            datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
            return true
        
        default : break;
        }
        return true
    }
    
    @objc func handleDatePicker(){
        print(datePicker.date)
        self.selectedDateTextfield.text = CommonFunctions.getDateInString(date: datePicker.date, strDateFormat: DateFormat.DateFormat_DDMMYYYY)
        //self.view.endEditing(true)
    }
    
    private func dropDownData(txtfld:UITextField)->[String]{
        var strArr = [String]()
        
        switch txtfld{
        case GENERAL_txtCity:
            for item in self.arrAllCity{
                strArr.append(item.name ?? "")
            }
            break;
     
        case SCHOOL_txtDepartment:
            for item in self.arrAllDepartment{
                strArr.append(item.name ?? "")
            }
            break;
        case SCHOOL_txtStaffRoom:
            for item in self.arrAllStaffRoom{
                strArr.append(item.room_no ?? "")
            }
            break;
     
        case PERSONAL_txtChildInMCS:
            strArr.append("Yes")
            strArr.append("No")
            break;
            
         default :
            break;
        }
        
        return strArr
    }
    
}


//MARK: - Api Work
extension EditProfileViewController{
    
    private func hitInitialApis(){
        //1-------
        self.callAPI_AllDepartment { success, response in
            if success{
                self.arrAllDepartment = response?.data ?? []
            }
        }
        //2-------
        callAPI_AllCity { success, response in
            if success{
                self.arrAllCity = response?.data ?? []
            }
        }
        //3-------
        callAPI_AllStaffRoom { success, response in
            if success{
                self.arrAllStaffRoom = response?.data ?? []
            }
        }
    }
    
    private func callAPI_AllDepartment(finished:@escaping(_ success: Bool, _ response: DepartmentDataModel?) -> Void) {
        Loader.show()
        UserManagementAPI.getAllDepartment { response, error in
            Loader.hide()
            guard let response = response else {
                self.toast(error?.localizedDescription ?? "Invalid Response")
                finished(false, nil)
                return
            }
            finished(true, response)
        }
    }
    
    private func callAPI_AllCity(finished:@escaping(_ success: Bool, _ response: CityDataModel?) -> Void) {
        Loader.show()
        UserManagementAPI.getAllCity { response, error in
            Loader.hide()
            guard let response = response else {
                self.toast(error?.localizedDescription ?? "Invalid Response")
                finished(false, nil)
                return
            }
            finished(true, response)
        }
    }
    
    private func callAPI_AllStaffRoom(finished:@escaping(_ success: Bool, _ response: StaffRoomDataModel?) -> Void) {
        Loader.show()
        UserManagementAPI.getAllStaffRoom { response, error in
            Loader.hide()
            guard let response = response else {
                self.toast(error?.localizedDescription ?? "Invalid Response")
                finished(false, nil)
                return
            }
            finished(true, response)
        }
    }
    
    private func callAPI_CheckAdmissionNumber(finished:@escaping(_ success: Bool, _ response: AdmissionDataModel) -> Void) {
        Loader.show()
        UserManagementAPI.checkAdmissionNo(admissionNo: PERSONAL_txtAdmissionNo.text!) { response, error in
            Loader.hide()
            guard let response = response else {
                self.toast(error?.localizedDescription ?? "Invalid Response")
                //finished(false, nil)
                return
            }
            
            guard response.status else {
                self.toast(response.message ?? "Invalid Response")
                //finished(false, nil)
                return
            }
            
            finished(true, response)
        }
    }
    
    func callAPIPutStaffDetails(finished:@escaping(_ success: Bool, _ response: UpdateStaffDataModel?) -> Void) {
        Loader.show()
        
        var students = [[String:Any]]()
        for M in arrStudents{
            students.append(M.dictionary)
        }
        let param : [String:Any] = [
            "date_of_birth": GENERAL_txtDateBirth.text!,
            "mobile": GENERAL_txtMobileNo.text!,
            "local_address": GENERAL_txtLocalAddress.text!,
            "city": GENERAL_txtCity.text!,
            "pincode": GENERAL_txtPin.text!,
            "emergency_name": SOS_txtName.text!,
            "emergency_mobile": SOS_txtMobileNo.text!,
            "date_of_joining": SCHOOL_txtDateOfJoining.text!,
            "qualification": SCHOOL_txtQualification.text!,
            "department_id": [
            "_id": selectedDepartment?._id ?? "",
            "name": selectedDepartment?.name ?? ""
          ],
          "staffroom_id": [
            "_id": selectedStaffRoom?._id ?? "",
            "room_no": selectedStaffRoom?.room_no ?? ""
          ],
            "address": [
              "local_address": GENERAL_txtLocalAddress.text!,
              "city": GENERAL_txtCity.text!,
              "pincode": GENERAL_txtPin.text!
            ],
            "spouse_name": PERSONAL_txtSpouseName.text!,
            "date_of_anniversary": PERSONAL_txtAnniversary.text!,
            "have_students": arrStudents.count == 0 ? false : true,
            "child_admission_no": "",
            "update_child_details": "Yes",
            "students": students
        ]
        print(param)

        StaffManageMentAPI.putStaffDetails(param: param) { (response, error) in
            Loader.hide()
         /*   guard let response = response else {
                let _ = error?.localizedDescription ?? "Invalid Response"
                finished(false, nil)
                return
            }
            guard response.status == true else {
                self.toast(response.message ?? "")
                finished(false, nil)
                return
            }
            guard let _ = response.message else {
                let _ = response.message ?? "Invalid Response"
                finished(false, nil)
                return
            }*/
            
            if let status = response?.status, !status{
                finished(false,nil)
                return
            }
            
            finished(true, response)
        }
    }
    
    private func CheckFieldsAreNotEmpty()->Bool{
     //   let defaultColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        var status = true
        if GENERAL_txtDateBirth.text! == ""{
            GENERAL_txtDateBirth.borderColor = .systemRed
            status = false
        }else{
            GENERAL_txtDateBirth.borderColor = .systemGreen
        }
        if GENERAL_txtMobileNo.text! == ""{
            GENERAL_txtMobileNo.borderColor = .systemRed
            status = false
        }else{
            GENERAL_txtMobileNo.borderColor = .systemGreen
        }
        if GENERAL_txtMobileNo.text!.count != 10{
            GENERAL_txtMobileNo.borderColor = .systemRed
            status = false
        }else{
            GENERAL_txtMobileNo.borderColor = .systemGreen
        }
        if GENERAL_txtLocalAddress.text! == ""{
            GENERAL_txtLocalAddress.borderColor = .systemRed
            status = false
        }else{
            GENERAL_txtLocalAddress.borderColor = .systemGreen
        }
        if GENERAL_txtCity.text! == ""{
            GENERAL_txtCity.borderColor = .systemRed
            status = false
        }else{
            GENERAL_txtCity.borderColor = .systemGreen
        }
        if GENERAL_txtPin.text! == ""{
            GENERAL_txtPin.borderColor = .systemRed
            status = false
        }else{
            GENERAL_txtPin.borderColor = .systemGreen
        }
        if SOS_txtName.text! == ""{
            SOS_txtName.borderColor = .systemRed
            status = false
        }else{
            SOS_txtName.borderColor = .systemGreen
        }
        if SOS_txtMobileNo.text! == ""{
            SOS_txtMobileNo.borderColor = .systemRed
            status = false
        }else{
            SOS_txtMobileNo.borderColor = .systemGreen
        }
        if SOS_txtMobileNo.text!.count != 10{
            SOS_txtMobileNo.borderColor = .systemRed
            status = false
        }else{
            SOS_txtMobileNo.borderColor = .systemGreen
        }
        if SCHOOL_txtDateOfJoining.text! == ""{
            SCHOOL_txtDateOfJoining.borderColor = .systemRed
            status = false
        }else{
            SCHOOL_txtDateOfJoining.borderColor = .systemGreen
        }
        if SCHOOL_txtQualification.text! == ""{
            SCHOOL_txtQualification.borderColor = .systemRed
            status = false
        }else{
            SCHOOL_txtQualification.borderColor = .systemGreen
        }
        if SCHOOL_txtDepartment.text! == ""{
            SCHOOL_txtDepartment.borderColor = .systemRed
            status = false
        }else{
            SCHOOL_txtDepartment.borderColor = .systemGreen
        }
        if SCHOOL_txtStaffRoom.text! == ""{
            SCHOOL_txtStaffRoom.borderColor = .systemRed
            status = false
        }else{
            SCHOOL_txtStaffRoom.borderColor = .systemGreen
        }
     /*   if PERSONAL_txtSpouseName.text! == ""{
            PERSONAL_txtSpouseName.borderColor = .red
        }else{
            PERSONAL_txtSpouseName.borderColor = defaultColor
        }
        if PERSONAL_txtAnniversary.text! == ""{
            PERSONAL_txtAnniversary.borderColor = .red
        }else{
            PERSONAL_txtAnniversary.borderColor = defaultColor
        }*/
        if PERSONAL_txtChildInMCS.text! == ""{
            PERSONAL_txtChildInMCS.borderColor = .systemRed
            status = false
        }else{
            PERSONAL_txtChildInMCS.borderColor = .systemGreen
        }
     /*   if PERSONAL_txtAdmissionNo.text! == ""{
            PERSONAL_txtAdmissionNo.borderColor = .systemRed
            status = false
        }else{
            PERSONAL_txtAdmissionNo.borderColor = .systemGreen
        }*/
        
        return status
    }
}

extension EditProfileViewController: NavigationBarViewDelegate {
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
