//
//  ProfileGeneralViewController.swift
//  MountCarmel
//
//  Created by Sandip on 06/04/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class ProfileGeneralViewController: UIViewController {

    @IBOutlet var txtAddress: GrowingTextView!
    @IBOutlet weak var navigationView: NavigationBarView!

    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblSOS: UILabel!
    @IBOutlet var lblMobile: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblMarriageAnniversary: UILabel!
    @IBOutlet var lblSpouseName: UILabel!
    @IBOutlet var lblDateOfJoining: UILabel!
    @IBOutlet var lblDateOfBirth: UILabel!
    
    
    // For School Section variables
    @IBOutlet var lblSchoolTitle: UILabel!
    
    @IBOutlet var lblScholasticVal: UILabel!
    @IBOutlet var lblScholasticTitle: UILabel!
    @IBOutlet var lblSubjectVal: UILabel!
    @IBOutlet var lblSubjectTitle: UILabel!
    @IBOutlet var lblHouseVal: UILabel!
    @IBOutlet var lblHouseTitle: UILabel!
    @IBOutlet var lblAdmissionDateVal: UILabel!
    @IBOutlet var lblAdmissionDateTitle: UILabel!
    @IBOutlet var lblAdmissionVal: UILabel!
    @IBOutlet var lblAdmissionTitle: UILabel!
    
    // For General Information Variables
    
    @IBOutlet var lblGeneralInformationTitle: UILabel!
   
    @IBOutlet var lblMobileNoVal: UILabel!
    @IBOutlet var lblMobileNoTitle: UILabel!
    @IBOutlet var lblEmailVal: UILabel!
    @IBOutlet var lblEmailTitle: UILabel!
    @IBOutlet var lblAadharVal: UILabel!
    @IBOutlet var lblAadharTitle: UILabel!
    @IBOutlet var lblNationalityVal: UILabel!
    @IBOutlet var lblNationalityTitle: UILabel!
    @IBOutlet var lblBirthDateVal: UILabel!
    @IBOutlet var lblBirthDateTitle: UILabel!
    @IBOutlet var lblGenderVal: UILabel!
    @IBOutlet var lblGenderTitle: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblNameTitle: UILabel!
    
    // For Residential Address Variable
    @IBOutlet var lblResidentialAddressTitle: UILabel!
    
    @IBOutlet var lblPincodeVal: UILabel!
    @IBOutlet var lblPincodeTitle: UILabel!
    @IBOutlet var lblCountryVal: UILabel!
    @IBOutlet var lblCountryTitle: UILabel!
    @IBOutlet var lblStateVal: UILabel!
    @IBOutlet var lblStateTitle: UILabel!
    @IBOutlet var lblCityVal: UILabel!
    @IBOutlet var lblCityTitle: UILabel!
    @IBOutlet var lblAddressVal: UILabel!
    @IBOutlet var lblAddressTitle: UILabel!
    @IBOutlet var lblMotherTongueTitle: UILabel!
    @IBOutlet var lblMotherTongueVal: UILabel!
    
    @IBOutlet var btnsEditStudentInfo: [UIButton]!
    
    
    var objGeneralProfileData : StudentDetailData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.lblTitle.text = "General"
        navigationView.delegate = self
        self.setAppFontAndData()
        
        for btn in btnsEditStudentInfo{
            btn.isHidden = !(APP_DELEGATE.userType == LoginType.Parent)
        }
        
       // setInitialData()
       // txtAddress.isUserInteractionEnabled = false
        // Do any additional setup after loading the view.
    }
    

    func setInitialData(){
       // self.lblName.text = (APP_DELEGATE.userInfo?.staffId?.firstName ?? "") + " " + (APP_DELEGATE.userInfo?.staffId?.lastName ?? "")
        
        self.lblDateOfBirth.text = CommonFunctions.getDateString(date: (APP_DELEGATE.userInfo?.staffId?.dateOfBirth ?? ""), fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_DDMMYYYY)
        
        self.lblDateOfJoining.text = CommonFunctions.getDateString(date: (APP_DELEGATE.userInfo?.staffId?.dateOfJoining ?? ""), fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_DDMMYYYY)
        
        self.lblSpouseName.text = (APP_DELEGATE.userInfo?.staffId?.spousename ?? "")
        
        self.lblMobile.text = (APP_DELEGATE.userInfo?.staffId?.mobile ?? "")
        
        self.lblMarriageAnniversary.text = CommonFunctions.getDateString(date: (APP_DELEGATE.userInfo?.staffId?.dateofanniversary ?? ""), fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_DDMMYYYY)
        
        let strAddress1 = APP_DELEGATE.userInfo?.staffId?.address?.localAddress ?? ""
        
        let strAddress2 = APP_DELEGATE.userInfo?.staffId?.address?.city ?? ""
        
         let strPinCode = APP_DELEGATE.userInfo?.staffId?.address?.pincode ?? ""
        
       // let strState = APP_DELEGATE.userInfo?.staffId?.address?.stateId?.stateName ?? ""
        
        self.txtAddress.text = strAddress1 + "," + strAddress2 + "-" + strPinCode
        
    }
    
    func setAppFontAndData(){
        // ------ School Information ---- //
         self.lblSchoolTitle.font = UIFont.setBoldFont(ofSize: 14.0)
        
        self.lblScholasticTitle.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblScholasticVal.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblAdmissionVal.font = UIFont.setBoldFont(ofSize: 13.0)
        self.lblAdmissionTitle.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblAdmissionDateTitle.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblAdmissionDateVal.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblHouseTitle.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblHouseVal.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblHouseTitle.font = UIFont.setRegularFont(ofSize: 13.0)
        
        self.lblSubjectVal.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblSubjectTitle.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblMotherTongueTitle.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblMotherTongueVal.font = UIFont.setRegularFont(ofSize: 13.0)
        
        self.lblMotherTongueVal.text = objGeneralProfileData?.mother_tongue_id?.name ?? ""
        
         self.lblAdmissionVal.text = objGeneralProfileData?.admission_no ?? ""
         self.lblAdmissionDateVal.text = CommonFunctions.getDateString(date: (objGeneralProfileData?.date_of_admission ?? ""), fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_ddMMYYYY)
        self.lblHouseVal.text = objGeneralProfileData?.house_id?.house_no ?? ""
        
        let sco = objGeneralProfileData?.achievement?.scholastic?.name ?? ""
        if sco != ""{
            self.lblScholasticVal.text = sco
            self.lblScholasticVal.textAlignment = .left
        }else{
            self.lblScholasticVal.text = "-"
            self.lblScholasticVal.textAlignment = .center
        }
         
        
        var strSubject = ""
        for data in objGeneralProfileData?.combo_id?.subjects ?? [ComboSubjects](){
            if(strSubject == ""){
                strSubject = data.subject_name ?? ""
            }else{
                strSubject = strSubject + "," + (data.subject_name ?? "")
            }
        }
        
        self.lblSubjectVal.text = strSubject
        
        // ---- General Information ---- //
        self.lblGeneralInformationTitle.font = UIFont.setBoldFont(ofSize: 14.0)
        self.lblNameTitle.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblName.font = UIFont.setBoldFont(ofSize: 13.0)
        self.lblGenderTitle.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblGenderVal.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblBirthDateTitle.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblBirthDateVal.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblAadharTitle.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblAadharVal.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblEmailTitle.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblEmailVal.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblMobileNoTitle.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblMobileNoVal.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblNationalityTitle.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblNationalityVal.font = UIFont.setRegularFont(ofSize: 13.0)
        
        self.lblName.text = objGeneralProfileData?.name ?? ""
        self.lblMobileNoVal.text = objGeneralProfileData?.sms_mobile ?? ""
        print(objGeneralProfileData?.aadhar_card)
        self.lblAadharVal.text = objGeneralProfileData?.aadhar_card ?? ""
         self.lblEmailVal.text = objGeneralProfileData?.email ?? ""
         self.lblNationalityVal.text = objGeneralProfileData?.nationality ?? ""
        self.lblBirthDateVal.text = CommonFunctions.getDateString(date: (objGeneralProfileData?.date_of_birth ?? ""), fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_ddMMYYYY) 
        self.lblGenderVal.text = objGeneralProfileData?.gender ?? ""
        
        //------- Residential Address -------//
        
        self.lblResidentialAddressTitle.font = UIFont.setBoldFont(ofSize: 14.0)
        self.lblAddressVal.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblAddressTitle.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblCityTitle.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblCityVal.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblStateTitle.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblStateVal.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblPincodeTitle.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblPincodeVal.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblCountryVal.font = UIFont.setRegularFont(ofSize: 13.0)
        self.lblCountryTitle.font = UIFont.setRegularFont(ofSize: 13.0)
        
        if let addressData = objGeneralProfileData?.address?.last {
            self.lblAddressVal.text = addressData.local_address ?? ""
            self.lblCityVal.text = addressData.city ?? ""
            self.lblPincodeVal.text = addressData.pincode ?? ""
            self.lblStateVal.text = addressData.state_id?.stateName ?? ""
            self.lblCountryVal.text = addressData.country_id?.countryName ?? ""
        }
        
        
    }
    
    @IBAction func actionEditAddressClick(_ sender: Any) {
        txtAddress.isUserInteractionEnabled = true
        txtAddress.becomeFirstResponder()

    }
    
    @IBAction func actionUpdateClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnEditSudentDate(_ sender: UIButton) {
        let vc = UIStoryboard(name: "ProfileGeneralViewController", bundle: nil).instantiateViewController(withIdentifier: "EditProfileGeneralViewController") as! EditProfileGeneralViewController
        vc.currentView = sender.tag == 0 ? .viewGeneral : .viewResidential
        vc.modalPresentationStyle = .overFullScreen
        
        vc.AdharCard = lblAadharVal.text!
        vc.MotherTounge = lblMotherTongueVal.text!
        vc.MotherTongueId = objGeneralProfileData?.mother_tongue_id?.id ?? ""
        
        vc.LocalAddress = lblAddressVal.text!
        vc.City = lblCityVal.text!
        vc.State = lblStateVal.text!
        vc.Country = lblCountryVal.text!
        vc.Pincode = lblPincodeVal.text!
        vc.stateId = objGeneralProfileData?.address?.last?.state_id?.ID ?? ""
        vc.countryId = objGeneralProfileData?.address?.last?.country_id?.ID ?? ""
        vc.objGeneralProfileData = objGeneralProfileData
        vc.submitHandler = {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                self.navigationController?.popViewController(animated: true)

            }
        }
        self.present(vc, animated: true)
    }
    
    
}
extension ProfileGeneralViewController: NavigationBarViewDelegate {
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
