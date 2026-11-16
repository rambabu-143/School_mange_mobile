//
//  TransportRenewalViewController.swift
//  MountCarmel
//
//  Created by Mandeep Singh on 20/05/23.
//  Copyright © 2023 InventionHill. All rights reserved.
//

import UIKit
import DTTextField
class TransportRenewalViewController: UIViewController {
    @IBOutlet weak var navigationView: NavigationBarView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblPlaceholder: UILabel!
    @IBOutlet weak var lblTransportSession: UILabel!
    @IBOutlet weak var lblBranchAddress: UILabel!
    
    @IBOutlet weak var lblProvisionClassSession: UILabel!
    @IBOutlet weak var imgRadioRenew: UIImageView!
    @IBOutlet weak var imgRadioWidhdraw: UIImageView!
    @IBOutlet weak var txtStudentName: UITextField!
    @IBOutlet weak var imgStudent: RoundedImage!
    @IBOutlet weak var txtAdmission: UITextField!
    @IBOutlet weak var txtClassSection: UITextField!
    @IBOutlet weak var txtHomeAddress: UITextField!
    @IBOutlet weak var lblHomeAddress: UILabel!
    @IBOutlet weak var txtMobileNo: UITextField!
    @IBOutlet weak var txtFatherNo: UITextField!
    @IBOutlet weak var txtMotherNo: UITextField!
    @IBOutlet weak var imgRadioSiblingYes: UIImageView!
    @IBOutlet weak var imgRadioSiblingNo: UIImageView!
    @IBOutlet weak var txtSiblingAdmission: DTTextField!
    @IBOutlet weak var txtMorningRoute: UITextField!
   // @IBOutlet weak var txtPickupPoint: UITextField!
    
    @IBOutlet weak var txtPickupPoint: UILabel!
    
    @IBOutlet weak var txtPickupTime: UITextField!
    @IBOutlet weak var txtAfternoonRoute: UITextField!
   // @IBOutlet weak var txtDropoffPoint: UITextField!
    @IBOutlet weak var txtDropoffPoint: UILabel!
    
    @IBOutlet weak var txtDropoffTime: UITextField!
    
    @IBOutlet weak var viewAddSibling: UIView!{didSet{viewAddSibling.isHidden=true}}
    
    @IBOutlet weak var viewSiblingHeader: UIView!{didSet{viewSiblingHeader.isHidden=true}}
    
    @IBOutlet var viewsSiblingDetails: [UIView]!
    @IBOutlet var lblsSiblingDetails: [UILabel]!
    
    private var arrSiblingDetails = [StudentDetailData](){
        didSet{
            self.AdjustSiblingDetails()
        }
    }
   private var objProfileData : StudentDetailData?
   private var imgURL = ""
    private var promoted_class = ""
    private var next_year_session = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationView.lblTitle.text = "Transport Renewal"
        navigationView.delegate = self
        
        self.scrollView.isHidden = true
        self.lblPlaceholder.isHidden = true
        
