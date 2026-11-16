//
//  ClassPublishAlertViewController.swift
//  MountCarmel
//
//  Created by Sandip on 11/04/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class ClassPublishAlertViewController: UIViewController {

    @IBOutlet var lblAlertTitle: UILabel!
    @IBOutlet var btnPublish: RoundedButton!
    @IBOutlet var lblClick: UILabel!
    @IBOutlet var lblCongratulate: UILabel!
    var arrSelectedList = [[String:Any]]()
    var doneHandler : ((String) -> ())?
    var strMessage = ""
    var strClass = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblAlertTitle.font = UIFont.setBoldFont(ofSize: 14.0)
        self.lblCongratulate.text = "Congratulations for motivating students of " + strClass
        self.lblCongratulate.font = UIFont.setRegularFont(ofSize: 12.0)
        self.lblClick.font = UIFont.setRegularFont(ofSize: 12.0)
        self.btnPublish.titleLabel?.font = UIFont.setBoldFont(ofSize: 13.0)
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        // Do any additional setup after loading the view.
    }
    

    //MARK:- ACTION EVENT -
   
    @IBAction func actionCloseClick(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func actionPublishClick(_ sender: Any) {
        self.callAPISaveStudentsIndividual { (success) in
            if(success){
                self.dismiss(animated: false) {
                    if(self.doneHandler != nil){
                        self.doneHandler!(self.strMessage)
                    }
                }
            }
        }
    }
    
}
extension ClassPublishAlertViewController{
    func callAPISaveStudentsIndividual(finished:@escaping(_ success:Bool) -> Void){
        Loader.show()
        WiseManagementAPI.saveClassStudent(body: arrSelectedList) { (respose, error) in
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
            guard let responseData = response.message else {
                self.toast(response.message ?? "Invalid Response")
                finished(false)
                return
            }
            self.strMessage = responseData
            finished(true)
        }
    }
}
