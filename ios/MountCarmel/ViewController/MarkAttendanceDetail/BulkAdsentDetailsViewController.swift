//
//  BulkAdsentDetailsViewController.swift
//  MountCarmel
//
//  Created by Mandeep Singh on 20/08/22.
//  Copyright © 2022 InventionHill. All rights reserved.
//

import UIKit
import DropDown

class BulkAdsentDetailsViewController: UIViewController {
    @IBOutlet weak var txtReason: RoundTextField!
    @IBOutlet weak var txtOtherDetails: RoundTextField!
    @IBOutlet weak var txtInformation: RoundTextField!
    
    @IBOutlet weak var txtDate: RoundTextField!
    @IBOutlet weak var viewOtherDetails: RoundedView!{didSet{viewOtherDetails.isHidden=true}}
    @IBOutlet weak var viewAbsentDetails: RoundedView!{didSet{viewAbsentDetails.isHidden = true}}
    @IBOutlet weak var viewCarryForward: RoundedView!{didSet{viewCarryForward.isHidden = true}}
    
    var arrReasonList = [ReasonAPIData]()
    var classDropDown = DropDown()
    var selectedBulk : bulkAttendance = .allAbsent
    
    var submitHandler : ((String?,String?,String?,String?) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedBulk == .allAbsent{
            self.viewAbsentDetails.isHidden = false
            self.callAPIForReasonList { success in }
        }else{
            self.viewCarryForward.isHidden = false
        }
        
    }
    
    @IBAction func btnReason(_ sender: Any) {
        classDropDown.anchorView = txtReason
        classDropDown.direction = .bottom
        classDropDown.textFont = UIFont.setRegularFont(ofSize: 13.0)
        classDropDown.width = txtReason.frame.size.width
        classDropDown.bottomOffset = CGPoint(x: 0, y: 50)
            
            var strArr = [String]()
            for item in self.arrReasonList{
                strArr.append(item.reason!)
            }
                    classDropDown.dataSource = strArr
            
                    classDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                        self.txtReason.text = item
                        if self.txtReason.text! == "Others"{
                            self.viewOtherDetails.isHidden = false
                        }else{
                            self.viewOtherDetails.isHidden = true
                        }
                        self.classDropDown.hide()
                    }
                    classDropDown.show()
    }

    @IBAction func btnInformation(_ sender: Any) {
        
            classDropDown.anchorView = txtInformation
            classDropDown.direction = .bottom
            classDropDown.textFont = UIFont.setRegularFont(ofSize: 13.0)
            classDropDown.width = txtInformation.frame.size.width
            classDropDown.bottomOffset = CGPoint(x: 0, y: 0)
            
            var strArr = [String]()
            strArr.append("Information Received")
            strArr.append("YES")
            strArr.append("NO")
            
            classDropDown.dataSource = strArr
            
            classDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                if item != "Information Received"{
                    self.txtInformation.text = item
                }
                self.classDropDown.hide()
            }
            classDropDown.show()
        
    }
    
    @IBAction func btnSave(_ sender: Any) {
        if selectedBulk == .carryForward{
            if self.txtDate.text == "Select Date"{
                self.toast("Please select date")
                return
            }
            if let handler = submitHandler{
                handler(nil, nil, nil, self.txtDate.text!)
                self.dismiss(animated: false, completion: nil)
            }
            
            return
        }
        // All absent
        if self.txtInformation.text == "Information Received"{
            self.toast("Please update 'Information Received' for all students marked absent")
            return
        }
        if let handler = submitHandler{
            let reason = self.txtReason.text! == "Select Reason" ? "" : self.txtReason.text!
            handler(reason, self.txtOtherDetails.text!, self.txtInformation.text!, nil)
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func actionSelectDate(_ sender: Any) {
        if let viewController: CalenderPopUpViewController = CalenderPopUpViewController.storyboardInstance.initialize() {
            
            viewController.modalPresentationStyle = .overCurrentContext
            viewController.strScreenName = "MarkAttendance"
            viewController.dateHandler = { (strDate) in
                self.txtDate.text = strDate
            }
            self.present(viewController, animated: false, completion: nil)
        }
    }

}

extension BulkAdsentDetailsViewController{
    
    func callAPIForReasonList(finished:@escaping(_ success: Bool) -> Void) {
        Loader.show()
        MarkAttendanceManagemnetAPI.getAttendanceReason() { (respose, error) in
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
            // ADDING CUSTOM REASON
            let tempDict = [
                "_id" : "5f09603d02015b0a53946fb225",
                "created_at" : "2020-07-11T09:08:36.853Z",
                "reason" : "Select Reason",
                "updated_at" : "2020-07-11T09:08:36.854Z" ]
            let data = try! JSONSerialization.data(withJSONObject: tempDict, options: [])
            let model = try! JSONDecoder().decode(ReasonAPIData.self, from: data)
            self.arrReasonList.append(model)

            for M in responseData{
                self.arrReasonList.append(M)
            }
            //self.arrReasonList = responseData
            finished(true)
        }
    }
}