        self.callAPITransportRenewalShow { status, response in
            if status == false{
                // Status == true - Hide Form and Show message
                self.lblPlaceholder.isHidden = false
                self.lblPlaceholder.text = response?.message ?? "Transport Renewal Form already filled!"
            }else{
                // Status == false - Show Form
                self.promoted_class = response?.promoted_class ?? ""
                self.next_year_session = response?.next_year_session ?? ""
                self.lblBranchAddress.text = response?.branch_details?.branch_address ?? ""
                self.scrollView.isHidden = false
               
                self.AdjustSiblingDetails()
                
                self.callAPIStudentDetails { (check, objData) in
                    if(check){
                        self.objProfileData = objData?.data
                        self.imgURL = objData?.path ?? ""
                        self.SetData()
                    }
                }
            }
        }
    }
    
    private func SetData(){
        let btn = UIButton()
        btn.tag = (self.objProfileData?.transport_renewal ?? false) ? 1 : 0
        btnRenewAndWidhdraw(btn)
        
        btn.tag = 1
        btnSiblingYesAndNo(btn)
        
        txtStudentName.text = objProfileData?.name ?? ""
        
        let imageURL = (imgURL)+(objProfileData?.profile_pic ?? "")
         self.imgStudent.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "profile-placeholder"), options: [], context: nil)
        
        txtAdmission.text = objProfileData?.admission_no ?? ""
        txtClassSection.text = promoted_class + " " + (objProfileData?.section_id?.name ?? "")
        
        let strAddress1 = objProfileData?.address?.last?.local_address ?? ""
        let strAddress2 = objProfileData?.address?.last?.city ?? ""
        let strPinCode = objProfileData?.address?.last?.pincode ?? ""
        let strCountry = (objProfileData?.address?.last?.country_id?.countryName ?? "").uppercased()
        lblHomeAddress.text = strAddress1 + ", " + strAddress2 + ", " + strCountry + ", " + strPinCode 
        
        txtMobileNo.text = objProfileData?.sms_mobile ?? ""
        
        let ArrRelation = (objProfileData?.relation ?? []).sorted { ($0.relation ?? "") < ($1.relation ?? "")}
        txtFatherNo.text = ArrRelation.first?.mobile ?? ""
        txtMotherNo.text = ArrRelation.last?.mobile ?? ""
        
        txtMorningRoute.text = objProfileData?.transport_bill_id?.transportAry?.last?.morningroute ?? ""
        txtPickupPoint.text = objProfileData?.transport_bill_id?.transportAry?.last?.morningstop ?? ""
       // txtPickupTime.text = objProfileData.
        txtAfternoonRoute.text = objProfileData?.transport_bill_id?.transportAry?.last?.eveningroute ?? ""
        txtDropoffPoint.text = objProfileData?.transport_bill_id?.transportAry?.last?.eveningstop ?? ""
       // txtDropoffTime.text = objProfileData.
        
        lblTransportSession.text = lblTransportSession.text! + "(\(self.next_year_session))"
        lblProvisionClassSession.text = lblProvisionClassSession.text! + "\(self.next_year_session))"
    }

    @IBAction func btnRenewAndWidhdraw(_ sender: UIButton) {
        if sender.tag == 0{//renew
            imgRadioRenew.image = UIImage(named: "radio_selected")
            imgRadioWidhdraw.image = UIImage(named: "radio_unselect")
        }else{//widhdraw
            imgRadioRenew.image = UIImage(named: "radio_unselect")
            imgRadioWidhdraw.image = UIImage(named: "radio_selected")
        }
    }
    
    @IBAction func btnSiblingYesAndNo(_ sender: UIButton) {
        if sender.tag == 0{//Yes
            imgRadioSiblingYes.image = UIImage(named: "radio_selected")
            imgRadioSiblingNo.image = UIImage(named: "radio_unselect")
            viewAddSibling.isHidden = false
        }else{//No
            imgRadioSiblingYes.image = UIImage(named: "radio_unselect")
            imgRadioSiblingNo.image = UIImage(named: "radio_selected")
            viewAddSibling.isHidden = true
            self.arrSiblingDetails.removeAll()
        }
    }
    
    @IBAction func btnDelSiblingDetails(_ sender: UIButton) {
        self.arrSiblingDetails.remove(at: sender.tag)
    }
    
    @IBAction func btnAddSibling(_ sender: Any) {
        guard txtSiblingAdmission.text!.count == 8 else{
            self.toast("Please enter valid Admission number.")
            return
        }
        
        guard arrSiblingDetails.count < 3 else{
            self.toast("Maximum 3 siblings details can be added.")
            return
        }
        
        guard self.arrSiblingDetails.filter({$0.admission_no == self.txtSiblingAdmission.text!}).count == 0 else{
            self.toast("Already Added")
            return
        }
        
        self.API_getAdmissionDetail { success, response in
            if let M = response?.data{
                self.txtSiblingAdmission.text = ""
                self.arrSiblingDetails.append(M)
            }
        }
    }
    
    private func AdjustSiblingDetails(){
            
      viewSiblingHeader.isHidden = arrSiblingDetails.count == 0
            
        for V in viewsSiblingDetails{ V.isHidden = true }
        for (i,M) in arrSiblingDetails.enumerated(){
            for V in viewsSiblingDetails{
                if V.tag == i{
                    V.isHidden = false
                }
            }
            for L in lblsSiblingDetails{
                if L.tag == i{
                    L.text = "\(i+1). \(M.admission_no ?? "") - \(M.name ?? "") (\(M.standard_id?.name ?? "")-\(M.section_id?.name ?? "") \(M.school_code ?? ""))"
                }
            }
        }
    }
    
    @IBAction func btnSaveDetails(_ sender: Any) {
        if imgRadioWidhdraw.image == UIImage(named: "radio_selected"){//withdraw
            let vc = UIStoryboard(name: "TransportRenewalViewController", bundle: nil).instantiateViewController(withIdentifier: "TransportWithdrawViewController") as! TransportWithdrawViewController
            vc.year = next_year_session
            vc.modalPresentationStyle = .overFullScreen
            vc.submitHandler = {
                self.HitApiForTransportRenewal()
            }
            self.present(vc, animated: true)
            
        }else{
            let vc = UIStoryboard(name: "TransportRenewalViewController", bundle: nil).instantiateViewController(withIdentifier: "TransportTermConditionPopup") as! TransportTermConditionPopup
            vc.modalPresentationStyle = .overFullScreen
            vc.submitHandler = {
                self.HitApiForTransportRenewal()
            }
            self.present(vc, animated: true)
        }
    }
    
    private func HitApiForTransportRenewal(){
        self.callAPIForTransportRenewal { success in
            self.view.isHidden = false
        }
    }
}

