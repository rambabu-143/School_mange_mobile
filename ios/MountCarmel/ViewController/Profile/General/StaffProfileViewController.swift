//
//  StaffProfileViewController.swift
//  MountCarmel
//
//  Created by Sandip on 23/08/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class StaffProfileViewController: UIViewController {
    @IBOutlet weak var navigationView: NavigationBarView!
    
    @IBOutlet weak var tblView: UITableView!{
        didSet{
            tblView.delegate = self
            tblView.dataSource = self
        }
    }
    @IBOutlet var lblAddressTitle: UILabel!
    @IBOutlet var lblSOSTitle: UILabel!{
        didSet{
            lblSOSTitle.isHidden = true
        }
    }
    @IBOutlet var lblMobileTitle: UILabel!
    @IBOutlet var lblEmailTitle: UILabel!
    @IBOutlet var lblMarriageAnnivarsaryTitle: UILabel!
    @IBOutlet var lblSpouseNameTitle: UILabel!
    @IBOutlet var lblJoiningDateTitle: UILabel!
    @IBOutlet var lblBirthdateTitle: UILabel!
    @IBOutlet var lblNameTitle: UILabel!
    
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblSOS: UILabel!
    @IBOutlet var lblMobile: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblMarriageAnniversary: UILabel!
    @IBOutlet var lblSpouseName: UILabel!
    @IBOutlet var lblDateOfJoining: UILabel!
    @IBOutlet var lblDateOfBirth: UILabel!
    
    @IBOutlet weak var lblSosName: UILabel!
    @IBOutlet weak var lblSosMob: UILabel!
    @IBOutlet weak var lblSosChildMcs: UILabel!
  
    
    @IBOutlet var txtAddress: GrowingTextView!
    @IBOutlet var lblName: UILabel!
    var objProfileData : LoginAPIStaffId_Separate?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.lblTitle.text = "General"
        navigationView.delegate = self
        setInitialFont()
        setInitialData()
        // Do any additional setup after loading the view.
    }
    
    func setInitialFont(){
        self.lblAddressTitle.font = UIFont.setBoldFont(ofSize: 14.0)
        self.lblSOSTitle.font = UIFont.setBoldFont(ofSize: 14.0)
        self.lblMobileTitle.font = UIFont.setBoldFont(ofSize: 14.0)
        self.lblEmailTitle.font = UIFont.setBoldFont(ofSize: 14.0)
        self.lblMarriageAnnivarsaryTitle.font = UIFont.setBoldFont(ofSize: 14.0)
        self.lblSpouseNameTitle.font = UIFont.setBoldFont(ofSize: 14.0)
        self.lblJoiningDateTitle.font = UIFont.setBoldFont(ofSize: 14.0)
        self.lblBirthdateTitle.font = UIFont.setBoldFont(ofSize: 14.0)
        self.lblNameTitle.font = UIFont.setBoldFont(ofSize: 14.0)
        
        self.lblDateOfBirth.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblDateOfJoining.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblSpouseName.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblMarriageAnniversary.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblEmail.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblMobile.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblSOS.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblAddress.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblName.font = UIFont.setRegularFont(ofSize: 13.0)
        
    }
    func setInitialData(){
        
        lblName.text = objProfileData?.name ?? ""
        lblEmail.text = objProfileData?.email ?? ""
       // lblSOS.text = objProfileData?.emergency_mobile ?? ""
        self.lblDateOfBirth.text = CommonFunctions.getDateString(date: (objProfileData?.dateOfBirth ?? ""), fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_DDMMYYYY)
        
        self.lblDateOfJoining.text = CommonFunctions.getDateString(date: (objProfileData?.dateOfJoining ?? ""), fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_DDMMYYYY)
        
        self.lblSpouseName.text = (objProfileData?.spousename ?? "")
        
        self.lblMobile.text = (objProfileData?.mobile ?? "")
        
        self.lblMarriageAnniversary.text = CommonFunctions.getDateString(date: (objProfileData?.dateofanniversary ?? ""), fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_DDMMYYYY)
        
        let strAddress1 = objProfileData?.address?.localAddress ?? ""
        
        let strAddress2 = objProfileData?.address?.city ?? ""
        
        let strPinCode = objProfileData?.address?.pincode ?? ""
        
        // let strState = APP_DELEGATE.userInfo?.staffId?.address?.stateId?.stateName ?? ""
        
        self.lblAddress.text = strAddress1 + "," + strAddress2 + "-" + strPinCode
        
        lblSosName.text = objProfileData?.emergency_name ?? ""
        lblSosMob.text = objProfileData?.emergency_mobile ?? ""
        lblSosChildMcs.text = (objProfileData?.students?.count ?? 0) == 0 ? "No" : "Yes"
        
        self.tblView.reloadData()
    }
    
}
extension StaffProfileViewController: NavigationBarViewDelegate {
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

extension StaffProfileViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        objProfileData?.students?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "cellid") as! staffTblCell
        if let obj = objProfileData?.students{
            cell.lblStudentsNameAddmission.text = "\(indexPath.row + 1). \(obj[indexPath.row].student_id?.name ?? "") (\(obj[indexPath.row].student_id?.admission_no ?? ""))"
        }else{
            cell.lblStudentsNameAddmission.text = ""
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40.0
    }
    
}

class staffTblCell:UITableViewCell{
    @IBOutlet weak var lblStudentsNameAddmission: UILabel!
    
}

