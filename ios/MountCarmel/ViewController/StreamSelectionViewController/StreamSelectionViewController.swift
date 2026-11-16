//
//  StreamSelectionViewController.swift
//  MountCarmel
//
//  Created by Mandeep Singh on 05/03/23.
//  Copyright © 2023 InventionHill. All rights reserved.
//

import UIKit
import DTTextField
import DropDown

class StreamSelectionViewController: UIViewController {
    @IBOutlet weak var navigationView: NavigationBarView!
    @IBOutlet weak var lastSubmissionDate: UILabel!
    @IBOutlet weak var txtCombination: DTTextField!{
        didSet{
            txtCombination.delegate = self
        }
    }
    
    @IBOutlet weak var txtSubject1: DTTextField!{
        didSet{
            txtSubject1.delegate = self
        }
    }
        @IBOutlet weak var txtSubject2: DTTextField!{
            didSet{
                txtSubject2.delegate = self
            }
        }
            @IBOutlet weak var txtSubject3: DTTextField!{
                didSet{
                    txtSubject3.delegate = self
                }
            }
                @IBOutlet weak var txtSubject4: DTTextField!{
                    didSet{
                        txtSubject4.delegate = self
                    }
                }
                    @IBOutlet weak var txtSubject5: DTTextField!{
                        didSet{
                            txtSubject5.delegate = self
                        }
                    }
                        @IBOutlet weak var txtSubject6: DTTextField!{
                            didSet{
                                txtSubject6.delegate = self
                            }
                        }
    @IBOutlet weak var txtViewRemark: UITextView!{
        didSet{
            txtViewRemark.delegate = self
        }
    }
    @IBOutlet weak var lblRemark: UILabel!
    
    private let textViewPlaceholder = "Enter Remark"
    private var commonDropDown = DropDown()
    private var arrStreams = [streamObject]()
    
    private var combinationIndex : Int? = nil
    private var subject1_Index : Int? = nil
    private var subject2_Index : Int? = nil
    private var subject3_Index : Int? = nil
    private var subject4_Index : Int? = nil
    private var subject5_Index : Int? = nil
    private var subject6_Index : Int? = nil
    
    private var arrAllSubjects = [streamSubjects]()
    private var eligibilityCriteriaLink = ""
    private var documentInteractionController = UIDocumentInteractionController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationView.lblTitle.text = "Stream Selection"
        navigationView.delegate = self
        
        txtViewRemark.text = textViewPlaceholder
        txtViewRemark.textColor = UIColor.lightGray
  
        self.callAPIForGetStreams { success in
            if let mSS = APP_DELEGATE.streamSelectionInfo{
               if let obj = self.arrStreams.filter({ obj in
                    (obj._id ?? "") == (mSS.combination_id?._id ?? "")
               }).first{
                   print(obj.combination_name ?? "combination_name = nil")
                   self.arrAllSubjects.removeAll()
                   self.arrAllSubjects.append(contentsOf: obj.subject1 ?? [])
                   self.arrAllSubjects.append(contentsOf: obj.subject2 ?? [])
                   self.arrAllSubjects.append(contentsOf: obj.subject3 ?? [])
                   self.arrAllSubjects.append(contentsOf: obj.subject4 ?? [])
                   self.arrAllSubjects.append(contentsOf: obj.subject5 ?? [])
                   self.arrAllSubjects.append(contentsOf: obj.subject6 ?? [])
                   
                   print(self.arrAllSubjects)
                   
                   self.txtCombination.text = obj.combination_name ?? ""
                   self.txtSubject1.text = self.arrAllSubjects.filter{$0._id == mSS.subject1}.first?.subject_name ?? ""
                   self.txtSubject2.text = self.arrAllSubjects.filter{$0._id == mSS.subject2}.first?.subject_name ?? ""
                   self.txtSubject3.text = self.arrAllSubjects.filter{$0._id == mSS.subject3}.first?.subject_name ?? ""
                   self.txtSubject4.text = self.arrAllSubjects.filter{$0._id == mSS.subject4}.first?.subject_name ?? ""
                   self.txtSubject5.text = self.arrAllSubjects.filter{$0._id == mSS.subject5}.first?.subject_name ?? ""
                   self.txtSubject6.text = self.arrAllSubjects.filter{$0._id == mSS.subject6}.first?.subject_name ?? ""
                   self.txtViewRemark.text = mSS.remark ?? ""
                   self.txtViewRemark.textColor = UIColor.black
                   self.lblRemark.text = "\(self.txtViewRemark.text!.count)/200"
                  // self.lastSubmissionDate.text = "Last Date of Submission : "+CommonFunctions.UTCToLocal(date: mSS.updated_at ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_DDMMYYYY)
                   self.lastSubmissionDate.text = "Last Date of Submission : "+CommonFunctions.UTCToLocal(date: APP_DELEGATE.student_LastStreamSelectionEnd_time ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_Notice)
                  
                   self.combinationIndex = self.arrStreams.firstIndex(where: { s in s.combination_name == self.txtCombination.text! })
                   self.subject1_Index = obj.subject1?.firstIndex(where: { s in s.subject_name == self.txtSubject1.text! })
                   self.subject2_Index = obj.subject2?.firstIndex(where: { s in s.subject_name == self.txtSubject2.text! })
                   self.subject3_Index = obj.subject3?.firstIndex(where: { s in s.subject_name == self.txtSubject3.text! })
                   self.subject4_Index = obj.subject4?.firstIndex(where: { s in s.subject_name == self.txtSubject4.text! })
                   self.subject5_Index = obj.subject5?.firstIndex(where: { s in s.subject_name == self.txtSubject5.text! })
                   self.subject6_Index = obj.subject6?.firstIndex(where: { s in s.subject_name == self.txtSubject6.text! })
                   
//                   print(self.subject1_Index)
//                   print(self.subject2_Index)
//                   print(self.subject3_Index)
//                   print(self.subject4_Index)
//                   print(self.subject5_Index)
//                   print(self.subject6_Index)
                   
               }
            }
        }
    }
    
    @IBAction func btnEligibilityCriteria(_ sender: Any) {
        //let fileName = "stream-selection-an/\(APP_DELEGATE.yearSession ?? "")/eligibility_criteria"
        CommonFunctions.download_and_save_file(str_url: self.eligibilityCriteriaLink) { msg in
            DispatchQueue.main.async {
                self.toast(msg)
            }
        }
    }
    
    @IBAction func btnUpdate(_ sender: Any) {
        self.postStreamsSelection()
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.onTapBack()
    }
    
}

