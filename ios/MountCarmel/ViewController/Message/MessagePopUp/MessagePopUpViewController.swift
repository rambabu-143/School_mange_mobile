//
//  MessagePopUpViewController.swift
//  MountCarmel
//
//  Created by Sandip on 03/08/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class MessagePopUpViewController: UIViewController {

    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblMessage: UILabel!
    var messageData:MessageData?
    var isFromNotification = false
    var doneHandler : (() -> ())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
//        if(!isFromNotification){
//
//        }
        setInitialData()
        
        // Do any additional setup after loading the view.
    }
    
    func  setInitialData() {
        self.lblMessage.font = UIFont.setRegularFont(ofSize: 14.0)
        self.lblDate.font = UIFont.setRegularFont(ofSize: 13.0)
        
        lblMessage.text = messageData?.sms_text ?? ""
        lblDate.text = CommonFunctions.UTCToLocal(date: messageData?.created_at ?? "", fromFormat: DateFormat.DateFormate_MessageServer, toFormat: DateFormat.DateFormat_Notice)
        if(isFromNotification){
            self.callAPIForStudentNotificationUpdate { (check) in
                
            }
        }else{
            self.callAPIForStudentMessageUpdate { (check) in
                
            }
        }
       
    }

    @IBAction func btnBackViewClick(_ sender: Any) {
        self.dismiss(animated: true) {
            if self.doneHandler != nil{
                self.doneHandler!()
            }
        }
    }
}
extension MessagePopUpViewController {
    func callAPIForStudentMessageUpdate(finished:@escaping(_ success: Bool) -> Void) {
        //Loader.show()
        let responseParam = MessageReadUnreadParam(read_flag: true)
        StaffManageMentAPI.updateStudentMessage(messageID: messageData?.id ?? "",body: responseParam) {  (respose, error) in
            //Loader.hide()
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
//            guard let responseData = response.data else {
//                self.toast(response.message ?? "Invalid Response")
//                finished(false)
//                return
//            }
            
            finished(true)
        }
    }
    
    func callAPIForStudentNotificationUpdate(finished:@escaping(_ success: Bool) -> Void) {
        //Loader.show()
        let responseParam = MessageReadUnreadParam(read_flag: true)
        StaffManageMentAPI.updateStudentNotification(messageID: messageData?.id ?? "",body: responseParam) {  (respose, error) in
            //Loader.hide()
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
            //            guard let responseData = response.data else {
            //                self.toast(response.message ?? "Invalid Response")
            //                finished(false)
            //                return
            //            }
            
            finished(true)
        }
    }
}
