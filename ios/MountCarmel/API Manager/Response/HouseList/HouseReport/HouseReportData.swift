//
//  HouseReportData.swift
//  MountCarmel
//
//  Created by Sandip on 27/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit


struct HouseReportData:Codable{
    var id : String?
    var admission_no : String?
    var name : String?
    var standard_section_id : StandardSectionData?
    var gender : String?
    var house_id : HouseSectionData?
    var profile_pic : String?
    var email : String?
    var sms_mobile : String?
    var reason : String?
    var information : String?
    var studentImg : String?
    var wise:WiseModel?
    var disciplinary:DisciplinaryModel?
    var attendance_data:AttendanceDataModel?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case admission_no = "admission_no"
        case name = "name"
        case standard_section_id = "standard_section_id"
        case gender = "gender"
        case house_id = "house_id"
        case profile_pic = "profile_pic"
        case email = "email"
        case sms_mobile = "sms_mobile"
        case reason = "reason"
        case information = "information"
        case studentImg = "studentImg"
        case wise = "wise"
        case disciplinary = "disciplinary"
        case attendance_data = "attendance_data"
       }
}
 
struct AttendanceDataModel:Codable{
    let today_attendance:String?
    //let total_absent:String?
    let total_days:Double?
    let total_present:Double?
}

struct DisciplinaryModel:Codable{
    let total:Int?
    let pink:Int?
    let red:Int?
    let yellow:Int?
}

struct WiseModel:Codable{
    let total:Int?
}

//"attendance_data" =             {
//    "today_attendance" = PRESENT;
//    "total_absent" = 2;
//    "total_days" = 118;
//    "total_present" = 116;
//}
