//
//  MessageData.swift
//  MountCarmel
//
//  Created by Sandip on 28/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class MessageData: WSResponseData {
    var response_status : Bool?
    var read_flag : Bool?
    var is_deleted : Bool?
    var id : String?
    var sms_text : String?
    var student_id : NoticeStudentData?
    var sms_type : String?
    var receiver_type : [String]?
    var mobile_no : String?
    var year_session : String?
    var school_code : String?
    var sent_by_staff : NoticeStaffData?
    var created_at : String?
    var v : Int?
    var mobilesData : [MobilesData]?
    
    enum CodingKeys: String, CodingKey {
        
        case responsestatus = "response_status"
        case readflag = "read_flag"
        case isdeleted = "is_deleted"
        case id = "_id"
        case smstext = "sms_text"
        case studentid = "student_id"
        case smstype = "sms_type"
        case receivertype = "receiver_type"
        case mobileno = "mobile_no"
        case yearsession = "year_session"
        case schoolcode = "school_code"
        case sentbystaff = "sent_by_staff"
        case createdat = "created_at"
        case v = "__v"
        case mobiles = "mobiles"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        response_status = try values.decodeIfPresent(Bool.self, forKey: .responsestatus)
        read_flag = try values.decodeIfPresent(Bool.self, forKey: .readflag)
        is_deleted = try values.decodeIfPresent(Bool.self, forKey: .isdeleted)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        sms_text = try values.decodeIfPresent(String.self, forKey: .smstext)
        student_id = try values.decodeIfPresent(NoticeStudentData.self, forKey: .studentid)
        sms_type = try values.decodeIfPresent(String.self, forKey: .smstype)
      //  receiver_type = try values.decodeIfPresent([String].self, forKey: .receivertype)
      //  mobile_no = try values.decodeIfPresent(String.self, forKey: .mobileno)
        year_session = try values.decodeIfPresent(String.self, forKey: .yearsession)
        school_code = try values.decodeIfPresent(String.self, forKey: .schoolcode)
        sent_by_staff = try values.decodeIfPresent(NoticeStaffData.self, forKey: .sentbystaff)
        created_at = try values.decodeIfPresent(String.self, forKey: .createdat)
        mobilesData = try values.decodeIfPresent([MobilesData].self, forKey: .mobiles)
        v = try values.decodeIfPresent(Int.self, forKey: .v)
    }
    
}


class MobilesData: WSResponseData {
    var read_flag : Bool?
    var device_id : [String]?
    var number : String?
    var text : String?
    var student_id : String?
    
    enum CodingKeys: String, CodingKey {
        
        case read_flag = "read_flag"
        case device_id = "device_id"
        case number = "number"
        case text = "text"
        case student_id = "student_id"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        read_flag = try values.decodeIfPresent(Bool.self, forKey: .read_flag)
        //device_id = try values.decodeIfPresent([String].self, forKey: .device_id)
        number = try values.decodeIfPresent(String.self, forKey: .number)
        text = try values.decodeIfPresent(String.self, forKey: .text)
        student_id = try values.decodeIfPresent(String.self, forKey: .student_id)
    }
    
}
