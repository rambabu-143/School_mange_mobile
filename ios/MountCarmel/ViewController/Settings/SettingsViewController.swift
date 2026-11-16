//
//  SettingsViewController.swift
//  MountCarmel
//
//  Created by Niraj on 04/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import LocalAuthentication.LAError

class SettingsViewController: UIViewController {

    // Labels
    @IBOutlet var lblSmsNoti: UILabel!
    @IBOutlet var lblMobileNoti: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var ScreenLockLabel: UILabel!
    @IBOutlet weak var navigationView: NavigationBarView!
    // Action Buttons
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnSMS: UIButton!
    @IBOutlet weak var screenLockSwitch: UISwitch!
    // Extra
    @IBOutlet weak var ScreenLockWrapperView: UIView!
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var viewBorder_Schools: BorderView!{
        didSet
        {
            viewBorder_Schools.isHidden = APP_DELEGATE.userType == .Staff ? false : true
        }
    }
    @IBOutlet weak var btnYear: UIButton!
    @IBOutlet weak var btnSchoolCode: UIButton!
    
    var objStaffProfileData : LoginAPIStaffId_Separate?
    var arrSettingData = [SettingData]()
    var requestParam = SettingParam(name: "", status: false)
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationView.lblTitle.text = "Settings"
        
        navigationView.delegate = self
        
        if APP_DELEGATE.userType == LoginType.Nursery {
            self.bgView.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.7607843137, blue: 0.8274509804, alpha: 1)
        }
        self.btnYear.titleLabel!.font = UIFont.setRegularFont(ofSize: 15.0)
        self.lblSmsNoti.font = UIFont.setRegularFont(ofSize: 15.0)
        self.lblMobileNoti.font = UIFont.setRegularFont(ofSize: 15.0)
        self.lblEmail.font = UIFont.setRegularFont(ofSize: 15.0)
        self.ScreenLockLabel.font = UIFont.setRegularFont(ofSize: 15.0)

        let (canUseScreenLock, _) = BiometricAuthManager.shared.canUseBiometricService()
        if canUseScreenLock {
            let screenLockEnabled = BiometricAuthManager.shared.isBiometricServiceEnabled()
            screenLockSwitch.isOn = screenLockEnabled
        } else {
            ScreenLockWrapperView.isHidden = true
        }

        btnYear.setTitle(APP_DELEGATE.yearSession ?? "" /*APP_DELEGATE.userInfo?.years?[0].yearSession ?? ""*/, for: .normal)
