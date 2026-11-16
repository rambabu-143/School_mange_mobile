//
//  AttendanceSubmittedPopUp.swift
//  MountCarmel
//
//  Created by Sandip on 08/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class MarkAttendanceAbsentDataInfo: NSObject {
    
    var fullDay: Int = 0
    var halfDay: Int = 0
    var totalStudents: Int = 0
    
    override init() {
        super.init()
    }
}

class AttendanceSubmittedPopUp: UIViewController {

    @IBOutlet var lblHalfDayTitle: UILabel!
    @IBOutlet var lblFulldayTitle: UILabel!
    @IBOutlet var lblAbsentTitle: UILabel!
    @IBOutlet var lblPresentTitle: UILabel!
    @IBOutlet var lblTotalTitle: UILabel!
    @IBOutlet var lblHalfDay: UILabel!
    @IBOutlet var lblFullDay: UILabel!
    @IBOutlet var lblPresentVal: UILabel!
    @IBOutlet var lblTotalVal: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var btnClass: RoundedButton!
    
    var className = ""
    var messageText = ""
    var closeHandler : (() -> ())?
    //Variable Received from Previous Screen
    var responseValue : MarkAttendanceAbsentDataInfo?
    var Params = [String:Any]()
    var strDate = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.setInitialValue()
        
       // let className = (APP_DELEGATE.userInfo?.staffId?.classTeacherID?.standard ?? "") + "-" + (APP_DELEGATE.userInfo?.staffId?.classTeacherID?.section ?? "")
        lblTotalTitle.font = UIFont.setRegularFont(ofSize: 14.0)
        lblPresentTitle.font = UIFont.setRegularFont(ofSize: 14.0)
        lblAbsentTitle.font = UIFont.setRegularFont(ofSize: 14.0)
        
        lblHalfDayTitle.font = UIFont.setRegularFont(ofSize: 8.0)
        lblFulldayTitle.font = UIFont.setRegularFont(ofSize: 8.0)

        lblPresentVal.font = UIFont.setBoldFont(ofSize: 15.0)
        lblTotalVal.font = UIFont.setBoldFont(ofSize: 15.0)
        lblFullDay.font = UIFont.setBoldFont(ofSize: 15.0)
        lblHalfDay.font = UIFont.setBoldFont(ofSize: 15.0)
        
        self.btnClass.setTitle(className, for: .normal)
        
    }

    func setInitialValue(){
        
        self.lblDate.text = self.strDate
        self.lblTotalVal.text = "\(responseValue?.totalStudents ?? 0)"
        
        let totalPresent = (responseValue?.totalStudents ?? 0) - ((responseValue?.fullDay ?? 0) + (responseValue?.halfDay ?? 0))
        
        self.lblPresentVal.text = "\(totalPresent)"
        self.lblFullDay.text = "\(responseValue?.fullDay ?? 0)"
        self.lblHalfDay.text = "\(responseValue?.halfDay ?? 0)"
    }
    
    @IBAction func btnCloseClick(_ sender: Any) {
        self.dismiss(animated: false, completion: {
          if self.closeHandler != nil{
            self.closeHandler!()
            }
        })
    }

    @IBAction func actionOKClick(_ sender: Any) {
        self.callAPIForSubmitAttendance(param: Params) { (success,message)  in
            
            self.toast(message)
            
            if(success){
                self.dismiss(animated: false, completion: {
                    if self.closeHandler != nil{
                        self.closeHandler!()
                    }
                })
            }
        }
        
    }

    func callAPIForSubmitAttendance(param: [String:Any],finished:@escaping(_ success: Bool,_ message:String) -> Void) {
       Loader.show()

      MarkAttendanceManagemnetAPI.submitAttendance(body: param) { (respose, error) in
          Loader.hide()
        guard let response = respose else {
            self.toast(error?.localizedDescription ?? "Invalid Response")
            finished(false,"Invalid Response")
            return
        }
    
       guard response.status == true else {
           self.toast(response.message ?? "Invalid Response")
          finished(false,"Invalid Response")
          return
      }
  //self.toast(response.message ?? "")
     //self.responseValue = response
//        self.responseValue?.present = response.present
//        self.responseValue?.total = response.total
//        self.responseValue?.absent = response.absent
    
         finished(true,response.message ?? "")
     }
}
    
  
}
