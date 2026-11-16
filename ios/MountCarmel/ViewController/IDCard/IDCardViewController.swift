//
//  IDCardViewController.swift
//  MountCarmel
//
//  Created by Mandeep Singh on 25/02/24.
//  Copyright © 2024 InventionHill. All rights reserved.
//

import UIKit
import SDWebImage

class IDCardViewController: UIViewController {
    @IBOutlet weak var navigationView: NavigationBarView!
    
    @IBOutlet weak var imgStudent: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAdmission: UILabel!
    @IBOutlet weak var lblClass: UILabel!
    @IBOutlet weak var lblDOB: UILabel!
    @IBOutlet weak var lblBloodGroup: UILabel!
    @IBOutlet weak var lblAllergies: UILabel!
    @IBOutlet weak var lblPhNo: UILabel!
    
    @IBOutlet weak var lblMorningRoute: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblEveningRoute: UILabel!
    @IBOutlet weak var lblGrdian: UILabel!
    
    @IBOutlet weak var viewBottomButtons: UIView!{
        didSet{
            viewBottomButtons.isHidden = true
        }
    }
    
    @IBOutlet weak var viewChangeMessage: UIView!{
        didSet{
            viewChangeMessage.isHidden = true
        }
    }
    
    @IBOutlet weak var lblChangeMessage: UILabel!
    
    private var objIdCard : IdCardModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.lblTitle.text = "ID CARD"
        navigationView.delegate = self
        
        self.API_IdCardInfo()
        
    }

    private func SetData(){
        let pppath = "https://mountcarmelschool.com/uploads/profile-pic/student/"
        let obj = objIdCard?.data
        
        if let currentSession = obj?.session {
            navigationView.lblTitle.text = "ID CARD (\(currentSession))"
        }
        
        imgStudent.sd_setImage(with: URL(string: pppath+(obj?.profile_pic ?? "")), placeholderImage: #imageLiteral(resourceName: "default_p"), options: [], context: nil)
        lblName.text = "Name: "+(objIdCard?.data?.name ?? "")
        lblAdmission.text = "Admission No. : " + (obj?.admission_no ?? "")
        lblClass.text = "Class/Section: " + (obj?.class_section ?? "")
        lblDOB.text = "DOB: " + CommonFunctions.getDateString(date: (obj?.date_of_birth ?? ""), fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_ddMMYYYY)
        lblBloodGroup.text = "Blood Group: " + (obj?.bloodgroup ?? "")
        lblAllergies.text = "Allergies (if any): " + (obj?.allergies ?? "")
        lblPhNo.text = "Mobile No: " + (obj?.sms_mobile ?? "")
        
        if let mr = obj?.morning_route , mr != "" ,let er = obj?.evening_route , er != ""{
            lblMorningRoute.text = "Transport: M:\(mr) E:\(er)"
        }else{
            lblMorningRoute.text = "Transport: \((obj?.transport_type ?? "").uppercased())"
        }
        
       
        lblGrdian.text = "Name: "+(obj?.fathers_name ?? "")
        
        let strAddress1 = obj?.address?.local_address ?? ""
        let strcity = obj?.address?.city ?? ""
        //let strState = obj?.address?.state_id?.state_name ?? ""
        //let strCountry = (obj?.address?.country_id?.country_name ?? "").uppercased()
        let strPinCode = obj?.address?.pincode ?? ""

        lblAddress.text = "Address: " + strAddress1 + ", " + strcity + ", " /*+ strState + " - "*/ + strPinCode
                
        if (objIdCard?.is_form_submitted ?? false) == true{
            viewBottomButtons.isHidden = true
        }else{
            viewBottomButtons.isHidden = false
        }
        
        self.lblChangeMessage.text = objIdCard?.change_message ?? ""
        
        if (objIdCard?.is_change_request ?? false) == true{
            viewChangeMessage.isHidden = false
        }else{
            viewChangeMessage.isHidden = true
        }
        
    }
    
    @IBAction func btnEditAddress(_ sender: Any) {
      /*  let obj = objIdCard?.data
        let strAddress1 = obj?.address?.local_address ?? ""
        let strcity = obj?.address?.city ?? ""
        let strState = obj?.address?.state_id?.state_name ?? ""
        let strCountry = (obj?.address?.country_id?.country_name ?? "").uppercased()
        let strPinCode = obj?.address?.pincode ?? ""
        let stateID = obj?.address?.state_id?._id ?? ""
        let countryID = obj?.address?.country_id?._id ?? ""
         
        let storyBoard = UIStoryboard(name: "IDCardViewController", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "EditIdCardAddressPopUp") as! EditIdCardAddressPopUp
        
            viewController.LocalAddress = strAddress1
            viewController.City = strcity
            viewController.State = strState
            viewController.Country = strCountry
            viewController.Pincode = strPinCode
            viewController.stateId = stateID
            viewController.countryId = countryID
            viewController.submitHandler = {
                self.API_IdCardInfo()
            }
        viewController.modalPresentationStyle = .overCurrentContext
        self.present(viewController, animated: true)*/
        
    }
    
    @IBAction func btnConfirm(_ sender: Any) {
        self.ApiSendSelection()
    }
    
    @IBAction func btnChange(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "IDCardViewController", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "IDCardChangeSelectionViewController") as! IDCardChangeSelectionViewController
        viewController.modalPresentationStyle = .overCurrentContext
        
        viewController.submitHandler = {  msg in
            self.toast(msg)
            DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                self.onTapBack()
            }
        }
        
        self.present(viewController, animated: true)
    }
    
}

