//
//  DiscplinaryCardStaffViewController.swift
//  MountCarmel
//
//  Created by Mandeep Singh on 18/06/23.
//  Copyright © 2023 InventionHill. All rights reserved.
//

import UIKit
import DTTextField
import DropDown

class DiscplinaryCardStaffViewController: UIViewController {
    @IBOutlet weak var navigationView: NavigationBarView!
    
    @IBOutlet var btnClass: UIButton!
    @IBOutlet var btnStudent: UIButton!
   
    
    @IBOutlet weak var studentImage: RoundedImage!
    @IBOutlet weak var stidentName: UILabel!
    @IBOutlet weak var studentAdmission: UILabel!
    
    @IBOutlet weak var btnPink: RoundedButton!
    @IBOutlet weak var btnYellow: RoundedButton!
    @IBOutlet weak var btnRed: RoundedButton!
    
    @IBOutlet weak var txtSelectReason: DTTextField!{
        didSet{
            txtSelectReason.delegate = self
        }
    }
    @IBOutlet weak var txtCustomReason: DTTextField!
    @IBOutlet weak var txtActionTaken: DTTextField!{
        didSet{
            txtActionTaken.addTarget(self, action: #selector(textActionTaken(textField:)), for: .editingChanged)
        }
    }
        @IBOutlet weak var txtHousePOints: DTTextField!{
            didSet{
                txtHousePOints.delegate = self
            }
        }
    
    @IBOutlet weak var lblActionTakenLenth: UILabel!
    
    @IBOutlet weak var viewCustomReason: UIView!{
        didSet{
            viewCustomReason.isHidden = true
        }
    }
    
    @IBOutlet weak var viewClass: UIView!
    @IBOutlet weak var viewQRCode: UIView!
    @IBOutlet weak var viewStudentDetail: RoundedView!
    @IBOutlet weak var viewTextfields: UIView!
    
    @IBOutlet weak var viewConfirmSendCard: UIView!{
        didSet{
            viewConfirmSendCard.isHidden = true
        }
    }
    
    @IBOutlet var lblSelectDate: UILabel!
    @IBOutlet var lblSelectClass: UILabel!
    @IBOutlet var btnSave: RoundedButton!
    @IBOutlet var txtDate: RoundTextField!
    @IBOutlet var tblStudentList: UITableView!{
        didSet{
            tblStudentList.delegate = self
            tblStudentList.dataSource = self
        }
    }
    @IBOutlet var txtSearch: UITextField!{didSet{txtSearch.delegate = self}}
    @IBOutlet var txtSelectClass: UITextField!
        
    @IBOutlet weak var lblPinkCard: UILabel!
    @IBOutlet weak var lblYellowCard: UILabel!
    @IBOutlet weak var lblRedCard: UILabel!
    
    @IBOutlet weak var btnSubmit: RoundedButton!
    @IBOutlet weak var lblConfirmSendCard: UILabel!
    
    @IBOutlet weak var viewClassStudent: RoundedView!
    
    @IBOutlet weak var btnCloseShowDetail: UIButton!{didSet{btnCloseShowDetail.isHidden=true}}
    enum state{
        case showClass
        case showQR
        case showDetail
        case showTextFields
    }
    private var currentMainState:state = .showClass
    private var currentState:state = .showClass{
        didSet{
            viewClass.isHidden = true
            viewQRCode.isHidden = true
            viewStudentDetail.isHidden = true
            viewTextfields.isHidden = true
            btnCloseShowDetail.isHidden=true
            viewClassStudent.isHidden=false
            switch currentState{
            case .showClass:
                currentMainState = .showClass
                viewClass.isHidden = false
                selectedReason = nil
                
                    btnClass.backgroundColor = #colorLiteral(red: 0.2117647059, green: 0.3803921569, blue: 0.6392156863, alpha: 1)
                btnClass.setTitleColor(UIColor.white, for: .normal)
                    
                    btnStudent.backgroundColor = UIColor.white
                btnStudent.setTitleColor(#colorLiteral(red: 0.2117647059, green: 0.3803921569, blue: 0.6392156863, alpha: 1), for: .normal)
                break;
                
            case .showQR:
                currentMainState = .showQR
                viewQRCode.isHidden = false
                selectedReason = nil
                
                btnStudent.backgroundColor = #colorLiteral(red: 0.2117647059, green: 0.3803921569, blue: 0.6392156863, alpha: 1)
                btnStudent.setTitleColor(UIColor.white, for: .normal)
                
                btnClass.backgroundColor = UIColor.white
                btnClass.setTitleColor(#colorLiteral(red: 0.2117647059, green: 0.3803921569, blue: 0.6392156863, alpha: 1), for: .normal)
                break;
                
            case .showDetail:
                self.btnPink.setImage(UIImage(named: "Unselect_dis"), for: .normal)
                self.btnYellow.setImage(UIImage(named: "Unselect_dis"), for: .normal)
                self.btnRed.setImage(UIImage(named: "Unselect_dis"), for: .normal)
                viewStudentDetail.isHidden = false
                btnCloseShowDetail.isHidden=false
                viewClassStudent.isHidden=true
                break;
                
            case .showTextFields:
                viewStudentDetail.isHidden = false
                viewTextfields.isHidden = false
                btnCloseShowDetail.isHidden=false
                viewClassStudent.isHidden=true
                btnSubmit.setTitle(currentMainState == .showClass ? "Issue" : "Submit", for: .normal)
                break;
            }
        }
    }
    
    private var imgPath = ""
    private var classDropDown = DropDown()

    private var commonDropDown = DropDown()
    
    private var scannedStudent : SearchStudentData?
    private var DisplinaryCountModel : DisplinaryCardCount?
    private var imgURL = ""
    private var admissionNo = ""
    
    private var arrReason = [DisiplinatyCardStaffData]()
    private var selectedReason:DisiplinatyCardStaffData?=nil{
        didSet{
            if selectedReason == nil{
                self.viewCustomReason.isHidden = true
                self.txtSelectReason.text = ""
                self.txtCustomReason.text = ""
                self.txtActionTaken.text = ""
                self.txtHousePOints.text = ""
                self.lblActionTakenLenth.text = ""
                lblActionTakenLenth.text = "0/80"
            }else{
                self.viewCustomReason.isHidden = !((selectedReason?.reason ?? "").lowercased() == "Any other reason".lowercased())
            }
        }
    }
    private var arrClassList = [ClassListWithSectionData]()
    private var selectedClassID : String = ""
    private var calenderStartDate = ""
    
    private var arrStudentsList = [HouseReportData]()
    private var arrStudentsListWithoutFilter = [HouseReportData]()
    
    private var selectedDisCardParam = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationView.lblTitle.text = "Disciplinary Card"
        navigationView.delegate = self
        
        let btn = UIButton(); self.btnClass(btn)
        
        self.SetClassView()
        
        self.callAPIForClassList { (check) in }
        self.callAPIForStartDate { success in }
        
    }
    
    private func SetClassView(){
        
        btnStudent.titleLabel?.font = UIFont.setBoldFont(ofSize: 13.0)
        btnClass.titleLabel?.font = UIFont.setBoldFont(ofSize: 13.0)
        
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
    }
    func setClassDropDown(){
        classDropDown.anchorView = txtSelectClass
        classDropDown.direction = .bottom
        classDropDown.textFont = UIFont.setRegularFont(ofSize: 13.0)
        classDropDown.width = txtSelectClass.frame.size.width
        classDropDown.bottomOffset = CGPoint(x: 0, y: 50)
    }
    @objc func textActionTaken(textField: UITextField) {
        print(txtActionTaken.text!.count)
        let count = txtActionTaken.text!.count
        if count == 80{
            txtActionTaken.text = String(txtActionTaken.text!.dropLast())
        }
        lblActionTakenLenth.text = "\(count)/80"
     }
    
    @IBAction func btnClass(_ sender: UIButton) {
        currentState = .showClass
    }
    @IBAction func btnStudent(_ sender: UIButton) {
        currentState = .showQR
//         DispatchQueue.main.asyncAfter(deadline: .now()+2.0) {
//         self.ShowSelectedStudent(adno: "11153425")
//         }
    }
    
    @IBAction func actionSelectClass(_ sender: Any) {
        self.setClassListDropDownData()
    }
   private func setClassListDropDownData(){
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
            self.APIForClassListByID()
        }
        classDropDown.show()
    }
    private func APIForClassListByID(enableSearch:Bool=false){
        self.callAPIForClassListByID { (success) in
            if enableSearch{
                self.searchData(serchTxt: self.txtSearch.text!)
            }
            self.tblStudentList.reloadData()
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
    @IBAction func btnCards(_ sender: RoundedButton) {
        if currentState == .showClass{
            let BP = sender.convert(sender.bounds.origin, to: self.tblStudentList)
            if let indexPath = self.tblStudentList.indexPathForRow(at: BP){
                let data = self.arrStudentsList[indexPath.row]
                self.ShowSelectedStudent(adno: data.admission_no ?? "") { success in
                    self.selectUnselectCheckbox(sender: sender)
                }
            }
        }else{
            self.selectUnselectCheckbox(sender: sender)
        }
    }
    
    private func selectUnselectCheckbox(sender:RoundedButton){
        var str = ""
        if sender.tag == 0{//pink
            str = "PINK"
        }else if sender.tag == 1{//yellow
            str = "YELLOW"
        }else{//red
            str = "RED"
        }
        self.selectedReason = nil
        self.getDisiplinatyCardReason(card: str) { success in
            if success{
                self.currentState = .showTextFields
                
                if str == "PINK"{//pink
                    self.btnPink.setImage(UIImage(named: "Select_dis"), for: .normal)
                    self.btnYellow.setImage(UIImage(named: "Unselect_dis"), for: .normal)
                    self.btnRed.setImage(UIImage(named: "Unselect_dis"), for: .normal)
                }else if str == "YELLOW"{//yellow
                    self.btnPink.setImage(UIImage(named: "Unselect_dis"), for: .normal)
                    self.btnYellow.setImage(UIImage(named: "Select_dis"), for: .normal)
                    self.btnRed.setImage(UIImage(named: "Unselect_dis"), for: .normal)
                }else{//red
                    self.btnPink.setImage(UIImage(named: "Unselect_dis"), for: .normal)
                    self.btnYellow.setImage(UIImage(named: "Unselect_dis"), for: .normal)
                    self.btnRed.setImage(UIImage(named: "Select_dis"), for: .normal)
                }
            }
        }
    }
    
    @IBAction func btnCloseShowDetail(_ sender: Any) {
        currentState = currentMainState
    }
    
    @IBAction func btnScanQRCOde(_ sender: Any) {
        self.openQRVC()
    }
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        self.view.endEditing(true)
        guard txtSelectReason.text! != "" else{
            self.toast("Please select reason")
            return
        }
        if txtSelectReason.text!.lowercased() == "Any other reason".lowercased(){
            guard txtCustomReason.text != "" else{
                self.toast("Please enter custom reason")
                return
            }
        }
        guard txtActionTaken.text! != "" else{
            self.toast("Please enter action taken")
            return
        }
        guard txtHousePOints.text! != "" else{
            self.toast("Please select house points deducted")
            return
        }
        
        if sender.tag == 101{
            viewConfirmSendCard.isHidden = false
            var str = ""
            if self.btnPink.image(for: .normal) == UIImage(named: "Select_dis")!{
                str = "Warning"
            }else if self.btnYellow.image(for: .normal) == UIImage(named: "Select_dis")!{
                str = "Tardy"
            }else{
                str = "Red"
            }
            
            self.lblConfirmSendCard.text = "You have issued a \(str) Card to \(stidentName.text!)\n\nA message (SMS) will be sent to the parent.\n\nAn email will be sent to the House Incharge and the Vice Principals."
            return
        }
        
        // Hit Submit Api
        
        var dict:[String:Any] =
          [
            "student_id":   scannedStudent?._id ?? "",//ce917150a89f079919452f0b
            "admission_no": admissionNo,
            "pink":         self.btnPink.image(for: .normal) == UIImage(named: "Select_dis")! ? 1 : 0,
            "yellow":       self.btnYellow.image(for: .normal) == UIImage(named: "Select_dis")! ? 1 : 0,
            "red":          self.btnRed.image(for: .normal) == UIImage(named: "Select_dis")! ? 1 : 0,
            "reason":       txtSelectReason.text!,
            "action_taken": txtActionTaken.text!,
            "house_point":  txtHousePOints.text!,
            "issue_date":   CommonFunctions.getDateInString(date: Date(), strDateFormat: DateFormat.DateFormat_Message2)
                //"18-06-2023"
          ]
        
        if txtSelectReason.text!.lowercased() == "Any other reason".lowercased(){
            dict[ "reason_other"] = txtCustomReason.text!
        }
        
        if currentMainState == .showClass{
            for (i,d) in self.selectedDisCardParam.enumerated(){
                if (d["admission_no"] as! String)  == (dict["admission_no"] as! String){
                    self.selectedDisCardParam.remove(at: i)
                }
            }
        }
        self.selectedDisCardParam.append(dict)
        self.tblStudentList.reloadData()
        
       // if currentMainState == .showQR{
            self.SubmitDiscipalinaryCard()
       /* }else if currentMainState == .showClass{
            self.viewConfirmSendCard.isHidden = true
            currentState = .showClass
            self.toast("You can give cards to multiple students.Please click on Save button after that.")
        }*/
    }
    
    private func SubmitDiscipalinaryCard(){
        print(self.selectedDisCardParam)
        self.sendDisiplinatyCard(param: self.selectedDisCardParam) { success in
            if success{
                self.selectedDisCardParam.removeAll()
                self.viewConfirmSendCard.isHidden = true
                self.currentState = self.currentMainState
                if self.currentState == .showClass{
                    self.APIForClassListByID(enableSearch: true)
                    
                }
            }
        }
    }
    
    @IBAction func btnSaveCardsFromClassList(_ sender: Any) {
        guard self.selectedDisCardParam.count != 0 else{
            self.toast("Please assign card to atleast one student.")
            return
        }
        self.SubmitDiscipalinaryCard()
    }
    
    
    @IBAction func btnCancel(_ sender: UIButton) {
        if sender.tag == 102{
            viewConfirmSendCard.isHidden = true
            return
        }
        currentState = .showClass
    }
    
    private func ShowSelectedStudent(adno:String,finished:@escaping(_ success: Bool) -> Void){
        admissionNo = adno
        self.GetStudentData { S in
            finished(true)
        }
        self.callAPIForSearchStudentsForPic { success in }
    }
}

//MARK: - QRScannerCodeDelegate
extension DiscplinaryCardStaffViewController:QRScannerCodeDelegate{
    private func openQRVC(){
         let scanner = QRCodeScannerController()
        //QRCode with Camera switch and Torch
        // scanner = QRCodeScannerController(cameraImage: UIImage(named: "camera"), cancelImage: UIImage(named: "cancel"), flashOnImage: UIImage(named: "flash-on"), flashOffImage: UIImage(named: "flash-off"))
        scanner.delegate = self
        scanner.mode = .camera
        scanner.modalPresentationStyle = .overFullScreen
        self.present(scanner, animated: true, completion: {
        })
    }
    
    func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {
        print("result:\(result)")
        self.ShowSelectedStudent(adno: result) { success in
            
        }
    }
    
    func qrScannerDidFail(_ controller: UIViewController, error: String) {
        print("error:\(error)")
    }
    
    func qrScannerDidCancel(_ controller: UIViewController) {
        print("SwiftQRScanner did cancel")
      
    }
    
    private func GetStudentData(finished:@escaping(_ success: Bool) -> Void){
        self.callAPIForSearchStudents() { (success) in
            if success == true {
                self.currentState = .showDetail
                
                self.studentAdmission.text = self.admissionNo
                self.stidentName.text = (self.scannedStudent?.name ?? "").uppercased()
                
                let P1 = NSMutableAttributedString (
                           string: "Warning Card\n(Pink - ",
                           attributes: [NSAttributedString.Key.font: UIFont(name: "Charter-Roman", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)])
                let P2 = NSAttributedString (
                           string: "\(self.DisplinaryCountModel?.warning ?? 0)",
                           attributes: [NSAttributedString.Key.font: UIFont(name: "Charter-Bold", size: 15.0) ?? UIFont.systemFont(ofSize: 15.0)])
                let P3 = NSMutableAttributedString (
                           string: ")",
                           attributes: [NSAttributedString.Key.font: UIFont(name: "Charter-Roman", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)])
                
                let Y1 = NSMutableAttributedString (
                           string: "Tardy Card\n(Yellow - ",
                           attributes: [NSAttributedString.Key.font: UIFont(name: "Charter-Roman", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)])
                let Y2 = NSAttributedString (
                           string: "\(self.DisplinaryCountModel?.tardy ?? 0)",
                           attributes: [NSAttributedString.Key.font: UIFont(name: "Charter-Bold", size: 15.0) ?? UIFont.systemFont(ofSize: 15.0)])
                let Y3 = NSMutableAttributedString (
                           string: ")",
                           attributes: [NSAttributedString.Key.font: UIFont(name: "Charter-Roman", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)])
                
                let R1 = NSMutableAttributedString (
                           string: "Red Card\n(Red - ",
                           attributes: [NSAttributedString.Key.font: UIFont(name: "Charter-Roman", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)])
                let R2 = NSAttributedString (
                           string: "\(self.DisplinaryCountModel?.red ?? 0)",
                           attributes: [NSAttributedString.Key.font: UIFont(name: "Charter-Bold", size: 15.0) ?? UIFont.systemFont(ofSize: 15.0)])
                let R3 = NSMutableAttributedString (
                           string: ")",
                           attributes: [NSAttributedString.Key.font: UIFont(name: "Charter-Roman", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)])
                
                P1.append(P2)
                P1.append(P3)
                
                Y1.append(Y2)
                Y1.append(Y3)
                
                R1.append(R2)
                R1.append(R3)
                
                self.lblPinkCard.attributedText = P1
                //"Warning Card\n(Pink - \(self.DisplinaryCountModel?.warning ?? 0))"
                
                self.lblYellowCard.attributedText = Y1
                //"Tardy Card\n(Yellow - \(self.DisplinaryCountModel?.tardy ?? 0))"
                
                self.lblRedCard.attributedText = R1
                //"Red Card\n(Red - \(self.DisplinaryCountModel?.red ?? 0))"
                
                finished(true)
            }
        }
    }
}
//MARK: - HIT APIS
extension DiscplinaryCardStaffViewController{
    
   private func callAPIForStartDate(finished:@escaping(_ success: Bool) -> Void) {
       
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
       
        Loader.show()
        StaffManageMentAPI.GetStartDate(term: currentTerm) { (respose, error) in
            Loader.hide()
            guard let response = respose else {
                self.toast(error?.localizedDescription ?? "Invalid Response")
              //  finished(false,nil)
                return
            }
            
            guard let responseData = response.data else {
                self.toast(response.message ?? "Invalid Response")
              //  finished(false,nil)
                return
            }
            print(responseData)
            self.calenderStartDate = responseData.start_date ?? ""
            //finished(true,responseData.start_date)
        }
       
    }
    
   private func callAPIForClassList(finished:@escaping(_ success: Bool) -> Void) {
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
    
    private func callAPIForClassListByID(finished:@escaping(_ success: Bool) -> Void) {
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
                //self.btnSave.isUserInteractionEnabled = false
                self.toast("No students found")
            }else{
                //self.btnSave.isUserInteractionEnabled = true
            }
            finished(true)
        }
    }
   private func callAPIForSearchStudents(finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
       
        StaffManageMentAPI.getDisiplinatyStudentInfo(adno: self.admissionNo) { (respose, error) in
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
            //self.imgURL = (response.path ?? "")
            
            self.scannedStudent = responseData
            self.DisplinaryCountModel = respose?.disciplinary
            if(self.scannedStudent == nil){
                self.toast("No Student Found")
                return
            }
            finished(true)
        }
    }
    
   private func callAPIForSearchStudentsForPic(finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
       
        let requestParam = SearchStudentsParam(admission_no: admissionNo, search_type: "min-search")
        WiseManagementAPI.searchWiseStudentsFromQR(body: requestParam) { (respose, error) in
            Loader.hide()
            self.imgURL = (respose?.data?.first?.profile_pic ?? "")
            
            //self.scannedStudent = responseData
//            if(self.scannedStudent!.count == 0){
//                self.toast("No Student Found")
//            }
            
            // let imageURL = self.imgURL + "/" + (self.scannedStudent?.first?.profile_pic ?? "")
            let imageURL = "https://mountcarmelschool.com/uploads/profile-pic/student/"+(self.imgURL )
             
             self.studentImage.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "profile-placeholder"), options: [], context: nil)
            
            finished(true)
        }
    }
    
    private func getDisiplinatyCardReason(card:String,finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
        
        StaffManageMentAPI.getDisiplinatyCardReason(card:card) { (response, error) in
            Loader.hide()
            guard let response = response else {
                let _ = error?.localizedDescription ?? "Invalid Response"
                finished(false)
                return
            }
            
            guard let DData = response.data else{
                self.toast(response.message ?? "No data found!!")
                return
            }
            
            self.arrReason = DData
            finished(response.status ??  false)
        }
    }
    
    private func sendDisiplinatyCard(param:[[String:Any]],finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
        
        StaffManageMentAPI.SendDisiplinatyCard(body: param) { (response, error) in
            Loader.hide()
            guard let response = response else {
                let errMsg = error?.localizedDescription ?? "Invalid Response"
                self.toast(errMsg)
                finished(false)
                return
            }
            
            self.toast(response.message ?? "Invalid Response")
            finished(response.status ??  false)
        }
    }
}


