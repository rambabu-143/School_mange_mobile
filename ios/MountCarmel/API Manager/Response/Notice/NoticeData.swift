//
//  NoticeData.swift
//  MountCarmel
//
//  Created by Sandip on 27/03/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit

class NoticeData: WSResponseData {
    var read_flag : Bool?
    var is_deleted : Bool?
    var id : String?
    var student_id : NoticeStudentData?
    var receiver_type : String?
    var year_session : String?
    var school_code : String?
    var sent_by_staff : NoticeStaffData?
    var platform : String?
    var title : String?
    var text : String?
    var attachments : [String?]?
    var created_at : String?
    var __v : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case readflag = "read_flag"
        case isdeleted = "is_deleted"
        case id = "_id"
        case studentid = "student_id"
        case receivertype = "receiver_type"
        case yearsession = "year_session"
        case schoolcode = "school_code"
        case sentbystaff = "sent_by_staff"
        case platform = "platform"
        case title = "title"
        case text = "text"
        case attachments = "attachments"
        case created_at = "created_at"
        case v = "__v"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        read_flag = try values.decodeIfPresent(Bool.self, forKey: .readflag)
        is_deleted = try values.decodeIfPresent(Bool.self, forKey: .isdeleted)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        student_id = try values.decodeIfPresent(NoticeStudentData.self, forKey: .studentid)
        receiver_type = try values.decodeIfPresent(String.self, forKey: .receivertype)
        year_session = try values.decodeIfPresent(String.self, forKey: .yearsession)
        school_code = try values.decodeIfPresent(String.self, forKey: .schoolcode)
        sent_by_staff = try values.decodeIfPresent(NoticeStaffData.self, forKey: .sentbystaff)
        platform = try values.decodeIfPresent(String.self, forKey: .platform)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        text = try values.decodeIfPresent(String.self, forKey: .text)
        attachments = try values.decodeIfPresent([String].self, forKey: .attachments)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        __v = try values.decodeIfPresent(Int.self, forKey: .v)
    }
    
}

