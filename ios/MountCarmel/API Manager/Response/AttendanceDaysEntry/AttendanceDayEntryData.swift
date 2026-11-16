//
//  AttendanceDayEntryData.swift
//  MountCarmel
//
//  Created by Sandip on 09/08/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class AttendanceDayEntryData: WSResponseData {
    var _id : String?
    var admission_no : String?
    var studentImg : String?
    var email : String?
    var gender : String?
    var house_id : String?
    var name : String?
    var profile_pic : String?
    var sms_mobile : String?
   // var standard_section_id : String?
    var combo_id : String?
    var date_of_withdrawal : String?
    var attendance_data : Attendance_data?
    
    enum CodingKeys: String, CodingKey {
        
        case _id = "_id"
        case admission_no = "admission_no"
        case studentImg = "studentImg"
        case email = "email"
        case gender = "gender"
        case house_id = "house_id"
        case name = "name"
        case profile_pic = "profile_pic"
        case sms_mobile = "sms_mobile"
      //  case standard_section_id = "standard_section_id"
        case combo_id = "combo_id"
        case attendance_data = "attendance_data"
        case date_of_withdrawal = "date_of_withdrawal"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        admission_no = try values.decodeIfPresent(String.self, forKey: .admission_no)
        studentImg = try values.decodeIfPresent(String.self, forKey: .studentImg)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        house_id = try values.decodeIfPresent(String.self, forKey: .house_id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        profile_pic = try values.decodeIfPresent(String.self, forKey: .profile_pic)
        sms_mobile = try values.decodeIfPresent(String.self, forKey: .sms_mobile)
      //  standard_section_id = try values.decodeIfPresent(String.self, forKey: .standard_section_id)
        combo_id = try values.decodeIfPresent(String.self, forKey: .combo_id)
        attendance_data = try values.decodeIfPresent(Attendance_data.self, forKey: .attendance_data)
        date_of_withdrawal = try values.decodeIfPresent(String.self, forKey: .date_of_withdrawal)
    }
    
}

class Attendance_data : WSResponseData {
    var total_days : Int?
    var total_present : Double?
    var total_absent : Double?
    
    enum CodingKeys: String, CodingKey {
        
        case total_days = "total_days"
        case total_present = "total_present"
        case total_absent = "total_absent"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        total_days = try values.decodeIfPresent(Int.self, forKey: .total_days)
        total_present = try values.decodeIfPresent(Double.self, forKey: .total_present)
        total_absent = try values.decodeIfPresent(Double.self, forKey: .total_absent)
    }
    
}