extension IDCardViewController{
    
    private func API_IdCardInfo(){
            let URLString = API_GETIDCARDINFO()
            let api : APITest = APITest<IdCardModel>()
            api.requestforGET(url: URLString, parameter: nil) { (response, error) in
                if error == nil {
                    self.objIdCard = response?.body
                    self.SetData()
                   // completion(response?.body, error)
                } else {
                    print(error)
                    self.toast(error?.localizedDescription ?? "")
                   // completion(nil, error)
                }
            }
    }
    
    private func ApiSendSelection(){
        let URLString = API_GETIDCARDINFO()
        let api : APITest = APITest<PostGeneralInfoModel>()
                        
        let param:[String:Any] =
           ["profile_pic": false,
             "name": false,
             //"class_section":false,
             "date_of_birth": false,
             "bloodgroup": false,
             "allergies": false,
             "fathers_name": false,
             "address": false,
             "sms_mobile": false,
             "transport": false
          ]
        print(param)
        
        api.requestforPUT(url: URLString, parameter: param) { response, error in
            if let stts = response?.body?.status, stts == true{
                self.toast(response?.body?.message ?? "")
                DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                    self.onTapBack()
                }
            }else{
                self.toast(error?.localizedDescription ?? "")
            }
        }
    }
    
}

struct IdCardModel:Codable{
    let data:IdCardData?
    let is_change_request:Bool?
    let is_form_submitted:Bool?
    let change_message:String?
}
struct IdCardData:Codable{
    let address:IdCardAddress?
    
    let admission_no:String?
    let allergies:String?
    let class_section:String?
    let date_of_birth:String?
    let evening_route:String?
    let fathers_name:String?
    let morning_route:String?
    let name:String?
    let profile_pic:String?
    let session:String?
    let sms_mobile:String?
    let transport_type:String?
    let bloodgroup:String?
}
struct IdCardAddress:Codable{
    let city:String?
    let country_id:country_id?
    let local_address:String?
    let pincode:String?
    let state_id:state_id?
}
struct country_id:Codable{
    let _id:String?
    let country_name:String?
}
struct state_id:Codable{
    let _id:String?
    let state_name:String?
}

extension IDCardViewController: NavigationBarViewDelegate {
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