//        self.callSettingListAPI { (check) in
//            if(check){
//                self.setInitialData()
//            }
//        }
        if APP_DELEGATE.userType == .Staff{
            self.callAPIStaffDetails { (check, responseData) in
                if(check){
                   self.objStaffProfileData = responseData?.data
                    
                    if let branch = APP_DELEGATE.currentStaffBranch{
                        self.btnSchoolCode.setTitle(branch, for: .normal)
                    }else{
                        
                        self.btnSchoolCode.setTitle("\(self.objStaffProfileData?.schoolCode ?? "") (\(self.objStaffProfileData?.branch_code ?? 0))", for: .normal)
                    }
                }
            }

        }
        
    }
    
    func setInitialData(){
        let emaildata = self.arrSettingData.filter { (objData) -> Bool in
            return objData.name == "email"
        }
        btnEmail.isSelected = emaildata[0].status ?? false
        
        let appData = self.arrSettingData.filter { (objData) -> Bool in
            return objData.name == "app"
        }
        btnNotification.isSelected = appData[0].status ?? false
        
        let smsData = self.arrSettingData.filter { (objData) -> Bool in
            return objData.name == "sms"
        }
        btnSMS.isSelected = smsData[0].status ?? false
    }
    
    @IBAction func settingNotification(_ sender: UIButton) {
       // btnNotification.isSelected = !sender.isSelected
        requestParam = SettingParam(name: "app", status: btnNotification.isSelected)
       // callUpdateSettingAPI()
        
    }
    
    @IBAction func settingEmailNotification(_ sender: UIButton) {
       // btnEmail.isSelected = !sender.isSelected
        requestParam = SettingParam(name: "email", status: btnEmail.isSelected)
      //  callUpdateSettingAPI()
    }
    
    @IBAction func settingSMSNotification(_ sender: UIButton) {
      //  btnSMS.isSelected = !sender.isSelected
        requestParam = SettingParam(name: "sms", status: btnSMS.isSelected)
      //  callUpdateSettingAPI()
    }
    
    @IBAction func onScreenLockSwitchValueChanged(_ sender: UISwitch!) {
        let enable = sender.isOn
        handleBioServiceEnableState(enable: enable)
    }
    
    private func enableBioService() {
        BiometricAuthManager.shared.authenticateUser{ success, error in
            DispatchQueue.main.async { [weak self] in
                if success {
                    BiometricAuthManager.shared.setBiometricService(enabled: true)
                    APP_DELEGATE.enableFaceIDPromptNeeded = false
                    APP_DELEGATE.isBiometricAuthenticated = true
                } else {
                    let biometricTypeLabel = BiometricAuthManager.shared.biometricTypeLabel
                    let error = error as? LAError
                    let alert = UIAlertController(
                        title: "Authentication Failed",
                        message: error?.localizedDescription ?? "\(biometricTypeLabel) ID authentication was unsuccessful. Please try again.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "Try \(biometricTypeLabel) ID Again", style: .default, handler: { [weak self] _ in
                        self?.enableBioService()
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] _ in
                        self?.screenLockSwitch.isOn = false
                    }))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func handleBioServiceEnableState(enable: Bool) {
        let isBioEnabled = BiometricAuthManager.shared.isBiometricServiceEnabled()

        guard enable != isBioEnabled else {
            // Return early when already enabled or already disabled
            return
        }
        guard enable else {
            BiometricAuthManager.shared.setBiometricService(enabled: false)
            return
        }
        let (canUseBio, error) = BiometricAuthManager.shared.canUseBiometricService()
        let biometricTypeLabel = BiometricAuthManager.shared.biometricTypeLabel
        if canUseBio {
            enableBioService()
        } else {
            let alert = UIAlertController(
                title: "\(biometricTypeLabel) ID Unavailable",
                message: error?.localizedDescription ?? "\(biometricTypeLabel) ID authentication is currently unavailable. Please try again later.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                self?.screenLockSwitch.isOn = false
                self?.screenLockSwitch.isEnabled = false
                self?.ScreenLockLabel.alpha = 0.4
            }))
            present(alert, animated: true, completion: nil)
        }
    }

    func callUpdateSettingAPI(){
        self.UpdateSettingAPI { (checkVal) in
            if(checkVal){
                self.callSettingListAPI { (check) in
                    if(check){
                        self.setInitialData()
                    }
                }
            }
        }
    }
    
    @IBAction func btnDropDownSchool(_ sender: Any) {
        let AlertController = UIAlertController(title: "Switch branch?", message: "", preferredStyle: .alert)
        AlertController.addAction(UIAlertAction(title: "Switch", style: .default, handler: { action in
            
            self.ShowSchoolListActionSheet { object in
                print(object?.branch_code ?? "")
                guard let branceCode = object?.branch_code else {return}
                
                let request = SwitchSchoolParam(branch_code: String(branceCode))
                StaffManageMentAPI.SwitchSchool(body: request) { response, error in
                    Loader.hide()
                    UserDefaults.standard.removeObject(forKey: "StoryChecked")
                    if let Err = error {
                        self.toast(Err.localizedDescription)
                        return
                    }
               
                    guard let token = response?.meta_data?.token else {return}
                    APP_DELEGATE.token = token
                    self.toast(response?.message ?? "Branch switched successfully!")
                    
                    self.btnSchoolCode.setTitle("\(object?.school_code ?? "") (\(object?.branch_code ?? 0))", for: .normal)
                    APP_DELEGATE.currentStaffBranch = "\(object?.school_code ?? "") (\(object?.branch_code ?? 0))"
                    
                    self.callAPIStaffDetails { (check, responseData) in
                        if(check){
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.9) {
                                APP_DELEGATE.manageApplicationRoot()
                            }
                        }
                    }
                }
            }
            
        }))
        
        AlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(AlertController, animated: true, completion: nil)
    }
    
   private func callAPIStaffDetails(finished:@escaping(_ success: Bool, _ response: StaffDetailAPIResponse?) -> Void) {
        Loader.show()
        
        StaffManageMentAPI.getStaffDetails() { (response, error) in
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
            guard let responseData = response.message else {
                //let message = response.message ?? "Invalid Response"
                finished(false, nil)
                return
            }
            finished(true, response)
        }
    }
    
   private func ShowSchoolListActionSheet(completion:@escaping(StaffSchoolsModal?)->()){
        let AlertController = UIAlertController(title: "Select Branch", message: nil, preferredStyle: .actionSheet)
       if let years = objStaffProfileData?.years{
           for data in years{
               if (data.year_session ?? "") == objStaffProfileData?.default_year_session ?? ""{
                   if let schools = data.schools{
                       for obj in schools{
                         //  print(obj.is_access)
                          // print(obj.school_code)
                           if (obj.is_access ?? false){
                               let alert = UIAlertAction(title: "\(obj.school_code ?? "") (\(obj.branch_code ?? 0))", style: .default) { action in
                                   completion(obj)
                               }
                               AlertController.addAction(alert)
                           }
                           
                       }
                   }
               }
           }
       }
       
       
       /* if let arrObject = APP_DELEGATE.userInfo?.schools{
            for object in arrObject{
                let alert = UIAlertAction(title: object.schoolCode, style: .default) { action in
                    completion(object)
                }
                AlertController.addAction(alert)
            }
        }*/
        AlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(AlertController, animated: true, completion: nil)
    }
}

extension SettingsViewController: NavigationBarViewDelegate {
    func onTapDropDown() {
        
    }
    func onTapMenu() {
        
    }
    
    func onTapBack() {
        
        if (self.navigationController?.viewControllers.count ?? 0) == 1 {
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
extension SettingsViewController{
    func callSettingListAPI(finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
        StaffManageMentAPI.getSettingsList() { (respose, error) in
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
            
            self.arrSettingData = responseData
            finished(true)
        }
    }
    
    func UpdateSettingAPI(finished:@escaping(_ success: Bool) -> Void) {
                
        Loader.show()
        StaffManageMentAPI.updateSettingsAPI(body: requestParam, completion:  { (respose, error) in
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
            self.toast(response.message ?? "Invalid Response")
            finished(true)
        })
    }
}
