//
//  EditParentViewController.swift
//  MountCarmel
//
//  Created by Mandeep Singh on 06/04/23.
//  Copyright © 2023 InventionHill. All rights reserved.
//

import UIKit
import DTTextField
import DropDown
class EditParentViewController: UIViewController {

@IBOutlet weak var lblHeading: UILabel!
    
    @IBOutlet weak var fld_Name: DTTextField!
    @IBOutlet weak var fld_Qualification: DTTextField!{
        didSet{
            fld_Qualification.delegate = self
        }
    }
    
    @IBOutlet weak var fld_Occupation: DTTextField!{
        didSet{
            fld_Occupation.delegate = self
        }
    }
    
    @IBOutlet weak var fld_SubCategory: DTTextField!{
        didSet{
            fld_SubCategory.delegate = self
        }
    }
    @IBOutlet weak var fld_SubCategory2: DTTextField!
    @IBOutlet weak var fld_OrganisationName: DTTextField!
    
    @IBOutlet weak var fld_Designation: DTTextField!
    
    @IBOutlet weak var fld_OfficeAddress: DTTextField!
    
    @IBOutlet weak var fld_OfficePhoneNo: DTTextField!
    
    @IBOutlet weak var fld_PANNo: DTTextField!
    
    @IBOutlet weak var fld_Email: DTTextField!
    
    @IBOutlet weak var fld_MobileNo: DTTextField!
    
    
    @IBOutlet weak var view_Name: UIView!
    @IBOutlet weak var view_Qualification : UIView!
    @IBOutlet weak var view_Occupation : UIView!
    @IBOutlet weak var view_SubCategory : UIView!
    @IBOutlet weak var view_SubCategory2 : UIView!
    @IBOutlet weak var view_OrganisationName : UIView!
    @IBOutlet weak var view_Designation : UIView!
    @IBOutlet weak var view_OfficeAddress : UIView!
    @IBOutlet weak var view_OfficePhoneNo : UIView!
    @IBOutlet weak var view_PANNo : UIView!
    @IBOutlet weak var view_Email : UIView!
    @IBOutlet weak var view_MobileNo : UIView!
    
    
//    internal var Name = String()
//    internal var Qualification = String()
//    internal var Occupation = String()
//    internal var SubCategory = String()
//    internal var OrganisationName = String()
//    internal var Designation = String()
//    internal var OfficeAddress = String()
//    internal var OfficePhoneNo = String()
//    internal var PANNo = String()
//    internal var Email = String()
//    internal var MobileNo = String()
    internal var QualificationId = String()
    internal var OccupationId = String()
    internal var SubcategotyId = String()

 enum viewState:String{
   case viewFather = "Father"
   case viewMother = "Mother"
 }
        
internal var currentView:viewState = .viewFather
    
    private  var cityStateDropDown = DropDown()
    private var arrQualification = [QualificationData]()
    
    private var arrOccupation = [OccupationData]()
    
    private var arrSubCategory = [SubOccupationData]()
    private var arrSortedSubCategory = [SubOccupationData]()
    
    internal var arrObjRelation : [Relation]?
    internal var selectedRelationIndex = Int()
    
    var submitHandler : (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let obj = arrObjRelation?[selectedRelationIndex]
        
        currentView = (obj?.relation ?? "").lowercased() == "father" ? .viewFather : .viewMother
        self.lblHeading.text = currentView.rawValue
        
        cityStateDropDown.textFont = UIFont.setRegularFont(ofSize: 13)
        cityStateDropDown.width = self.view.frame.size.width-50
        
        fld_Name.text = obj?.name ?? ""
        fld_Qualification.text = obj?.qualification_id?.qualification ?? ""
        fld_Occupation.text = obj?.occupation_id?.occupation_name ?? ""
        fld_SubCategory.text = obj?.occupation_child_id?.occupation_child_name ?? ""
        fld_SubCategory2.text = obj?.other_occupation ?? ""
        fld_OrganisationName.text = obj?.organization ?? ""
        fld_Designation.text = obj?.designation ?? ""
        fld_OfficeAddress.text = obj?.office_address ?? ""
        fld_OfficePhoneNo.text = obj?.office_phone ?? ""
        fld_PANNo.text = obj?.pancard ?? ""
        fld_Email.text = obj?.email ?? ""
        fld_MobileNo.text = obj?.mobile ?? ""
        
        
        QualificationId = obj?.qualification_id?._id ?? ""
        OccupationId = obj?.occupation_id?._id ?? ""
        SubcategotyId = obj?.occupation_child_id?._id ?? ""

        self.ApiGetQualification()
        self.ApiGetOccupation()
        self.ApiGetSubCategory()
        
        self.HideShowStackViews()
        
    }

