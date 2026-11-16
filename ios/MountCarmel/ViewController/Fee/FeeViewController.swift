//
//  FeeViewController.swift
//  MountCarmel
//
//  Created by Niraj on 04/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import QuickLook

class FeeViewController: UIViewController {

    @IBOutlet var lblLeftDueAmt: UILabel!
    @IBOutlet var lblLeftFine: UILabel!
    @IBOutlet var lblLeftTransportAmt: UILabel!
    @IBOutlet var lblLeftTransportInstallment: UILabel!
   
    @IBOutlet var lblDueAmt: UILabel!
    @IBOutlet var lblFine: UILabel!
    @IBOutlet var lblAMount: UILabel!
    @IBOutlet var lblinstallment: UILabel!
    @IBOutlet var lblSchoolFeeTitle: UILabel!
    @IBOutlet var viewSchoolFee: UIView!
    
    @IBOutlet var lblSchool_installment: UILabel!
    @IBOutlet var lblSchool_amount: UILabel!
    
    @IBOutlet var lblSchool_fine: UILabel!
    
    @IBOutlet weak var btnPayBillSchool: UIButton!
    
    @IBOutlet var lblSchool_DueAmt: UILabel!
    var previewItem : URL?
    
    @IBOutlet var lblTransport_DueAmount: UILabel!
    @IBOutlet var lblTransport_Fine: UILabel!
    @IBOutlet var lblTransport_Amount: UILabel!
    @IBOutlet var lblTransport_installment: UILabel!
    @IBOutlet var viewTransPortFee: UIView!
    @IBOutlet weak var btnPayBillTransport: UIButton!
    
    @IBOutlet weak var lblHostelTitle: UILabel!
    @IBOutlet var lblHostelDueAmt: UILabel!
    @IBOutlet var lblHostelFine: UILabel!
    @IBOutlet var lbLHostelAmt: UILabel!
    @IBOutlet var lblHostelInstallment: UILabel!
    
    @IBOutlet var lblHostel_DueAmount: UILabel!
    @IBOutlet var lblHostel_Fine: UILabel!
    @IBOutlet var lblHostel_Amount: UILabel!
    @IBOutlet var lblHostel_installment: UILabel!
    @IBOutlet var viewHostelFee: UIView!
    @IBOutlet weak var btnPayBillHostel: UIButton!
    
    
    @IBOutlet weak var navigationView: NavigationBarView!
    var objFeeData : FeesData?
    var objProfileData : StudentDetailData?
    var objStaffProfileData : LoginAPIStaffId_Separate?
   
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationView.lblTitle.text = "Fee"
        navigationView.delegate = self
        self.viewTransPortFee.isHidden = true
        self.viewSchoolFee.isHidden = true
        self.viewHostelFee.isHidden = true
        self.lblSchoolFeeTitle.font = UIFont.setBoldFont(ofSize: 14.0)
        
        self.lblFine.font = UIFont.setRegularFont(ofSize: 14.0)
        self.lblAMount.font = UIFont.setRegularFont(ofSize: 14.0)
        self.lblDueAmt.font = UIFont.setBoldFont(ofSize: 14.0)
        self.lblinstallment.font = UIFont.setRegularFont(ofSize: 14.0)
        
        self.lblLeftFine.font = UIFont.setRegularFont(ofSize: 14.0)
        self.lblLeftTransportAmt.font = UIFont.setRegularFont(ofSize: 14.0)
        self.lblLeftDueAmt.font = UIFont.setBoldFont(ofSize: 14.0)
        self.lblLeftTransportInstallment.font = UIFont.setRegularFont(ofSize: 14.0)
        
        self.lblSchool_fine.font = UIFont.setRegularFont(ofSize: 14.0)
        self.lblSchool_amount.font = UIFont.setRegularFont(ofSize: 14.0)
        self.lblSchool_DueAmt.font = UIFont.setBoldFont(ofSize: 14.0)
        self.lblSchool_installment.font = UIFont.setRegularFont(ofSize: 14.0)
        