extension TransportRenewalViewController{
    
    private func callAPITransportRenewalShow(finished:@escaping(_ success: Bool, _ response: TransportRenewbleModel?) -> Void) {
        Loader.show()
        StudentManagementAPI.getTransportRenewalShow(studentID: APP_DELEGATE.selected_Student?.studentId?.ID ?? "") { (response, error) in
            Loader.hide()
            guard let response = response else {
                let _ = error?.localizedDescription ?? "Invalid Response"
                finished(false, nil)
                return
            }
            finished(response.status ??  false, response)
        }
    }
    
    private func callAPIStudentDetails(finished:@escaping(_ success: Bool, _ response: StudentDetailAPIResponse?) -> Void) {
        Loader.show()
        
        //        var arrStudents = [LoginAPIStudent]()
        //        arrStudents = APP_DELEGATE.userInfo?.students ?? [LoginAPIStudent]()
        
        StudentManagementAPI.getStuddentDetails(studentID: APP_DELEGATE.selected_Student?.studentId?.ID ?? "") { (response, error) in
            Loader.hide()
            guard let response = response else {
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
            }
            finished(true, response)
        }
    }
    
    
    private func API_getAdmissionDetail(finished:@escaping(_ success: Bool, _ response: StudentDetailAPIResponse?) -> Void) {
        Loader.show()
        
        StudentManagementAPI.getAdmissionDetail(admisionNO: self.txtSiblingAdmission.text!) { (response, error) in
            Loader.hide()
            guard let response = response else {
                //let message = error?.localizedDescription ?? "Invalid Response"
                print(error as Any)
                finished(false, nil)
                return
            }
            guard response.status == true else {
                self.toast(response.message ?? "")
                finished(false, nil)
                return
            }
            guard let _ = response.message else {
                //  let message = response.message ?? "Invalid Response"
                finished(false, nil)
                return
            }
            finished(true, response)
        }
    }
    
    private func callAPIForTransportRenewal(finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
        
        var arrSibling = [[String:Any]]()
        for M in self.arrSiblingDetails{
            arrSibling.append(["sibling_id":M._id ?? "",
                               "standard_section_id":M.standard_section_id ?? "",
                               "name":M.name ?? "",
                               "admission_no":M.admission_no ?? "",
                               "school_code":M.school_code ?? "",
                               "class":M.standard_id?.name ?? "",
                               "section":M.section_id?.name ?? ""])
            
            
        }
        
        let param:[String : Any] = ["student_id":objProfileData?._id ?? "",
                                    "transport_type":imgRadioRenew.image == UIImage(named: "radio_selected") ? "renew" : "withdraw",
                                    "admission_no":objProfileData?.admission_no ?? "",
                                    "sibling_details":arrSibling]
        
        
        print(param)
       
        StudentManagementAPI.postTransportRenewalData(parameters: param) { data, error in
            Loader.hide()
            guard let response = data else{
                self.toast(error?.localizedDescription ?? "Invalid response")
                finished(false)
                return
            }
            
            let msg = response.message ?? "Server Error!!"
            self.toast(msg)
                    
            if msg.contains("Updated Successfully"){
                self.onTapBack()
            }
            finished(true)
        }
        
    }
}
    
 
  
extension TransportRenewalViewController: NavigationBarViewDelegate {
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