    @IBAction func btnUpdate(_ sender: Any) {
        self.ApiSendParentInfo2()
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    private func HideShowStackViews(){
        view_SubCategory.isHidden = true
        view_SubCategory2.isHidden = true
        view_OrganisationName.isHidden = true
        view_Designation.isHidden = true
        view_OfficeAddress.isHidden = true
        view_OfficePhoneNo.isHidden = true

        switch fld_Occupation.text!.lowercased(){
         case "home maker":
          break
        case "other","others":
            view_SubCategory2.isHidden = false
            view_OrganisationName.isHidden = false
            view_Designation.isHidden = false
            view_OfficeAddress.isHidden = false
            view_OfficePhoneNo.isHidden = false
         break
            
        default:
            view_SubCategory.isHidden = false
            view_OrganisationName.isHidden = false
            view_Designation.isHidden = false
            view_OfficeAddress.isHidden = false
            view_OfficePhoneNo.isHidden = false
            
            switch fld_SubCategory.text!.lowercased(){
             case "other","others":
                view_SubCategory2.isHidden = false
              break
                
            default:
                view_SubCategory2.isHidden = true
                break
            }
            
            break
        }
        
    }
    
    private func ApiGetQualification(){
        let URLString = API_QUALIFICATION
        let api : APITest = APITest<QualificationModel>()
        Loader.show()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            Loader.hide()
            if error == nil, let model = response?.body, let arr = model.data {
                self.arrQualification.append(contentsOf: arr)
            } else {
              //  completion(nil, error)
            }
        }
    }
    
    private func ApiGetOccupation(){
        let URLString = API_OCCUPATION
        let api : APITest = APITest<OccupationModel>()
        Loader.show()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
            Loader.hide()
            if error == nil , let model = response?.body, let arr = model.data {
                self.arrOccupation.append(contentsOf: arr)
              //  completion(response?.body, error)
            } else {
               // completion(nil, error)
            }
        }
    }
    
    private func ApiGetSubCategory(){
        let URLString = API_SubCategory()
        let api : APITest = APITest<SubOccupationModel>()
       // Loader.show()
        api.requestforGET(url: URLString, parameter: nil) { (response, error) in
         //   Loader.hide()
            if error == nil , let model = response?.body, let arr = model.data {
                self.arrSubCategory.append(contentsOf: arr)
                self.sortSubcategoty()
              //  completion(response?.body, error)
            } else {
               // completion(nil, error)
            }
        }
    }
    
    private func sortSubcategoty(){
        self.arrSortedSubCategory = self.arrSubCategory.filter({ obj in
            obj.occupation_id == self.OccupationId
        })
    }
    
    private func ApiSendParentInfo2(){
        guard fld_Name.text! != "" else{
            toast("Please add Name")
            return
        }
        
        guard fld_Email.text! != "" else{
            toast("Please add Email")
            return
        }
        guard fld_Email.text!.isValidEmail() else{
            toast("Please add Email")
            return
        }
       /* guard fld_PANNo.text! != "" else{
            toast("Please add PANNo")
            return
        }*/
        if fld_PANNo.text! != "" && fld_PANNo.text!.lowercased() != "na" && fld_PANNo.text!.lowercased() != "n/a"{
            guard fld_PANNo.text!.validatePANCardNumber() else{
                toast("Please enter valid PANNo")
                return
            }
        }
            
        guard fld_MobileNo.text! != "" else{
            toast("Please add MobileNo")
            return
        }
        guard fld_MobileNo.text!.isValidMobile() else{
            toast("Please add MobileNo")
            return
        }
     
        
     var param =   [
        "email" : fld_Email.text!,
        "pancard" : fld_PANNo.text!.uppercased(),
        "mobile" : fld_MobileNo.text!,
        "name" : fld_Name.text!.uppercased(),
        "qualification_id" : QualificationId,
        "occupation_id" : OccupationId,

        "relation" : currentView.rawValue.uppercased()
        ]
                   
        switch fld_Occupation.text!.lowercased(){
         case "home maker":
          break
        case "other","others":
            
            guard fld_OrganisationName.text! != "" else{
                toast("Please add sub Organisation Name")
                return
            }
            
            guard fld_Designation.text! != "" else{
                toast("Please add sub Designation")
                return
            }
            
            guard fld_OfficeAddress.text! != "" else{
                toast("Please add sub Office Address")
                return
            }
            
            guard fld_OfficePhoneNo.text! != "" else{
                toast("Please add sub Office PhoneNo")
                return
            }
            
            param["other_occupation"] = fld_SubCategory2.text!
            param["organization"] = fld_OrganisationName.text!
            param["designation"] = fld_Designation.text!
            param["office_address"] = fld_OfficeAddress.text!
            param["office_phone"] = fld_OfficePhoneNo.text!
            
         break
            
        default:
            
            guard fld_OrganisationName.text! != "" else{
                toast("Please add sub Organisation Name")
                return
            }
            
            guard fld_Designation.text! != "" else{
                toast("Please add sub Designation")
                return
            }
            
            guard fld_OfficeAddress.text! != "" else{
                toast("Please add sub Office Address")
                return
            }
            
            guard fld_OfficePhoneNo.text! != "" else{
                toast("Please add sub Office PhoneNo")
                return
            }
            
            
            param["occupation_child_id"] = SubcategotyId
            param["organization"] = fld_OrganisationName.text!
            param["designation"] = fld_Designation.text!
            param["office_address"] = fld_OfficeAddress.text!
            param["office_phone"] = fld_OfficePhoneNo.text!

            
            switch fld_SubCategory.text!.lowercased(){
             case "other","others":
                
                guard fld_SubCategory2.text! != "" else{
                    toast("Please add sub category")
                    return
                }
                param["other_occupation"] = fld_SubCategory2.text!
              break
                
            default:
               
                break
            }
            break
        }
               
        print(param)
        
        let api : APITest = APITest<PostGeneralInfoModel>()
        Loader.show()
        
        let URLString = API_UPDATEPARENT(stID: APP_DELEGATE.selected_Student?.studentId?.ID ?? "")
        
        
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
   
//    private func ApiSendParentInfo(){
//
//        let obj = arrObjRelation?[selectedRelationIndex]
//
//        obj?.name = fld_Name.text!
//        obj?.qualification_id?.qualification = fld_Qualification.text!
//        obj?.occupation_id?.occupation_name = fld_Occupation.text!
//        obj?.occupation_child_id?.occupation_child_name = fld_SubCategory.text!
//        obj?.organization = fld_OrganisationName.text!
//        obj?.designation = fld_Designation.text!
//        obj?.office_address = fld_OfficeAddress.text!
//        obj?.office_phone = fld_OfficePhoneNo.text!
//        obj?.pancard = fld_PANNo.text!
//        obj?.email = fld_Email.text!
//        obj?.mobile = fld_MobileNo.text!
//
//        obj?.qualification_id?._id = QualificationId
//        obj?.occupation_id?._id = OccupationId
//        obj?.occupation_child_id?._id = SubcategotyId
//
//        self.arrObjRelation?[selectedRelationIndex] = obj!
//        print(self.arrObjRelation?[selectedRelationIndex].occupation_id?.occupation_name)
//        print(self.arrObjRelation?[selectedRelationIndex].occupation_id?._id)
//
//        let URLString = API_STUDENTDETAIL(stID: APP_DELEGATE.selected_Student?.studentId?.ID ?? "")
//
//        let param = ["relation":[self.arrObjRelation?.first?.dictionary,self.arrObjRelation?.last?.dictionary]]
//       // print(self.arrObjRelation!.dictionary)
//        print(param)
//        return
//        let api : APITest = APITest<PostGeneralInfoModel>()
//        Loader.show()
//        api.requestforPUT(url: URLString, parameter: param) { response, error in
//            Loader.hide()
//            if let msg = response?.body?.message, msg == "Data updated successfully"{
//                if(self.submitHandler != nil){
//                    self.submitHandler!()
//                    self.dismiss(animated: false, completion: nil)
//                }
//                self.toast(msg)
//            }else{
//                self.toast(error?.localizedDescription ?? "")
//            }
//        }
//    }
}

