//
//  IDCardChangeSelectionViewController.swift
//  MountCarmel
//
//  Created by Mandeep Singh on 26/02/24.
//  Copyright © 2024 InventionHill. All rights reserved.
//

import UIKit

class IDCardChangeSelectionViewController: UIViewController {

    @IBOutlet var btnSelection: [UIButton]!
    
    var submitHandler : ((String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for btn in btnSelection{
            btn.setImage(UIImage(named: "Intellect_unselect"), for: .normal)
        }
    }
    
    @IBAction func btnSelection(_ sender: UIButton) {
        guard let btn = btnSelection.filter({ btn in
            btn.tag == sender.tag
        }).first else {return}
        
       if btn.image(for: .normal) == UIImage(named: "Intellect_unselect"){
            btn.setImage(UIImage(named: "Intellect_select"), for: .normal)
        }else{
            btn.setImage(UIImage(named: "Intellect_unselect"), for: .normal)
        }
    }
    
    @IBAction func btnSave(_ sender: Any) {
        self.ApiSendSelection()
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    private func getStatus(tag:Int)->Bool{
        guard let btn = btnSelection.filter({ btn in
            btn.tag == tag
        }).first else {return false}
        
       if btn.image(for: .normal) == UIImage(named: "Intellect_unselect"){
            return false
        }else{
            return true
        }
    }
}

extension IDCardChangeSelectionViewController{
    
    private func ApiSendSelection(){
        let URLString = API_GETIDCARDINFO()
        let api : APITest = APITest<PostGeneralInfoModel>()
                        
        let param:[String:Any] =
            ["profile_pic": getStatus(tag:0),
             "name": getStatus(tag:1),
             //"class_section": getStatus(tag:2),
             "date_of_birth": getStatus(tag:3),
             "bloodgroup": getStatus(tag:4),
             "allergies": getStatus(tag:5),
             "fathers_name": getStatus(tag:6),
             "address": getStatus(tag:7),
             "sms_mobile": getStatus(tag:8),
             "transport": getStatus(tag:9)
          ]
        print(param)
        
        api.requestforPUT(url: URLString, parameter: param) { response, error in
            if let stts = response?.body?.status, stts  == true{
                if(self.submitHandler != nil){
                    self.submitHandler!(response?.body?.message ?? "")
                    self.dismiss(animated: false, completion: nil)
                }
            }else{
                self.toast(error?.localizedDescription ?? "")
            }
        }
    }

}