extension DiscplinaryCardStaffViewController:UITextFieldDelegate{

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        commonDropDown.anchorView = textField
        commonDropDown.textFont = UIFont.setRegularFont(ofSize: 13.0)
        
        commonDropDown.bottomOffset = CGPoint(x: 0, y: 50)
        
    switch textField{
        case txtSelectReason:
        commonDropDown.direction = .any
        commonDropDown.width = self.view.frame.size.width/1.4
        commonDropDown.dataSource = self.arrReason.map {$0.reason ?? ""}
            commonDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                // print("Selected item: \(item) at index: \(index)")
                textField.text = item
                self.selectedReason = arrReason[index]
                self.commonDropDown.hide()
            }
            commonDropDown.show()
            
            return false
        
    case txtHousePOints:
        commonDropDown.direction = .any
        commonDropDown.width = 150
        commonDropDown.dataSource = ["1","2","3","4","5"]
        commonDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            // print("Selected item: \(item) at index: \(index)")
            textField.text = item
            self.commonDropDown.hide()
        }
        commonDropDown.show()
        
        return false
        default :
           return true;
        }
        
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard txtSearch == textField else {return}
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

extension DiscplinaryCardStaffViewController: NavigationBarViewDelegate {
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

struct DisiplinatyCardStaffReasonModel:Codable{
    let data:[DisiplinatyCardStaffData]?
    let status:Bool?
    let message:String?
}

struct DisiplinatyCardStaffData:Codable{
    let _id:String?
    let card_type:String?
    let reason:String?
}

extension DiscplinaryCardStaffViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.arrStudentsList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblStudentList.dequeueReusableCell(withIdentifier: "cell") as! DiscsplinaryCardTblCell
       let data = self.arrStudentsList[indexPath.row]
        cell.stidentName.text = data.name ?? ""
        cell.studentAdmission.text = data.admission_no ?? ""
        