extension EditParentViewController:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        cityStateDropDown.anchorView = textField
        if textField == fld_Qualification {
            cityStateDropDown.dataSource = arrQualification.map({ obj in obj.qualification })
            cityStateDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
               // self.selectedID = self.arrClassList[index].id ?? ""
                self.QualificationId = self.arrQualification[index]._id
                textField.text = item
                self.cityStateDropDown.hide()
            }
            cityStateDropDown.show()

            return false
        }

        if textField == fld_Occupation {
            cityStateDropDown.dataSource = arrOccupation.map({ obj in obj.occupation_name })
            cityStateDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
               // self.selectedID = self.arrClassList[index].id ?? ""
                self.OccupationId = self.arrOccupation[index]._id
                textField.text = item
                self.cityStateDropDown.hide()
                self.sortSubcategoty()
                self.HideShowStackViews()
                self.fld_SubCategory.text = ""
                self.SubcategotyId = ""

            }
            cityStateDropDown.show()
            return false
        }
//
        if textField == fld_SubCategory {
            cityStateDropDown.dataSource = arrSortedSubCategory.map({ obj in obj.occupation_child_name})
            cityStateDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
               // self.selectedID = self.arrClassList[index].id ?? ""
                self.SubcategotyId = self.arrSortedSubCategory[index]._id
                print(SubcategotyId)
                textField.text = item
                self.cityStateDropDown.hide()
                self.HideShowStackViews()
            }
            cityStateDropDown.show()
            return false
        }
           
     return true
    }
}
 
struct QualificationModel:Codable{
 let message : String
 let data : [QualificationData]?
}
struct QualificationData:Codable{
 let _id : String
 let code : String
 let qualification : String
}

struct OccupationModel:Codable{
 let message : String
 let data : [OccupationData]?
}
struct OccupationData:Codable{
 let _id : String
 let occupation_code : String
 let occupation_name : String
}

struct SubOccupationModel:Codable{
 let message : String
 let data : [SubOccupationData]?
}
struct SubOccupationData:Codable{
 let _id : String
 let occupation_child_code : String
 let occupation_child_name : String
  let  category_Id : String
   let occupation_id : String
}

//struct OccupationData:Codable{
// let _id : String
// let occupation_child_code : String
// let occupation_child_name : String
//    let category_Id : String
//    let occupation_id : String
//}
