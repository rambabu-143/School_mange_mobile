//
//  EditProfileGeneralViewController.swift
//  MountCarmel
//
//  Created by Mandeep Singh on 06/04/23.
//  Copyright © 2023 InventionHill. All rights reserved.
//

import UIKit
import DTTextField
import DropDown

class EditProfileGeneralViewController: UIViewController {

    @IBOutlet weak var viewGeneralInfo: ViewCustom!{
        didSet{
            viewGeneralInfo.isHidden = true
        }
    }
    
    @IBOutlet weak var fld_AdharCard: DTTextField!{
        didSet{
            fld_AdharCard.delegate = self
        }
    }
    @IBOutlet weak var fld_MotherTounge: DTTextField!{
        didSet{
            fld_MotherTounge.delegate = self
        }
    }
    
    @IBOutlet weak var viewResidentialAddress: ViewCustom!{
            didSet{
                viewResidentialAddress.isHidden = true
            }
        }
    
    @IBOutlet weak var fld_LocalAddress: DTTextField!{
        didSet{
            fld_LocalAddress.delegate = self
        }
    }
        @IBOutlet weak var fld_City: DTTextField!{
            didSet{
                fld_City.delegate = self
            }
        }
            @IBOutlet weak var fld_State: DTTextField!{
                didSet{
                    fld_State.delegate = self
                }
            }
    @IBOutlet weak var fld_Country: DTTextField!{
        didSet{
            fld_Country.delegate = self
        }
    }
                @IBOutlet weak var fld_Pincode: DTTextField!{
                    didSet{
                        fld_Pincode.delegate = self
                    }
                }
    
    enum viewState{
        case viewGeneral
        case viewResidential
    }
    
   private  var cityStateDropDown = DropDown()
    
    private var arrMotherTounge = [MotherTongueData]()
   // private var MotherToungueSelected : Int?
    
    private var arrCity = [CityDataNew]()
    //private var CitySelected : Int?

    private var arrState = [StateDataNew]()
    //private var StateSelected : Int?

    private var arrCountry = [CountryDataNew]()
    //private var CountrySelected : Int?
    
    internal var currentView:viewState = .viewGeneral
    
    internal var AdharCard = String()
    internal var MotherTounge = String()
    internal var LocalAddress = String()
    internal var City = String()
    internal var State = String()
    internal var Country = String()
    internal var Pincode = String()
    
    internal var MotherTongueId = String()
    internal var stateId = String()
    internal var countryId = String()
    internal var objGeneralProfileData : StudentDetailData?
    var submitHandler : (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityStateDropDown.textFont = UIFont.setRegularFont(ofSize: 13)
        cityStateDropDown.width = self.view.frame.size.width/1.4
        //cityStateDropDown.topOffset = CGPoint(x: 0, y: 1000)
        //cityStateDropDown.bottomOffset = CGPoint(x: 0, y: 200)
        
        if currentView == .viewGeneral{
            viewGeneralInfo.isHidden = false
        }else{
            viewResidentialAddress.isHidden = false
        }
        
        fld_AdharCard.text = AdharCard
        fld_MotherTounge.text = MotherTounge
        fld_LocalAddress.text = LocalAddress
        fld_City.text = City
        fld_State.text = State
        fld_Country.text = Country
        fld_Pincode.text = Pincode
        
        
        self.ApiGetmotherTounge()
        self.ApiGetCity()
        self.ApiGetState()
        self.ApiGetCountry()
        
    }
    