        let imageUrl = self.imgPath+(data.profile_pic ?? "")
        //studentImageIssue
        cell.studentImage.sd_setImage(with: URL(string:imageUrl), placeholderImage: #imageLiteral(resourceName: "profile-placeholder"), options: [], context: nil)
        
        cell.lblPinkCard.text = "Warning Card\n(\(data.disciplinary?.pink ?? 0))"
        cell.lblYellowCard.text = "Tardy Card\n(\(data.disciplinary?.yellow ?? 0))"
        cell.lblRedCard.text = "Red Card\n(\(data.disciplinary?.red ?? 0))"
        
        
        
        let obj = self.selectedDisCardParam.first { d in
            (d["admission_no"] as! String) == data.admission_no ?? ""
        }
        
        if let obj = obj{
            let p = obj["pink"] as! Int
            let y = obj["yellow"] as! Int
            let r = obj["red"] as! Int
            
            cell.btnPink.setImage(UIImage(named: p == 1 ? "Select_dis" : "Unselect_dis"), for: .normal)
            cell.btnYellow.setImage(UIImage(named: y == 1 ? "Select_dis" : "Unselect_dis"), for: .normal)
            cell.btnRed.setImage(UIImage(named: r == 1 ? "Select_dis" : "Unselect_dis"), for: .normal)
        }else{
            cell.btnPink.setImage(UIImage(named: "Unselect_dis"), for: .normal)
            cell.btnYellow.setImage(UIImage(named: "Unselect_dis"), for: .normal)
            cell.btnRed.setImage(UIImage(named: "Unselect_dis"), for: .normal)
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.arrStudentsList[indexPath.row]
        self.ShowSelectedStudent(adno:  data.admission_no ?? "") { success in
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        220
    }
}

class DiscsplinaryCardTblCell:UITableViewCell{
    @IBOutlet weak var studentImage: RoundedImage!
    @IBOutlet weak var stidentName: UILabel!
    @IBOutlet weak var studentAdmission: UILabel!
    @IBOutlet weak var lblPinkCard: UILabel!
    @IBOutlet weak var lblYellowCard: UILabel!
    @IBOutlet weak var lblRedCard: UILabel!
    
    @IBOutlet weak var btnPink: RoundedButton!
    
    @IBOutlet weak var btnYellow: RoundedButton!
    
    @IBOutlet weak var btnRed: RoundedButton!
}


