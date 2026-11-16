//
//  EditIdCardAddressPopUp.swift
//  MountCarmel
//
//  Created by Mandeep Singh on 25/02/24.
//  Copyright © 2024 InventionHill. All rights reserved.
//

import UIKit
import DTTextField
import DropDown

class EditIdCardAddressPopUp: UIViewController {

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
            fld_Country.isUserInteractionEnabled = false
            fld_Country.alpha = 0.5
        }
    }
   @IBOutlet weak var fld_Pincode: DTTextField!{
                    didSet{
                        fld_Pincode.delegate = self
                    }
                }
    
    private  var cityStateDropDown = DropDown()
     private var arrCity = [CityDataNew]()
     private var arrState = [StateDataNew]()
    
     internal var LocalAddress = String()
     internal var City = String()
     internal var State = String()
     internal var Country = String()
     internal var Pincode = String()
    
    internal var stateId = String()
    internal var countryId = String()
    var submitHandler : (() -> ())?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        fld_LocalAddress.text = LocalAddress
        fld_City.text = City
        fld_State.text = State
        fld_Country.text = Country
        fld_Pincode.text = Pincode

        self.ApiGetCity()
        self.ApiGetState()
    }
    
    @IBAction func btnUpdate(_ sender: Any) {
        self.ApiSendIDAddressInfo()
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

extension EditIdCardAddressPopUp{
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

    private func ApiSendIDAddressInfo(){
        
        guard fld_LocalAddress.text! != "" else {
            return toast("Please enter local address")
        }
        guard fld_City.text! != "" else {
            return toast("Please select city")
        }
        guard stateId != "" else {
            return toast("Please select state")
        }
       /* guard countryId != "" else {
            return toast("Please select country")
        }*/
        guard fld_Pincode.text! != "" else {
            return toast("Please enter pincode")
        }
        guard fld_Pincode.text!.count == 6 else {
            return toast("Please enter valid pincode")
        }
        
        self.view.endEditing(true)
        
        let URLString = API_GETIDCARDINFO()
        let api : APITest = APITest<PostGeneralInfoModel>()
                        
        let param:[String:Any] = ["local_address":fld_LocalAddress.text!,
                                  "pincode":fld_Pincode.text!,
                                  "country_id":countryId,
                                  "state_id":stateId,
                                  "city":fld_City.text!]
        print(param)
        
        api.requestforPUT(url: URLString, parameter: param) { response, error in
            if let msg = response?.body?.message, msg == "Address updated successfully"{
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


extension EditIdCardAddressPopUp:UITextFieldDelegate{
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
     return true
 }
}
