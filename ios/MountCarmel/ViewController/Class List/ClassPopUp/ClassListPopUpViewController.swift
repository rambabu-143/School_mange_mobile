//
//  ClassListPopUpViewController.swift
//  MountCarmel
//
//  Created by Sandip on 16/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class ClassListPopUpViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAdmission: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var lblWISE: UILabel!
    @IBOutlet weak var lblDiscplinaryDard: UILabel!
    @IBOutlet weak var lblTotalAttendance: UILabel!
    @IBOutlet weak var lblAttendance: UILabel!
    
    internal var obj : HouseReportData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  print(obj)
        
        lblTitle.text = "\(obj?.name ?? "") - \(obj?.admission_no ?? "")"
      //  lblName.text = "(a) Name : \(obj?.name ?? "")"
       // lblAdmission.text = "(b) Admission no. : \(obj?.admission_no ?? "")"
        lblMobile.text = "(a) Mobile no. for SMS : \(obj?.sms_mobile ?? "")"
        lblWISE.text = "(b) WISE : \(obj?.wise?.total ?? 0)"
        lblDiscplinaryDard.text = "(c) Disciplinary cards : \(obj?.disciplinary?.total ?? 0)"
        lblTotalAttendance.text = "(d) Total Attendance : \(calculateAttendancePercentage())"
        lblAttendance.text = "(e) Today's Attendance : \(obj?.attendance_data?.today_attendance ?? "")"
        
    }
    
   private func calculateAttendancePercentage() -> String {
       let total_present = obj?.attendance_data?.total_present ?? 0
       let total_days  = obj?.attendance_data?.total_days ?? 0
       
       let Show_TP = String(total_present).replacingOccurrences(of: ".0", with: "")
       let Show_TD = String(total_days).replacingOccurrences(of: ".0", with: "")
       
        if total_days == 0 { // To handle division by zero error
            return "\(Show_TP)/\(Show_TD) (0.0%)"
            //return "\(total_days)/\(total_present) (0.0%)"
        }
        
        let attendancePercentage = (Double(total_present) / Double(total_days)) * 100
        print(attendancePercentage)
        let roundedPercentage = (attendancePercentage * pow(10, Double(2))).rounded() / pow(10, Double(2))
        print(roundedPercentage)
       
       
       
       return "\(Show_TP)/\(Show_TD) (\(roundedPercentage)%)"
        //return "\(total_days)/\(total_present) (\(roundedPercentage)%)"
    }
     
    @IBAction func actionClosePopUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
