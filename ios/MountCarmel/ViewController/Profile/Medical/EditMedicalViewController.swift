//
//  EditMedicalViewController.swift
//  MountCarmel
//
//  Created by Mandeep Singh on 06/04/23.
//  Copyright © 2023 InventionHill. All rights reserved.
//

import UIKit
import DTTextField
import DropDown
class EditMedicalViewController: UIViewController {

    @IBOutlet weak var fld_Blood: DTTextField!{
        didSet{
            fld_Blood.delegate = self
        }
    }
    @IBOutlet weak var fld_Allergies: DTTextField!
    
    private let arrBloodGroup = ["A+","A-","AB+","AB-","B+","B-","O+","O-"]
    private  var cityStateDropDown = DropDown()
    
    internal var Blood = String()
    internal var Allergies = String()
    
    var submitHandler : (() -> ())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cityStateDropDown.textFont = UIFont.setRegularFont(ofSize: 13)
        cityStateDropDown.width = 100
        
        fld_Blood.text = Blood
        fld_Allergies.text = Allergies
    }
    
    @IBAction func btnUpdate(_ sender: Any) {
        self.ApiSendMedical()
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    private func ApiSendMedical(){
        guard fld_Blood.text! != "" else {
            return toast("Please add Blood group")
        }
        guard fld_Allergies.text! != "" else {
            return toast("Please add Allergies")
        }
        let URLString = API_STUDENTDETAIL(stID: APP_DELEGATE.selected_Student?.studentId?.ID ?? "")
        let api : APITest = APITest<PostGeneralInfoModel>()
        let param = ["medical" : ["bloodgroup":fld_Blood.text!,"allergies":fld_Allergies.text!]]
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
    
}


extension EditMedicalViewController:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        cityStateDropDown.anchorView = textField
        if textField == fld_Blood {
            cityStateDropDown.dataSource = arrBloodGroup
            cityStateDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                textField.text = item
                self.cityStateDropDown.hide()
            }
            cityStateDropDown.show()
            
            return false
        }
        
        return true
    }
}