        lblTransport_installment.font = UIFont.setRegularFont(ofSize: 14.0)
        lblTransport_Fine.font = UIFont.setRegularFont(ofSize: 14.0)
        lblTransport_Amount.font = UIFont.setRegularFont(ofSize: 14.0)
        lblTransport_DueAmount.font = UIFont.setBoldFont(ofSize: 14.0)
        
        lblHostelTitle.font = UIFont.setRegularFont(ofSize: 14.0)
        lblHostelDueAmt.font = UIFont.setRegularFont(ofSize: 14.0)
        lblHostelFine.font = UIFont.setRegularFont(ofSize: 14.0)
        lbLHostelAmt.font = UIFont.setRegularFont(ofSize: 14.0)
        lblHostelInstallment.font = UIFont.setRegularFont(ofSize: 14.0)
        
        lblHostel_installment.font = UIFont.setRegularFont(ofSize: 14.0)
        lblHostel_Fine.font = UIFont.setRegularFont(ofSize: 14.0)
        lblHostel_Amount.font = UIFont.setRegularFont(ofSize: 14.0)
        lblHostel_DueAmount.font = UIFont.setBoldFont(ofSize: 14.0)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        callAPI()
    }
    
    func callAPI() {
        if APP_DELEGATE.userType == .Staff{
            self.callAPIStaffDetails { (check, responseData) in
                if(check){
                    self.objStaffProfileData = responseData?.data
                    self.setUpData()
                }
            }
        }else{
            self.callAPIStudentDetails { (check, objData) in
                if(check){
                    self.objProfileData = objData?.data
                    self.setUpData()
                }
            }
        
        }
    }
    
    func setUpData(){
        
        if APP_DELEGATE.userType == .Staff{
            
             if let transportData = self.objStaffProfileData?.transport_bill_id{
                self.viewTransPortFee.isHidden = false
               
                    let installmentData = transportData.installment?.filter({ (objData) -> Bool in
                        objData.installment_type == "CURRENT"//feeBillData.installmentNO
                    })
                    
                    lblTransport_installment.text = transportData.installmentNO
                    lblTransport_Fine.text = "₹" + "\(installmentData?[0].fine?.intValue ?? 0)"
                    lblTransport_Amount.text = "₹" + "\(installmentData?[0].amount ?? 0)"
                    lblTransport_DueAmount.text = "₹" + "\(installmentData?[0].amount_payble ?? 0)"
                    
                 if transportData.full_payment_received != true || ((transportData.payable ?? 0) > 0) {
                    btnPayBillTransport.setTitleColor(UIColor(red: 176.0/255.0, green: 197.0/255.0, blue: 97.0/255.0, alpha: 1.0), for: .normal)
                    btnPayBillTransport.setTitle("Pay Bill", for: .normal)
                }else{
                    btnPayBillTransport.setTitleColor(UIColor.systemRed, for: .normal)
                    btnPayBillTransport.setTitle("Paid", for: .normal)
                }
            }

            return
        }
       // student
        if let transportData = self.objProfileData?.transport_bill_id{
            self.viewTransPortFee.isHidden = false
            
                let installmentData = transportData.installment?.filter({ (objData) -> Bool in
                    objData.installment_type == "CURRENT"//feeBillData.installmentNO
                })
                
                lblTransport_installment.text = transportData.installmentNO
                lblTransport_Fine.text = "₹" + "\(installmentData?[0].fine ?? 0)"
                lblTransport_Amount.text = "₹" + "\(installmentData?[0].amount ?? 0)"
                lblTransport_DueAmount.text = "₹" + "\(installmentData?[0].amount_payble ?? 0)"
                
            if transportData.full_payment_received != true || ((transportData.payable ?? 0) > 0){
                btnPayBillTransport.setTitleColor(UIColor(red: 176.0/255.0, green: 197.0/255.0, blue: 97.0/255.0, alpha: 1.0), for: .normal)
                btnPayBillTransport.setTitle("Pay Bill", for: .normal)
            }else{
                btnPayBillTransport.setTitleColor(UIColor.systemRed, for: .normal)
                btnPayBillTransport.setTitle("Paid", for: .normal)
            }
        }
        
        
        if let feeBillData = self.objProfileData?.fee_bill_id{
            self.viewSchoolFee.isHidden = false
            
                let installmentData = feeBillData.installment?.filter({ (objData) -> Bool in
                    objData.installment_type == "CURRENT"//feeBillData.installmentNO
                })
                
                lblSchool_installment.text = feeBillData.installmentNO
                lblSchool_fine.text = "₹" + "\(installmentData?[0].fine_installment ?? 0)"
                lblSchool_amount.text = "₹" + "\(installmentData?[0].amount ?? 0)"
                lblSchool_DueAmt.text = "₹" + "\(installmentData?[0].amount_payble ?? 0)"
                
            if (self.objProfileData?.full_payment_received == true) {
                btnPayBillSchool.setTitleColor(UIColor.systemRed, for: .normal)
                btnPayBillSchool.setTitle("Paid", for: .normal)
            } else {
                btnPayBillSchool.setTitleColor(UIColor(red: 176.0/255.0, green: 197.0/255.0, blue: 97.0/255.0, alpha: 1.0), for: .normal)
                btnPayBillSchool.setTitle("Pay Bill", for: .normal)
            }
        }
        
        if let hostelBillData = self.objProfileData?.hostel_bill_id{
            self.viewHostelFee.isHidden = false
            
                let installmentData = hostelBillData.installment?.filter({ (objData) -> Bool in
                    objData.installment_type == "CURRENT"//feeBillData.installmentNO
                })
                
                lblHostel_installment.text = hostelBillData.installmentNO
                lblHostel_Fine.text = "₹" + "\(installmentData?[0].fine_installment ?? 0)"
                lblHostel_Amount.text = "₹" + "\(installmentData?[0].amount ?? 0)"
                lblHostel_DueAmount.text = "₹" + "\(installmentData?[0].amount_payble ?? 0)"
                
            if hostelBillData.full_payment_received != true || ((hostelBillData.totalPayable ?? 0) > 0){
                btnPayBillHostel.setTitleColor(UIColor(red: 176.0/255.0, green: 197.0/255.0, blue: 97.0/255.0, alpha: 1.0), for: .normal)
                btnPayBillHostel.setTitle("Pay Bill", for: .normal)
            }else{
                btnPayBillHostel.setTitleColor(UIColor.systemRed, for: .normal)
                btnPayBillHostel.setTitle("Paid", for: .normal)
            }
        }
    }
    
    @IBAction func actionPaySchoolBill(_ sender: Any) {
        guard btnPayBillSchool.title(for: .normal) == "Pay Bill" else {return}
        let payBillViewController = PayBillViewController()
        payBillViewController.paymentType = "school"
        payBillViewController.userType = "member"
        payBillViewController.studentId = objProfileData?._id
        payBillViewController.billTypeUpdated = objProfileData?.is_bill_type_updated
        payBillViewController.studentType = objProfileData?.student_type
        guard let navController = self.navigationController else {
            print("navigationController is not available")
            self.toast("NavigationController is not available, Try again or Contact Admin!")
            return
        }
        navController.pushViewController(payBillViewController, animated: true)
    }
    
    
    @IBAction func actionPayTransportBill(_ sender: Any) {
        guard btnPayBillTransport.title(for: .normal) == "Pay Bill" else {return}
        let payBillViewController = PayBillViewController()
        payBillViewController.paymentType = "transport"
        payBillViewController.userType = APP_DELEGATE.userType == .Staff ? "staff" : "member"
        payBillViewController.studentId = objProfileData?._id
        payBillViewController.staffId = objStaffProfileData?.ID
        guard let navController = self.navigationController else {
            print("navigationController is not available")
            self.toast("NavigationController is not available, Try again or Contact Admin!")
            return
        }
        navController.pushViewController(payBillViewController, animated: true)
    }
    
    
    @IBAction func actionPayBillHostel(_ sender: Any) {
        guard btnPayBillHostel.title(for: .normal) == "Pay Bill" else {return}
        let payBillViewController = PayBillViewController()
        payBillViewController.paymentType = "hostel"
        payBillViewController.userType = "member"
        payBillViewController.studentId = objProfileData?._id
        guard let navController = self.navigationController else {
            print("navigationController is not available")
            self.toast("NavigationController is not available, Try again or Contact Admin!")
            return
        }
        navController.pushViewController(payBillViewController, animated: true)
    }
    
    @IBAction func actionSchoolBillClick(_ sender: Any) {
       /* if let viewController: DataSheetViewController = DataSheetViewController.storyboardInstance.initialize() {
            viewController.urlPath = objProfileData?.feebillurl ?? ""
            viewController.isFromFee = true
            viewController.strTitle = "School Fee"
            self.navigationController?.pushViewController(viewController, animated: true)
        }*/
        let fileURL = self.objProfileData?.fee_bill_id?.filepath ?? ""
        let fileName = "School Fee"
        let title = "School Fee"
        
        let storyBoard = UIStoryboard(name: "NoticeViewController", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            viewController.fileName = fileName
            viewController.Title = title
            viewController.url = URL(string: fileURL)
            self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func actionViewTransportBillClick(_ sender: Any) {
       /* if let viewController: DataSheetViewController = DataSheetViewController.storyboardInstance.initialize() {
            viewController.urlPath = objProfileData?.transportbillid?.filepath ?? ""
            viewController.isFromFee = true
            viewController.strTitle = "Transport Fee"
            self.navigationController?.pushViewController(viewController, animated: true)
        }*/
        
        let fileURL =  APP_DELEGATE.userType == .Staff ? objStaffProfileData?.transport_bill_id?.filepath ?? "" : objProfileData?.transport_bill_id?.filepath ?? ""
        let fileName = "Transport Fee"
        let title = "Transport Fee"

        let storyBoard = UIStoryboard(name: "NoticeViewController", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            viewController.fileName = fileName
            viewController.Title = title
            viewController.url = URL(string: fileURL)
            self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func actionViewHostelBillClick(_ sender: Any) {
        let fileURL =  self.objProfileData?.hostel_bill_url ?? ""
        let fileName = "Hostel Fee"
        let title = "Hostel Fee"

        let storyBoard = UIStoryboard(name: "NoticeViewController", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            viewController.fileName = fileName
            viewController.Title = title
            viewController.url = URL(string: fileURL)
            self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension FeeViewController: NavigationBarViewDelegate {
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
extension FeeViewController {
   /* func callAPIForFees(finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
        StaffManageMentAPI.getFees() { (respose, error) in
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
            self.objFeeData = responseData
            if(self.objFeeData?.feebillid != nil){
                
            }
            finished(true)
        }
    }*/

    
    func callAPIStudentDetails(finished:@escaping(_ success: Bool, _ response: StudentDetailAPIResponse?) -> Void) {
        Loader.show()
        
        StudentManagementAPI.getStuddentDetails(studentID: APP_DELEGATE.selected_Student?.studentId?.ID ?? "") { (response, error) in
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
            guard let responseData = response.message else {
              //  let message = response.message ?? "Invalid Response"
                finished(false, nil)
                return
            }
            finished(true, response)
        }
    }
    private func callAPIStaffDetails(finished:@escaping(_ success: Bool, _ response: StaffDetailAPIResponse?) -> Void) {
         Loader.show()
         
         StaffManageMentAPI.getStaffDetails() { (response, error) in
             Loader.hide()
             guard let response = response else {
                 let _ = error?.localizedDescription ?? "Invalid Response"
                 print(error)
                 finished(false, nil)
                 return
             }
             guard response.status == true else {
                 self.toast(response.message ?? "")
                 finished(false, nil)
                 return
             }
             guard let responseData = response.message else {
                 //let message = response.message ?? "Invalid Response"
                 finished(false, nil)
                 return
             }
             finished(true, response)
         }
     }
    
}
extension FeeViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        
        return self.previewItem! as QLPreviewItem
    }
}