extension StreamSelectionViewController:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        commonDropDown.anchorView = textField
        commonDropDown.direction = .bottom
        commonDropDown.textFont = UIFont.setRegularFont(ofSize: 13.0)
        commonDropDown.width = self.view.frame.size.width/1.4
        commonDropDown.bottomOffset = CGPoint(x: 0, y: 50)
        commonDropDown.dataSource = dropDownData(txtfld: textField)
        
        commonDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            // print("Selected item: \(item) at index: \(index)")
            textField.text = item
            self.dropDownSelectedData(txtfld: textField, index: index)
            self.commonDropDown.hide()
        }
        commonDropDown.show()
        
        return false
    }
    
    private func dropDownData(txtfld: UITextField)->[String]{
        switch txtfld{
        case txtCombination:
            return arrStreams.map { $0.combination_name ?? ""}
            
        case txtSubject1:
            guard txtCombination.text != "" else{
                self.toast("Please select Combination")
                return []
            }
            return (arrStreams[combinationIndex!].subject1 ?? []).map { $0.subject_name ?? ""}
            
        case txtSubject2:
                guard txtCombination.text != "" else{
                    self.toast("Please select Combination")
                    return []
                }
            return (arrStreams[combinationIndex!].subject2 ?? []).map { $0.subject_name ?? ""}
            
        case txtSubject3:
                    guard txtCombination.text != "" else{
                        self.toast("Please select Combination")
                        return []
                    }
            return (arrStreams[combinationIndex!].subject3 ?? []).map { $0.subject_name ?? ""}
            
        case txtSubject4:
                        guard txtCombination.text != "" else{
                            self.toast("Please select Combination")
                            return []
                        }
            return (arrStreams[combinationIndex!].subject4 ?? []).map { $0.subject_name ?? ""}
            
        case txtSubject5:
                            guard txtCombination.text != "" else{
                                self.toast("Please select Combination")
                                return []
                            }
            return (arrStreams[combinationIndex!].subject5 ?? []).map { $0.subject_name ?? ""}
            
        case txtSubject6:
                                guard txtCombination.text != "" else{
                                    self.toast("Please select Combination")
                                    return []
                                }
            return (arrStreams[combinationIndex!].subject6 ?? []).map { $0.subject_name ?? ""}
            
        default:
            break;
        }
        return []
    }
    
    private func validate()->Bool{
        guard txtCombination.text != "" else{
            self.toast("Please select Combination")
            return false
        }
        return true
    }
    
    private func dropDownSelectedData(txtfld: UITextField,index:Int){
        
        switch txtfld{
        case txtCombination:
            combinationIndex = index
            subject1_Index = nil
            subject2_Index = nil
            subject3_Index = nil
            subject4_Index = nil
            subject5_Index = nil
            subject6_Index = nil

            txtSubject1.text = ""
            txtSubject2.text = ""
            txtSubject3.text = ""
            txtSubject4.text = ""
            txtSubject5.text = ""
            txtSubject6.text = ""
            break;
            
        case txtSubject1:
            subject1_Index = index
            break;
            
        case txtSubject2:
            subject2_Index = index
            break;
            
        case txtSubject3:
            subject3_Index = index
            break;
            
        case txtSubject4:
            subject4_Index = index
            break;
            
        case txtSubject5:
            subject5_Index = index
            break;
            
        case txtSubject6:
            subject6_Index = index
            break;
            
        default:
            break;
        }
        
    }
    
}