    @IBAction func btnUpdate(_ sender: Any) {
        currentView == .viewGeneral ? ApiSendGeneralInfo() : ApiSendResidentialInfo()
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

extension EditProfileGeneralViewController{
    private func ApiGetCity(){
        let URLString = API_CITY
        let api : APITest = APITest<CityModelNew>()
        Loader.show()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            Loader.hide()
            if error == nil , let model = response?.body, let arr = model.data {
                self.arrCity.append(contentsOf: arr)
              //  completion(response?.body, error)
            } else {
               // completion(nil, error)
            }
        }
    }
    
    private func ApiGetState(){
        let URLString = API_STATE
        let api : APITest = APITest<StateModelNew>()
        Loader.show()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            Loader.hide()
            if error == nil, let model = response?.body, let arr = model.data {
                self.arrState.append(contentsOf: arr)
                
               // completion(response?.body, error)
            } else {
              //  completion(nil, error)
            }
        }
    }
    private func ApiGetCountry(){
        let URLString = API_COUNTRY
        let api : APITest = APITest<CountryModelNew>()
        Loader.show()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            Loader.hide()
            if error == nil , let model = response?.body, let arr = model.data {
                self.arrCountry.append(contentsOf: arr)
              //  completion(response?.body, error)
            } else {
               // completion(nil, error)
            }
        }
    }
    
    private func ApiGetmotherTounge(){
        let URLString = API_MOTHERTOUNGE
        let api : APITest = APITest<MotherTongueModel>()
        Loader.show()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            Loader.hide()
            if error == nil, let model = response?.body, let arr = model.data {
                self.arrMotherTounge.append(contentsOf: arr)
            } else {
              //  completion(nil, error)
            }
        }
    }
    
    private func ApiSendGeneralInfo(){
        guard fld_AdharCard.text! != "" else {
            return toast("Please add Aadhar card no")
        }
        guard fld_AdharCard.text!.count == 12 else {
            return toast("Please enter valid Aadhar card no")
        }
        guard MotherTongueId != "" else {
            return toast("Please select Mother Tongue")
        }
        let URLString = API_STUDENTDETAIL(stID: APP_DELEGATE.selected_Student?.studentId?.ID ?? "")
        let api : APITest = APITest<PostGeneralInfoModel>()
        let param = ["aadhar_card":fld_AdharCard.text!,"mother_tongue_id":MotherTongueId]
        
        Loader.show()
        api.requestforPUT(url: URLString, parameter: param) { response, error in
            Loader.hide()
            if let msg = response?.body?.message, msg == "Data updated successfully"{
                if(self.submitHandler != nil){
                    self.submitHandler!()
                    self.dismiss(animated: false, completion: nil)
                }
                self.toast(msg)
            }else{
                self.toast(error?.localizedDescription ?? "")
            }
        }
    }
    
    private func ApiSendResidentialInfo(){
        
        guard fld_LocalAddress.text! != "" else {
            return toast("Please enter local address")
        }
        guard fld_City.text! != "" else {
            return toast("Please select city")
        }
        guard stateId != "" else {
            return toast("Please select state")
        }
        guard countryId != "" else {
            return toast("Please select country")
        }
        guard fld_Pincode.text! != "" else {
            return toast("Please enter pincode")
        }
        guard fld_Pincode.text!.count == 6 else {
            return toast("Please enter valid pincode")
        }
        
        let URLString = API_STUDENTDETAIL(stID: APP_DELEGATE.selected_Student?.studentId?.ID ?? "")
        let api : APITest = APITest<PostGeneralInfoModel>()
      //  let param = ["address" : ["local_address":fld_LocalAddress.text!,"city":fld_City.text!,"state_id":stateId,"pincode":fld_Pincode.text!,"country_id":countryId]]
        
        var arr = [[String:Any]]()
        
            for obj in objGeneralProfileData?.address ?? []{
                let dict = ["local_address":obj.local_address ?? "","city":obj.city ?? "","state_id":obj.state_id?.ID ?? "","pincode":obj.pincode ?? "","country_id":obj.country_id?.ID ?? ""]
                arr.append(dict)
            }
        
        let lastDict:[String:Any] = ["local_address":fld_LocalAddress.text!,"city":fld_City.text!,"state_id":stateId,"pincode":fld_Pincode.text!,"country_id":countryId,"is_parent":true,"parent":objGeneralProfileData?.name ?? ""]
        arr.append(lastDict)
        
        let param = ["address" : arr]
        print(param)
        
        api.requestforPUT(url: URLString, parameter: param) { response, error in
            if let msg = response?.body?.message, msg == "Data updated successfully"{
                if(self.submitHandler != nil){
                    self.submitHandler!()
                    self.dismiss(animated: false, completion: nil)
                }
                self.toast(msg)
            }else{
                self.toast(error?.localizedDescription ?? "")
            }
        }
    }
    
}

extension EditProfileGeneralViewController:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        cityStateDropDown.anchorView = textField
        if textField == fld_City {
            
            cityStateDropDown.dataSource = arrCity.map({ obj in obj.name })
            cityStateDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
               // self.selectedID = self.arrClassList[index].id ?? ""
                
                textField.text = item
                self.cityStateDropDown.hide()
            }
            cityStateDropDown.show()
            
            return false
        }
        if textField == fld_State{
            
            cityStateDropDown.dataSource = arrState.map({ obj in obj.state_name })
            cityStateDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
               // self.selectedID = self.arrClassList[index].id ?? ""
                self.stateId = self.arrState[index]._id
                textField.text = item
                self.cityStateDropDown.hide()
            }
            cityStateDropDown.show()
            
            return false
        }
        if textField == fld_Country{
            
            cityStateDropDown.dataSource = arrCountry.map({ obj in obj.country_name })
            cityStateDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
               // self.selectedID = self.arrClassList[index].id ?? ""
                self.countryId = self.arrCountry[index]._id
                textField.text = item
                self.cityStateDropDown.hide()
            }
            cityStateDropDown.show()
            
            return false
        }
        if textField == fld_MotherTounge{
            cityStateDropDown.dataSource = arrMotherTounge.map({ obj in obj.name })
            cityStateDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                self.MotherTongueId = self.arrMotherTounge[index]._id
                textField.text = item
                self.cityStateDropDown.hide()
            }
            cityStateDropDown.show()
            
            return false
        }
        
        return true
    }
}

struct PostGeneralInfoModel:Codable{
    let message : String?
    let status : Bool?
}

struct MotherTongueModel:Codable{
    let message : String
    let data : [MotherTongueData]?
}
struct MotherTongueData:Codable{
    let _id : String
    let code : String
    let name : String
}

struct CityModelNew:Codable{
    let message : String
    let data : [CityDataNew]?
}
struct CityDataNew:Codable{
    let _id : String
    let city_code : String
    let name : String
}
struct StateModelNew:Codable{
    let message : String
    let data : [StateDataNew]?
}
struct StateDataNew:Codable{
    let _id : String
    let state_code : String
    let state_name : String
}
struct CountryModelNew:Codable{
    let message : String
    let data : [CountryDataNew]?
}
struct CountryDataNew:Codable{
    let _id : String
    let country_code : String
    let country_name : String
}
