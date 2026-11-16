//
//  SchoolFeeViewController.swift
//  MountCarmel
//
//  Created by Sandip on 10/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class SchoolFeeViewController: UIViewController {
    @IBOutlet var tblInstallment: UITableView!
    
    @IBOutlet var btnPay: RoundedButton!
    @IBOutlet var conTblInstallmentHeight: NSLayoutConstraint!
    @IBOutlet var lblStudentName: UILabel!
    
    @IBOutlet var lblAdmissionNo: UILabel!
    
    @IBOutlet var lblClass: UILabel!
    
    @IBOutlet var lblStationary: UILabel!
    @IBOutlet var lblAnualFee: UILabel!
    @IBOutlet var lblBillDate: UILabel!
    @IBOutlet var lblBillYear: UILabel!
    
    @IBOutlet weak var navigationView: NavigationBarView!

    @IBOutlet var conTblMonthlyCharges: NSLayoutConstraint!
    @IBOutlet var tblMonthlyCharges: UITableView!
    var objSchoolFeeData : FeeDetailsBillData?
    var strTitle = ""
    var arrMonthlyFee = [MonthlyFee]()
    var arrInstallment = [FeeDetailsInstallment]()
    var arranualFee = [AnnualFee]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.lblTitle.text = strTitle
        navigationView.delegate = self
        setInitialView()
        
        self.callAPIForGetSchoolFeeDetail { (success) in
            if(success){
                self.setViewData()
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func setInitialView(){
        tblMonthlyCharges.register(UINib(nibName: "MonthlyChargesCell", bundle: nil), forCellReuseIdentifier: "MonthlyChargesCell")
        
        tblMonthlyCharges.register(UINib(nibName: "TotalAmountCell", bundle: nil), forCellReuseIdentifier: "TotalAmountCell")
        
        tblInstallment.register(UINib(nibName: "InstallmentCell", bundle: nil), forCellReuseIdentifier: "InstallmentCell")
        
        tblInstallment.register(UINib(nibName: "InstallmentPayCell", bundle: nil), forCellReuseIdentifier: "InstallmentPayCell")
        
        self.tblMonthlyCharges.isHidden = true
        self.tblInstallment.isHidden = true
        
//        self.tblMonthlyCharges.reloadData()
//        self.tblMonthlyCharges.layoutIfNeeded()
//        self.conTblMonthlyCharges.constant = 0
//        self.view.layoutSubviews()
//
//        self.tblInstallment.reloadData()
//        self.tblInstallment.layoutIfNeeded()
//        self.conTblInstallmentHeight.constant = 0
//        self.view.layoutSubviews()
    }
    
    func setViewData(){
        lblStudentName.text  = objSchoolFeeData?.name ?? ""
        lblAdmissionNo.text  = objSchoolFeeData?.admission_no ?? ""
        lblClass.text = (objSchoolFeeData?.strclass ?? "") + "-" + (objSchoolFeeData?.section ?? "")
        lblBillYear.text  = objSchoolFeeData?.yearsession ?? ""
        lblBillDate.text  = objSchoolFeeData?.date ?? ""
        
        self.arrMonthlyFee = objSchoolFeeData?.fees?.monthlyFee ?? [MonthlyFee]()
        
        self.arrInstallment = objSchoolFeeData?.installment ?? [FeeDetailsInstallment]()
        
        self.arranualFee = objSchoolFeeData?.fees?.annualFee ??  [AnnualFee]()
        
        if(self.arranualFee.count > 0){
            self.lblAnualFee.text = "₹" + (self.arranualFee[0].charges ?? "")
            self.lblStationary.text = "₹" + (self.arranualFee[1].charges ?? "")

        }
       
        self.tblMonthlyCharges.delegate = self
        self.tblMonthlyCharges.dataSource = self
        self.tblMonthlyCharges.isHidden = false
        
        self.tblMonthlyCharges.reloadData()
        self.tblMonthlyCharges.layoutIfNeeded()
        self.conTblMonthlyCharges.constant = self.tblMonthlyCharges.contentSize.height
        self.view.layoutSubviews()
        
        self.tblInstallment.delegate = self
        self.tblInstallment.dataSource = self
        self.tblInstallment.isHidden = false
        self.tblInstallment.reloadData()
        self.tblInstallment.layoutIfNeeded()
        self.conTblInstallmentHeight.constant = self.tblInstallment.contentSize.height + 20
        self.view.layoutSubviews()
        let strPay = "₹" + "\(objSchoolFeeData?.totalPayable ?? 0)"
        btnPay.setTitle("PAY  \(strPay)", for: .normal)
        
        
    }
}

extension SchoolFeeViewController: NavigationBarViewDelegate {
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
extension SchoolFeeViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == tblMonthlyCharges){
            if(self.arrMonthlyFee.count > 0){
                return self.arrMonthlyFee.count + 1
            }else{
                return 0
            }
        }else{
            if(self.arrInstallment.count > 0){
                return self.arrInstallment.count + 1
            }else{
                return 0
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == tblMonthlyCharges){
            if(indexPath.row == self.arrMonthlyFee.count){
                let cell = self.tblMonthlyCharges.dequeueReusableCell(withIdentifier: "TotalAmountCell", for: indexPath) as? TotalAmountCell
                var totalSum = 0
                for i in 0..<self.arrMonthlyFee.count{
                    totalSum = totalSum + (self.arrMonthlyFee[i].charges ?? 0)
                }
                cell?.lblTotalAmount.text = "₹" + "\(totalSum)"
                return cell ?? UITableViewCell()
            }else{
                let cell = self.tblMonthlyCharges.dequeueReusableCell(withIdentifier: "MonthlyChargesCell", for: indexPath) as? MonthlyChargesCell
                cell?.lblDescription.text = self.arrMonthlyFee[indexPath.row].head_name ?? ""
                cell?.lblPriceVal.text = "₹" + "\(self.arrMonthlyFee[indexPath.row].charges ?? 0)"
                return cell ?? UITableViewCell()
            }
            
        }else{
            if(indexPath.row == self.arrInstallment.count){
                let cell = self.tblInstallment.dequeueReusableCell(withIdentifier: "InstallmentPayCell", for: indexPath) as? InstallmentPayCell
                cell?.lblPayable.text = "₹" + "\(objSchoolFeeData?.totalPayable ?? 0)"
                return cell ?? UITableViewCell()
            }else{
                let cell = self.tblInstallment.dequeueReusableCell(withIdentifier: "InstallmentCell", for: indexPath) as? InstallmentCell
                cell?.setUpCell(data: self.arrInstallment[indexPath.row])
                
                return cell ?? UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
extension SchoolFeeViewController{
    func callAPIForGetSchoolFeeDetail(finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
        StaffManageMentAPI.getSchoolFeeDetail() { (respose, error) in
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
            
            self.objSchoolFeeData = responseData.feebillid
            finished(true)
        }
    }
}
