//
//  StudentViewController.swift
//  MountCarmel
//
//  Created by Sandip on 06/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class StudentViewController: UIViewController {

    @IBOutlet var btnSave: RoundedButton!
    @IBOutlet var lblReason: UILabel!
    @IBOutlet weak var lblStaticFor: UILabel!{didSet{lblStaticFor.isHidden = true}}
    @IBOutlet var viewLine: UIView!
    @IBOutlet var btnStature: RoundedButton!
    @IBOutlet var btnEmotion: RoundedButton!
    @IBOutlet var btnIntellect: RoundedButton!
    @IBOutlet var btnWorthy: RoundedButton!
    
    var selectedClassID : String = "5e428327f3c49184a40e3027"
    var scannedStudent : [SearchStudentData]?
    var arrSelectedStudent = [[String:Any]]()
    
    @IBOutlet var studentView: RoundedView!
    @IBOutlet var lblId: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgProfile: RoundedImage!
    @IBOutlet var lblIndex: UILabel!
    var imgURL = ""
    var admissionNo = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        
      // admissionNo = "11153425"
      //  updateView()
    }
    
    func openQRVC(){
         let scanner = QRCodeScannerController()
        //QRCode with Camera switch and Torch
        // scanner = QRCodeScannerController(cameraImage: UIImage(named: "camera"), cancelImage: UIImage(named: "cancel"), flashOnImage: UIImage(named: "flash-on"), flashOffImage: UIImage(named: "flash-off"))
        scanner.delegate = self
        scanner.mode = .camera
        scanner.modalPresentationStyle = .overFullScreen
        self.present(scanner, animated: true, completion: {
        })
    }
    
    func updateView(){
        self.callAPIForSearchStudents { (success) in
            if success == true {
                self.btnSave.isHidden = false
                self.studentView.isHidden = false
                self.lblIndex.text = "1"
                self.lblId.text = self.admissionNo
                self.lblName.text = (self.scannedStudent?.first?.name ?? "").uppercased()
                
               // let imageURL = self.imgURL + "/" + (self.scannedStudent?.first?.profile_pic ?? "")
                let imageURL = "https://mountcarmelschool.com/uploads/profile-pic/student/"+(self.scannedStudent?.first?.profile_pic ?? "")
                
                self.imgProfile.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "profile-placeholder"), options: [], context: nil)
              
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateSegmentColor"), object: nil, userInfo: nil)
            }
        }
    }
    func setHomeScreen() {
        if let viewController: HomeViewController = HomeViewController.storyboardInstance.initialize() {
            let contentViewController = UINavigationController(rootViewController: viewController)
            contentViewController.navigationBar.isHidden = true
            self.sideMenuViewController!.setContentViewController(contentViewController, animated: true)
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
    //MARK:- Action Event -
    
    @IBAction func actionSaveRecord(_ sender: Any) {
        if(self.arrSelectedStudent.count != 0){
            print(self.arrSelectedStudent)
            if let viewController: ClassPublishAlertViewController = ClassPublishAlertViewController.storyboardInstance.initialize() {
                viewController.modalPresentationStyle = .overCurrentContext
                viewController.arrSelectedList = self.arrSelectedStudent
                viewController.strClass = (self.scannedStudent?.first?.standard_id?.name ?? "")+" "+(self.scannedStudent?.first?.section_id?.name ?? "")
                viewController.doneHandler = { (strMsg) in
                    self.toast(strMsg)
                    self.setHomeScreen()
                }
                self.present(viewController, animated: false, completion: nil)
            }
        }else{
            self.toast("Select atleast one student card with information")
        }
    }
    @IBAction func btnScanQrCodeClick(_ sender: Any) {
        openQRVC()
    }
    
    @IBAction func btnIntellectClick(_ sender: Any) {
      
        if let viewController: PopUpViewController = PopUpViewController.storyboardInstance.initialize() {
            
            viewController.modalPresentationStyle = .overCurrentContext
            viewController.strTitle = "Intellect"
            viewController.doneHandler = { (strDesc) in
                if(strDesc != ""){
                    self.btnWorthy.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    self.btnWorthy.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
                    
                    self.btnIntellect.backgroundColor = #colorLiteral(red: 0.1480000019, green: 0.2960000038, blue: 0.8029999733, alpha: 1)
                    self.btnIntellect.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                    
                    self.btnStature.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    self.btnStature.setTitleColor( #colorLiteral(red: 0.9620772004, green: 0.6563818455, blue: 0.2461998165, alpha: 1), for: .normal)
                    
                    self.btnEmotion.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    self.btnEmotion.setTitleColor( #colorLiteral(red: 0.2901960784, green: 0.6039215686, blue: 0.4588235294, alpha: 1), for: .normal)
                    self.viewLine.isHidden = false
                    self.lblReason.isHidden = false
                    self.lblStaticFor.isHidden = false
                    self.lblReason.text = strDesc
                    
                    let dict = WiseClassRequestParam(wise_date: self.getDate(), worthy: 0, student_id: self.scannedStudent?.first?._id ,intellect: 1, reason: strDesc, stature: 0, emotion: 0,admission_no: self.admissionNo)
                    self.arrSelectedStudent.append(dict.dictionary)
                    
                }else{
                    self.viewLine.isHidden = true
                    self.lblReason.isHidden = true
                    self.lblStaticFor.isHidden = true
                    
                }
                
            }
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnWorthyClick(_ sender: Any) {
       
        if let viewController: PopUpViewController = PopUpViewController.storyboardInstance.initialize() {
            
            viewController.modalPresentationStyle = .overCurrentContext
            viewController.strTitle = "Worthy"
            viewController.doneHandler = { (strDesc) in
                if(strDesc != ""){
                    self.btnWorthy.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                    self.btnWorthy.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                    
                    self.btnIntellect.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    self.btnIntellect.setTitleColor(#colorLiteral(red: 0.1480000019, green: 0.2960000038, blue: 0.8029999733, alpha: 1), for: .normal)
                    
                    self.btnStature.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    self.btnStature.setTitleColor( #colorLiteral(red: 0.9620772004, green: 0.6563818455, blue: 0.2461998165, alpha: 1), for: .normal)
                    
                    self.btnEmotion.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    self.btnEmotion.setTitleColor( #colorLiteral(red: 0.2901960784, green: 0.6039215686, blue: 0.4588235294, alpha: 1), for: .normal)
                    self.viewLine.isHidden = false
                    self.lblReason.isHidden = false
                    self.lblStaticFor.isHidden = false
                    self.lblReason.text = strDesc
                    
                    self.arrSelectedStudent.removeAll()
                    
                    let dict = WiseClassRequestParam(wise_date: self.getDate(), worthy: 1, student_id: self.scannedStudent?.first?._id ,intellect: 0, reason: strDesc, stature: 0, emotion: 0,admission_no: self.admissionNo)
                    print(dict.dictionary)
                    self.arrSelectedStudent.append(dict.dictionary)
                    
                }else{
                    self.viewLine.isHidden = true
                    self.lblReason.isHidden = true
                    self.lblStaticFor.isHidden = true
                    
                }
                            
            }
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnStatureClick(_ sender: Any) {
        
        if let viewController: PopUpViewController = PopUpViewController.storyboardInstance.initialize() {
            
            viewController.modalPresentationStyle = .overCurrentContext
            viewController.strTitle = "Stature"
            viewController.doneHandler = { (strDesc) in
                if(strDesc != ""){
                    self.btnWorthy.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    self.btnWorthy.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
                    
                    self.btnIntellect.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    self.btnIntellect.setTitleColor(#colorLiteral(red: 0.1480000019, green: 0.2960000038, blue: 0.8029999733, alpha: 1), for: .normal)
                    
                    self.btnStature.backgroundColor = #colorLiteral(red: 0.9620772004, green: 0.6563818455, blue: 0.2461998165, alpha: 1)
                    self.btnStature.setTitleColor( #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                    
                    self.btnEmotion.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    self.btnEmotion.setTitleColor( #colorLiteral(red: 0.2901960784, green: 0.6039215686, blue: 0.4588235294, alpha: 1), for: .normal)
                    self.viewLine.isHidden = false
                    self.lblReason.isHidden = false
                    self.lblStaticFor.isHidden = false
                    self.lblReason.text = strDesc
                    
                    self.arrSelectedStudent.removeAll()
                    
                    let dict = WiseClassRequestParam(wise_date: self.getDate(), worthy: 0, student_id: self.scannedStudent?.first?._id ,intellect: 0, reason: strDesc, stature: 1, emotion: 0,admission_no: self.admissionNo)
                    self.arrSelectedStudent.append(dict.dictionary)
                    
                }else{
                    self.viewLine.isHidden = true
                    self.lblReason.isHidden = true
                    self.lblStaticFor.isHidden = true
                    
                }
                
            }
            self.present(viewController, animated: true, completion: nil)
        }
    }
    @IBAction func btnEmotionClick(_ sender: Any) {
        
        if let viewController: PopUpViewController = PopUpViewController.storyboardInstance.initialize() {
            
            viewController.modalPresentationStyle = .overCurrentContext
            viewController.strTitle = "Emotion"
            viewController.doneHandler = { (strDesc) in
                if(strDesc != ""){
                    self.btnWorthy.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    self.btnWorthy.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
                    
                    self.btnIntellect.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    self.btnIntellect.setTitleColor(#colorLiteral(red: 0.1480000019, green: 0.2960000038, blue: 0.8029999733, alpha: 1), for: .normal)
                    
                    self.btnStature.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    self.btnStature.setTitleColor( #colorLiteral(red: 0.9620772004, green: 0.6563818455, blue: 0.2461998165, alpha: 1), for: .normal)
                    
                    self.btnEmotion.backgroundColor = #colorLiteral(red: 0.2901960784, green: 0.6039215686, blue: 0.4588235294, alpha: 1)
                    self.btnEmotion.setTitleColor( #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                    
                    self.viewLine.isHidden = false
                    self.lblReason.isHidden = false
                    self.lblStaticFor.isHidden = false
                    self.lblReason.text = strDesc
                    
                    self.arrSelectedStudent.removeAll()
                    
                    let dict = WiseClassRequestParam(wise_date: self.getDate(), worthy: 0, student_id: self.scannedStudent?.first?._id ,intellect: 0, reason: strDesc, stature: 0, emotion: 1,admission_no: self.admissionNo)
                    self.arrSelectedStudent.append(dict.dictionary)
                    
                }else{
                    self.viewLine.isHidden = true
                    self.lblReason.isHidden = true
                    self.lblStaticFor.isHidden = true
                    
                }
                
            }
            self.present(viewController, animated: true, completion: nil)
        }
    }
}

extension StudentViewController: QRScannerCodeDelegate {
    func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {
        print("result:\(result)")
        admissionNo = result //"11153425"
        updateView()
    }
    
    func qrScannerDidFail(_ controller: UIViewController, error: String) {
        print("error:\(error)")
    }
    
    func qrScannerDidCancel(_ controller: UIViewController) {
        print("SwiftQRScanner did cancel")
      /*  admissionNo = "11153425"
        updateView()*/
    }
}

extension StudentViewController {
//    func callAPIForClassWiseList(finished:@escaping(_ success: Bool) -> Void) {
//        Loader.show()
//
//        let dtForm : DateFormatter = DateFormatter()
//        dtForm.dateFormat = "yyyy"
//        let strStart : String = "20-01-2019"
//        let strEnd : String = "31-03-2020"
//
//        WiseManagementAPI.studentWise(scanedID: self.selectedClassID, startDate: strStart, endDate: strEnd) { (response, error) in
//            Loader.hide()
//            guard let response = response else {
//                self.toast(error?.localizedDescription ?? "Invalid Response")
//                finished(false)
//                return
//            }
//
//            guard let responseData = response.data else {
//                self.toast(response.message ?? "Invalid Response")
//                finished(false)
//                return
//            }
//
//            self.scannedStudent = responseData.first
//            finished(true)
//        }
//    }
    
    func callAPIForSearchStudents(finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
       
        let requestParam = SearchStudentsParam(admission_no: admissionNo, search_type: "min-search")
        WiseManagementAPI.searchWiseStudentsFromQR(body: requestParam) { (respose, error) in
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
            self.imgURL = (response.path ?? "")
            
            self.scannedStudent = responseData
            if(self.scannedStudent!.count == 0){
                self.toast("No Student Found")
            }
            finished(true)
        }
    }
}