extension StreamSelectionViewController:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = textViewPlaceholder
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textView.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)

        //itulblRemark.text = "\(updatedText.count)/200"
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.lblRemark.text = "\(self.txtViewRemark.text!.count)/200"
        }
        // make sure the result is under 16 characters
        return updatedText.count <= 200
    }
}

extension StreamSelectionViewController: NavigationBarViewDelegate{
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
extension StreamSelectionViewController{
    private func callAPIForGetStreams(finished:@escaping(_ success: Bool) -> Void) {
         Loader.show()
        
        StudentManagementAPI.getStreamSelection { data, error in
            Loader.hide()
            guard let response = data else{
                self.toast(error?.localizedDescription ?? "Invalid response")
                finished(false)
                return
            }
            print(response)
            
            self.arrStreams = response.data ?? []
            for (i,_) in self.arrStreams.enumerated(){
                var sub6 = self.arrStreams[i].subject6 ?? []
                sub6.insert(streamSubjects(_id: "empty", subject_name: "SELECT"), at: 0)
                self.arrStreams[i].subject6 = sub6
            }
            
            self.eligibilityCriteriaLink = response.eligibility_criteria ?? ""
            
            finished(true)
        }
     }
    
    private func postStreamsSelection(){
        guard let sub1 = subject1_Index else{
            self.toast("Please select subject 1")
            return
        }
            guard let sub2 = subject2_Index else{
                self.toast("Please select subject 2")
                return
            }
                guard let sub3 = subject3_Index else{
                    self.toast("Please select subject 3")
                    return
                }
                    guard let sub4 = subject4_Index else{
                        self.toast("Please select subject 4")
                        return
                    }
                        guard let sub5 = subject5_Index else{
                            self.toast("Please select subject 5")
                            return
                        }
        
        
        
        var param = [String:Any]()
        
        let comid = combinationIndex!
        
        param["student_id"] = APP_DELEGATE.selected_Student?.studentId?.ID ?? ""
        param["remark"] = txtViewRemark.text!
        
        param["combination_id"] = arrStreams[comid]._id ?? ""
        param["subject1"] = arrStreams[comid].subject1?[sub1]._id ?? ""
        param["subject2"] = arrStreams[comid].subject2?[sub2]._id ?? ""
        param["subject3"] = arrStreams[comid].subject3?[sub3]._id ?? ""
        param["subject4"] = arrStreams[comid].subject4?[sub4]._id ?? ""
        param["subject5"] = arrStreams[comid].subject5?[sub5]._id ?? ""
        
        if let sub6 = subject6_Index{
            if arrStreams[comid].subject6?[sub6]._id ?? "" == "empty"{
                param["subject6"] = ""
                param["is_additional_subject"] = false
            }else{
                param["subject6"] = arrStreams[comid].subject6?[sub6]._id ?? ""
                param["is_additional_subject"] = true
            }
           
        }
        print(param)
        Loader.show()
        StudentManagementAPI.postStreamSelection(body: param) { (response, error) in
            Loader.hide()
            if response?.status == true {
                
                for case let vc as SideMenu in (self.navigationController?.parent as? HostViewController)?.children ?? []{
                    vc.callAPIForSelfAwernessMenu { success in
                        
                    }
                }
                
                self.toast(response?.message ?? "")
                self.onTapBack()
               // self.navigationController?.popViewController(animated: true)
            }else{
                self.toast(response?.message ?? "")
            }
        }
    }
 
}

struct postStreamDataModel:Codable{
    let message : String?
    let status : Bool
    
}

struct streamDataModel:Codable{
    let data : [streamObject]?
    let eligibility_criteria:String?
}

struct streamObject:Codable{
    let branch_code : Int?
    let _id : String?
    let combination_name : String?
    let subject1 : [streamSubjects]?
    let subject2 : [streamSubjects]?
    let subject3 : [streamSubjects]?
    let subject4 : [streamSubjects]?
    let subject5 : [streamSubjects]?
    var subject6 : [streamSubjects]?
}
struct streamSubjects:Codable{
    let _id : String?
    let subject_name : String?
}
