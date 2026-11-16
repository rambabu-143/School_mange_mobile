//
//  MarkAttendanceListData.swift
//  MountCarmel
//
//  Created by Sandip on 19/08/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class MarkAttendanceListData: WSResponseData {
    var id : String?
    var admission_no : String?
    var name : String?
    var gender : String?
    var house_id : String?
    var profile_pic : String?
    var email : String?
    var sms_mobile : String?
    var reason : String?
    var details : String?
    var information : String?
    var studentImg : String?
    var combo_id : String?
    var attendance : Attendance?
    var isSectionChanged : Bool?
    var standardSectionId : StandardSectionData?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "_id"
        case admissionno = "admission_no"
        case name = "name"
        case gender = "gender"
        case houseid = "house_id"
        case profile_pic = "profile_pic"
        case email = "email"
        case smsmobile = "sms_mobile"
        case studentImg = "studentImg"
        case combo_id = "combo_id"
        case attendance = "attendance"
        case isSectionChanged = "is_section_changed"
        case standardSectionId = "standard_section_id"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        admission_no = try values.decodeIfPresent(String.self, forKey: .admissionno)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        house_id = try values.decodeIfPresent(String.self, forKey: .houseid)
        profile_pic = try values.decodeIfPresent(String.self, forKey: .profile_pic)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        sms_mobile = try values.decodeIfPresent(String.self, forKey: .smsmobile)
        studentImg  = try values.decodeIfPresent(String.self, forKey: .studentImg)
        combo_id  = try values.decodeIfPresent(String.self, forKey: .combo_id)
        isSectionChanged = try values.decodeIfPresent(Bool.self, forKey: .isSectionChanged)
        standardSectionId = try values.decodeIfPresent(StandardSectionData.self, forKey: .standardSectionId)
        
        if let tmpattendance = try values.decodeIfPresent(Attendance.self, forKey: .attendance){
            self.attendance = tmpattendance
        }
        
    }
    
}


class Attendance : WSResponseData {
    var marked_on : String?
    var type : String?
    var reason : String?
    var details : String?
    var information : String?
    
    enum CodingKeys: String, CodingKey {
        
        case marked_on = "marked_on"
        case type = "type"
        case reason = "reason"
        case details = "details"
        case information = "information"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        marked_on = try values.decodeIfPresent(String.self, forKey: .marked_on)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        reason = try values.decodeIfPresent(String.self, forKey: .reason)
        details = try values.decodeIfPresent(String.self, forKey: .details)
        information = try values.decodeIfPresent(String.self, forKey: .information)
    }
    
}
